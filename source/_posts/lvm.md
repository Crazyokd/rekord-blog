---
layout: post
title: LVM
date: 2024/01/14
updated: 2024/01/14
cover: https://cdn.sxrekord.com/blog/lvm.jpg
coverWidth: 512
coverHeight: 296
comments: true
categories: 
- 技术
tags:
- Linux
- 学习笔记
---

LVM是Linux环境中的逻辑卷管理（Logical Volume Manager）的缩写。它是一个非常灵活的存储管理解决方案，允许你更改存储设备的大小和位置，而不会影响存储设备上的数据。这是通过将物理设备抽象化为逻辑设备来实现的。

使用LVM，你可以创建，删除，调整大小，合并和复制逻辑卷，而不会影响存储在逻辑卷上的数据。这为Linux环境中的存储管理提供了极大的灵活性。

LVM的主要组件包括：

1. 物理扩展（Physical Extents，PE）：PE是物理卷上的一块连续的空间，这是LVM管理存储空间的基本单元。当你创建一个卷组时，LVM将每个物理卷分割成大小相等的块，这些块就是PE。PE的大小在创建卷组时定义，并且在卷组的生命周期内保持不变。默认情况下，每个物理扩展的大小为4MB，但可以在创建卷组时进行更改。
2. 物理卷（Physical Volumes，PV）：这是你的实际硬盘或者其他存储设备。
3. 卷组（Volume Groups，VG）：物理卷可以组合成卷组，以便更好地管理和分配存储空间。
4. 逻辑卷（Logical Volumes，LV）：从卷组中划分出来的逻辑卷，可以被看作是一个独立的分区，你可以在上面创建文件系统，就像在物理硬盘上一样。

# PV

创建pv的基本单位可以是整个磁盘或磁盘的某个分区，所以首先你可以使用类似于fdisk这样的工具划分出想要创建为pv的磁盘分区。然后使用如下命令创建pv：

```bash
pvcreate /dev/sdb1
pvcreate /dev/sda4 /dev/sde
```

接下来让我们详细看看pv：

```bash
sudo pvdisplay

#输出结果如下:
--- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-vg
  PV Size               <444.08 GiB / not usable 0   
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              113684
  Free PE               88084
  Allocated PE          25600
  PV UUID               xWohoN-H8md-mtXq-mKIN-DEcs-k7MJ-mWAlhC
```

• `not usable 0`表示不可用的空间为0，LVM在物理卷上创建时，会尽可能地将其划分为物理扩展（PE）。然而，由于物理扩展的大小（默认为4MiB）是固定的，所以如果物理卷的大小不能被物理扩展的大小整除，那么就会有一部分空间无法使用。

• `Allocatable`：这个字段指示是否可以在此物理卷上分配新的逻辑卷。"yes" 表示可以。通常情况下，这个字段的值为"yes"，表示可以在该物理卷上分配新的逻辑卷。然而，有些情况下，你可能希望阻止在特定的物理卷上创建新的逻辑卷。例如，如果你有一个物理卷，你希望保留它只用于特定的逻辑卷，或者你不希望在其上创建任何新的逻辑卷，你可以将其设置为"no"。这可以通过`pvchange`命令来实现，如下所示：

```bash
pvchange --allocatable n /dev/sdX
```

这样，在尝试在该物理卷上创建新的逻辑卷时，LVM会阻止这个操作。如果你想再次允许在该物理卷上分配新的逻辑卷，你可以再次运行`pvchange`命令，但这次使用"y"选项：

```bash
pvchange --allocatable y /dev/sdX
```

请注意，这个设置不会影响已经在该物理卷上创建的逻辑卷，只影响尝试创建的新逻辑卷。

• `PV UUID`：这是物理卷的唯一标识符（UUID）。它是LVM在创建物理卷时自动生成的，用于唯一标识这个物理卷。

# VG

一个反直觉的事实是创建vg时使用的是磁盘或磁盘分区的路径标识：

```bash
vgcreate myVolumeGroup /dev/sdb1
```

接下来让我们详细看看vg：

```bash
vgdisplay [-v]

#输出结果如下:
--- Volume group ---
  VG Name               ubuntu-vg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <444.08 GiB
  PE Size               4.00 MiB
  Total PE              113684
  Alloc PE / Size       25600 / 100.00 GiB
  Free  PE / Size       88084 / <344.08 GiB
  VG UUID               eYGbbx-wZUO-sGeh-TDKa-34NO-kCRw-ZW3Hgt
```

