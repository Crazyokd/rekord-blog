---
layout: post
title: 配置 vim + c/cpp 开发环境
date: 2023/07/18
updated: 2023/09/09
cover: /assets/vim.webp
coverWidth: 920
coverHeight: 400
comments: true
categories:
- 技术
tags:
- C++
- Linux
- vim
---

# 前置提示
由于整个过程中涉及到很多 Git 网络操作，请务必保持**“网络通畅”**。
笔者配置的环境为 wsl(ubuntu) ，如果你也和我一样，可以参考这篇[解决WSL下使用Clash for Windows的记录](https://zhuanlan.zhihu.com/p/451198301)文章对网络的可访问性进行优化。

具体操作下来就是在shell中执行以下命令配置好代理。

```shell
export http_proxy='http://192.168.3.4:7890'  # 根据实际IP和端口修改地址
export https_proxy='http://192.168.3.4:7890'
export all_proxy='socks5://192.168.3.4:7890'
export ALL_PROXY='socks5://192.168.3.4:7890'
git config --global http.proxy "http://192.168.3.4:7890"
git config --global https.proxy "https://192.168.3.4:7890"
```

# 代码补全
笔者这里选用的是[YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)，应该还有针对 c/cpp 更加轻量化或者专有化的 vim 插件，欢迎留言推荐。

由于我已经使用了 vim-plug 作为 vim 插件管理器，所以这里详细讲解一下如何使用 vim-plug 安装、配置 YouCompleteMe。其实官方更推荐的是使用 [Vundle](https://github.com/VundleVim/Vundle.vim) 插件管理器，不过安装配置方式也大同小异。

首先在 vim 配置文件中加入如下行：

```vim
" vim-plug
call plug#begin('~/.vim/plugged')

" youcompleteme
Plug 'ycm-core/YouCompleteMe'

" Initialize plugin system
call plug#end()
```

然后在 vim 中执行`:PlugInstall`（不同的插件管理器有不同的安装命令，具体差异请查阅文档）。这时如果一切正常，那么 YouCompleteMe 的源码仓库应该被克隆到了 `~/.vim/plugged/` 目录（如果是使用 vundle，那么安装目录应当是 `~/.vim/bundle/`）。

紧接着进入本地的 YouCompleteMe 目录（如上所述），并在该目录下依次执行：

```shell
git submodule update --init --recursive
# 安装依赖
sudo apt install build-essential cmake vim-nox python3-dev
sudo apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
python3 install.py --clangd-completer
```

由于我这里主要需要的是 C-family languages，所以使用了 `--clangd-completer` 编译选项，如果需要全部安装，可以使用 `--all` 选项，详细的语言选项可参考[ycm编译参数](https://github.com/ycm-core/YouCompleteMe#c-family-semantic-completion:~:text=YouCompleteMe%0A./install.py-,The%20following%20additional%20language%20support%20options%20are%20available%3A,-C%23%20support%3A%20install)

命令执行完毕后，代码应该就能自动补全了，可以使用 `ctrl+n/p`/`TAB` 在补全选项中进行切换选择。

---

# 改用coc.nvim
使用了ycm一段时间后发现，ycm稍显笨重，配置起来并不方便，搜索一番后故改用[coc.nvim](https://github.com/neoclide/coc.nvim)。

coc.nvim类似于一个lsp管理平台，需要什么lsp就安装什么插件，通过它的一些内置命令从而能够便捷的管理各种lsp插件。

使用coc.nvim配置C/C++开发环境时，后端仍然是[clangd](https://clangd.llvm.org/)。

clangd是这样识别配置文件的：
- 寻找当前文件的父目录
- 寻找当前文件的父目录下的build子目录

然后在这两个目录中寻找`compile_commands.json`或`compile_flags.txt`文件。其中前者优先级比后者高，存在前者将忽略后者。
> 这里面存在一个小坑，当打开.h文件时，clangd会认为这是一个C文件，从而不支持C++语法，此时可以通过修改编译参数为`-xcxx`强制识别。
