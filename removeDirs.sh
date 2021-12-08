#!/bin/bash                                                                                          

for dir in $(cat	dirs.txt)
do
    rm -r $dir
    rm $dir-*
done

