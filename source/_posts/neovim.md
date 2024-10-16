---
title: neovim
index_img: https://cdn.sxrekord.com/blog/neovim-vs-vim.png
banner_img: https://cdn.sxrekord.com/blog/neovim-vs-vim.png
date: 2024-10-16 06:35:58
updated: 2024-10-16 06:35:58
categories:
- 折腾
tags:
- vim/neovim
- C/C++
---

# vim折腾体验

vim是我一直想要使用的编辑器。因为它已经被广泛证明了“高效”。

以往我的主力语言是Java，在那种开发环境下，很难想象没有丝滑的补全功能。而且整体来讲命令行环境使用并不多。

现在主力语言是C/C++，开发环境也是Linux/gcc/g++。

所以使用vim作为开发环境变得合理和科学。

在此之前我或多或少或系统或零散的学过vim的语法和哲学，[配置 vim + c/cpp 开发环境](https://sxrekord.com/build-cpp-dev-env/)就是写于当时。

但是由于上面提及的原因，一直没有形成能投入生产环境的肌肉记忆。现在是时候再次尝试了。

# vim优先

vi就不考虑了，而neovim属于vim的重构，所以学好了vim后再切到neovim也不会有太多摩擦。

配置和插件方案还是将克制作为基本原则。

[基本配置](https://github.com/Crazyokd/vimrc/blob/vim/settings/configs.vim)大概就是设置编码、行号、搜索、tab和颜色主题。

[插件方案](https://github.com/Crazyokd/vimrc/blob/vim/settings/plugins.vim)也是盯准刚需，采用vim-plug作为插件管理器，安装fzf、rainbow、nerdtree和coc插件管理器。

其中[coc-settings的配置](https://github.com/Crazyokd/vimrc/blob/vim/coc-settings.json)重点在于c/c++的lsp配置，虽然内容不多，但是把clangd和ccls的选项大部分尝试了一遍，留下的都是~~心血~~。

最后就是辅以[mapping](https://github.com/Crazyokd/vimrc/blob/vim/settings/mappings.vim)提高效率。

# 为什么迁移？

这套配置托管在[vimrc](https://github.com/Crazyokd/vimrc/tree/vim)，来来回回折腾了有一周左右，最终留下的配置虽然不多，但是幕后是不断地尝试和取舍。

lsp管理器尝试过youcompleteme，使用后又转战coc.nvim，而有关c/c++的lsp尝试尤其折磨。

其他插件也是经过一番甄选，要么解决痛点要么提供耳目一新的体验。

那么为什么放弃呢？

其中一个原因是因为开发C++过程中使用跳转偶尔会segment fault，导致开发体验大幅下降。


最重要的原因是因为慢，特别是lsp尤其慢，高亮/跳转反应迟钝，有时候我写完一个函数名后需要保存后**等待**lsp奏效。

我因为想要更快选择了vim，而工具的速度反而跟不上人了，无疑是舍本逐末。

在朋友的再三安利下，最终我还是切到了neovim。

手动编译了v0.10.1的稳定版本（因为Ubuntu22.04自带的nvim版本太低）后，再次开始驰骋neovim的生态。

> 编译过程忘记录了，下次再补上。

# nvim新世界

[neovim](https://github.com/neovim/neovim)是用Lua进行重构的，而Lua和C的配合相当默契，所以性能自不必多提。其项目宗旨也是Extensible和Usable。

令我最感叹的还是neovim的生态，我过去一直以为老牌vim已经存在并流行很长一段时间了，所以生态必定已经是趋于成熟，该有的插件一定有了，没有的话说明无法实现或取舍后放弃实现。而neovim的生态成熟度心里就不太有底了。


然而事实上，多亏了它聚集宗旨的重构，导致很多过去需要使用插件的功能已经内置在neovim核心中，而其插件生态也能向更广阔的方向拓展。

所以我的感受是过去需要的功能都能在neovim中找到平替甚至得到更好的体验，而且大多数高赞插件还处于活跃开发中（因为neovim本身也在不断更新）。


虽然但是，这也意味着需要将过去的插件几乎全部转为neovim版本或寻找相应平替。

这一过程，我主要是直接参考别人的neovim配置，另外，为了避免臃肿，插件选择仍然十分克制。

而插件选择过程中惊喜相当多，下面对其分别简单提一嘴（~~顺序不代表心仪程度~~）：

* Lazy

  nvim中的插件管理器，好用，够用。

* colorscheme

  tokyonight和vscode主题都十分对我胃口
* gitsigns

  侧边能显示当前行的git状态
* nvim-tree


  相当于vim中的NERDTree
* telescope

  相当于vim中的fzf
* treesitter

  高亮到位
* nvim-cmp/lspconfig

  助力补全/跳转等功能

目前的neovim配置托管在[nvim](https://github.com/Crazyokd)（还会继续更新），不知道前方还有多少惊喜，但是我敢说目前这套配置已经有了相当棒的开发体验。

现在的任务就是practice、practice、practice！更多的去练习vim操作和感悟vim哲学。

希望自己能持之以恒，并能有越来越多的编辑工作是在vim下完成的。

# 参考链接

* https://github.com/iggredible/Learn-Vim
* https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim
* https://github.com/jaxvanyang/dotfiles/tree/main/.config/nvim