- `System ID`：这是一个可选的系统ID，用于锁定VG以防止来自其他系统的访问。在这个例子中，它是空的，表示没有设置系统ID。
- `Metadata Areas 1`：元数据区域的数量。这通常与物理卷（PV）的数量相同，因为每个PV都有一个元数据区域。
- `Metadata Sequence No 2`：这是元数据的序列号，表示元数据被更改的次数。每次更改VG（例如，添加或删除逻辑卷），这个数字都会增加。
- `VG Access read/write`：这是VG的访问权限，这里是读/写。
- `VG Status resizable`：这是VG的状态。在这个例子中，它是"resizable"，表示可以调整VG的大小。
- `MAX LV 0`：这是VG中可以创建的最大逻辑卷（LV）数量。0表示没有限制。
- `Cur LV 1`：当前VG中的LV数量。
- `Open LV 1`：当前打开的LV数量。
- `Max PV 0`：这是在VG中可以有的最大PV数量。0表示没有限制。
- `Cur PV 1`：当前VG中的PV数量。
- `Act PV 1`：当前活动的PV数量。

# LV

创建LV是相当灵活的，下面是一些示例：

```bash
Create a striped LV with 3 stripes, a stripe size of 8KiB and a size of 100MiB.
The LV name is chosen by lvcreate.
       lvcreate -i 3 -I 8 -L 100m vg00

Create a raid1 LV with two images, and a useable size of 500 MiB.
This operation requires two devices, one for each mirror image.
RAID metadata (superblock and bitmap) is also included on the two devices.
       lvcreate --type raid1 -m1 -L 500m -n mylv vg00

Create a mirror LV with two images, and a useable size of 500 MiB.
This operation requires three devices: two for mirror images and one for a disk log.
       lvcreate --type mirror -m1 -L 500m -n mylv vg00

Create a mirror LV with 2 images, and a useable size of 500 MiB.
This operation requires 2 devices because the log is in memory.
       lvcreate --type mirror -m1 --mirrorlog core -L 500m -n mylv vg00

Create a copy-on-write snapshot of an LV:
       lvcreate --snapshot --size 100m --name mysnap vg00/mylv

Create a copy-on-write snapshot with a size sufficient for overwriting 20% of the size 
of the original LV.
       lvcreate -s -l 20%ORIGIN -n mysnap vg00/mylv

Create a sparse LV with 1TiB of virtual space, and actual space just under 100MiB.
       lvcreate --snapshot --virtualsize 1t --size 100m --name mylv vg00

Create a linear LV with a usable size of 64MiB on specific physical extents.
       lvcreate -L 64m -n mylv vg00 /dev/sda:0-7 /dev/sdb:0-7

Create a RAID5 LV with a usable size of 5GiB, 3 stripes, a stripe size of 64KiB,
using a total of 4 devices (including one for parity).
       lvcreate --type raid5 -L 5G -i 3 -I 64 -n mylv vg00

Create a RAID5 LV using all of the free space in the VG and spanning all the PVs 
in the VG (note that the command will fail if there are more than 8 PVs in the VG,
in which case -i 7 must be used to get to the current maximum of  8  devices
including  parity  for RaidLVs).
       lvcreate --config allocation/raid_stripe_all_devices=1
              --type raid5 -l 100%FREE -n mylv vg00

Create RAID10 LV with a usable size of 5GiB, using 2 stripes,
each on a two-image mirror.
(Note that the -i and -m arguments behave differently:
-i specifies the total number of stripes,
but -m specifies the number of images in addition to the first image).
       lvcreate --type raid10 -L 5G -i 2 -m 1 -n mylv vg00

Create a 1TiB thin LV mythin, with 256GiB thinpool tpool0 in vg00.
       lvcreate --T --size 256G --name mythin vg00/tpool0

Create a 1TiB thin LV, first creating a new thin pool for it,
where the thin pool has 100MiB of space, uses 2 stripes, has a 64KiB stripe size,
and 256KiB chunk size.
       lvcreate --type thin --name mylv --thinpool mypool
              -V 1t -L 100m -i 2 -I 64 -c 256 vg00

Create a thin snapshot of a thin LV (the size option must not be used,
otherwise a copy-on-write snapshot would be created).
       lvcreate --snapshot --name mysnap vg00/thinvol

Create a thin snapshot of the read-only inactive LV named "origin" which
becomes an external origin for the thin snapshot LV.
       lvcreate --snapshot --name mysnap --thinpool mypool vg00/origin

Create a cache pool from a fast physical device.
The cache pool can then be used to cache an LV.
       lvcreate --type cache-pool -L 1G -n my_cpool vg00 /dev/fast1

Create a cache LV, first creating a new origin LV on a slow physical device,
then combining the new origin LV with an existing cache pool.
       lvcreate --type cache --cachepool my_cpool
              -L 100G -n mylv vg00 /dev/slow1

Create a VDO LV vdo0 with VDOPoolLV size of 10GiB and name vpool1.
       lvcreate --vdo --size 10G --name vdo0 vg00/vpool1
```

