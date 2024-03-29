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


# delete all *.Identifier
function deleteIdentifier() {
    find . -name "*.Identifier" > identifier

    while read line
    do
        rm "$line"
    done < identifier

    # delete temporary file
    rm identifier
}

# md to html
function mdToHtml() {
    find $1 -name "*.md" > md
    while read line
    do
        python3 md2html.py "$line"
    done < md
    rm md
}

# cp files but not include .md
function cpFiles() {
    cp -rf $1 "public${1: 8}/"
    find $1 | grep .*\.md$ > cp_file
    while read line
    do
        rm -rf "public${line: 8}"
    done < cp_file
    rm cp_file
}

# clean public
function cleanPublic() {
    rm -rf public/md_render.css
    rm -rf public/nginx_zh
    rm -rf public/music_theory
    rm -rf public/diary
    rm -rf public/linux
    rm -rf public/entertainment
    rm -rf public/resource
    rm -rf public/interview
    rm -rf public/personal
    rm -rf public/book
}


cleanPublic

if [ ! -e "public" ]; then 
    mkdir public
fi


cpFiles "personal/nginx_zh"
cpFiles "personal/music_theory"
cpFiles "personal/linux"
cpFiles "personal/entertainment"
cpFiles "personal/book"

cp -f personal/md_render.css public/md_render.css
# convert .md file to .html file
pip3 list | grep mistune > error.Identifier 2>&1
if [ $? -ne 0 ]; then
    echo "install mistune."
    pip3 install mistune > error.Identifier
fi
mdToHtml "personal/diary"
mdToHtml "personal/linux"
mdToHtml "personal/resource"
mdToHtml "personal/interview"

deleteIdentifier


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