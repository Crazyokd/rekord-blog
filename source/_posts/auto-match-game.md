---
title: 自动消消乐
index_img: https://cdn.sxrekord.com/blog/code.jpg
date: 2025-05-17 10:36:33
updated: 2025-05-17 10:36:33
categories:
- 技术
tags:
- C/C++
- 游戏
---


# Problem

有一个 **NROW**×**NCOL** 的棋盘，每个格子里放置一张牌，其值为整数，范围：0~**MAX_VALUE**。其中数字 0 表示“赖子”，可以与任意数字视为相同。

当在某一轮中，存在连续 **MIN_ELE** 个或以上相同的牌（包括赖子） 在横向或纵向上相连时，即触发获胜条件。这些牌将在这一轮结束前被标记为待消除。

每张牌可同时参与横向消除和纵向消除，下图的5*6棋盘框线中的元素将被消除。

![游戏示例](https://cdn.sxrekord.com/v2/image-20250517183133-de0rbdo.png)

当一轮结束的时候，会把获胜的地方全部去掉，并且未消除的牌会依次掉落下去。掉落完成后，空着的位置会随机获得一张新牌。补充完整盘面后，进入下一轮。

结束条件：当没有获胜的时候结束。



# Analysis

我采用的方式是为每一张牌增加一个标志字段，从而辅助实现每一张牌在横向和纵向上仅比较一次。比如，当（1，1）位置的牌一直匹配到（1，NCOL），则第一行的所有牌都不再进行横向比较。这样每轮的复杂度大约为2*O(n)（n为盘面大小）。



# Solution

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct Card {
    int v;
#define HOR 0x100
#define VER 0x10
#define ELE 0x1
    int f;
} Card;

#ifndef MAX_VALUE
  #define MAX_VALUE 12
#endif

Card getCard(int, int)
{
    Card card;
    card.v = rand() % MAX_VALUE;
    card.f = 0;
    return card;
}

#ifndef NROW
  #define NROW 5
#endif
#ifndef NCOL
  #define NCOL 6
#endif
static Card arr[NROW][NCOL];
/*
= {
        {{1, 0}, {2, 0}, {0, 0}, {2, 0}, {1, 0}, {1, 0}},
        {{1, 0}, {2, 0}, {1, 0}, {0, 0}, {2, 0}, {0, 0}},
        {{0, 0}, {0, 0}, {1, 0}, {2, 0}, {0, 0}, {0, 0}},
        {{0, 0}, {0, 0}, {1, 0}, {0, 0}, {0, 0}, {2, 0}},
        {{1, 0}, {2, 0}, {1, 0}, {1, 0}, {2, 0}, {1, 0}}
};
*/

void init()
{
    srand((unsigned)time(NULL));
    for (int i = 0; i < NROW; ++i) {
        for (int j = 0; j < NCOL; ++j) {
            arr[i][j] = getCard(i, j);
        }
    }
}

static void display()
{
    for (int i = 0; i < NCOL*3; i++) {
        printf("=");
    }
    printf("\n");
    for (int i = 0; i < NROW; ++i) {
        for (int j = 0; j < NCOL; ++j) {
            printf("%2d", arr[i][j].v);
            if (j < NCOL - 1) {
                printf(" ");
            }
        }
        printf("\n");
    }
}

#ifndef MIN_ELE
  #define MIN_ELE 5
#endif
static inline void hormatch(int row, int col)
{
    if (NCOL - col < MIN_ELE) {
        return;
    }
    if ((col + 1 < NCOL && (arr[row][col + 1].f & HOR) == HOR)
        || (arr[row][col].v != 0 && (arr[row][col].f & HOR) == HOR)) {
        // 已经比较过
        return;
    }
    int i = col + 1;
    int n = 1;
    int v = arr[row][col].v;
    while (i < NCOL) {
        if (v == 0) v = arr[row][i].v;

        if (arr[row][i].v == 0 || v == arr[row][i].v) {
            arr[row][col].f |= HOR;
            n++;
        } else if (n < MIN_ELE) {
            return;
        } else {
            break;
        }
        i++;
    }
    // 标记为消除
    for (int k = 0; k < n; k++) {
        arr[row][col++].f |= ELE;
    }
}

static inline void vermatch(int row, int col)
{
    if (NROW - row < MIN_ELE) {
        return;
    }
    if ((row + 1 < NROW && (arr[row + 1][col].f & VER) == VER)
        || (arr[row][col].v != 0 && (arr[row][col].f & VER) == VER)) {
        // 已经比较过
        return;
    }
    int i = row + 1;
    int n = 1;
    int v = arr[row][col].v;
    while (i < NROW) {
        if (v == 0) v = arr[i][col].v;

        if (arr[i][col].v == 0 || v == arr[i][col].v) {
            arr[row][col].f |= VER;
            n++;
        } else if (n < MIN_ELE) {
            return;
        } else {
            break;
        }
        i++;
    }
    // 标记为消除
    for (int k = 0; k < n; k++) {
        arr[row++][col].f |= ELE;
    }
}
/**
 * 标记所有待消除的牌
 */
static void mark()
{
    for (int i = 0; i < NROW; i++) {
        for (int j = 0; j < NCOL; j++) {
            hormatch(i, j); // 横向比较
            vermatch(i, j); // 纵向比较
        }
    }
}

static inline int isStill(int row, int col)
{
    return (arr[row][col].f & ELE) == 0;
}

static int nele = 0;
static inline Card getNext(int *vi, int row, int col)
{
    while (*vi >= 0) {
        *vi = *vi - 1;
        if (isStill(*vi + 1, col)) {
            arr[*vi + 1][col].f = 0; // 还原标志位
            return arr[*vi + 1][col];
        }
    }
    ++nele;
    return getCard(row, col);
}

static int eliminate()
{
    nele = 0; // 置0
    // 遍历每一列
    for (int i = 0; i < NCOL; ++i) {
        int vi = NROW - 1; // valid index
        // 掉落
        for (int j = vi; j >= 0; --j) {
            arr[j][i] = getNext(&vi, j, i);
        }
    }
    return nele;
}

/**
 * 输出结果
 */
static void over()
{
    printf("\n!!!game over!!!\n");
}

int main()
{
    init();

    do {
        display();
        mark();
        sleep(1);
    } while (eliminate() != 0);

    over();
    return 0;
}

```

# Compile & Run

```shell
gcc main.c -o game -DMAX_VALUE=3 -DNROW=10 -DNCOL=16 -DMIN_ELE=5 && ./game
```

