#!/bin/bash

wget -qO- https://archive.org/download/stackexchange |
sed -e 's/<[^>]*>//g' |
grep 'com.7z' |
awk '$0 !~ /meta/' |
tr -d [:blank:] |
sed 's/.\{14\}$//' > filename

for item in $(cat filename); do wget https://archive.org/download/stackexchange/$item/Posts.xml -O $item.Posts.xml; done
