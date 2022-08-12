#!/usr/bin/env bash

# This script is used to deploy my custom content.

# update bangumi and cinema page
hexo bangumi -u
hexo cinema -u


# reset alias
nameRM="rm"
nameCP="cp"

function resetAlias() {
    alias $1 > error 2>&1
    if [ $? -eq 0 ]; then
        echo "reset $1"
        name=`alias $1 | awk 'BEGIN{FS="="}{ print $(NF)}'`
        name=${name//\'/}
        name=${name//\"/}
        if [ $1 == "cp" ]; then
            nameCP=$name
            unalias cp
        else 
            nameRM=$name
            unalias rm
        fi
    fi
}

resetAlias "rm"
resetAlias "cp"
rm error



function deleteMDFromPublic() {
    find $1 -name "*.md" > md
    while read line
    do
        rm "$line"
    done < md
    rm md
}

# md to html
function mdToHtml() {
    pip3 install mistune
    find $1 -name "*.md" > md
    while read line
    do
        python3 md2html.py "$line"
    done < md
    rm md
}


rm -rf public/nginx_zh
rm -rf public/music_theory
rm -rf public/personal

if [ ! -e "public" ]; then 
    mkdir public
fi

# convert .md file to .html file
# mdToHtml "personal/lao"
# mdToHtml "personal/diary"

# copy personal/music_theory/*.html to public/music_theory
# find personal/music_theory \! -name "index.html" > html

cp -rf personal/nginx_zh public/nginx_zh
cp -rf personal/music_theory public/music_theory
cp -rf personal/lao public/lao
cp -rf personal/diary public/diary

# delete all .md file
deleteMDFromPublic "public/music_theory"
deleteMDFromPublic "public/lao"


# delete all *.Identifier
find . -name "*.Identifier" > identifier

while read line
do
    rm "$line"
done < identifier

# delete temporary file
rm identifier


# fix hexo-prism-plugin curly bracket error
line=`sed '13!d' node_modules/hexo-prism-plugin/src/index.js`
len=${#line}
if [ $len -lt 40 ]; then
    var1="'\"'"
    var2="'\"', '\&#123;': '{', '\&#125;': '}'"
    sed -i "s|$var1|$var2|" node_modules/hexo-prism-plugin/src/index.js
    if [ $? -eq 0 ]; then
        echo "fix hexo-prism-plugin curly bracket error"
    fi
fi

# use plain layout
sed -i "s/post/plain/" node_modules/hexo-bilibili-bangumi/lib/bangumi-generator.js


# restore alias
if [ "rm" != "$nameRM" ]; then
    alias rm="$nameRM"
fi
if [ "cp" != "$nameCP" ]; then
    alias cp="$nameCP"
fi