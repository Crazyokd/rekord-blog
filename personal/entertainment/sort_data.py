#!/usr/bin/python3
# -*- coding: utf-8 -*-
# @Author: Rekord
# @Date: 2022-08-23

import json

with open('data.json', encoding='utf-8') as f:
    json_datas = json.load(f)

# 去重
ser_list = []
for video in json_datas:
    ser_list.append(video['ser'])
origin_len = len(ser_list)
current_len = len(list(set(ser_list)))

if origin_len != current_len:
    print('存在重复视频')

def takeSer(video):
    return video['ser']

json_datas.sort(key=takeSer)

with open('data.json', 'w', encoding='utf-8') as f:
    f.write(json.dumps(json_datas))