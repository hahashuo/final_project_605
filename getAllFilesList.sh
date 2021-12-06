#!/bin/bash                                                                                                                                                                             

rm -f files.txt
for topic in $(cat temp.txt)
do

    for entry in $topic/*.csv.*
    do
	
        echo $entry >> files.txt

    done
done
head -n 1 files.txt > 1file.txt
