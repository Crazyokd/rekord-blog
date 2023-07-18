---
layout: post
title: Tmux Guideline
date: 2023/07/17
updated: 2023/07/17
cover: https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Tmux_logo.svg/1200px-Tmux_logo.svg.png
coverWidth: 1200
coverHeight: 316
comments: true
categories:
- 技术
tags:
- tmux
---

# 专业术语
在讲解 tmux 之前，让我们先来熟悉几个名词。
- 会话（session）
当我们在终端中执行一个任务时，窗口一旦关闭，会话随之结束，其中运行的进程也就被强制终止了。
我们可以使用 tmux 将窗口与会话解绑。
- 窗口（window）
窗口就是我们所看到的整个终端界面。
- 窗格（pane）
窗口可以划分为多个窗格，可以根据需要垂直排列或水平排列。

# 前缀键（send-prefix）
tmux 中的很多操作都是通过**前缀键+快捷键**来实现的。用户也可以根据自己需要在`~/.tmux.conf`配置文件中修改前缀键。
# 会话操作
## tmux外部指令

```shell
tmux [new -s <session-name>] # 新建会话
tmux ls # 查看会话
tmux attach [-t <session-name>] # 连接会话(不指定具体的会话将连接最后退出的会话)
tmux kill-session -t <session-name> # 关闭会话(不指定具体的会话将关闭最先退出的会话)
```

## tmux内部快捷键

```shell
prefix + s # 切换会话；指令：tmux switch -t <session-name>
prefix + d # 分离会话；指令：tmux detach
prefix + $ # 重命名会话；指令：tmux rename-session -t <old-session-name> <new-session-name>
```


# 窗口操作

```shell
prefix + c # 新建窗口；指令：tmux new-window [-n <window-name>]
prefix + , # 窗口重命名；指令：tmux rename-window <new-name>
prefix + p/n/number # 切换到（上/下一个）/指定编号窗口
prefix + w # 切换窗口；指令：tmux select-window -t <window-number>
```

# 窗格操作

如果你经常使用 vim，建议在配置文件中添加如下设置：
```tmux
# Navigate panes using jkhl
# -r 表示可重复按键，大概500ms以内，重复的h、j、k、l按键都将有效
bind-key -r j select-pane -D
bind-key -r k select-pane -U
bind-key -r h select-pane -L
bind-key -r l select-pane -R

# 绑定prefix + Ctrl+hjkl键为面板上下左右调整边缘的快捷指令
bind -r ^k resizep -U 10 # 绑定Ctrl+k为往↑调整面板边缘10个单元格
bind -r ^j resizep -D 10 # 绑定Ctrl+j为往↓调整面板边缘10个单元格
bind -r ^h resizep -L 10 # 绑定Ctrl+h为往←调整面板边缘10个单元格
bind -r ^l resizep -R 10 # 绑定Ctrl+l为往→调整面板边缘10个单元格
```

## 快捷键

```shell
prefix + " # 分割水平窗格；指令：tmux split-window 
prefix + % # 分割垂直窗格；指令：tmux split-window -h
prefix + x # 关闭当前窗格
prefix + t # 显示当前时间
prefix + z # 放大/还原当前窗格
```

# 其他命令

```shell
# 列出所有快捷键，及其对应的 Tmux 命令
tmux list-keys

# 列出所有 Tmux 命令及其参数
tmux list-commands

# 列出当前所有 Tmux 会话的信息
tmux info

tmux source-file ~/.tmux.conf # 加载配置
```

# 参考
- [Tmux使用教程-阮一峰](https://www.ruanyifeng.com/blog/2019/10/tmux.html)
- [Tmux使用手册](http://louiszhai.github.io/2017/09/30/tmux/)