接下来让我们详细看看lv：

```bash
lvdisplay

#输出结果如下:
--- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                XmYa9u-j4nc-PKRe-wauS-fsBz-x03f-dIsH1j
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2023-09-29 11:30:34 +0000
  LV Status              available
  # open                 1
  LV Size                100.00 GiB
  Current LE             25600
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

- `LV Status available`：这是LV的状态，这里是"available"，表示LV可用，可以被文件系统挂载和使用。
- `# open 1`：打开LV的数量，通常表示有多少进程正在使用这个LV。这里的1表示有一个进程正在使用这个LV。
- `Current LE 25600`：当前的逻辑扩展（LE）数量。LE是LV中的基本单位，与VG中的PE大小相同。这里的25600表示这个LV包含25600个LE，与`LV Size`的值相符。
- `Segments 1`：LV的段数。一个LV可以由多个不连续的PE段组成，这里的1表示这个LV只有一个段，即所有的PE都是连续的。
- `Allocation inherit`：这是LV的分配策略，这里是"inherit"，表示LV继承了VG的分配策略。
    
    在LVM中，分配策略决定了物理扩展（PE）是如何分配到逻辑卷（LV）上的。以下是LVM支持的分配策略：
    
    - `contiguous`：连续策略要求所有的PE都在同一物理卷（PV）上，并且是连续的。这种策略可能会导致空间利用率不高，因为如果单个PV上没有足够的连续空间，那么即使在其他PV上有空闲空间，也无法创建或扩展LV。
    - `cling`：粘附策略尽量将新的PE分配到与现有PE在同一PV上的空闲PE上。这种策略有助于保持数据局部性，可以提高一些RAID配置的性能。
    - `normal`：正常策略在需要新的PE时，会在所有的PV上查找空闲的PE，并不需要PE在同一PV上或连续。
    - `anywhere`：该策略类似于正常策略，但是它允许PE被分配到不同的PV上，即使这些PV在不同的卷组（VG）上。这通常用于镜像或RAID配置。
    - `inherit`：继承策略表示LV继承了其VG的分配策略。
- `Read ahead sectors auto`：这是预读扇区的数量，用于提高顺序读取的性能。这里的"auto"表示由内核自动决定预读扇区的数量。
- `currently set to 256`：这是当前设置的预读扇区的数量，这里是256。
- `Block device 253:0`：这是LV对应的块设备，可以通过这个设备路径来访问和使用LV。这里的"253:0"表示主设备号是253，次设备号是0。

# 实例

```bash
# 创建并使用lv
lvcreate -n myLogicalVolume -L 10G myVolumeGroup # create lv
mkfs.ext4 /dev/myVolumeGroup/myLogicalVolume
mount /dev/myVolumeGroup/myLogicalVolume /mnt/myMountPoint
# umount /mnt/myMountPoint

# 扩展已有的lv
lvextend -L+1G /dev/myVolumeGroup/myLogicalVolume
resize2fs /dev/myVolumeGroup/myLogicalVolume # for ext4
```

# SEE ALSO

```
lvm(8)lvm.conf(5)lvmconfig(8)

pvchange(8)pvck(8)pvcreate(8)pvdisplay(8)pvmove(8)pvremove(8)pvresize(8)pvs(8)pvscan(8)

vgcfgbackup(8)vgcfgrestore(8)vgchange(8)vgck(8)vgcreate(8)vgconvert(8)vgdisplay(8)vgexport(8)vgextend(8)vgimport(8)vgimportclone(8)vgmerge(8)vgmknodes(8)vgreduce(8)vgremove(8)vgrename(8)vgs(8)vgscan(8)vgsplit(8)

lvcreate(8)lvchange(8)lvconvert(8)lvdisplay(8)lvextend(8)lvreduce(8)lvremove(8)lvrename(8)lvresize(8)lvs(8)lvscan(8)

lvm-fullreport(8)lvm-lvpoll(8)lvm2-activation-generator(8)blkdeactivate(8)lvmdump(8)

dmeventd(8)lvmpolld(8)lvmlockd(8)lvmlockctl(8)cmirrord(8)lvmdbusd(8)

lvmsystemid(7)lvmreport(7)lvmraid(7)lvmthin(7)lvmcache(7)

```