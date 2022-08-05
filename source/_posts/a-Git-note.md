---
layout: post
title: 一份Git笔记
date: 2021/10/22
updated: 2022/08/02
cover: /assets/git.webp
# coverWidth: 920
# coverHeight: 613
comments: true
categories:
- 技术
tags:
- Git
- 学习笔记
---

## Git配置

### 相关文件
Git 自带一个 git config 的工具来帮助设置控制 Git 外观和行为的配置变量。 这些变量存储在三个不同的位置：
1. /etc/gitconfig 文件: 包含系统上每一个用户及他们仓库的通用配置。 如果在执行 git config 时带上 --system 选项，那么它就会读写该文件中的配置变量。 （由于它是系统配置文件，因此你需要管理员或超级用户权限来修改它。）

2. ~/.gitconfig 或 ~/.config/git/config 文件：只针对当前用户。 你可以传递 --global 选项让 Git 读写此文件，这会对你系统上所有的仓库生效。

3. 当前使用仓库的 Git 目录中的 config 文件（即 .git/config ）：针对该仓库。 你可以传递 --local 选项让 Git 强制读写此文件，虽然默认情况下用的就是它。 （当然，你需要进入某个 Git 仓库中才能让该选项生效。）

### 相关命令
```shell
git config --list [--show-origin]           # 查看当前使用的所有配置【以及它们所在的文件】
git config --[local/global/system] --list	# 查看 当前仓库/全局/系统 的Git配置
git config key [value]                      # 查看【或设置】某项配置
git config --unset key                      # 删除某项配置
```

