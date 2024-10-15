---
title: 一个对多引用指针访问和释放的解决方案（定时器）
date: 2024/9/21
updated: 2024/9/21
index_img: https://cdn.sxrekord.com/blog/cplus.png
banner_img: https://cdn.sxrekord.com/blog/cplus.png
categories: 
- 技术
tags:
- C/C++
---

# 背景

1. 定时器通过时间轮的方式实现，即将定时器节点按照过期时间挂在相应的单向链表上。（中途可能存在更细粒度的时间划分，从而出现多次挂载）

    > 定时器节点在其内部动态分配
    >
2. 外部可能同时存在多个用户类使用该定时器，可能的操作包括

    1. 添加定时器（需分配用户数据）
    2. 删除定时器（需删除用户数据）
    3. 析构整个用户类（取消所有该用户添加且还未触发的定时器，并删除所有分配的用户数据）

所以每个定时器节点包含两部分内存分配，其一是节点本身，其二是用户数据（与节点中的用户数据指针挂钩）

```c++
typedef struct timer_node_s {
	xxx
	void *data; // 用户数据
	xxx
} timer_node_t;
```

## 结构

​![timerwheel](https://cdn.sxrekord.com/blog/timerwheel.png)​

## 先从内存分配角度分析：

定时器节点四散在定时器中的各个单向链表中，而且又因为中间可能存在多次调整，所以访问频繁且时机不定，故生命周期应该交由定时器自身负责。

用户数据与用户类息息相关，脱离了用户类（析构），用户数据毫无意义，所以生命周期应主要由用户类控制。

> 试想一下，如果定时器节点由用户类释放，那么定时器本身的所有链表操作都将变得不再安全。
>
>> 还有一种用户类直接管理定时器内存的方案，定时器采用双向链表，删除的时候将节点从链表中移除并继续维护前后关系，继而释放。
>>

‍

## 从性能方面分析：

既然写的是C/C++，那么性能一定要尽可能高。其中有一个很重要的指标是内存使用率，也就是说我们应尽可能早的释放内存。

而当定时器节点被触发时，除非用户数据中携带对应的用户指针，否则用户是无感知的，也就不能及时释放定时器节点。

所以更好的方式是定时器节点触发后即释放；那么用户数据呢，同样也可以在定时器节点触发后即释放。

> 用户数据中携带一份用户指针无疑又会增加每次需分配的内存量

‍

## 从用户使用角度分析：

用户类可以删除自己添加的定时器，并可能在某个时间点析构，析构前必定需要对与自己相关的定时器做一些收尾工作。

> 析构的时间是完全随机的，并不强制等到所有相关定时器触发完毕。

如果此时直接释放单向链表中的某些定时器节点，那么整个定时器都会被破坏。

与此同时必须释放自己管理的用户数据，因为这些用户数据在脱离了当前用户类以后再无意义，也就是说回调不能也不应该再被触发。

‍

## 综合三方面考虑：

1. 定时器节点不能由用户释放，因为释放后定时器就被破坏了。

2. 定时器节点的用户数据应当由用户类管理
3. 由于定时器用户数据与定时器节点挂钩，但是节点可能被定时器释放，所以此时定时器用户数据存在但无法通过定时器节点指针访问。此时在用户处应分开维护二者的集合。
4. 用户需在保证不访问已被释放的定时器节点的前提下，在析构时取消所有自己设置但还未被触发的定时器。

‍

# 最终方案

**定时器中的单向链表中的next指针改为共享指针，外部用户类使用弱指针引用该共享指针，同时用户数据仍旧使用普通指针（完全由用户类控制）** 。

数据结构如下：

```c++
// 自定义哈希函数
struct WeakPtrHash {
    std::size_t operator()(const std::weak_ptr<timer_node_t>& wp) const {
        return std::hash<timer_node_t*>()(wp.lock().get());
    }
};

// 自定义相等性比较函数
struct WeakPtrEqual {
    bool operator()(const std::weak_ptr<timer_node_t>& lhs, const std::weak_ptr<timer_node_t>& rhs) const {
        return lhs.lock().get() == rhs.lock().get();
    }
};

/* timer node TO user data */
std::unordered_map<std::weak_ptr<timer_node_t>, l_timer_node_t *, WeakPtrHash, WeakPtrEqual> tn2ud;
```

这时回头来看三种操作的处理方式：

1. 添加定时器：在map中添加一条记录
2. 删除定时器：如果弱引用指针没有过期，则取消定时器，否则忽略；同时删除用户指针
3. 析构：遍历map并执行2

定时器节点本身使用共享指针，使用完后没有链表引用自动调用析构被释放。

```c++
    timer_node_t *addTimer(int ts, int func_ref, int ref)
    {
        l_timer_node_t *ln = (l_timer_node_t *)malloc(sizeof(l_timer_node_t));
        if (!ln) return NULL;

        ln->L = L;
        ln->func_ref = func_ref;
        ln->ref = ref;
        std::weak_ptr<timer_node_t> n = tm->add_timer(ts, TimeoutHandle, ln);
        if (n.expired()) {
            free(ln);
            return NULL;
        }
        tn2ud.insert(std::make_pair(n, ln));
        return n.lock().get();
    }

    void delTimer(timer_node_t *n)
    {
        for (auto it = tn2ud.begin(); it != tn2ud.end();) {
            if (it->first.expired()) {
                /* release user data and remove pair */
                luaL_unref(L, LUA_REGISTRYINDEX, it->second->ref);
                luaL_unref(L, LUA_REGISTRYINDEX, it->second->func_ref);
                free(it->second);
                it = tn2ud.erase(it);
                continue;
            }
            auto tn = it->first.lock().get();
            if (tn == n) {
                tm->del_timer(tn);
                /* release user data */
                luaL_unref(L, LUA_REGISTRYINDEX, it->second->ref);
                luaL_unref(L, LUA_REGISTRYINDEX, it->second->func_ref);
                free(it->second);
                tn2ud.erase(it);
                break;
            }
            it++;
        }
    }

    ~LvirtualTimer()
    {
        for (auto it = tn2ud.begin(); it != tn2ud.end(); ++it) {
            /* cancel all untriggered timer nodes */
            if (auto tn = it->first.lock()) {
                tm->del_timer(tn.get());
            }
            /* release all user datas */
            luaL_unref(L, LUA_REGISTRYINDEX, it->second->ref);
            luaL_unref(L, LUA_REGISTRYINDEX, it->second->func_ref);
            free(it->second);
        }
    }
```
