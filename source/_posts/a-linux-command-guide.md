---
layout: post
title: 一份Linux命令指南
date: 2021/11/15
updated: 2021/11/15
cover: /assets/linux.webp
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- Linux
- 学习笔记
---

<h1 align="center">
Linux命令识记
</h1>

## 帮助信息
### 1. 查看 Linux 命令帮助信息的要点

- 查看 Shell 内部命令的帮助信息 - 使用 [help](#help)
- 查看命令的简要说明 - 使用 [whatis](#whatis)
- 查看命令的详细说明 - 使用 [info](#info)
- 查看命令的位置 - 使用 [which](#which)
- 显示命令的类型 - 使用 [type](#type)
- 定位指令的二进制程序、源代码文件和 man 手册页等相关文件的路径 - 使用 [whereis](#whereis)
- 查看命令的帮助手册（包含说明、用法等信息） - 使用 [man](#man)

### 2. 命令常见用法

#### 2.1. help

> help 命令用于查看 Shell 内部命令的帮助信息。而对于外部命令的帮助信息只能使用 man 或者 info 命令查看。

#### 2.2. whatis

> whatis 用于查询一个命令执行什么功能。

#### 2.3. info

> info 是 Linux 下 info 格式的帮助指令。

#### 2.4. which

> which 命令用于查找并显示给定命令的绝对路径，环境变量 PATH 中保存了查找命令时需要遍历的目录。which 指令会在环境变量$PATH 设置的目录里查找符合条件的文件。也就是说，使用 which 命令，就可以看到某个系统命令是否存在，以及执行的到底是哪一个位置的命令。

**说明：which 是根据使用者所配置的 PATH 变量内的目录去搜寻可运行档的！**

#### 2.5. type

> type命令用于判断一个命令是内部命令还是外部命令。

#### 2.6. whereis

> whereis 命令用来定位指令的二进制程序、源代码文件和 man 手册页等相关文件的路径。
>
> whereis 命令只能用于程序名的搜索，而且只搜索二进制文件（参数-b）、man 说明文件（参数-m）和源代码文件（参数-s）。如果省略参数，则返回所有信息。

#### 2.7. man

> man 命令是 Linux 下的帮助指令，通过 man 指令可以查看 Linux 中的指令帮助、配置文件帮助和编程帮助等信息。

示例：

```bash
$ man date # 查看 date 命令的帮助手册
$ man 3 printf # 查看 printf 命令的帮助手册中的第 3 类
$ man -k keyword # 根据命令中部分关键字来查询命令
```

##### 2.7.1. man 要点

在 man 的帮助手册中，可以使用 page up 和 page down 来上下翻页。

man 的帮助手册中，将帮助文档分为了 9 个类别，对于有的关键字可能存在多个类别中， 我们就需要指定特定的类别来查看；（一般我们查询 bash 命令，归类在 1 类中）。

man 页面的分类(常用的是分类 1 和分类 3)：

1. 可执行程序或 shell 命令
2. 系统调用(内核提供的函数)
3. 库调用(程序库中的函数)
4. 特殊文件(通常位于 /dev)
5. 文件格式和规范，如 /etc/passwd
6. 游戏
7. 杂项(包括宏包和规范，如 man(7)，groff(7))
8. 系统管理命令(通常只针对 root 用户)
9. 内核例程 [非标准]

前面说到使用 whatis 会显示命令所在的具体的文档类别，我们学习如何使用它

```bash
$ whatis printf
printf (1) - format and print data
printf (1p) - write formatted output
printf (3) - formatted output conversion
printf (3p) - print formatted output
printf [builtins](1) - bash built-in commands, see bash(1)
```

我们看到 printf 在分类 1 和分类 3 中都有；分类 1 中的页面是命令操作及可执行文件的帮助；而 3 是常用函数库说明；如果我们想看的是 C 语言中 printf 的用法，可以指定查看分类 3 的帮助：

```bash
$ man 3 printf
```

### 3.一些小技巧
#### 命令别名
- 使用`alias`定义别名

示例:
```bash
alias name='string'

alias   #查看系统所有别名
```
- 使用`unalias`取消别名

示例：
```bash
unalias command
```
#### 输入输出重定向
示例:
```bash
command 2> file     #将标准错误流重定向到file
command > file 2>&1     #将标准错误流和标准输出流重定向到file
command &> file     #将标准错误流和标准输出流重定向到file
```
#### echo
示例:
```bash
echo 字符串     #字符串可以不带引号
echo 通配符     #匹配当前目录下的文件名
echo $((算术表达式))
echo {.,.,.}  #花括号展开（笛卡尔）
echo $var   #变量展开
echo $(command)     #命令替换
echo `command`      #命令替换
echo -e     #解释转义字符

#使用双引号会看作一个参数,内部符号只认'$'和'`',可使用\进行转义
#将所有字符原始输出
```
#### 立刻生效
```bash
source filename     在当前shell中从filename中读取命令并执行
```
### 4. 参考资料

[https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-help.md](https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-help.md)



## 磁盘管理

### 文件系统配置文件

| 文件路径                                      | 内容描述                       |
| --------------------------------------------- | ------------------------------ |
| /etc/filesystems                              | 系统指定的测试挂载文件系统类型 |
| /proc/filesystems                             | 系统已经加载的文件系统类型     |
| /lib/modules/3.10.0-1160.el7.x86_64/kernel/fs | 文件系统类型的驱动所在目录     |
| /etc/fstab                                    | 系统启动时要挂载的设备         |
| /etc/mtab                                     |                                |

### Linux文件类型的颜色

| 颜色     | 含义               |
| -------- | ------------------ |
| 蓝色     | 目录               |
| 绿色     | 可执行文件         |
| 红色     | 压缩文件           |
| 浅蓝色   | 链接文件           |
| 灰色     | 其他文件           |
| 红色闪烁 | 链接的文件出现问题 |
| 黄色     | 设备文件           |

### 文件系统操作命令

| 命令      | 效果                                                         |
| --------- | ------------------------------------------------------------ |
| df        | 列出文件系统的整体磁盘使用情况                               |
| du        | 列出目录所占空间                                             |
| dumpe2fs  | 显示当前的磁盘状态                                           |
| free      | 显示当前系统未使用的和已使用的内存，以及被内核使用的内存缓冲区 |
| fdisk     | 首先必须umount，操纵磁盘分区表，[<=2T]                                       |
| parted    | 2T以上磁盘分区工具                                           |
| partprobe | 更新分区表/磁盘                                              |
| mkfs      | 磁盘格式化(make file system)                                                   |
| e2label   | 设置磁盘卷标                                                 |
| mount     | 挂载磁盘                                                     |
| umount    | 卸载文件设备                                                 |
| dd        | 将数据移入\出设备                                             |



## 用户管理

### 前言

- Linux安全系统的核心是用户账户。用户权限是通过创建用户时分配的用户ID（UID）来跟踪的。
- 用户主目录默认位于**/home**目录下。root除外
- Linux系统使用一个专门的文件（/etc/passwd）来将用户的登录名匹配到对应的UID值，它包含了一些与用户有关的信息。
  
    各字段含义如下：

     登录用户名
     用户密码
     用户账户的UID（数字形式）
     用户账户的组ID（GID）（数字形式）
     用户账户的文本描述（称为备注字段）
     用户HOME目录的位置
     用户的默认shell

- 现在，绝大多数Linux系统都将用户密码保存在另一个单独的文件中（叫作shadow文件，位置在/etc/shadow）。只有特定的程序（比如登录程序）才能访问这个文件。

    各字段含义如下：

     与/etc/passwd文件中的登录名字段对应的登录名
     加密后的密码
     自上次修改密码后过去的天数密码（自1970年1月1日开始计算）
     多少天后才能更改密码
     多少天后必须更改密码
     密码过期前提前多少天提醒用户更改密码
     密码过期后多少天禁用用户账户
     用户账户被禁用的日期（用自1970年1月1日到当天的天数表示）
     预留字段给将来使用

### 用户相关命令
#### useradd

**useradd -D**  显示或更改默认的useradd配置（文件位置：/etc/default/useradd）

<img width="131" alt="useradd默认配置" src="https://user-images.githubusercontent.com/74645100/140612548-c89c300e-65e1-450f-868d-1df942b20881.png">

默认情况下，创建新用户会执行下列操作：

 新用户会被添加到GID为100的公共组；
 新用户的HOME目录将会位于/home/loginname；
 新用户账户密码在过期后不会被禁用；
 新用户账户未被设置过期日期；
 新用户账户将bash shell作为默认shell；
 系统会将/etc/skel目录下的内容复制到用户的HOME目录下；
 系统为该用户账户在mail目录下创建一个用于接收邮件的文件。

**useradd -m username**	创建用户的同时创建主目录

---

#### userdel	
**userdel username**	删除用户及用户默认组

**userdel -r username**	删除用户的同时删除主目录和邮件目录以及默认组

---

#### usermod

**usermod -l newlogin oldlogin** 不会影响home目录和邮件目录

**usermod -p pwd login**	修改login的登录密码

**usermod -g group_name user_name**	修改用户的组

**usermod -aG group username**	为用户添加组

---

#### passwd

**passwd**	修改当前用户密码

**passwd username**	修改用户密码

---

#### chage	

**chage**	修改用户密码的过期信息

---

#### id

**id**	查询用户所对应的UID和GID及GID所对应的用户组

---

#### finger

**finger**	查询用户信息，侧重用户家目录、登录shell等

---

#### w

**w**	查询登录主机的用户

---

#### who

**who**	查询登录主机的用户

---

#### users

**who**	查询登录主机的用户

---

#### last

**last**	显示每个用户最后的登录时间

---

#### lastlog

**lastlog**	显示每个用户最后的登录时间

---

#### cut -d: -f1 /etc/passwd

**cut -d: -f1 /etc/passwd**	查看系统所有用户

---

#### pwck

**pwck**	检查`etc/passwd`配置文件内的信息与实际主文件夹是否存在，还可比较`/etc/passwd`和`etc/shadow`的信息是否一致，另外如果`/etc/passwd`中的数据字段错误也会提示。

### 用户组相关命令

#### 相关配置文件

`etc/gshadow`

`etc/group`

---

#### groups

**groups username**	查看用户所在组

---

#### groupadd

---

#### groupdel

---

#### groupmod

---

#### cut -d: -f1 /etc/group
**cut -d: -f1 /etc/group**    查看系统所有组

---

#### grpck
**grpck**   类似于`pwck`,用于检查用户组


### 用户身份切换

#### 相关配置文件

`/etc/sudoers`

---

#### sudo
**sudo -l**     查看当前用户可以执行哪些root操作

---

#### su

**su**	切换用户
**su -c 'command'**     #使用root执行command



## 文件和目录

### 文件和目录管理
#### clear

**clear**	清屏

---

#### pwd

**pwd**	显示当前目录

---

#### tree
**tree**    树状显示当前目录

---

#### cd

**cd ..**	根目录\下也可以继续执行此命令，但无效果

**cd**	进入个人主目录

**cd -**	进入上一步所在目录

---

#### touch

**touch filename**	创建一个空文件

---

#### rm

**rm -i**	提示是否真的删除该文件

**rm -R**	递归删除目录

**rm -f**	不提示

---

#### mkdir

**mkdir 目录名**    创建目录

**mkdir dir1 dir2**    同时创建两个目录

**mkdir -p**	同时创建多个目录和子目录

---

#### rmdir

**rmdir**

---

#### ls

**ls -a**	列出隐藏文件及文件夹

**ls -A**	相对于-a少了 . 和 ..

**ls -F**	区分文件和目录

**ls -R**	列出当前目录下包含的子目录中的文件

**ls -l**	显示长列表

**ls -d**	列出目录本身的信息

**ls -i**	查看文件或目录的inode编号

---

#### ln

**ln -s 源文件 链接文件**	创建符号链接（软链接）
**ln 源文件 链接文件**	创建硬链接

---

#### cp

**cp source destination**	复制文件

**cp -i source destination**	需要覆盖时提示用户

**cp -R source destination**	递归复制整个目录或文件

---

#### scp
**scp**     远程拷贝文件

---

#### rsync

---

#### mv

**mv -i**	覆盖文件时提示用户

---

#### rename
**rename "matchstring" file**   批量重命名文件

---

#### file

**file filename**	探测文件

---

#### stat 
**stat filename**    显示文件的详细信息

---

#### locate
**locate filename**     列出所有匹配路径
> locate是从一个路径数据库中进行查找，使用**`updatedb`**命令更新该路径数据库。

---

#### find
**find dir**    在指定目录下查找文件

### 查看和编辑文件

#### cat

**cat**     接收键盘输入作为输入(按ctrl+D结束输入)

---

#### wc
**wc file**     默认显示file所包含的行数、字数和字节数      

---

#### less

**less**

---

#### tail

**tail**

---

#### head

**head**

---

#### tee
**tee file**    将标准输入输出到file和标准输出

---

#### grep
> grep（global search regular expression(RE) and print out the line，全面搜索正则表达式并把行打印出来）是一种强大的文本搜索工具，它能使用正则表达式搜索文本，并把匹配的行打印出来。

---

#### sed
> sed 是一种流编辑器，它是文本处理工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用 sed 命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有改变，除非你使用重定向存储输出。Sed 主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。

### 归档和压缩
#### tar
> tar 命令可以为 linux 的文件和目录创建档案。利用 tar，可以为某一特定文件创建档案（备份文件），也可以在档案中改变文件，或者向档案中加入新的文件。tar 最初被用来在磁带上创建档案，现在，用户可以在任何设备上创建档案。利用 tar 命令，可以把一大堆的文件和目录全部打包成一个文件，这对于备份文件或将几个文件组合成为一个文件以便于网络传输是非常有用的。

示例：

```bash
tar -cvf log.tar log2012.log            # 仅打包，不压缩
tar -zcvf log.tar.gz log2012.log        # 打包后，以 gzip 压缩
tar -jcvf log.tar.bz2 log2012.log       # 打包后，以 bzip2 压缩

tar -ztvf log.tar.gz                    # 查阅上述 tar 包内有哪些文件
tar -zxvf log.tar.gz                    # 将 tar 包解压缩
tar -zxvf log30.tar.gz log2013.log      # 只将 tar 内的部分文件解压出来
```
#### gzip
> gzip 命令用来压缩文件。gzip 是个使用广泛的压缩程序，文件经它压缩过后，其名称后面会多出“.gz”扩展名。
> 
> gzip 是在 Linux 系统中经常使用的一个对文件进行压缩和解压缩的命令，既方便又好用。gzip 不仅可以用来压缩大的、较少使用的文件以节省磁盘空间，还可以和 tar 命令一起构成 Linux 操作系统中比较流行的压缩文件格式。据统计，gzip 命令对文本文件有 60%～ 70%的压缩率。减少文件大小有两个明显的好处，一是可以减少存储空间，二是通过网络传输文件时，可以减少传输的时间。

示例：
```bash
gzip * # 将所有文件压缩成 .gz 文件
gzip -l * # 详细显示压缩文件的信息，并不解压
gzip -dv * # 解压上例中的所有压缩文件，并列出详细的信息
gzip -r log.tar     # 压缩一个 tar 备份文件，此时压缩文件的扩展名为.tar.gz
gzip -rv test/      # 递归的压缩目录
gzip -dr test/      # 递归地解压目录
```
#### zip
> zip 命令可以用来解压缩文件，或者对文件进行打包操作。zip 是个使用广泛的压缩程序，文件经它压缩后会另外产生具有“.zip”扩展名的压缩文件。

示例：
```bash
# 将 /home/Blinux/html/ 这个目录下所有文件和文件夹打包为当前目录下的 html.zip
zip -q -r html.zip /home/Blinux/html
```
#### unzip
unzip 命令用于解压缩由 zip 命令压缩的“.zip”压缩包。

示例：
```bash
unzip test.zip              # 解压 zip 文件
unzip -n test.zip -d /tmp/  # 在指定目录下解压缩
unzip -o test.zip -d /tmp/  # 在指定目录下解压缩，如果有相同文件存在则覆盖
unzip -v test.zip           # 查看压缩文件目录，但不解压
```

参考自[https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-file-compress.md](https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-file-compress.md)
### 权限管理

#### 前言

- 执行`ls -l`命令

    输出结果的第一个字段就是描述文件和目录权限的编码。这个字段的第一个字符代表了对象的类型：

     -代表文件
     d代表目录
     l代表链接
     c代表字符型设备
     b代表块设备
     n代表网络设备

- 之后有3组三字符的编码。每一组定义了3种访问权限：

     r代表对象是可读的
     w代表对象是可写的
     x代表对象是可执行的

    若没有某种权限，在该权限位会出现单破折线。

- 这3组权限分别对应对象的3个安全级别：
     对象的属主
     对象的属组
     系统其他用户

#### umask

**umask**	显示和设置用户账户的默认权限
**umask	xxxx**	为umask设置新值xxxx

- 第一位代表了一项特别的安全特征，叫做粘着位；后面的3位表示文件或目录对应的umask八进制值。

| 权限 | 二进制值 | 八进制值 |
| ---- | -------- | -------- |
| ---  | 000      | 0        |
| --x  | 001      | 1        |
| -w-  | 010      | 2        |
| -wx  | 011      | 3        |
| r--  | 100      | 4        |
| r-x  | 101      | 5        |
| rw-  | 110      | 6        |
| rwx  | 111      | 7        |

- 要把umask值从对象的全权限值中减掉。对文件来说，全权限的值是666（所有用户都有读和写的权限）；而对目录来说，则是777（所有用户都有读、写、执行权限）。

    所以**文件权限=全权限值-umask值**。

- 在大多数Linux发行版中，umask值通常会设置在/etc/profile启动文件中，不过有一些是设置在/etc/login.defs文件中的（如Ubuntu）

#### chmod

**chmod xxx file**	将file的权限设为xxx（直观）

**chmod u+x file**	为file属主添加执行权限

 u代表用户
 g代表组
 o代表其他
 a代表上述所有(默认)

**chmod u+s file**  执行该文件时以文件的所有者身份执行
**chmod g+s file**  执行该文件时以文件的所有者组身份执行
**chmod +t file**   阻止非所有者用户删除或重命名文件

#### chown

**chown user:group file**    改变文件属主为user，属组为group

#### chgrp

**chgrp**      改变文件的默认属组



## 系统管理
### 系统信息
#### lsb_release
**lsb_release**     查看系统版本信息

---

#### systemctl
> systemctl 命令是系统服务管理器指令，它实际上将 service 和 chkconfig 这两个命令组合到一起。

---

#### service
> service 命令是 Redhat Linux 兼容的发行版中用来控制系统服务的实用工具，它以启动、停止、重新启动和关闭系统服务，还可以显示所有系统服务的当前状态。

---

#### crontab
> crontab 命令被用来提交和管理用户的需要周期性执行的任务，与 windows 下的计划任务类似，当安装完成操作系统后，默认会安装此服务工具，并且会自动启动 crond 进程，crond 进程每分钟会定期检查是否有要执行的任务，如果有要执行的任务，则自动执行该任务。

### 进程管理

进程状态表

| 状态 | 含义                               |
| ---- | ---------------------------------- |
| R    |                                    |
| S    |                                    |
| D    | 不可中断睡眠，进程正在等待I/O      |
| T    | 已停止                             |
| Z    | 进程已经终止，但父进程还没有清空它 |
| <    | 高优先级进程                       |
| N    | 低优先级进程                       |

#### ps
> ps 命令用于报告当前系统的进程状态。可以搭配 kill 指令随时中断、删除不必要的程序。ps 命令是最基本同时也是非常强大的进程查看命令，使用该命令可以确定有哪些进程正在运行和运行的状态、进程是否结束、进程有没有僵死、哪些进程占用了过多的资源等等。
#### pstree
**pstree**      输出一个树型结构的进程列表
#### top
> 实时显示进程运行状况
#### jobs
> 列出从当前终端中启动了的任务
#### fg
> 将一个进程返回前台
#### bg
> 将一个进程返回后台
#### kill
**kill PID**    杀死进程
**kill %jobspec**   杀死进程
**kill -l**     查看完整的信号列表
> kill 命令用来删除执行中的程序或工作。kill 可将指定的信息送至程序。预设的信息为 SIGTERM(15),可将指定程序终止。若仍无法终止该程序，可使用 SIGKILL(9) 信息尝试强制删除程序。
#### killall
**killall procname**    杀死所有叫procname的进程
#### vmstat
**vmstat**  输出一个系统资源使用快照
#### xload
**xload**   画出系统负载随时间变化的图形

_注意:_
> ctrl+z停止程序
>
> ctrl+c终止程序
### 硬件管理
#### free
> 显示当前系统未使用的和已使用的内存，以及被内核使用的内存缓冲区
#### iotop
> iotop 命令是一个用来监视磁盘 I/O 使用状况的 top 类工具。

### 关机和重启
#### reboot
**reboot**  重启
**reboot -w**   模拟重启(有日志记录但不会真的重启)

---

#### shutdown
**shutdown -r** 重启(reboot)
**shutdown -H** 禁用CPU(halt)
**shutdown -P** 关闭电源(power off)
**shutdown -h** 要么禁用CPU要么关闭电源，由系统选择。

> 命令参数可以选择now（马上执行）、m（m分钟后执行）、hh:mm（指定时间执行）

参考自[**https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-system.md**](https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-system.md)



## 网络管理
### 1. Linux 网络应用要点

- 下载文件 - 使用 [curl](#curl)、[wget](#wget)
- telnet 方式登录远程主机，对远程主机进行管理 - 使用 [telnet](#telnet)
- 查看或操纵 Linux 主机的路由、网络设备、策略路由和隧道 - 使用 [ip](#ip)
- 查看和设置系统的主机名 - 使用 [hostname](#hostname)
- 查看和配置 Linux 内核中网络接口的网络参数 - 使用 [ifconfig](#ifconfig)
- 查看和设置 Linux 内核中的网络路由表 - 使用 [route](#route)
- ssh 方式连接远程主机 - 使用 ssh
- 为 ssh 生成、管理和转换认证密钥 - 使用 [ssh-keygen](#ssh-keygen)
- 查看、设置防火墙（Centos7），使用 [firewalld](#firewalld)
- 查看、设置防火墙（Centos7 以前），使用 [iptables](#iptables)
- 查看域名信息 - 使用 [host](#host), [nslookup](#nslookup)
- 设置路由 - 使用 [nc/netcat](#ncnetcat)
- 测试主机之间网络是否连通 - 使用 [ping](#ping)
- 追踪数据在网络上的传输时的全部路径 - 使用 [traceroute](#traceroute)
- 查看当前工作的端口信息 - 使用 [netstat](#netstat)

### 2. 命令常见用法

#### 2.1. curl

> curl 命令是一个利用 URL 规则在命令行下工作的文件传输工具。它支持文件的上传和下载，所以是综合传输工具，但按传统，习惯称 curl 为下载工具。作为一款强力工具，curl 支持包括 HTTP、HTTPS、ftp 等众多协议，还支持 POST、cookies、认证、从指定偏移处下载部分文件、用户代理字符串、限速、文件大小、进度条等特征。做网页处理流程和数据检索自动化，curl 可以祝一臂之力。
>
> 参考：http://man.linuxde.net/curl

示例：

```bash
# 下载文件
$ curl http://man.linuxde.net/text.iso --silent

# 下载文件，指定下载路径，并查看进度
$ curl http://man.linuxde.net/test.iso -o filename.iso --progress
########################################## 100.0%
```

#### 2.2. wget

> wget 命令用来从指定的 URL 下载文件。
>
> 参考：http://man.linuxde.net/wget

示例：

```bash
# 使用 wget 下载单个文件
$ wget http://www.linuxde.net/testfile.zip
```

#### 2.3. telnet

> telnet 命令用于登录远程主机，对远程主机进行管理。
>
> 参考：http://man.linuxde.net/telnet

示例：

```bash
telnet 192.168.2.10
Trying 192.168.2.10...
Connected to 192.168.2.10 (192.168.2.10).
Escape character is '^]'.

    localhost (Linux release 2.6.18-274.18.1.el5 #1 SMP Thu Feb 9 12:45:44 EST 2012) (1)

login: root
Password:
Login incorrect
```

#### 2.4. ip

> ip 命令用来查看或操纵 Linux 主机的路由、网络设备、策略路由和隧道，是 Linux 下较新的功能强大的网络配置工具。
>
> 参考：http://man.linuxde.net/ip

示例：

```bash
$ ip link show                     # 查看网络接口信息
$ ip link set eth0 upi             # 开启网卡
$ ip link set eth0 down            # 关闭网卡
$ ip link set eth0 promisc on      # 开启网卡的混合模式
$ ip link set eth0 promisc offi    # 关闭网卡的混个模式
$ ip link set eth0 txqueuelen 1200 # 设置网卡队列长度
$ ip link set eth0 mtu 1400        # 设置网卡最大传输单元
$ ip addr show     # 查看网卡IP信息
$ ip addr add 192.168.0.1/24 dev eth0 # 设置eth0网卡IP地址192.168.0.1
$ ip addr del 192.168.0.1/24 dev eth0 # 删除eth0网卡IP地址

$ ip route show # 查看系统路由
$ ip route add default via 192.168.1.254   # 设置系统默认路由
$ ip route list                 # 查看路由信息
$ ip route add 192.168.4.0/24  via  192.168.0.254 dev eth0 # 设置192.168.4.0网段的网关为192.168.0.254,数据走eth0接口
$ ip route add default via  192.168.0.254  dev eth0        # 设置默认网关为192.168.0.254
$ ip route del 192.168.4.0/24   # 删除192.168.4.0网段的网关
$ ip route del default          # 删除默认路由
$ ip route delete 192.168.1.0/24 dev eth0 # 删除路由
```

#### 2.5. hostname

> hostname 命令用于查看和设置系统的主机名称。环境变量 HOSTNAME 也保存了当前的主机名。在使用 hostname 命令设置主机名后，系统并不会永久保存新的主机名，重新启动机器之后还是原来的主机名。如果需要永久修改主机名，需要同时修改 `/etc/hosts` 和 `/etc/sysconfig/network` 的相关内容。
>
> 参考：http://man.linuxde.net/hostname

示例：

```bash
$ hostname
AY1307311912260196fcZ
```

#### 2.6. ifconfig

> ifconfig 命令被用于查看和配置 Linux 内核中网络接口的网络参数。用 ifconfig 命令配置的网卡信息，在网卡重启后机器重启后，配置就不存在。要想将上述的配置信息永远的存的电脑里，那就要修改网卡的配置文件了。
>
> 参考：http://man.linuxde.net/ifconfig

示例：

```bash
# 查看网络设备信息（激活状态的）
[root@localhost ~]# ifconfig
eth0      Link encap:Ethernet  HWaddr 00:16:3E:00:1E:51
          inet addr:10.160.7.81  Bcast:10.160.15.255  Mask:255.255.240.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:61430830 errors:0 dropped:0 overruns:0 frame:0
          TX packets:88534 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:3607197869 (3.3 GiB)  TX bytes:6115042 (5.8 MiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:56103 errors:0 dropped:0 overruns:0 frame:0
          TX packets:56103 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:5079451 (4.8 MiB)  TX bytes:5079451 (4.8 MiB)
```

#### 2.7. route

> route 命令用来查看和设置 Linux 内核中的网络路由表，route 命令设置的路由主要是静态路由。要实现两个不同的子网之间的通信，需要一台连接两个网络的路由器，或者同时位于两个网络的网关来实现。
>
> 参考：http://man.linuxde.net/route

示例：

```bash
# 查看当前路由
route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
112.124.12.0    *               255.255.252.0   U     0      0        0 eth1
10.160.0.0      *               255.255.240.0   U     0      0        0 eth0
192.168.0.0     10.160.15.247   255.255.0.0     UG    0      0        0 eth0
172.16.0.0      10.160.15.247   255.240.0.0     UG    0      0        0 eth0
10.0.0.0        10.160.15.247   255.0.0.0       UG    0      0        0 eth0
default         112.124.15.247  0.0.0.0         UG    0      0        0 eth1

route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0    # 添加网关/设置网关
route add -net 224.0.0.0 netmask 240.0.0.0 reject      # 屏蔽一条路由
route del -net 224.0.0.0 netmask 240.0.0.0             # 删除路由记录
route add default gw 192.168.120.240                   # 添加默认网关
route del default gw 192.168.120.240                   # 删除默认网关
```

#### 2.8. ssh

> ssh 命令是 openssh 套件中的客户端连接工具，可以给予 ssh 加密协议实现安全的远程登录服务器。
>
> 参考：http://man.linuxde.net/ssh

示例：

```bash
# ssh 用户名@远程服务器地址
ssh user1@172.24.210.101
# 指定端口
ssh -p 2211 root@140.206.185.170
```

引申阅读：[ssh 背后的故事](https://linux.cn/article-8476-1.html)

#### 2.9. ssh-keygen

> ssh-keygen 命令用于为 ssh 生成、管理和转换认证密钥，它支持 RSA 和 DSA 两种认证密钥。
>
> 参考：http://man.linuxde.net/ssh-keygen

#### 2.10. firewalld

> firewalld 命令是 Linux 上的防火墙软件（Centos7 默认防火墙）。
>
> 参考：https://www.cnblogs.com/moxiaoan/p/5683743.html

##### 2.10.1. firewalld 的基本使用

- 启动 - systemctl start firewalld
- 关闭 - systemctl stop firewalld
- 查看状态 - systemctl status firewalld
- 开机禁用 - systemctl disable firewalld
- 开机启用 - systemctl enable firewalld

##### 2.10.2. 使用 systemctl 管理 firewalld 服务

systemctl 是 CentOS7 的服务管理工具中主要的工具，它融合之前 service 和 chkconfig 的功能于一体。

- 启动一个服务 - systemctl start firewalld.service
- 关闭一个服务 - systemctl stop firewalld.service
- 重启一个服务 - systemctl restart firewalld.service
- 显示一个服务的状态 - systemctl status firewalld.service
- 在开机时启用一个服务 - systemctl enable firewalld.service
- 在开机时禁用一个服务 - systemctl disable firewalld.service
- 查看服务是否开机启动 - systemctl is-enabled firewalld.service
- 查看已启动的服务列表 - systemctl list-unit-files|grep enabled
- 查看启动失败的服务列表 - systemctl --failed

##### 2.10.3. 配置 firewalld-cmd

- 查看版本 - firewall-cmd --version
- 查看帮助 - firewall-cmd --help
- 显示状态 - firewall-cmd --state
- 查看所有打开的端口 - firewall-cmd --zone=public --list-ports
- 更新防火墙规则 - firewall-cmd --reload
- 查看区域信息: firewall-cmd --get-active-zones
- 查看指定接口所属区域 - firewall-cmd --get-zone-of-interface=eth0
- 拒绝所有包：firewall-cmd --panic-on
- 取消拒绝状态 - firewall-cmd --panic-off
- 查看是否拒绝 - firewall-cmd --query-panic

##### 2.10.4. 在防火墙中开放一个端口

- 添加（--permanent 永久生效，没有此参数重启后失效） - firewall-cmd --zone=public --add-port=80/tcp --permanent
- 重新载入 - firewall-cmd --reload
- 查看 - firewall-cmd --zone= public --query-port=80/tcp
- 删除 - firewall-cmd --zone= public --remove-port=80/tcp --permanent

#### 2.11. iptables

> iptables 命令是 Linux 上常用的防火墙软件，是 netfilter 项目的一部分。可以直接配置，也可以通过许多前端和图形界面配置。
>
> 参考：http://man.linuxde.net/iptables

示例：

```bash
# 开放指定的端口
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT               #允许本地回环接口(即运行本机访问本机)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT    #允许已建立的或相关连的通行
iptables -A OUTPUT -j ACCEPT         #允许所有本机向外的访问
iptables -A INPUT -p tcp --dport 22 -j ACCEPT    #允许访问22端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT    #允许访问80端口
iptables -A INPUT -p tcp --dport 21 -j ACCEPT    #允许ftp服务的21端口
iptables -A INPUT -p tcp --dport 20 -j ACCEPT    #允许FTP服务的20端口
iptables -A INPUT -j reject       #禁止其他未允许的规则访问
iptables -A FORWARD -j REJECT     #禁止其他未允许的规则访问

# 屏蔽IP
iptables -I INPUT -s 123.45.6.7 -j DROP       #屏蔽单个IP的命令
iptables -I INPUT -s 123.0.0.0/8 -j DROP      #封整个段即从123.0.0.1到123.255.255.254的命令
iptables -I INPUT -s 124.45.0.0/16 -j DROP    #封IP段即从123.45.0.1到123.45.255.254的命令
iptables -I INPUT -s 123.45.6.0/24 -j DROP    #封IP段即从123.45.6.1到123.45.6.254的命令是

# 查看已添加的iptables规则
iptables -L -n -v
Chain INPUT (policy DROP 48106 packets, 2690K bytes)
 pkts bytes target     prot opt in     out     source               destination
 5075  589K ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0
 191K   90M ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:22
1499K  133M ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:80
4364K 6351M ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED
 6256  327K ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 3382K packets, 1819M bytes)
 pkts bytes target     prot opt in     out     source               destination
 5075  589K ACCEPT     all  --  *      lo      0.0.0.0/0            0.0.0.0/0
```

#### 2.12. host

> host 命令是常用的分析域名查询工具，可以用来测试域名系统工作是否正常。
>
> 参考：http://man.linuxde.net/host

示例：

```bash
[root@localhost ~]# host www.jsdig.com
www.jsdig.com is an alias for host.1.jsdig.com.
host.1.jsdig.com has address 100.42.212.8

[root@localhost ~]# host -a www.jsdig.com
Trying "www.jsdig.com"
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34671
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;www.jsdig.com.               IN      ANY

;; ANSWER SECTION:
www.jsdig.com.        463     IN      CNAME   host.1.jsdig.com.

Received 54 bytes from 202.96.104.15#53 in 0 ms
```

#### 2.13. nslookup

> nslookup 命令是常用域名查询工具，就是查 DNS 信息用的命令。
>
> 参考：http://man.linuxde.net/nslookup

示例：

```bash
[root@localhost ~]# nslookup www.jsdig.com
Server:         202.96.104.15
Address:        202.96.104.15#53

Non-authoritative answer:
www.jsdig.com canonical name = host.1.jsdig.com.
Name:   host.1.jsdig.com
Address: 100.42.212.8
```

#### 2.14. nc/netcat

> nc 命令是 netcat 命令的简称，都是用来设置路由器。
>
> 参考：http://man.linuxde.net/nc_netcat

示例：

```bash
# TCP 端口扫描
[root@localhost ~]# nc -v -z -w2 192.168.0.3 1-100
192.168.0.3: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.0.3] 80 (http) open
(UNKNOWN) [192.168.0.3] 23 (telnet) open
(UNKNOWN) [192.168.0.3] 22 (ssh) open

# UDP 端口扫描
[root@localhost ~]# nc -u -z -w2 192.168.0.1 1-1000  # 扫描192.168.0.3 的端口 范围是 1-1000
```

#### 2.15. ping

> ping 命令用来测试主机之间网络的连通性。执行 ping 指令会使用 ICMP 传输协议，发出要求回应的信息，若远端主机的网络功能没有问题，就会回应该信息，因而得知该主机运作正常。
>
> 参考：http://man.linuxde.net/ping

示例：

```bash
[root@AY1307311912260196fcZ ~]# ping www.jsdig.com
PING host.1.jsdig.com (100.42.212.8) 56(84) bytes of data.
64 bytes from 100-42-212-8.static.webnx.com (100.42.212.8): icmp_seq=1 ttl=50 time=177 ms
64 bytes from 100-42-212-8.static.webnx.com (100.42.212.8): icmp_seq=2 ttl=50 time=178 ms
64 bytes from 100-42-212-8.static.webnx.com (100.42.212.8): icmp_seq=3 ttl=50 time=174 ms
64 bytes from 100-42-212-8.static.webnx.com (100.42.212.8): icmp_seq=4 ttl=50 time=177 ms
...按Ctrl+C结束

--- host.1.jsdig.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2998ms
rtt min/avg/max/mdev = 174.068/176.916/178.182/1.683 ms
```

#### 2.16. traceroute

> traceroute 命令用于追踪数据包在网络上的传输时的全部路径，它默认发送的数据包大小是 40 字节。
>
> 参考：http://man.linuxde.net/traceroute

示例：

```bash
traceroute www.58.com
traceroute to www.58.com (211.151.111.30), 30 hops max, 40 byte packets
 1  unknown (192.168.2.1)  3.453 ms  3.801 ms  3.937 ms
 2  221.6.45.33 (221.6.45.33)  7.768 ms  7.816 ms  7.840 ms
 3  221.6.0.233 (221.6.0.233)  13.784 ms  13.827 ms 221.6.9.81 (221.6.9.81)  9.758 ms
 4  221.6.2.169 (221.6.2.169)  11.777 ms 122.96.66.13 (122.96.66.13)  34.952 ms 221.6.2.53 (221.6.2.53)  41.372 ms
 5  219.158.96.149 (219.158.96.149)  39.167 ms  39.210 ms  39.238 ms
 6  123.126.0.194 (123.126.0.194)  37.270 ms 123.126.0.66 (123.126.0.66)  37.163 ms  37.441 ms
 7  124.65.57.26 (124.65.57.26)  42.787 ms  42.799 ms  42.809 ms
 8  61.148.146.210 (61.148.146.210)  30.176 ms 61.148.154.98 (61.148.154.98)  32.613 ms  32.675 ms
 9  202.106.42.102 (202.106.42.102)  44.563 ms  44.600 ms  44.627 ms
10  210.77.139.150 (210.77.139.150)  53.302 ms  53.233 ms  53.032 ms
11  211.151.104.6 (211.151.104.6)  39.585 ms  39.502 ms  39.598 ms
12  211.151.111.30 (211.151.111.30)  35.161 ms  35.938 ms  36.005 ms
```

#### 2.17. netstat

> netstat 命令用来打印 Linux 中网络系统的状态信息，可让你得知整个 Linux 系统的网络情况。
>
> 参考：http://man.linuxde.net/netstat

示例：

```bash
# 列出所有端口 (包括监听和未监听的)
netstat -a     #列出所有端口
netstat -at    #列出所有tcp端口
netstat -au    #列出所有udp端口

# 列出所有处于监听状态的 Sockets
netstat -l        #只显示监听端口
netstat -lt       #只列出所有监听 tcp 端口
netstat -lu       #只列出所有监听 udp 端口
netstat -lx       #只列出所有监听 UNIX 端口

# 显示每个协议的统计信息
netstat -s   显示所有端口的统计信息
netstat -st   显示TCP端口的统计信息
netstat -su   显示UDP端口的统计信息
```

参考自[https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-net.md](https://github.com/dunwu/linux-tutorial/blob/master/docs/linux/cli/linux-cli-net.md)



## 软件安装

### RPM

- #### rpm

    **rpm initdb**	初始化rpm数据库

    **rpm updatedb**	更新rpm数据库

    **rpm -ivh xxx.rpm**    安装rpm包

    **rpm -e 包名**     卸载rpm包,包名不可以包含后缀

    **配置文件为`rpmrc`，一般位于`/usr/lib/rpm/rpmrc`。**

- #### yum

    ##### 配置文件

    * **`/etc/yum.repos.d`**
    * **`etc/yum.conf`**

    ##### 获取软件包信息

    * **yum list installed**	显示系统上已安装的包

    * **yum list package**	列出package的详细信息

    * **yum list installed package**	查看package是否已安装
    * **yum info**    列出所有软件包的信息
    * **yum search package**    查询package

    * **yum provides file_name**	找出系统上的某个特定文件属于哪个软件包

    ##### 安装软件包

    * **yum install package_name**	安装软件包

    * **yum localinstall package_name.rpm**	手动下载rpm安装文件并用yum安装（本地安装）

    ##### 更新软件包

    * **yum list updates**	列出所有已安装包的可用更新

    * **yum update package_name**	更新软件包

    * **yum update**	对列表中的所有包进行更新

    ##### 卸载软件包

    * **yum remove package_name**	只删除软件包而保留配置文件和数据文件

    * **yum erase package_name**	删除软件和它所有的文件

    ##### 清除缓存

    * **yum clean packages**    清除缓存目录下的软件包
    
    * **yum clean headers**    清除缓存目录下的 headers

    * **yum clean oldheaders**    清除缓存目录下旧的 headers

    ##### 其他软件包信息

    * **yum deplist package_name**	显示所有包的库依赖关系以及什么软件可以提供这些库依赖关系

    * **yum repolist all**	显示当前获取软件的所有仓库

### DPKG



## shell编程
### 环境变量
#### printenv
**printenv**    查看所有环境变量
**printenv var**    查看环境变量var的值(不需要带上$)
#### set
**set**     查看环境变量、shell变量、shell函数

