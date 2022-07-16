#!/usr/bin/env bash

# This script is used to deploy my custom content.

rm -rf public/nginx_zh
rm -rf public/music_theory
rm -rf public/personal

if [ ! -e "public" ]; then 
    mkdir public
fi

cp -rf personal/nginx_zh public/nginx_zh
cp -rf personal/music_theory public/music_theory

# delete all *.Identifier
find . -name "*.Identifier" > identifier

while read line
do
    rm "$line"
done < identifier

# delete temporary file
rm identifier