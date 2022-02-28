#!/usr/bin/env bash
# This script is used to deploy blog 

# kill hexo process
pkill hexo

# launch hexo use 80 port
npm install
hexo server -p 80 &