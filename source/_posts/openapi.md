---
title: 配置OpenAPI设计、开发、测试环境
index_img: https://cdn.sxrekord.com/blog/openAPI-specification-the-definitive-guide.png
banner_img: https://cdn.sxrekord.com/blog/openAPI-specification-the-definitive-guide.png
date: 2024-10-16 01:44:20
updated: 2024-10-16 01:44:20
categories:
- 折腾
tags:
- C/C++
- 规范
---

OpenAPI最新规范可以在[swagger](https://swagger.io/specification/)或[github](https://github.com/OAI/OpenAPI-Specification/)查询。

openapi文档使用并遵循openapi规范。

openapi文档可以使用json格式或yaml格式。

相关语法可以从上面两个链接中的任意一个上学习。

有了openapi文档后，可以理解为相当于有了根(root)。

在此基础上，可以生成各种语言/框架版本的客户端或服务端。

> 可以使用openapi-generator-cli(已验证)或swagger-codegen(未验证)

openapi文档可以使用swagger-editor方便的进行编辑修改（也有对应的vscode插件），并可以使用swagger-ui得到文档的可视化效果。

综上，如果你想设计一套API，不妨先写一份OpenAPI文档，然后整个生态可以从此基础上建设而来。

# 设计OpenAPI文档

根据业务需求设计一套Restful接口。

为了学习OpenAPI的语法和概念，我把[swagger.json](https://petstore.swagger.io/v2/swagger.json)使用OpenAPI3.0升级了一遍。并托管在[github仓库](https://github.com/crazyokd/swagger-petstore)。

从中你基本也能学会各种概念，包括info/servers/paths/components/tags等。

> 其中安全部分还需要着重强化学习。

官方文档讲的相当详细，另外还有一份ApiFox提供的3.0版本的[中文文档](https://openapi.apifox.cn/)。

这里只讲一个升级过程遇到的坑：


> 如何设置Accept header：
>
> [https://github.com/swagger-api/swagger-ui/issues/5567#issuecomment-1231643350](https://github.com/swagger-api/swagger-ui/issues/5567#issuecomment-1231643350)
>
> 如果在parameters中设置Accept header会被忽略。
>
> 如果在response中设置content类型一般情况也会被忽略。
>
> 必须通过设置**response中的200或default的content**，[代码案例](https://github.com/Crazyokd/swagger-petstore/blob/bc37db6b0fe6a97856bc2f3e5720e2efe218c831/swagger-v3.json#L412)。

# 开发代码

我的重点可能会放在C/C++，尤其是服务端，目前我会首选[pistache](https://github.com/pistacheio/pistache)。

> [restbed](https://github.com/Corvusoft/restbed)有些重，而且已经有好几年没有更新了。

可以简单使用`openapi-generator-cli generate -i swagger-v3.json -g cpp-pistache-server -o ./petstore`​命令生成示例代码。

> `openapi-generator-cli`的安装请参考[官网](https://openapi-generator.tech/#try)。

后续我可能会深入源码，敬请期待（~~建议不要期待~~）。

# 测试代码

swagger-ui的设计使得测试基本可以在浏览器上进行，通过浏览器的网络面板或者手动抓包基本可以得到不错的反馈。

而且swagger-ui每次try out都会生成相应的curl命令，所以自成api文档。

> 命令行玩家表示很欣慰。


但是最大的问题还是在于浏览器存在跨域问题。

将[swagger-ui](https://github.com/swagger-api/swagger-ui)对应的[dist](https://github.com/swagger-api/swagger-ui/tree/master/dist)托管在http服务器上非常轻松，比如使用`python -m http`​或`Live Server`​插件，再不济也有`nginx`​（不过由于权限问题，灵活性还是稍差一截）。

但是跨域问题如何处理最快捷&灵活呢？下面列举几种可行方案：

1. 后端主动设置`Access-Control-Allow-Origin`​，如果熟悉对应的后端框架，改起来或许只需要几行代码。但是毕竟依赖于框架特点而且需要修改代码重新编译。
2. nginx作为代理服务器，然后区分真正的前端请求和后端请求。前端请求直接提供静态资源，后端请求通过nginx转发到后端程序对应的端口。这种方式需要nginx作为前端代理所以不够灵活。
3. nginx仅作为后端代理，本身提供跨域支持并能转发请求到真正的后端程序。前后端均分离，非常方便灵活。[配置参考](https://www.cnblogs.com/fnz0/p/15803011.html)

    ```nginx
    # 将来自9999的请求转发至8080端口
    server {
            listen 9999;

            server_name _;
            location / {
                    #proxy_set_header Host $host;
                    #proxy_set_header X-Realm-IP $remote_addr;
                    #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                    #proxy_set_header X-forwarded-Proto $scheme;


                    # handle OPTIONS request
                    if ($request_method = 'OPTIONS') {
                            add_header Access-Control-Allow-Origin '*' always;
                            add_header Access-Control-Allow-Methods '*';
                            add_header Access-Control-Allow-Headers '*';
                            add_header Access-Control-Allow-Credentials 'true';
                            return 204;
                    }
                    add_header Access-Control-Allow-Origin '*' always;
                    add_header Access-Control-Allow-Credentials 'true';

                    proxy_pass http://localhost:8080;
            }
    }
    ```

此后你可以使用任意方式托管swagger-ui，然后运行后端程序于8080端口。（后端端口如果需要修改可以通过修改nginx配置或者后端程序配置）

openapi文档记得将servers设置成可配置化：

```json
"servers": [
    {
        "url": "{scheme}://{host}/{basePath}",
        "description": "servers.url:description",
        "variables": {
            "scheme": {
                "default": "https",
                "enum": [
                    "https",
                    "http"
                ]
            },
            "host": {
                "default": "petstore.swagger.io",
                "enum": [
                    "petstore.swagger.io",
                    "192.168.31.5:9999"
                ],
                "description": "host"
            },
            "basePath": {
                "enum": [
                    "v2"
                ],
                "default": "v2"
            }
        }
    }
],
```

# 结语

在你有了接口想法后，就可以通过以上流程快速实现API真正落地。

快速搭建完毕后，你可以将你的精力尽管放在前后端真正的设计开发上。
