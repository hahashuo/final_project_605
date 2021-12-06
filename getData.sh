#!/bin/bash                                                                                                                                                                                                

for topic in $(head -n 1 temp.txt)
do
    mkdir $topic
    echo $topic
    wget https://archive.org/download/stackexchange/$topic/Posts.xml -O $topic.Posts.xml
    cat $topic.Posts.xml | grep -Pio '.*Body="\K[^"]*' | sed 's/;/\n/g' | awk '$0 ~ /&lt/' | sed 's/&lt//g' | tr " " "\n" | sed '/\S/!d' > $topic/$topic.csv
    split -d -l 210000 $topic/$topic.csv "$topic/$topic.csv."
    rm $topic/$topic.csv
done
rm *.xml

