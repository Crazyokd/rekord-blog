---
title: luaxml
index_img: https://cdn.sxrekord.com/blog/code.jpg
date: 2024-10-14 15:00:20
updated: 2024-11-12 15:43:00
categories:
- 折腾
tags:
- Lua
---

由于业务要求，需要使用lua操作xml，本想着这算不得什么问题，但没想到在GitHub大致搜了一圈都没有找到比较好用且还在维护的`lua for xml`​库。

其中star比较多且还在更新的一个库叫[manoelcampos/xml2lua](https://github.com/manoelcampos/xml2lua)。

然而将我的一个业务xml模板套上去就发现存在问题，问题的具体表现我提了一个[issue](https://github.com/manoelcampos/xml2lua/issues/101)。

刚好最近要用lua，而且xml这个需求的频率还比较高，所以干脆直接看了看它的源码，发现简单解决我的问题并不难，所以也就提了一个简单的[pr](https://github.com/manoelcampos/xml2lua/pull/102)。

# 问题

趁着看了部分源码的热乎劲，顺便就看了看所有issue，总结下来，发现原来的库还存在以下几个问题：

1. 无法同时支持既有值和属性的tag（我的解决方案也不过是应付燃眉之急的小把戏）
2. 无法保证有序，从而导致转换前后可能存在较大出入。

    以其中的[issue#100](https://github.com/manoelcampos/xml2lua/issues/100)举例：

    ```xml
    <dict>
      <key>background</key>
      <string>#262626</string>
      <key>foreground</key>
      <string>#bcbcbc</string>
      <key>invisibles</key>
      <string>#585858</string>
      <key>lineHighlight</key>
      <string>#262626</string>
      <key>lineDiffAdded</key>
      <string>#87afff</string>
      <key>lineDiffModified</key>
      <string>#dfdfdf</string>
      <key>lineDiffDeleted</key>
      <string>#ffdf87</string>
    </dict>
    ```

	仅从肉眼观察，xml所代表的含义比较明确，每一个key对应一个string。

	但是转换后的结果（使用最新版本）却是：

    ```xml
    <dict>
    <string>#262626</string>
    <string>#bcbcbc</string>
    <string>#585858</string>
    <string>#262626</string>
    <string>#87afff</string>
    <string>#dfdfdf</string>
    <string>#ffdf87</string>
    <key>background</key>
    <key>foreground</key>
    <key>invisibles</key>
    <key>lineHighlight</key>
    <key>lineDiffAdded</key>
    <key>lineDiffModified</key>
    <key>lineDiffDeleted</key>
    </dict>
    ```

	此时仅凭心智模型就有可能出现理解偏差，当然我们仍然可以使用下面的代码正确取值：

    ```lua
    for i = 1, n do
        local key = get('/dict/key[' .. i .. ']')
        local string = get('/dict/string[' .. i .. ']')
    end
    ```

	Anyway，在xml中tag的顺序我认为是非常有意义的。然而原来的代码库对xml的lua底层表示是无法保证有序性的。

3. 不够易用。在它的场景中，parser和handler的实现是分离的，当parser解析到最小子集的有意义信息时，会回调handler的对应函数（handler在parser构造时传递进来）。通过这种设计方式，用户可以自定义实现handler，以实现不同场景。但是对大部分用户而言，并不需要多个handler，普通的`parse/get/set/print`​基本足够，而且具备自定义handler能力的用户，或许更倾向于修改已有的handler？


通过上面的现状分析，我们对应的也有了一套定向解决上述痛点的需求模型。

# 设计

解析部分基本沿用原来的库（否则是个体力活），同时将其中的回调改为直接调用。

lua中普通的key是不存在顺序约束的，这也是xml2lua无法保证有序的根由。那么我如何实现有序呢？通过使用@head节点告知第一个key，同时在每一个key中使用一个@next字段，类似于单链表。同时为了解决过去无法同时表达key/attr的问题，我使用@val和@attr分别表示tag的值和属性表。也因此不难看出，@val和@head字段是互斥的。

又因为lua中是没有原生数组的，其中的数组也是用table进行表达的（但是存在一定的局限性）。如此导致在处理数组tag（同一级别出现多个相同名字的tag）和普通的tag时需要分别处理。所以数组tag中无需维护@head，因为键带有顺序。

lua内部表示如下：

```lua
{
    ["@meta"] = {},
    root = {
        key1 = {
            ["@val"] = "value1",
            ["@next"] = "key2",
        },
        key2 = {
            ["@val"] = 123,
            ["@attr"] = {type = "string"},
            ["@next"] = "key3",
        },
        key3 = {
            [1] = {
                ["@val"] = 31,
            },
            [2] = {
                ["@val"] = 32,
            },
            ["@next"] = "key4",
        },
        key4 = {
            key41 = {
                ["@val"] = 123,
                ["@next"] = "key42"
            },
            key42 = {
                ["@val"] = 123,
            },

            ["@head"] = "key41"
        },
        ["@head"] = "key1",
    },
    ["@head"] = "root",
}
```

## v2

上面的设计使得在**绝大多数情况下**确实保证了有序性，但是如果数组tag如issue#100那样分隔分布，就会导致顺序错误，即最终输出时出现“数组永远排列在一起”的现象。

于是就有了第二版设计，这一次我不再将数组tag特殊对待，而是再次利用xml的tag不能包含@这一字符的约束（这也是为什么之前特殊键都是@xxx），将所有的key在lua内部都加上@index后缀，这样就能有效解决上述由于数组导致的顺序问题，还能一致化处理逻辑。

最终的lua内部表示如下：


```lua
{
    ["@meta"] = {},
    ["root@1"] = {
        ["key1@1"] = {
            ["@val"] = "value1",
            ["@next"] = "key2@1",
        },
        ["key2@1"] = {
            ["@val"] = 123,
            ["@attr"] = { type = "string" },
            ["@next"] = "key3@1",
        },
        ["key3@1"] = {
            ["@val"] = 31,
            ["@next"] = "key3@2",
        },
        ["key3@2"] = {
            ["@val"] = 32,
            ["@next"] = "key4@1",
        },
        ["key4@1"] = {
            ["key41@1"] = {
                ["@val"] = 123,
                ["@next"] = "key42@1"
            },
            ["key42@1"] = {
                ["@val"] = 123,
            },
            ["@head"] = "key41@1",

            ["@attr"] = { type = "map" },
        },
        ["@head"] = "key1@1",
    },
    ["@head"] = "root@1",
}
```

# 用法

1. 支持使用xpath形式像对待表成员一样设置/获取元素。
2. 支持使用`load/load_ffile/save`函数输入输出xml字符串。
3. 调用`parse`函数解析字符串。

# 成品

Lua新手，所以对代码质量并不满意，后续重构范围较大，也欢迎Lua大佬pr。

目前最新的版本托管在[github](https://github.com/Crazyokd/luaxml)，大家有机会/有需求可以来试试，功能/bug尽管提。
