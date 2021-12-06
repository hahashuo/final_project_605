#!/bin/bash                                                                                                                                                                                                


for topic in $(cat temp.txt)
do

    for entry in /home/bressett/final_project/$topic/*.csv.*
    do

        echo $entry >> files.txt

    done
done
