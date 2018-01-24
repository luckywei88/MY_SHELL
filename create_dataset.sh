#!/bin/bash

launch=/home/lucky/workspace/launch/create_dataset.launch

if [ -z $1 ]; then
	exit 0
fi

dir=/home/lucky/dataset/my_dataset/$1


if [ -d $dir ]; then
	rm -rf $dir
fi

roslaunch $launch dataset:=$1

python associate.py $dir/rgb.txt $dir/depth.txt > $dir/associate.txt
