---
title: 规则模型
date: 2025-02-23 03:05:01
updated: 2025-02-23 03:05:01
index_img: https://cdn.sxrekord.com/blog/cplus.png
banner_img: https://cdn.sxrekord.com/blog/cplus.png
categories:
- 技术
tags:
- C/C++
---

此文姑且算是承接 [一个对多引用链表的解决方案](link-multi-pointer/)。

上次我们已然解决了野指针的问题，而这次主要聚焦于系统的进一步重构优化，而非任何特性或问题。

由于lua服务的单线程特性（否则虚拟栈的栈帧会错乱），故对于某一特定的`lua_State`的使用方式一定是单线程且异步轮询的。

这里异步的实现有赖于**任务消息**的概念，即第三方服务产生任务消息，任务主线程轮询并处理任务消息，所谓的处理即是将该消息传递给对应的lua_State，并执行相应的lua回调函数。而在处理过程中也可能导致其内部引用的C服务进一步产生任务消息。下面是其大致的流程图：

![流程](https://cdn.sxrekord.com/v2/image-20250222092519-nkc9pwm.png)

举个定时器的例子，事件循环中执行lua脚本，脚本中调用c提供的定时器服务添加一个定时器，然后do something并退出任务脚本。任务的事件循环忙等直到定时器服务触发超时生成一个超时消息并推送至消息队列，事件循环拉取消息并执行回调，其中的处理逻辑类似于回调一个lua函数同时传递进一些事件消息和用户数据。以上过程可以不断进行...

第三方服务需要能正确的对消息进行分发，而这其中最重要的依据当属任务id了，如果消息自身带有taskid，那么分发并无疑问，但还有一些情形消息并没有直接的分发依据，比如某个服务收到一条WebSocket消息，而其中只有一些事件内容，此时分发就需要规则来完成了。而规则显然需要是动态的。

在生产场景下，一些重要服务均有“规则引擎”的需求，故对其抽象势在必行。

下面是设计后的UML类图：

![UML类图](https://cdn.sxrekord.com/v2/image-20250221160656-160c80l.png)

代码大致如下：

```c++
class AbstractRule
{
public:
    /* 匹配成功会设置内部的taskid */
    virtual bool matchRule(AbstractRule *rule) = 0;
    virtual std::string toString() = 0;
    virtual ~AbstractRule() {}
    AbstractRule(long long taskid = -1)
        : _index(-1), _taskid(taskid), next(nullptr)
    {}

public:
    int _index;
    uint32_t _priority; // reserved
    long long _taskid;
    AbstractRule *next;
};

struct NodeInfo {
    AbstractRule *address;
    uint32_t use_cnt;
    uint32_t next_idx;
    // NodeInfo(AbstractRule *addr, uint32_t uc, uint32_t ni)
    //     : address(addr), use_cnt(uc), next_idx(ni)
    // {}
};

class AbstractRuleManager
{
public:
    virtual AbstractRule *newRule(std::string &info)
    {
        return nullptr;
    }
    int assignRootRule()
    {
        std::lock_guard<std::mutex> lock(mtx);
        if (!root) return -1;
        idx2info[root->_index].use_cnt += 1;
        return root->_index;
    }
    void releaseNodeInfo(uint32_t idx)
    {
        if (idx == -1) return;

        std::lock_guard<std::mutex> lock(mtx);
        /* assert(idx2info.find(idx) != idx2info.end()) */
        if (idx2info.find(idx) == idx2info.end()) {
            return;
        }
        if (idx2info[idx].use_cnt == 1) {
            if (!idx2info[idx].address && idx2info[idx].next_idx != -1)
                releaseNodeInfo(idx2info[idx].next_idx);

            idx2info.erase(idx);
        } else {
            idx2info[idx].use_cnt -= 1;
        }
    }

    bool matchRule(AbstractRule *rule, int &startIdx)
    {
        if (!rule || startIdx == -1) return false;

        std::lock_guard<std::mutex> lock(mtx);
        AbstractRule *node = getNodeInfo(startIdx);
        if (!node) {
            releaseNodeInfo(startIdx);
            return false;
        }
        for (; node; node = node->next) {
            if (rule->matchRule(node)) {
                rule->_taskid = node->_taskid;
                releaseNodeInfo(startIdx);
                if (node->next) {
                    startIdx = node->next->_index;
                    ++idx2info[startIdx].use_cnt;
                } else {
                    startIdx = -1;
                }
                return true;
            }
        }
        return false;
    }
    int addRule(std::string &info)
    {
        AbstractRule *rule = newRule(info);
        if (!rule) {
            return -1;
        }
        std::lock_guard<std::mutex> lock(mtx);
        rule->_index = ++ruleIndex;
        // 插入至规则链
        rule->next = root;
        root = rule;
        // 更新NodeInfo
		idx2info[rule->_index] = {rule, 1, -1u};
        return rule->_index;
    }
    std::string getRules()
    {
        std::ostringstream oss;
        std::lock_guard<std::mutex> lock(mtx);
        oss << "[";
        for (auto node = root; node; node = node->next) {
            if (node != root) {
                oss << ",";
            }
            oss << node->toString();
        }
        oss << "]";
        return oss.str();
    }

    bool removeRule(int ruleid)
    {
        std::lock_guard<std::mutex> lock(mtx);
        AbstractRule *node, *prev = nullptr;
        for (node = root; node; node = node->next) {
            if (node->_index == ruleid) {
                removeNodeInfo(ruleid);
                if (prev) {
                    prev->next = node->next;
                } else {
                    root = node->next;
                }
                delete node;
                return true;
            }
            prev = node;
        }
        return false;
    }
    AbstractRuleManager()
    {
        root = nullptr;
        ruleIndex = 0;
    }
    virtual ~AbstractRuleManager()
    {
        while (root) {
            removeRule(root->_index);
        }
        if (idx2info.size() > 0) {
            fprintf(stderr, "warn: idx2info is not empty\n");
        }
    }

private:
    void removeNodeInfo(uint32_t idx)
    {
        if (idx2info.find(idx) == idx2info.end()) {
            return;
        }

        if (idx2info[idx].use_cnt == 1) {
            idx2info.erase(idx);
        } else {
            idx2info[idx].use_cnt -= 1;
            if (idx2info[idx].address->next) {
                idx2info[idx].next_idx = idx2info[idx].address->next->_index;
                idx2info[idx2info[idx].next_idx].use_cnt += 1;
            } else {
                idx2info[idx].next_idx = -1;
            }
            idx2info[idx].address = NULL;
        }
    }

    AbstractRule *getNodeInfo(uint32_t idx)
    {
        if (idx2info.find(idx) == idx2info.end()) {
            return NULL;
        }

        if (idx2info[idx].address) {
            // 指向的节点还未被释放
            return idx2info[idx].address;
        } else {
            // 指向的节点已经被释放
            if (idx2info[idx].next_idx != -1)
                return getNodeInfo(idx2info[idx].next_idx);
            else
                return NULL;
        }
    }

private:
    std::unordered_map<uint32_t, NodeInfo> idx2info;
    mutable std::mutex mtx;
    int ruleIndex;
    AbstractRule *root; // 规则链根节点
};

```

由于不同服务对应的规则是不尽相同的，所以对于具体规则的解析必须放置在具体的服务类内部，即实现自身的`newRule(std::string &info)`方法。

同时在RuleManager内部通过模板模式安全的实现对Rule的所有增删改查。
