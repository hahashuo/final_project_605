#!/bin/bash                                                                                                                                                                                                 

for entry in temp.txt
do
    for name in $(find -iname "$entry.csv*")
    do
        mv $name home/bressett/$entry     #Change to your NetID
    done
done
