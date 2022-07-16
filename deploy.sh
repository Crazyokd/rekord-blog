#!/usr/bin/env bash

# This script is used to deploy my custom content.

rm -rf public/nginx_zh
rm -rf public/music_theory
rm -rf public/personal

if [ ! -e "public" ]; then 
    mkdir public
fi

cp -rf personal/nginx_zh public/nginx_zh

# md to html
# go install github.com/ueffel/mdtohtml@latest
# find personal/music_theory -name "*.md" > md
# while read line
# do
#     mdtohtml "$line"
# done < md
# rm md

# copy personal/music_theory/*.html to public/music_theory
# find personal/music_theory \! -name "index.html" > html
cp -rf personal/music_theory public/music_theory
# delete all .md file
find public/music_theory -name "*.md" > md
while read line
do
    rm "$line"
done < md
rm md


# delete all *.Identifier
find . -name "*.Identifier" > identifier

while read line
do
    rm "$line"
done < identifier

# delete temporary file
rm identifier