#!/bin/bash  

for entry in $(cat temp.txt)
do
cat $entry-TF-Main.csv |
sed '2d' |
head -n 101 |
awk '{sub(/[^,]*/,"");sub(/,/,"")} 1' > cleaned_$entry.csv
done
