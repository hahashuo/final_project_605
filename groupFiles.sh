#!/bin/bash                                                                                                                                                                                                

for entry in $(cat temp.txt)
do
echo $entry
    for name in $(find -iname "$entry-TF.csv*")
    do
        echo $name
	name="${name:2}"
	echo $name
        mv $name $entry
    done
done

