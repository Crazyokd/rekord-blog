#!/usr/bin/python3
# -*- coding: utf-8 -*-
# @Author: Rekord
# @Date: 2022-08-12


import mistune
import sys
import datetime
import time


sourcePath = sys.argv[1]
fileName = sourcePath[sourcePath.rfind("/") + 1:len(sourcePath) - 2] + 'html'
destinationPath = sourcePath[:sourcePath.rfind("/") + 1] + fileName

with open(sourcePath, 'r', encoding='utf-8', newline='') as file:
    mdContent = file.read()

user = "Rekord"
generateTime = str(datetime.datetime.today() + datetime.timedelta(hours=8-int(time.strftime('%z')[0:3])))
head = """<!-- Markdown Source -->
<!--
""" + mdContent + """
-->



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>""" + fileName + """</title>
    <link rel="stylesheet" href="md_render.css">
</head>
<body>
"""

foot = """<div class="div_foot">
        <b>""" + fileName + '</b> - Generated on <b>' + generateTime[:len(generateTime) - 7] + '</b> by <b>' + user + """</b> using <a href="https://github.com/lepture/mistune">mistune</a>. Source is embedded.
    </div>
    </body>
</html>
"""

with open(destinationPath, 'w', encoding='utf-8', newline='') as file:
    file.write(head + mistune.html(mdContent) + foot)