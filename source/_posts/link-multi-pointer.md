---
title: 一个对多引用链表的解决方案
date: 2024/9/22
index_img: https://cdn.sxrekord.com/blog/cplus.png
banner_img: https://cdn.sxrekord.com/blog/cplus.png
categories: 
- 技术
tags:
- C/C++
---

# 背景

现在手上有一套遗留代码，其中有一个单例对象维护了一张链表，并提供对链表的下列操作：

1. 添加节点（排序插入）
2. 删除节点（遍历链表并通过节点索引进行匹配）
3. 分发节点（将节点指针传递给用户，此后用户可以直接使用该指针作为下一次迭代的起始位置）

    > 第一次分发直接传递链表头指针给用户，如果中间某个节点被删除，依赖该节点的用户应继续使用该节点的next节点。
    >
4. 遍历链表所有节点并构造节点集合的json字符串

# 问题

同一时间可能存在大量该对象的用户，但如果没有第三点，仅使用线程锁也不会有问题。

在有了第3点功能的情况下，用户对自身持有指针的使用并不安全，因为持有的指针可能已经被释放了。

# 方案

遗留的代码尽量还是采取最小化修改，同时因为一些原因，禁止使用智能指针或弱指针。

最终我采用如下方案解决问题并维持原有的功能，同时还提升了部分性能：

* 用户干脆不持有指针，而是持有节点的索引，每次需使用该指针时传递给单例对象该节点和一个回调函数（负责具体的处理逻辑）。
* 为了避免遍历链表，我单独使用一个map记录节点索引与节点信息（包括节点指针）的对应关系。
* 因为我们要求节点被释放后，继续使用被释放节点的next节点。所以在节点被释放前，我们应更新该节点索引对应的的节点信息。

## 最终的数据结构

```cpp
typedef rule_s {
	struct rule_s *next;
	uint32_t idx;
} rule_t;

typedef struct node_info_s {
	rule_t *address;
	uint32_t use_cnt;
	uint32_t next_idx;
} node_info_t;

map<idx, node_info_t>
```

## 添加节点

添加节点后该节点就被单例对象所管理，所以use_cnt初始为1。

```cpp
void storeNodeInfo(uint32_t idx, void *address) {
	map[idx] = {address, 1, -1};
}
```

## 删除节点

如果use_cnt为1，说明除了单例对象，无其他用户直接或间接引用该对象，于是可以直接从map表中移除，否则应当将use_cnt减一，同时更新address和next_idx。

在执行该操作时，被删除节点的next指针要么指向一个有效对象，要么指向NULL。

前者，我们应更新next_idx为next节点的index**并同时更新next_idx记录的引用计数**；后者，我们仅将next_idx置为-1。

不论前者还是后者，address都设为NULL标志该节点已被删除。

```cpp
void removeNodeInfo(uint32_t idx) {
	if (map[idx].use_cnt == 1) {
		map.erase(idx);

	} else {
		map[idx].use_cnt -= 1;
		if (map[idx].address->next) {

			map[idx].next_idx = map[idx].address->next->idx;
			map[map[idx].next_idx].use_cnt += 1;
		} else {
			map[idx].next_idx = -1;
		}
		map[idx].address = NULL;
	}
}
```

## 首次分配头节点

```cpp
// 也要加锁
map[idx].use_cnt += 1
```

## 获取节点索引对应的节点指针

如果address的值不为NULL，说明该节点还未被释放，返回对应的地址即可。

否则再次判断其next_idx，如果值为-1，说明原来的指针删除时已然没有下一个节点了，此时直接返回NULL；反之，从下一个节点开始递归寻找。

```cpp
void *getNodeInfo(uint32_t idx) {
	if (map[idx].address) {
		// 指向的节点还未被释放
		return map[idx].address;
	} else {
		// 指向的节点已经被释放
		if (map[idx].next_idx != -1)
			return getNodeInfo(map[idx].next_idx);
		else
			return NULL;
	}
}
```

## 用户放弃对指针的持有

如果use_cnt为1，说明该节点已经被删除且除了当前用户外没有其他用户，那么可以安全的从map中移除这条记录。

但在移除之前，检查其next_idx是否有效，即是否有引用其他记录。

如果有，则递归式的更新被引用记录的引用计数。

```c++

void releaseNodeInfo(uint32_t idx) {
	if (map[idx].use_cnt == 1) {
		if (!map[idx].address && map[idx].next_idx != -1)
			releaseNodeInfo(map[idx].next_idx);
		map.erase(idx);
	} else {
		map[idx].use_cnt -= 1;
	}
}
```

## 迭代用户持有的索引

```c++
void iterNodeInfo(uint32_t old_idx, uint32_t new_idx) {
	releaseNodeInfo(old_idx);
	map[new_idx].use_cnt += 1;
}
```
