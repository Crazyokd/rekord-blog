#!/usr/bin/env bash
# This script is used to deploy blog 

# kill hexo process
pkill hexo

# launch hexo use 80 port
rm -rf package-lock.json
rm -rf node_modules
sudo npm cache clear --force
sudo npm install

hexo server -p 80 &