### 配置参考
- [.gitconfig](https://github.com/Crazyokd/my-config)

## 帮助文档

```shell
#获取帮助
git help <verb>
git <verb> --help
man git-<verb>
git <verb> -h	                            # 获取简易帮助
```

## 基本操作

```shell
#得到仓库
# 1.初始化仓库
git init
# 2.克隆仓库
git clone [--recurse-submodules] <url> [<rep_name>]
git clone [--recurse-submodules] ssh://user@server:path/to/repo.git	# 通过SSH

git status [-s|--short]                         # 查看仓库状态
git log

git add	<file>...	                            # 开始跟踪新文件，或者把已跟踪的文件放到暂存区
git add [-p|--patch]                            # 部分暂存文件

git commit [-m "message"]		                # 提交暂存区文件
git commit -a -m "message"	                    # 把所有已经跟踪过的文件暂存起来一并提交，从而跳过 git add 步骤

git describe <branch>                           # 生成一个构建号
git archive <branch> --prefix='dir/'            # 创建快照归档

git ls-files                                    # 查看暂存区中的文件
git ls-files files...                           # 查看暂存区中的特定文件或目录

git rm --cached files...                        # 将files从暂存区移除，但仍然保留在当前工作目录中，取消对files的跟踪
git rm --cached -r dirs...                      # 将dirs从暂存区移除，但仍然保留在当前工作目录中
git rm files...                                 # 将files从暂存区和工作区移除，取消对files的跟踪

git push <remote> <localbranch>:<remotebranch>
git pull <remote> <remotebranch>:<localbranch>

git mv file_from file_to	                    # 移动文件，移动后还需commit（自动完成add）

git fetch <remote>	                            # 拉取所有你还没有的数据

git merge <branchname>     #将branchname分支合并到当前分支

git ls-remote <remote>	#查看远程仓库的所有远程分支
git push <remote> --delete <remotebranch>	#删除远程分支
```


## `.gitignore`

### 格式规范：
- 所有空行或者以 # 开头的行都会被 Git 忽略。
- 可以使用标准的 glob 模式匹配，它会递归地应用在整个工作区中。
- 匹配模式可以以（/）开头防止递归。
- 匹配模式可以以（/）结尾指定目录。
- 取消忽略指定模式的文件或目录，可以在模式前加上叹号（`!`）取反。 

### glob 模式： 
所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。

- 星号（*）匹配零个或多个任意字符；
- [abc] 匹配任何一个列在方括号中的字符（这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）； 
- 问号（?）只 匹配一个任意字符；
- 如果在方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配 （比如 [0-9] 表示匹配所有 0 到 9 的数字）。 
- 使用两个星号表示匹配任意中间目录，比如 a/**/z 可以匹配 a/z 、 a/b/z 或 a/b/c/z 等。

### 使用示例：

```shell
# 忽略所有的 .a 文件 
*.a
# 但跟踪所有的 lib.a，即便你在前面忽略了 .a 文件 
!lib.a
# 只忽略当前目录下的 TODO 文件，而不忽略 subdir/TODO 
/TODO
# 忽略任何目录下名为 build 的文件夹 
build/
# 忽略 doc/notes.txt，但不忽略 doc/server/arch.txt 
doc/*.txt
# 忽略 doc/ 目录及其所有子目录下的 .pdf 文件 
doc/**/*.pdf
```
> 在最简单的情况下，一个仓库可能只根目录下有一个 .gitignore 文件，它递归地应用到整个仓库中。 然而，子目录下也可以有额外的 .gitignore 文件。子目录中的 .gitignore 文件中的规则只作用于它所在的目录中。


## `git diff`

```shell
git diff [<file>...]	                # 此命令比较的是工作目录中当前文件和暂存区域快照之间的差异。 也就是修改之后还没有暂存起来的变化内容。
git diff --[staged|cached] <file>...	# 比对已暂存文件与最后一次提交的文件差异

git diff --check    # 找出可能的空白错误并将它们列出来

git diff branch1...branch2              # 显示自branch2分支与branch1分支的共同祖先起，branch2分支中的工作

git difftool --tool-help	            # 看你的系统支持哪些 Git Diff 插件
```

## `git reflog`

当你在工作时，Git 会在后台保存一个引用日志(reflog)，引用日志记录了最近几个月你的 HEAD 和分支引用所指向的历史。

每当你的 HEAD 所指向的位置发生了变化，Git 就会将这个信息存储到引用日志这个历史记录里。

引用日志只存在于本地仓库，它只是一个记录你在自己仓库里做过什么的日志。其他人拷贝的仓库里的引用日志不会和你的相同，而你新克隆一个仓库时，引用日志是空的。

```shell
git reflog [show]
```

## `git log`

```shell
git log		                                        # 参看提交历史【指定显示条数】
git log -p [-n]	                                    # 按补丁的格式输出
git log --stat	                                    # 查看提交的简略统计信息
git log --pretty=oneline	                        # 将每个提交放在一行显示
git log --pretty=format:"%h - %an, %ar :%s"	        # 指定输出格式
git log --graph	                                    # 形象的展示你的分支、合并历史
git log --decorate	                                # 查看各个分支当前所指的对象

git log --since=2.weeks
git log -S string	                                # 显示那些添加或删除了该字符串的提交

git log --abbrev-commit                             # 显示的 SHA-1 简短且唯一

git log branch1..branch2                            # 在branch2分支而不在branch1分支中的提交
git log --left-right branch1...branch2                           # 被两个分支之一包含但又不被两者同时包含
```

## 贮藏
```shell
git stash [-u] [--patch] [push]         # 将新的贮藏推送到栈上
git stash list                          # 查看贮藏的东西
git stash apply stash@{n}               # 应用一个贮藏
git stash drop stash@{n}                # 移除贮藏
git stash pop stash@{n}                 # 应用并移除贮藏
git stash branch <new branchname>       # 以指定的分支名创建一个新分支，检出贮藏工作时所在的提交，重新在那应用工作并在应用成功后丢弃贮藏
```

## 搜索
```shell
git grep [-n] pattern
```

## Git 调试
```shell
git blame [-L n1,n2] <file>	    # 查看file的修改记录

git bisect start                # 二分查找错误
git bisect bad
git bisect good <commit>
git bisect reset
```

## 子模块

```shell
git submodule add <url>         # 将一个已存在的仓库添加为正在工作的仓库的子模块
git submodule init              # 初始化本地配置文件
git submodule update            # 从该项目中抓取所有数据并检出父项目中列出的合适提交
```

## reset揭秘
reset 移动 HEAD 指向的分支指针

```shell
git reset --[soft|mixed|hard] <SHA-1> <file...>                 # 放弃工作目录下的所有修改
```

|  | HEAD | Index | Workdir |
|--| ---- | ----- | ------- |
|commit level | | | |
|reset --soft [commit] | REF | NO | NO |
|reset [commit] | ref | yes | no |
| reset --hard [commit]| REF | yes | yes |
| checkout [commit]| head | yes | yes |
|file level | | | |
| reset [commit] <paths> | no | yes | no |
|checkout [commit] <paths> | no | yes | yes |


## 撤销操作

```shell
git commit --amend [--no-edit]	    # 重新提交暂存区,本次提交将覆盖上一次提交
git restore --staged <file>...	    # 取消暂存
git restore <file>...	            # 用最近一次提交覆盖该文件
```


## `git remote`

```shell
git remote [-v]                         # 列出所有远程服务器的简写
git remote show <remote>	            # 查看某个远程仓库

git remote add <shortname> <url>        # 添加远程仓库

git remote rename <fromname> <toname>
git remote remove <shortname>
```


## `git tag`
Git 支持两种标签：轻量标签（lightweight）与附注标签（annotated）
- 轻量标签像一个不会改变的分支——它只是某个特定提交的引用。
- 附注标签是存储在 Git 数据库中的一个完整对象，它们是可以被校验的，其中包含打标签者的名字、电子邮件地址、日期时间，此外还有一个标签信息，并且可以使用 GNU Privacy Guard (GPG) 签名并验证.

**默认情况下，git push 命令并不会传送标签到远程仓库服务器上。在创建完标签后你必须显式的推送标签到共享服务器上。**

```shell
git tag [-l]	                                # 列出标签
git tag -l "tagname"                            # 列出tagname，可使用通配符
git show <tagname>	                            # 查看标签信息和与之对应的提交信息

git tag -a <tagname> -m <message>	            # 创建附注标签
git tag <tagname>	                            # 创建轻量标签

git tag -a <tagname> <SHA>	                    # 给SHA所对应的提交打标签

git push <remote> <tagname>	                    # 将标签推送到远程仓库
git push <remote> --tags	                    # 推送所有不在远程仓库的标签（不区分轻量标签和附注标签）

git tag -d <tagname>	                        # 删除本地标签
git push <remote> :refs/tags/<tagname>	        # 移除远程仓库标签
git push <remote> --delete <tagname>	        # 移除远程仓库标签
git checkout <tagname>                          # 检出标签
```


## Git别名

```shell
git config --global alias.<name> '<internalcommand>'	# 为git命令(无需git前缀)创建别名，eg. git config --global alias.co checkout
git config --global alias.<name> '!<externalcommand>'	# 为外部命令创建别名
```


## 分支管理

### 分支模型

一个文件对应于一个blob对象

整个项目对应着一个树对象（snapshot)

