#!/usr/bin/env bash

# This script is used to deploy my custom content.

deleteMDFromPublic() {
    find $1 -name "*.md" > md
    while read line
    do
        rm "$line"
    done < md
    rm md
}

# exist some bugs
# md to html
mgToHtml() {
    go install github.com/ueffel/mdtohtml@latest
    find $1 -name "*.md" > md
    while read line
    do
        mdtohtml "$line"
    done < md
    rm md
}


rm -rf public/nginx_zh
rm -rf public/music_theory
rm -rf public/personal

if [ ! -e "public" ]; then 
    mkdir public
fi

# copy personal/music_theory/*.html to public/music_theory
# find personal/music_theory \! -name "index.html" > html

cp -rf personal/nginx_zh public/nginx_zh
cp -rf personal/music_theory public/music_theory
cp -rf personal/lao public/lao

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