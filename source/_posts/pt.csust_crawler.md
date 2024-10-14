---
title: pt.csust_crawler
date: 2022/06/13
index_img: https://cdn.sxrekord.com/blog/code.jpg
categories: 
- 折腾
tags:
- GitHub
---

这篇博客主要是介绍我的一个小项目————[pt.csust_crawler](https://github.com/Crazyokd/pt.csust_crawler)。

## 由来
上学期学了 Python 课，那怎么能不学学爬虫呢？然后就有了该项目的雏形。

在这里也顺便说说该项目名字的由来：
- 因为项目本质上属于爬虫范畴，所以是‘crawler’
- 爬的是我学校的网络教学平台（网址为[pt.csust.edu.cn](http://pt.csust.edu.cn/)）

## 雏形
最开始的时候这个东东就只是输入账号密码然后爬取网站的待提交作业。
没有 GUI 客户端，大三了还是和 cmd 打交道啊┭┮﹏┭┮！

写好了之后用了几次就很少用了，毕竟被爬网站算是我们学校运营的比较好的网站了，用这个相较来说成本太高。

后面有朋友似乎有强迫症，觉得网站主页（左）侧边栏的通知提醒十分碍眼，根据这个需求我又添加了一个清空通知的功能。

再之后就几乎没更新了......

## 平地翻身
但这篇博客的出现也预示着关于它的种种远没有结束。

今年有门课叫《软件项目管理及案例》，某次登录网络教学平台上去交作业时发现竟有足足连续三次未交作业。

照这样下去我甚至想会不会挂了？

冲着这个迫在眉睫的需求，当晚就开始着手更新项目。
由于有 GitHub Action 这个好东西，所以思路选型早早就定为“按一定时间间隔运行该程序”。

然后立刻就有几个问题急不可耐的浮出水面。
1. 如何标记某作业已提醒过或已多次提醒过？
2. 如何有效提醒本人？

第二个问题最终定为使用邮件提醒，提醒的同时也附带有作业详情的附件。
由于在此之前该项目就存在邮件模块，只不过在以往该功能纯属鸡肋，所以第二点非常容易实现。

那么第一个问题又如何解决呢？
1. 使用数据库当然非常简单但是否不值？
    - 因为涉及到与数据库的连接和操作，代码量必然疯涨
    - 如果因为需要持久化存储几个标记字段就建库，显然大题小做
    - 如果建库涉及到更多功能，那才合适且合理。但这些子虚乌有的功能我暂时连想法都没有
2. 虽然需要记录的标记字段可以尽量最小化，但在不使用数据库的情况下应该存储在何处呢？

想了想发现只要让 GitHub Action 承担更多的功能即可。

以下为 GA 的“所作所为”：
1. 按一定时间间隔运行（实际定为每3小时运行一次）
2. 检出本仓库（注意与克隆区分）
3. 下载 Python 并安装相关依赖
4. 运行程序并记录相关运行日志
5. 暂存所有修改并提交（而且得使用`--amend`类似选项来防止污染GitHub提交记录面板） 
6. `--force push` 到原仓库

## 差点让我放弃的一个不能放弃的功能
在这里我不得不说为了实现第5条，我整个人真的是心力交瘁┭┮﹏┭┮。

首先一个发现就是 Action 运行之后提交历史竟只有一条了！？
当然这都是小事，毕竟只是一个私有 instance 库。

但提交记录一直被污染，由于这种无法容忍的现象存在，我算是折腾了一遍 action 库。
当晚最终无果，但还是固执的将最终的错误原因定位在[ad-m/github-push-action](https://github.com/ad-m/github-push-action)仓库。

时隔一周多，特意再去翻了翻《Pro Git》里面的一些高级知识，于是又带着信心再来挑战该 issue 了。

然而事实十分残酷，我甚至fork了一份[ad-m/github-push-action](https://github.com/ad-m/github-push-action)代码并自定义了一份提交方案，但还是无法解决提交记录被污染的问题。

最终通过在 GA 运行时记录`git log`的输出发现了此事的蹊跷。

原来我使用的检出仓库[actions/checkout](https://github.com/actions/checkout)并不是简简单单的克隆原仓库，而是提供了非常多的检出方案。
而默认采用的就是检出当前仓库默认分支的最新提交快照的方式。

所以以往的 GA 运行时操作的 Git 仓库本身就仅有一条提交记录，所以重写之后自然还是只有一条。
于是乎，这个神奇的现象就被解释清楚了。
> 所以友情提示一下大家，在使用第三方的 action 库时请一定要去仔细看看用法。

言归正传，那么 Git 仓库是如何被污染的呢？
因为 Git 的每次提交涉及到两个时间
其一是 `AuthorDate`
第二是 `CommitDate`

一般我们在`git log`的输出里面看见的就是 AuthorDate。

每次使用`--amend`时我们会将当次提交合并至上次提交。
但使用这个命令并不是说真的对当前被合并提交毫不记录。
实际上，**上次提交的 AuthorDate 并不会更新，但上次提交的 CommitDate 会更新为本次提交的时间**。

那么，这会造成什么影响呢？
参考[官方文档](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/managing-contribution-settings-on-your-profile/troubleshooting-commits-on-your-timeline)直接造成的影响至少有如下几点：
1. GitHub 检测到有新的 CommitDate 提交后，将会在对应的`AuthorDate`那天更新提交次数，实际表现就是小框框颜色加深。
2. 第一点的长期表现就是反复被合并的上一次提交对应的那天显示的提交次数十分多。
3. 但在仓库中看来又没有那么多的提交记录
4. 另外 GitHub 的提交记录是按 CommitDate 进行排序的，但 Gitee 的提交记录却又是按 AuthorDate 进行排序的，总之就是非常奇妙。

那么是不是就无解了呢？
当然不是，既然问题是由 GitHub 的提交记录面板的生成机制所产生的。
那么相应的解决方案当然就是以其人之道还治其人之身。

参考[官方文档](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/managing-contribution-settings-on-your-profile/why-are-my-contributions-not-showing-up-on-my-profile)发现，该面板仅记录 default 分支上的提交，那么只要将提交的主体移至非默认分支即可。

最终`main.yml`代码如下：
```yml
name: pt.csust_crawler

on:
  workflow_dispatch:
  schedule:
  - cron: '30 */3 * * *'

jobs:
  main:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 0
    - run: git checkout instance

    - uses: actions/setup-python@v3
    
    - name: Set ENV
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    - name: Run crawler
      run: |
        echo "## 运行时间：" > info.bak.log
        echo `date` >> info.bak.log
        echo "## 运行情况：" >> info.bak.log
        python main.py >> info.bak.log
        echo -e "=========================\n\n" >> info.bak.log
    - name: Update logs
      run: |
        source update_log.sh
    - name: Commit .env #上传新的refresh_token到仓库
      run: |
        git config --global user.email 1324596506@qq.com
        git config --global user.name rekord
        git add .
        git commit --amend --no-edit
    - name: Push changes
      uses: ad-m/github-push-action@master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        branch: instance
        force: true
```

## 王婆卖瓜
真不是自吹自擂，这个项目真的有一定的实用价值，更重要的是没有使用成本。

只要经过~~简单~~的配置，这个项目就能准确侦测并报告作业提醒。

我用了也有两周左右了，目前运行良好，唯一的遗憾是来的太晚了，下学期压根没课。

下面是它的几个主要 feature ：
- 一次配置，终身使用
- 绝不做任何多余提醒，只要你积极写作业，它甚至没活干！
- 代码精简（没有使用数据库这种一听就很重的组件），维护成本低，稳定性好。
- 如果你也想 GitHub 一直绿，上面虽然用大量篇幅阐释了如何避免该特性，但同时也说明反向实现该功能也十分简单。

**最后，喜欢的话千万不要忘记给一颗 star 啊！！！**