一次提交对应着一个对象

![image-20211021112052798](https://user-images.githubusercontent.com/74645100/141408501-04add94b-f158-4fdc-9502-1ffa19712c8d.png)

HEAD指针是指向当前所在本地分支的指针


### 本地分支

```shell
git branch	#显示所有本地分支
git branch -a   #显示所有分支（本地分支+远程分支）
git branch -r 	#查看所有远程分支
git branch -v	#查看所有分支以及它们的最后一次提交

git branch <branchname>	#基于当前分支创建分支
git checkout <branchname>	#切换分支
git checkout -b <newbranchname>	#创建新分支并切换到新分支
git checkout -b <branch> <tagname>	#对tagname位置创建一个分支，并切换到该分支
git branch -d <branch>	#删除分支（已合并）
git branch -D <branch>	#强制删除分支

git branch --merged	#查看所有已经合并到当前分支的分支
git branch --no-merged	
git branch --no-merged <branch>	#查看未合并到branch分支的所有分支
```


> **当你试图合并两个分支时， 如果顺着一个分支走下去能够到达另一个分支，那么 Git 在合并两者的时候， 只会简单的将指针向前推进（指针右移），因为这种情况下的合并操作没有需要解决的分歧——这就叫做 “快进（fast-forward）”。**


> 你可以在合并冲突后的任意时刻使用 git status 命令来查看那些因包含合并冲突而处于未合并（unmerged）状态的文件。
在你解决了所有文件里的冲突之后，对每个文件使用 git add 命令来将其标记为冲突已解决。 一旦暂存这些原本有冲突的文件，Git 就会将它们标记为冲突已解决。
如果你对结果感到满意，并且确定之前有冲突的的文件都已经暂存了，这时你可以输入 git commit 来完成合并提交。



### 远程分支

远程跟踪分支是远程分支状态的引用。它们是你无法移动的本地引用。一旦你进行了网络通信， Git 就会为你移动它们以精确反映远程仓库的状态。请将它们看做书签， 这样可以提醒你该分支在远程仓库中的位置就是你最后一次连接到它们的位置。

```shell
git ls-remote <remote>	#查看远程仓库的所有远程分支
git remote show <remote>	#查看远程分支的详细信息

git fetch <remote>	    # fetch branches and/or tags;将<remote>所有的远程分支同步到本地
git push <remote> <localbranch>:<remotebranch>

git checkout -b <branch> <remote>/<remotebranch>    # 基于远程分支创建分支

git fetch --all	# 抓取所有的远程仓库
git push <remote> --delete <remotebranch>	#删除远程分支
```

### 跟踪分支
从一个远程跟踪分支检出一个本地分支会自动创建所谓的“跟踪分支”（它跟踪的分支叫做“上游分支”）。
跟踪分支是与远程分支有直接关系的本地分支。如果在一个跟踪分支上输入 `git pull` ，Git 能自动地识别去哪个服务器上抓取、合并到哪个分支。

当克隆一个仓库时，它通常会自动地创建一个跟踪 `origin/master` 的 `master` 分支。

当设置好跟踪分支后，可以通过简写 @{upstream} 或 @{u} 来引用它的上游分支。

```shell
git checkout --track <remote>/<branch>
git branch -u <remote>/<remotebranch>   # 设置当前分支的上游分支/跟踪分支
git branch -vv      # 列出所有本地分支及其对应的上游分支
```


### 变基
变基使得提交历史更加整洁。

你在查看一个经过变基的分支的历史记录时会发现，尽管实际的开发工作是并行的，但它们看上去就像是串行的一样，提交历史是一条直线没有分叉。

```shell
git rebase <branch>	# 将当前分支上的所有修改变基到branch分支上
git rebase --onto <branch1> <branch2> <branch3>	# 取出branch3分支，找出它从branch2分支分歧之后的补丁，然后把这些补丁在branch1分支上重放一遍。
git rebase <branch1> <branch2>	# 将branch2变基到branch1
```

**如果提交存在于你的仓库之外，而别人可能基于这些提交进行开发，那么不要执行变基**

## Git原理
- `description` 文件仅供 GitWeb 程序使用
- `logs` 目录包含引用日志
- `config` 文件包含项目特有的配置选项
- `info` 目录包含一个全局性排除文件，用以放置那些不希望被记录在 .gitignore 文件中的忽略模式
- `hooks` 目录包含客户端或服务端的钩子脚本
- `objects` 目录存储所有数据内容
- `refs` 目录存储指向数据（分支、远程仓库和标签等）的提交对象的指针
- `HEAD` 文件指向目前被检出的分支
- `index` 文件保存暂存区信息

### Git对象
Git 的核心部分是一个简单的键值对数据库（key-value data store）。你可以向 Git 仓库中插入任意类型的内容，它会返回一个唯一的键，通过该键可以在任意时刻再次取回该内容。
一旦你将内容存储在了对象数据库中，那么可以通过 `cat-file` 命令从 Git 那里取回数据。

___

> 本文参考自[**Pro Git**](https://git-scm.com/book/en/v2)第二版.