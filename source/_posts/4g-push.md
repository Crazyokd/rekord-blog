---
title: 4G 短信和语音推送
date: 2024/7/29
updated: 2024/7/29
index_img: https://cdn.sxrekord.com/blog/asterisk.png
categories: 
- 技术
tags:
- C/C++
---


# **短信推送**

## 方案1

创建一个新的sms-c网元（c表示control）。

该网元的功能主要有：

1. 与sms建立diameter连接。
2. 能够正常向sms发送ofr信令，并接收ofa信令。
3. 接收并处理命令行输入（由用户给出被推送目标信息）

‍

成品：

```shell
# 进入容器内部
docker exec -it sms-c env LANG=C.UTF-8 bash
# 启动sms接管程序
./etc/sms-c.sh
# 等待diameter连接成功后即可开始推送短信
> help
Usage: called data caller sc-addr
called          Required argument
data            Required argument
caller          Optional argument
sc-addr         Optional argument
help            Show this help message
Ctrl+D          Quit the program
```

## 方案2：

1. 增加一条用于发送短信的extension

```conf
exten => 203,1,NoOp(SMS Sending Extension)

 same => n,Set(MESSAGE_DATA(Content-Type)=application/vnd.3gpp.sms)

 same => n,AGI(send_sms.py,1234,1234,hello)

 same => n,Set(MESSAGE(body)=hello)

 same => n,Set(MESSAGE(from)=sip:0000f30A0A01@192.168.70.1)

 same => n,Set(MESSAGE(to)=sip:0000f30B0B02@192.168.70.1)

 same => n,MessageSend(pjsip:0000f30A0A01@192.168.70.1, sip:0000f30B0B02@192.168.70.1)

 same => n,Hangup()
```

2. 使用ari触发这条extension。

==Warning==：

方案2的宏观流程确实可以分为以上两步，但是第一步中想要正确的设置MESSAGE(body)非常不容易。

如果不使用MESSAGE_DATA设置sip头字段，则body发送的是纯文本，理论上手机肯定不吃这一套。

如果设置了body类型为application/vnd.3gpp.sms，那么body需要设置为rp-data（deliver）的utf8字符串形式。

Asterisk并没有对于gsm编码的支持，但是我们可以使用agi脚本通过传参交由脚本去完成短信编码工作（通常是shell脚本或python脚本）。

最后再将该结果传递进环境变量，交由asterisk并将这些utf8字符再转为字节流从网络发送出去。

---

但是短信编解码只是一个小众领域，所以很难找到好用完善的库。另外很多库对中文编码也不感兴趣。

综上，即使使用agi脚本调用外部程序也需要满足几个条件：

1. 库足够完善
2. 能够生成最后编码结果（通常是字节数组形式）的utf8字符串形式。

> 最终简单修改了[smspdu](https://github.com/legale/smspdu/pull/1)库，使之能够支持中文编码。

==Error==：

事实上外部程序中最终结果只能以字节数组的形式输出，因为最终的字节数组通常无法被编码为ascii或utf-8格式（其他格式不考虑可行性）。

也就意味着无论如何都无法将结果传递给MESSAGE(body），所以这种方案是不可行的。

‍

# **语音推送**

## 命令示例：

### asterisk内部命令：

channel originate PJSIP/0000f30A0A01 extension 200@sets

### Ari请求：

[http://192.168.70.128:8088/ari/channels?endpoint=PJSIP%2F0000f30A0A01&amp;extension=200&amp;context=sets&amp;timeout=30&amp;api_key=asterisk:passwd](http://192.168.70.128:8088/ari/channels?endpoint=PJSIP%2F0000f30A0A01&extension=200&context=sets&timeout=30&api_key=asterisk:passwd)

如果要使用变量，就在请求体中加上：

```json
{
  "variables": {
    "self_sound": "hello-world"
  }
}
```

> 如果asterisk报错Strict RTP learning...
>
> 则需要修改rtp.conf文件，将其中的strictrtp设为no

## 程序

使用aricpp库写一个小程序，其至少应包含以下功能：

1. 与asterisk建立连接
2. 能够发送ari命令
3. 接收命令行输入（由用户给出被推送目标信息）

‍

成品：

```c++
#include <boost/program_options.hpp>
#include <string>
#include <thread>
#include "../include/aricpp/client.h"
#include "../include/aricpp/urlencode.h"

using namespace std;
using namespace aricpp;

int main( int argc, char* argv[] )
{
    try
    {
        string host = "172.16.30.49";
        string port = "8088";
        string username = "asterisk";
        string password = "passwd";
        string application = "zarniwoop";


        namespace po = boost::program_options;
        po::options_description desc("Allowed options");
        desc.add_options()
            ("help,h", "produce help message")
            ("version,V", "print version string")

            ("host,H", po::value(&host), "ip address of the ARI server [localhost]")
            ("port,P", po::value(&port), "port of the ARI server [8088]")
            ("username,u", po::value(&username), "username of the ARI account on the server [asterisk]")
            ("password,p", po::value(&password), "password of the ARI account on the server [asterisk]")
            ("application,a", po::value(&application), "stasis application to use [attendant]")
        ;

        po::variables_map vm;
        po::store(po::parse_command_line(argc, argv, desc), vm);
        po::notify(vm);

        if (vm.count("help"))
        {
            std::cout << desc << "\n";
            return 0;
        }

        if (vm.count("version"))
        {
            cout << "This is push application v1.0.\n";
            return 0;
        }

#if BOOST_VERSION < 106600
        using IoContext = boost::asio::io_service;
#else
        using IoContext = boost::asio::io_context;
#endif
        IoContext ios;

        Client client( ios, host, port, username, password, application );
        client.Connect( [&](boost::system::error_code e){
            if (e) cerr << "Error connecting: " << e.message() << '\n';
            else {
                cout << "Connected" << '\n';
            }
        });

        auto inputReader = [&]()
        {
            string line;
            while (true)
            {
                cout << "> Enter called and the voice you need to push:\n";
                getline( std::cin, line );

                std::istringstream iss(line);
                std::string called, voice, caller;

                if (!(iss >> called >> voice)) {
                    std::cerr << "Error: Not enough input." << std::endl;
                    continue;
                }

                auto url = "/ari/channels?endpoint=PJSIP%2F"+called+"&extension=2839&context=ims&timeout=30&api_key=asterisk:passwd";
                if (iss >> caller) {
                    url += "&callerId=" + caller;
                }
                if (iss.rdbuf()->in_avail() != 0) {
                    std::cerr << "Warning: Extra input detected." << std::endl;
                }

                auto sendRequest =
                    [&client,url,voice]()
                    {
                        client.RawCmd(Method::post, url, [](auto,auto,auto,auto){}, "{\"variables\": {\"push_sound\": \""+voice+"\"}}");
                    };

#if BOOST_VERSION < 106600
                ios.post(sendRequest);
#else
                boost::asio::post(ios.get_executor(), sendRequest);
#endif
            }

            cout << "Exiting application\n";
            ios.stop();
        };
        thread readerThread( inputReader );

        ios.run();

        readerThread.join();

    }
    catch ( const exception& e )
    {
        cerr << "Exception in app: " << e.what() << ". Aborting\n";
        return -1;
    }
    return 0;
}

```


