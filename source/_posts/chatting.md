---
title: Let’s chatting on web
date: 2023/04/12
updated: 2023/04/12
index_img: https://cdn.sxrekord.com/blog/code.jpg
categories:
- 折腾
tags:
- GitHub
- Java
- JavaScript
- Docker
---


# 项目萌芽

干这行的都知道，程序员开发一定少不了浏览器，或许现在还少不了ChatGPT？

总之我是尽量用各种软件的web端，除非web端没有或者烂到不能用的。

我的电脑上没有安装微信，现在没有，以后也不想有。（~~QQ倒是装了一个，至少Windows上的QQ还是蛮好用的~~）

但是现在我事实上用的最多的两款社交软件（QQ、微信）都没有Web端。

另外我也经常使用QQ作为跨端文件传输工具，但是手机QQ本地文件存储的位置我一直没能找到，并且其自带的文件过期机制，使得明明是自己传输的文件却做不到收放自如。

基于以上两个痛点，我开始萌发做一款Web聊天软件的想法。

# 开始动手

最初的动手是在2022年9月-10月。促使动手的原因很简单，需要做一个项目应付软件实训。当时看了市面上大部分的Web聊天系统，基本上都是基于 Vue + Express + socket.io。而我的技术栈是Java后端，前端属于原生级别。不过所幸还是找到了一款相当合适的。

