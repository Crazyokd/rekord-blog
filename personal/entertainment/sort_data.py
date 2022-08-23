#!/usr/bin/python3
# -*- coding: utf-8 -*-
# @Author: Rekord
# @Date: 2022-08-23

import json

with open('data.json', encoding='utf-8') as f:
    json_datas = json.load(f)

def takeSer(video):
    return video['ser']

json_datas.sort(key=takeSer)

with open('data.json', 'w', encoding='utf-8') as f:
    f.write(json.dumps(json_datas))