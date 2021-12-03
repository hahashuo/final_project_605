#!/bin/bash

for topic in $(cat temp.txt)
do
    echo $topic
    wget https://archive.org/download/stackexchange/$topic/Posts.xml -O $topic.Posts.xml
    cat $topic.Posts.xml | grep -Pio 'Id="1".*Body="\K[^"]*' | sed 's/;/\n/g' | awk '$0 ~ /&lt/' | sed 's/&lt//g' | tr " " "\n" | sed '/\S/!d' > $topic.csv
    split -d -l 105000 $topic.csv "$topic.csv."
done
