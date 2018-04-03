#!/bin/bash

Dir=/home/lucky/dataset/TUM/
Rgb=rgb.txt
Dep=depth.txt
Ass=associate.txt

result=$(ls $Dir)

for i in $result
do
	Data=$Dir$i
	echo $Data
	Ground=${Data}/groundtruth.txt
	if [ ! -f $Ground ]; then
		echo $i
		rm -rf $Data
	fi
	python associate.py $Data/$Rgb $Data/$Dep > $Data/$Ass
done
