---
layout: post
title: 8086汇编
date: 2023/10/10
updated: 2023/10/10
cover: https://cdn.sxrekord.com/blog/dosbox.png
coverWidth: 639
coverHeight: 302
comments: true
categories:
- 技术
tags:
- 汇编
---


# 环境搭建

这次我使用的环境为vscode+MASM/TASM插件。

如果你想完全自己来的话，需要下载一个[dosbox]([https://www.dosbox.com/](https://www.dosbox.com/))和以下几个8086开发程序以用于编译和链接。

- debug.exe：调试
- MASM.exe：编译
- LINK.exe：链接

然后在dosbox的*dosbox.conf*中添加以下配置：

```batch
[autoexec]
# 挂载MASM开发工具所在目录
mount c "path\to\MASM-v6.11""
# 设置环境变量
set PATH=C:\MASM
```

- 不嫌难用的话，可以在dosbox中使用edit命令编辑源文件。

# 寄存器

## 寄存器一览

ax, bx, cx, dx, si, di, bp, sp, IP, cs, ss, ds, es

## 通用寄存器

`ax`：十分通用，特殊：作为除法指令的被除数或被除数的低16位并存放指令执行后的结果（高位存余数，低位存商），作为乘法指令的乘数或执行后结果的低位

`bx`：除通用外还可以做内存地址的偏移地址，比如`mov ax, [bx]`

`cx`：loop指令的隐式判断对象，还可以作为移位指令的参数

`dx`：特殊：作为除法指令的高16位并存放指令执行后的余数，并作为乘法指令结果的高位

- **这些通用寄存器在很多指令中往往都有隐含的作用，上面的说明只是很小的一部分。**

## 段寄存器

`cs`：代码段，配合IP使用

`ss`：栈段，配合sp使用

`ds`：数据段，配合bx/bp/si/di或立即数使用

`es`：扩展段(movsb/movsw会用到)

## si/di

source/destination

si和di不能分成两个8位寄存器使用，si和di也能提供bx的能力（即做内存地址的偏移地址），并且可以与bx/bp共同使用，如[bx+si]或写成[bx][si]

**但这四个寄存器只能以bx和si或bx和di或bp和si或bp和di的组合出现**

## bp/bx

bp的使用类似于`bx`，只要在[…]中使用寄存器bp，而指令中没有显式的给出段地址，段地址默认为`ss`，反之，如果使用bx，则默认段地址为ds。

## 标志寄存器(`flag`)

![flag](https://cdn.sxrekord.com/blog/flag.png)

zf：零标志位，它记录相关指令执行后，其结果是否为0，如果为0，则zf=1

pf：奇偶标志位，它记录相关指令执行后，其结果的所有位中1的个数是否为偶数，如果为偶数，则pf=1

sf：符号标志位，它记录相关指令执行后，其结果是否为负，如果为负，sf=1

cf：进位标志位，它记录相关指令执行后，其结果是否进位，如果进位，cf=1**（无符号）**

of：溢出标志位，进行有符号运算时，如果溢出，结果将不正确**（有符号）**

df：方向标志位，df=0，每次操作后si、di递增；反之递减

tf：单步中断标志位，它记录相关指令执行后，tf是否为1，如果为1，则单步中断

if：为0不响应可屏蔽中断，可通过`sti`（设为1）和`cli`指令设置值

# 算术运算指令

## 加法

| ADD | 加法 |  |
| --- | --- | --- |
| ADC | 带进位的加法 | 操作对象1 = 操作对象1 + 操作对象2 + cf |
| INC |  | INC BYTE PTR[BX] |
| AAA | 加法的ASCII调整(ASCII Adjust for Addition) | 针对非压缩十进制数 |
| DAA | 加法的十进制调整(Decimal Adjust for Addition) | 针对压缩十进制数 |

## 减法

| SUB | 减法 |  |
| --- | --- | --- |
| SBB | 带借位的减法 | 操作对象1 = 操作对象1 - 操作对象2 - cf |
| DEC |  |  |
| NEG | 取负 |  |
| CMP | 比较 | 操作对象1 - 操作对象2 |
| AAS | 减法的ASCII调整(ASCII Adjust for Subtraction) |  |
| DAS | 减法的十进制调整(Decimal Adjust for Subtraction) |  |

## 乘法

| MUL | 无符号数乘法 | AX = AL * 源 || (DX,AX) = AX * 源 | 源操作数不能是立即数，当源操作数是存储单元时，必须在操作数前加BYTE或WORD |
| --- | --- | --- | --- |
| IMUL | 整数乘法(Integer multiply) |  |  |
| AAM | 乘法的ASCII调整 |  |  |

## 除法

| DIV | 无符号数除法 |  |
| --- | --- | --- |
| IDIV |  |  |
| AAD | 除法的ASCII调整 | 除法运算前执行 |
| CBW | 把字节转换成字 | 把寄存器AL中的符号位扩充到AH的所有位 |
| CWD | 把字转换为双字 | 把寄存器AX中的符号位扩充到DX的所有位 |

# 逻辑运算和移位指令

## 逻辑运算

| NOT |  | 对标志位无影响 |
| --- | --- | --- |
| AND |  |  |
| OR |  |  |
| XOR |  |  |
| TEST |  | 对两个操作数进行逻辑与操作，并修改标志位，但不回送结果 |

## 算术逻辑移位

| SHL/SHA | 逻辑/算术左移 | 最低位补0，最高有效位写入cf；如果移动次数大于1，必须将移动次数放在cl中。 |
| --- | --- | --- |
| SHR | 逻辑右移 | 将移出的那一位写入CF，将空出的那一位用0填充；如果移动次数大于1，必须将移动次数放在cl中。 |
| SAR(arithmetic) | 算术右移 | 最低位移入CF，最高位保持不变；如果移动次数大于1，必须将移动次数放在cl中。 |

## 循环移位

| 指令 | 含义 | 功能 |
| --- | --- | --- |
| ROL dst,cnt | Rotate Left | 循环左移 cnt 位 |
| ROR dst,cnt | Rotate Right | 循环右移 cnt 位 |
| RCL dst,cnt | Rotate through Carry Left | 带进位左移 cnt 位 |
| RCR dst,cnt | Rotate through Carry Right | 带进位右移 cnt 位 |

# 数据传送指令

## 通用数据传送指令

| mov | 字节或字的传送 | IP寄存器不能用作源操作数或目的操作数，目的操作数也不允许用立即数和CS寄存器。两个操作数中必有一个是寄存器，但不能都是段寄存器 |
| --- | --- | --- |
| push | 入栈 |  |
| pop | 出栈 |  |
| XCHG | 交换字或字节 | 段寄存器不能作为操作数，也不能直接交换两个存储单元中的内容 |
| XLAT | 表转换 | BX、AL |

## 输入输出指令

| in | 输入 | AL/AX、DX | in al, 85h |
| --- | --- | --- | --- |
| out | 输出 | AL/AX、DX | out 85h, al |

## 地址目标传送指令

| LEA | 转入有效地址 | 源操作数必须是存储单元，而目的操作数必须是除段寄存器外的16位寄存器 |  |
| --- | --- | --- | --- |
| LDS | 装入数据段寄存器 | 源操作数必须是存储单元，而目的操作数必须是除段寄存器外的16位寄存器。源操作数的低两位送入目的操作数，高两位送入DS | lds si, [450h] |
| LES | 转入附加段寄存器 |  | les di, [bx] |

## 标志传送指令

| LAHF | 标志寄存器低字节装入AH（load ah from Flags） | 把标志寄存器SF、ZF、AF、PF和CF分别传送到AH寄存器的位7、6、4、2、0。 |
| --- | --- | --- |
| SAHF | AH内容装入标志寄存器低字节（store ah into Flags） |  |
| PUSHF | 标志寄存器入栈 | 把整个寄存器的内容推入堆栈 |
| POPF | 标志寄存器出栈 |  |

# 字符串处理指令

| 指令名称 | 字节/字操作 | 字节操作 | 字操作 |  |
| --- | --- | --- | --- | --- |
| 字符串传送 | movs 目的串, 源串 | movsb | movsw |  |
| 字符串比较 | cmps 目的串, 源串 | cmpsb | cmpsw |  |
| 字符串扫描 | scans 目的串 | scansb | scansw | 从AL/AX寄存器的内容减去es:di为指针的目的串元素，结果反映在标志位上，但不改变源操作数 |
| 字符串装入 | lods 源串 | lodsb | lodsw | 把ds:si作为指针的串元素，传送到AL/AX中 |
| 字符串存储 | stos 目的串 | stosb | stosw | 把al/ax中的一个字节或字传送到es:di为目标指针的目的串中。 |

`movsb/movsw`

```nasm
; movsb
mov es:[di], byte ptr ds:[si]
if df = 0: inc si, inc di
else dec si, dec di
; movsw
mov es:[di], word ptr ds:[si]
if df = 0: add si, 2, add di, 2
else add si, 2, add di, 2
```

movsb/movsw 一般和 rep 配合使用，语法为 `rep/repe/repz/repne/repnz movsb/movsw`

`cld`指令可以将df设置为0

`std`指令可以将df设置为1

# 控制转移指令

可以修改IP，或同时修改CS和IP的指令称为转移指令。

## 无条件转移和过程调用指令

- 段内转移，如jmp ax
    - 短转移（-128-127），如`jmp short 标号`
    - 近转移（2B补码），如`jmp near ptr 标号`
- 段间转移，如jmp 1000:0，如`jmp far ptr 标号`

| JMP | 无条件转移 |
| --- | --- |
| CALL | 过程调用 |
| RET | 过程返回 |

## 条件转移

所有的条件转移均为段内短转移

| JZ/JE、JC/JNC、JNZ/JNE、JS/JNS、JO/JNO、JP/JPE、JNP/JPO | 直接标志转移 |
| --- | --- |
| JA/JNBE等（see table below for detail） | 间接标志转移 |

| 类别 | 指令助记符 | 测试条件 | 指令功能 |
| --- | --- | --- | --- |
| 无符号数比较测试 | JA/JNBE | CF|ZF = 0 | above |
|  | JAE/JNB | CF = 0 |  |
|  | JB/JNAE | CF = 1 | below |
|  | JBE/JNA | CF|ZF = 1 |  |
| 有符号数比较测试 | JG/JNLE | (SF^OF) | ZF = 0 | great than |
|  | JGE/JNL | SF ^ OF = 0 |  |
|  | JL/JNGE | SF ^ OF = 1 | less than |
|  | JLE/JNG | (SF ^ OF) | ZF = 1 |  |

## 条件循环控制

| LOOP | cx≠0 |  |
| --- | --- | --- |
| loope/loopz | cx≠0 && zf == 1 | 若减一后cx≠0&&zf=1，则转到指令所指定的标号处重复执行 |
| loopne/loopnz | cx≠0 && zf == 0 |  |
| jcxz | cx==0 | 若cx为0跳转（jump if cx zero），它不对cx寄存器进行自动减一的操作 |

## 中断

| INT | 软中断/陷阱中断 |  |
| --- | --- | --- |
| INTO | 溢出中断 |  |
| IRET | 中断返回 | 它总是被安排在中断服务程序的出口处 |

# 处理器控制指令

| CLC | 进位标志清0 | clear carry |
| --- | --- | --- |
| CMC | 进位标志取反 | complement carry |
| stc |  | set carry |
| CLD |  | clear direction |
| STD |  | set direction |
| CLI | IF = 0 | clear interrupt |
| STI | IF = 1 | set interrupt |
| esc | 外部同步指令 | 换码指令 |
| wait | 外部同步指令 |  |
| lock | 外部同步指令 |  |
| HLT |  | 暂停CPU |
| NOP |  | No Operation |

# 数据定义指令

db：define byte

dw

dd：define double word

dq: define quardword(4 word)

dt: 10 byte

可以配合dup操作符使用减少冗余。如`db 3 dup (0, 1, 2)`表示定义了九个字节，分别为0,1,2,0,…

# 传送长度

- 有寄存器依据名字判断
- 没有寄存器使用X ptr显式声明，如`mov word ptr ds:[0], 1`或`inc byte ptr [bx]`
- push/pop命令只进行字操作

# 标号

后面带有`:`的标号只能在cs段中使用

## 同时描述内存地址和单元长度(数据标号)

```nasm
code segment
	a db 1 2 3 4 5 6 7 8
	b dw 0
```

如果想在代码段中直接用数据标号访问数据，则需要用伪指令assume将标号所在的段和一个段寄存器联系起来，否则编译器在编译的时候无法确定标号的段地址在哪一个寄存器中。

类似于offset操作符，还存在seg操作符，功能为取得某一标号的段地址。

# Debug

需要有*debug.exe*程序。

- R：查看、改变CPU寄存器的内容
    
    R查看
    
    R r_n：修改r_n寄存器
    
- D：查看内存内容
    
    D cs:ip：查看从cs:ip开始的128个字节
    
    D cs:ip1 ip2：查看从ip1到ip2的内存
    
    D：查看预设内容或继续上一次
    
- E：改写内存内容
    
    e cs:ip d1 d2 d3 …（可以直接写入字符，但是字符需要使用单引号包裹，也可以直接写入字符串，但是需使用双引号包裹）
    
    e cs:ip：空格表示不修改，回车表示修改完成
    
- U：将内存中的机器指令翻译成汇编指令
    
    u cs:ip
    
- T：执行cs:ip处的机器指令
    
    如果执行了修改ss的指令，则紧接其后的下一条指令也会得到执行。因为ss指令后一般紧接着设置sp的指令，此时是不允许可屏蔽中断的。
    
- A：以汇编指令的格式在内存中写入一条机器指令
    
    a cs:ip
    
- G：执行到指定的地址后停止，类似于gdb中的断点执行
    
    G ip
    
- P：遇到int指令使用p而不是t执行
    
    也可以用p跳出循环，类似于gdb中的until
    
- Q：退出程序

执行R指令后右下角字符含义如下：

| 标志 | 值为1的标记 | 值为0的标记 |
| --- | --- | --- |
| of | OV(overflow) | NV |
| sf | NG | PL |
| zf | ZR(zero) | NZ |
| pf | PE(even) | PO(odd) |
| cf | CY(carry) | NC |
| df | DN(down) | UP(up) |

# 内中断
内部中断不需要硬件支持，不受IF标志控制，不执行中断总线周期，除单步中断可通过TF标志允许或禁止外，其余都是不可屏蔽中断。

- 除法错误（0）
- 单步执行（1）
- 执行into指令且OF=1时触发溢出中断（4）
- 执行`int n`指令触发软中断
- 断点中断（3）

8086用称为中断类型码的数据来标识中断信息的来源，中断类型码为一个字节。

cpu用中断类型码通过中断向量表找到对应中断处理程序的入口地址

![中断向量表](https://cdn.sxrekord.com/blog/中断向量表.png)

在8086中，中断向量表存放在内存地址0处。从内存0000:0000到0000:03FF的1024个单元中存放着中断向量表。每个表项大小为两个字，高地址存放段地址，低地址存放偏移地址

## 中断过程

1. 从中断信息中取得中断类型码
2. 标志寄存器的值入栈（pushf）
3. 设置标志寄存器的TF和IP值为0
4. CS入栈
5. IP入栈
6. 读取中断向量表，获取中断处理程序入口地址同时设置CS和IP

## 中断处理程序

编写的常规步骤为：

1. 保存用到的寄存器
2. 处理中断
3. 回复用到的寄存器
4. 用iret指令返回

iret用汇编语法描述为：

```nasm
pop IP
pop CS
popf
```

## 中断优先级和中断嵌套

中断嵌套仅用于可屏蔽中断中。

## 单步中断

cpu在执行完一条指令后，如果检测到标志寄存器的tf为1，则产生单步中断，引发终端过程，单步中断的中断类型码为1

cpu在执行完设置ss的指令后，不响应中断，以防栈破坏。

## int中断

int n，引发n号中断

# BIOS

bios中主要包含以下内容：

- 硬件系统的检测和初始化程序
- 外部中断和内部中断的中断例程
- 用于对硬件设备进行I/O操作的中断例程
- 其他和硬件系统相关的中断例程

和硬件设备相关的dos中断例程中，一般都调用了bios的中断例程

## bios和dos中断例程的安装过程

- 开机后，一加电，初始化cs=0ffffh，ip=0，自动从ffff:0单元开始执行程序。ffff:0处有一条跳转指令，cpu执行该指令转去执行bios中的硬件系统检测和初始化程序。
- 初始化程序将建立bios所支持的中断向量，即将bios提供的中断例程的入口地址登记在中断向量表中，其中入口地址是固定的，因为固化到ROM中的程序一直在内存中存在。
- 硬件系统检测和初始化完成后，调用 int 19h 进行操作系统的引导。从此将计算机交由操作系统控制。
- DOS启动后，除完成其他工作外，还将它所提供的中断例程装入内存，并建立相应的中断向量

# 端口

cpu可以直接读写以下3个地方的数据

- cpu内部的寄存器
- 内存单元
- 端口

在pc系统中，cpu最多可以定位64kb个不同的端口。则端口地址范围为一个字，如in 60h

在in/out指令中，只能使用ax或al来存放从端口中读入的数据或要发送到端口中的数据

对255~65535的端口进行读写时，端口号放在dx中，如

```nasm
mov dx, 3f8h
in al, dx
out dx, al
```

# 外中断

- 可屏蔽中断
    
    当CPU检测到可屏蔽中断信息时，如果IF=1，则CPU在执行完当前指令后响应中断；否则不响应可屏蔽中断。
    
    中断类型码是通过数据总线送入CPU的
    
    **几乎所有由外设引起的中断都是可屏蔽中断**
    
- 不可屏蔽中断
    
    当cpu检测到不可屏蔽中断信息时，则在执行完当前指令后，立即响应引发中断
    
    在8086cpu中，不可屏蔽中断的中断类型码固定为2
    

## pc机键盘的处理过程

键盘上的每一个键相当于一个开关，键盘中有一个芯片对键盘上的每一个键的开关状态进行扫描。

按下一个键时，开关接通，该芯片就产生一个扫描码，扫描码说明了按下的键在键盘上的位置。

扫描码被送入主板上的相关接口芯片的寄存器中，该寄存器的端口地址为60h 。

松开按下的键时，也产生一个扫描码，松开按键时产生的扫描码也被送入 60h 端口中。

一般将按下一个键时产生的扫描码称为通码，松开一个键产生的扫描码称为断码。

扫描码长度为一个字节，通码的第 7 位为 0 ，断码的第 7 位为 1。即：断码=通码+ 80h比如， g 键的通码为 22h ，断码为 a2h 。

键盘的输入到达 60h 端口时，相关的芯片就会向 CPU 发出中断类型码为 9 的可屏蔽中断信息。 CPU 检测到该中断信息后，如果 IF=I ，则响应中断，引发中断过程，转去执行 9 中断例程。

BIOS 提供了 int 9 中断例程，用来进行基本的键盘输入处理，主要的工作如下：

1. 读出 60h 端口中的扫描码；
2. 如果是字符键的扫描码，将该扫描码和它所对应的字符码（即 ASCII 码）送入内存中的 BIOS 键盘缓冲区：如果是控制键（比如 C 旧）和切换键（比如 CapsLock) 的扫描码，则将其转变为状态字节（用二进制位记录控制键和切换键状态的字节）写入内存中存储状态字节的单元
3. 对键盘系统进行相关的控制，比如说，向相关芯片发出应答信息。

BIOS 键盘缓冲区是系统启动后用于存放 int 9 中断例程所接收的键盘输入的内存区。该内存区可以存储15个键盘输入，因为 int 9 中断例程除了接收扫描码外，还要产生和扫描码对应的字符码，所以在 BIOS 键盘缓冲区中，一个键盘输入用一个字单元存放，高位字节存放扫描码，低位字节存放字符码。

# 总线