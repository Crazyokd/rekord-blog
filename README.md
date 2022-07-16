# rekord-blog
repo for my blog.
## Content
- [Usage](#Usage)
- [ToDo](#ToDo)
- [Reference](#Reference)
- [License](#License)

## Usage
1. install [Git](http://git-scm.com/) and [Node.js](https://nodejs.org/en/).
2. install [hexo](https://hexo.io).
3. clone this repository.
4. run [launch.sh](launch.sh).

> you can through change mirror to boost the speed of npm.
>
> eg. `npm config set registry https://registry.npm.taobao.org --global`

## ToDo
- [x] 加入文章归档
- [x] 提供RSS订阅
- [x] 加入分析系统
- [x] 使用HTTPS代替HTTP
- [x] 添加音乐
- [x] 添加[一言](https://github.com/hitokoto-osc)组件
- [ ] 使用nginx优化网站访问效果
    - [x] 使用 nginx 静态部署
    - [ ] 使用 nginx 反向代理
- [ ] 优化图片使用
    - [x] 优化文章封面图片使用
    - [ ] 优化博客头像图片使用
- [x] 修复 Gitalk 无法登陆的问题
- [ ] 将 .md 文件 解析为 .html 文件

## Reference
- This blog is based on [hexo-theme-nexmoe](https://github.com/theme-nexmoe/hexo-theme-nexmoe) theme.
- For the use of hexo, please refer to the [Hexo](https://hexo.io/zh-cn/docs/).
- use [hexo-generator-feed](https://github.com/hexojs/hexo-generator-feed) to generate rss-feed.

## License
Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
