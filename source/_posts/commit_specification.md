---
layout: post
title: Git提交规范
date: 2022/05/07
updated: 2022/05/07
cover: /assets/git.webp
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- Git
- 规范
---

## 正文
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **test**: Adding missing tests or correcting existing tests
- **style**: Changes that do not affect the meaning of the code (空格、格式化、分号缺失等)
- **ci**: Changes to our CI configuration files and scripts (examples: CircleCi, SauceLabs)
- **docs**: Documentation only changes
- **chore**: 构建过程或辅助工具的修改、修改工具相关（包括但不限于文档、代码生成、依赖更新/脚手架配置修改等）
- **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)

## 参考链接：
### commit type
- [https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
- [https://github.com/streamich/git-cz](https://github.com/streamich/git-cz)

### CI
- [https://www.ruanyifeng.com/blog/2015/09/continuous-integration.html](https://www.ruanyifeng.com/blog/2015/09/continuous-integration.html)