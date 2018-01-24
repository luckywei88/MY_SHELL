#!/bin/bash

Dir=/home/lucky/dataset/my_dataset/
Rgb=rgb.txt
Dep=depth.txt
Ass=associate.txt

result=$(ls $Dir)

for i in $result
do
	Data=$Dir$i
	python associate.py $Data/$Rgb $Data/$Dep > $Data/$Ass
done