这个就是当时看中的一款：[https://github.com/Kanarienvogels/Chatroom]([https://github.com/Kanarienvogels/Chatroom](https://github.com/Kanarienvogels/Chatroom))。

clone到本地，花了好几天将前后端代码都看完了，然后在原来的基础上做了一些规范化操作，并提交了一条PR，奈何原作者已经不玩GitHub了，故最终还是将这条pr关了，如果当时原作者能够响应，或许又是另一个故事了。

于是我索性基于这个项目单开一个项目，取名为 chatting 。然后接下来就是不断地重构、重构。第一次比较大的重构主要是从Spring到SpringBoot，后面的重构主要包括前后端各种地方的代码重写，总之就是在没有添加明显功能的前提下，不断地提高代码的质量和可扩展性。

当代码终于稳定下来后，我发现如果我需要添加新功能居然寸步难行。其中最大的问题在于前端，原因是因为最初的前端就是原生js + jQuery + Bootstrap样式。虽然我改动了不少js代码，但是对于Bootstrap样式我并不熟悉，而且由于大量使用了jQuery，所以js代码和样式以及结构耦合十分严重，经典的改一行出现五行新的报错。

而且当时项目检查的时间也快到了，我就索性开摆拿另一个功能更多的项目顶了上去，此后，项目被搁置了几个月。

# 前端重写，后端重构

转眼间，毕设就要求选题了，于是我又再次拾起了这个项目。但是这时我是知道这个项目的问题在哪的，于是我花了一周时间学习了Vue框架（说实话中文项目上手还是很快的）。最初使用vue并不十分顺手，因为它和曾经前端的直来直去编写方式有所差异，很多时候完成一项功能需要绕个弯。但是当你写了几千行代码后，这些问题就渐渐不是问题而是习惯了。

前端页面编写的难点倒是不多，但是需要考虑功能的全面性，防止以后又要再加功能改结构和样式，那将是代码灾难。整个页面的设计和编码花的时间不算多，大概一周就写完了，最终的成品和现在的也差不了多少。

接下来主要就是改后端，其实此时完全没必要用上以前的后端，因为除了Netty相关其他部分基本上都被重写了，不过为了情怀嘛，整个项目的后端还是在以前的基础上进行的开发。

中间经历了不少联调适配，反正前后端代码都是在不断地修修补补，最终形成了现在的效果。

![demo](https://cdn.sxrekord.com/project/demo.gif)

# 更多的话

整个项目开发过程大概就是这样，不过接下来我还想说一些我认为值得一提的过程与结果。

- 前端的编码设计一直在重构，真真正正的使用到了Vue的各种特性，如store、plugin、mixin、router、services等，也真正的体会到了为什么Vue有这些特性，为什么Vue需要这些特性。
- 后端的代码也一直在重构，组件也尽量在升级，最近的升级主要是从Mybatis到Mybatis-plus，规范程度向jar包靠拢。
- 需求和bug采用issue管理，pr分情况使用rebase或者merge。
- 欢迎合作

# 项目总结

- 前端架构
    
    ```plain
    ├─.github 
    │ ├─dependabot.yml 
    │ └─workflows 
    │   ├─ci.yml 
    │   └─tagged-release.yml 
    ├─.gitignore 
    ├─babel.config.js 
    ├─jenkins 
    │ └─Jenkinsfile 
    ├─jsconfig.json 
    ├─package-lock.json 
    ├─package.json 
    ├─public 
    │ ├─avatar 
    │ │ ├─default_group_avatar.jpg 
    │ │ ├─default_user_avatar.jpg 
    │ │ └─openai.png 
    │ ├─favicon.ico 
    │ ├─img 
    │ │ ├─loading.gif 
    │ │ ├─login_bg.jpg 
    │ │ └─sign-weixin.png 
    │ ├─index.html 
    │ └─upload 
    ├─README.md 
    ├─src 
    │ ├─App.vue 
    │ ├─assets 
    │ │ └─emoji.json 
    │ ├─components 
    │ │ ├─MessageArea 
    │ │ │ ├─MessageArea.vue 
    │ │ │ ├─MessageBottomInputArea.vue 
    │ │ │ └─MessageTopTitle.vue 
    │ │ ├─NavigationZone 
    │ │ │ ├─ApplicationList.vue 
    │ │ │ ├─NavigationApplication.vue 
    │ │ │ ├─NavigationContact.vue 
    │ │ │ ├─NavigationTopSearchBar.vue 
    │ │ │ ├─NavigationZone.vue 
    │ │ │ └─RelationList.vue 
    │ │ ├─SearchArea 
    │ │ │ ├─SearchArea.vue 
    │ │ │ └─SearchAreaBody.vue 
    │ │ └─ToolBar 
    │ │   ├─ToolBar.vue 
    │ │   ├─ToolBarBottom.vue 
    │ │   └─ToolBarTop.vue 
    │ ├─config 
    │ │ ├─api.js 
    │ │ └─openai.js 
    │ ├─main.js 
    │ ├─mixins 
    │ │ └─socketMixin.js 
    │ ├─pages 
    │ │ ├─ChattingPage.vue 
    │ │ └─LoginPage.vue 
    │ ├─plugins 
    │ │ └─apiPlugin.js 
    │ ├─router 
    │ │ └─index.js 
    │ ├─services 
    │ │ ├─api 
    │ │ │ ├─api.js 
    │ │ │ └─index.js 
    │ │ └─request.js 
    │ ├─store 
    │ │ ├─actions.js 
    │ │ ├─index.js 
    │ │ └─mutations.js 
    │ ├─styles 
    │ │ └─common.css 
    │ └─utils 
    │   ├─common.js 
    │   ├─date.js 
    │   └─socket.js 
    └─vue.config.js
    ```
    
- 后端架构
    
    ```plain
    ├─.github 
    │ └─workflows 
    │   └─ci.yml 
    ├─.gitignore 
    ├─docker-compose.yml 
    ├─Dockerfile 
    ├─Jenkinsfile 
    ├─Makefile 
    ├─pom.xml 
    ├─README.md 
    ├─scripts 
    │ └─local-deploy.bat 
    └─src 
      ├─main 
      │ ├─java 
      │ │ └─com 
      │ │   └─sxrekord 
      │ │     └─chatting 
      │ │       ├─ChattingApplication.java 
      │ │       ├─common 
      │ │       │ ├─Constant.java 
      │ │       │ ├─MessageType.java 
      │ │       │ └─WSType.java 
      │ │       ├─config 
      │ │       │ ├─UriConfig.java 
      │ │       │ └─WebMvcConfig.java 
      │ │       ├─context 
      │ │       │ └─AppContext.java 
      │ │       ├─controller 
      │ │       │ ├─AdminController.java 
      │ │       │ ├─FileController.java 
      │ │       │ ├─GroupController.java 
      │ │       │ ├─MessageController.java 
      │ │       │ ├─RelationController.java 
      │ │       │ └─UserController.java 
      │ │       ├─dao 
      │ │       │ ├─FileContentDao.java 
      │ │       │ ├─FileDao.java 
      │ │       │ ├─GroupDao.java 
      │ │       │ ├─ImageContentDao.java 
      │ │       │ ├─MessageDao.java 
      │ │       │ ├─RelationDao.java 
      │ │       │ ├─TextContentDao.java 
      │ │       │ └─UserDao.java 
      │ │       ├─exception 
      │ │       │ └─GlobalExceptionHandler.java 
      │ │       ├─interceptor 
      │ │       │ └─UserAuthInterceptor.java 
      │ │       ├─model 
      │ │       │ ├─po 
      │ │       │ │ ├─File.java 
      │ │       │ │ ├─FileContent.java 
      │ │       │ │ ├─Group.java 
      │ │       │ │ ├─ImageContent.java 
      │ │       │ │ ├─Message.java 
      │ │       │ │ ├─Relation.java 
      │ │       │ │ ├─TextContent.java 
      │ │       │ │ └─User.java 
      │ │       │ └─vo 
      │ │       │   └─ResponseJson.java 
      │ │       ├─service 
      │ │       │ ├─ChatService.java 
      │ │       │ ├─FileService.java 
      │ │       │ ├─GroupService.java 
      │ │       │ ├─impl 
      │ │       │ │ ├─ChatServiceImpl.java 
      │ │       │ │ ├─FileServiceImpl.java 
      │ │       │ │ ├─GroupServiceImpl.java 
      │ │       │ │ ├─MessageServiceImpl.java 
      │ │       │ │ ├─RelationServiceImpl.java 
      │ │       │ │ └─UserServiceImpl.java 
      │ │       │ ├─MessageService.java 
      │ │       │ ├─RelationService.java 
      │ │       │ └─UserService.java 
      │ │       ├─task 
      │ │       │ └─FileTask.java 
      │ │       ├─util 
      │ │       │ ├─FileUtils.java 
      │ │       │ ├─HeaderUtils.java 
      │ │       │ ├─JsonMsgHelper.java 
      │ │       │ ├─JwtTokenUtils.java 
      │ │       │ ├─RedisUtils.java 
      │ │       │ └─WrapEntity.java 
      │ │       └─websocket 
      │ │         ├─HttpRequestHandler.java 
      │ │         ├─WebSocketChildChannelHandler.java 
      │ │         ├─WebSocketServer.java 
      │ │         └─WebSocketServerHandler.java 
      │ └─resources 
      │   ├─application.yml 
      │   ├─banner.txt 
      │   ├─mapper 
      │   │ ├─file-mapper.xml 
      │   │ ├─filecontent-mapper.xml 
      │   │ ├─group-mapper.xml 
      │   │ ├─imagecontent-mapper.xml 
      │   │ ├─message_mapper.xml 
      │   │ ├─relation-mapper.xml 
      │   │ ├─textcontent-mapper.xml 
      │   │ └─user-mapper.xml 
      │   └─sql 
      │     ├─data.sql 
      │     └─schema.sql 
      └─test 
        └─java 
          └─com 
            └─sxrekord 
              └─chatting 
                ├─config 
                │ ├─DruidTest.java 
                │ └─FastAutoGeneratorTest.java 
                ├─dao 
                │ ├─GroupDaoTest.java 
                │ ├─MessageDaoTest.java 
                │ └─RelationDaoTest.java 
                ├─model 
                │ └─vo 
                │   └─ResponseJsonTest.java 
                ├─service 
                │ ├─FileServiceTest.java 
                │ ├─GroupServiceTest.java 
                │ ├─MessageServiceTest.java 
                │ ├─RelationServiceTest.java 
                │ └─UserServiceTest.java 
                └─util 
                  ├─FileUtilsTest.java 
                  ├─JwtTokenUtilTest.java 
                  └─RedisUtilsTest.java
    ```
    
- 功能特色
    - 实现群组和好友的完全管理
    - 支持多种消息格式
    - 消息记录持久化与懒加载
    - 使用JWT作为token，安全性更高
    - 前端会在用户无感知的前提下自动鉴权
    - 文件管理十分精巧，不误删、不滥存

# 最后

希望自己不忘初心，能坚持更新维护吧！
