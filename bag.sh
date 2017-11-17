#!/bin/bash

Launch=/home/lucky/workspace/launch/bag_orb_slam.launch
Dir=/home/lucky/rosbag/

result=$(ls $Dir)

var=0
array=()

for i in $result
do
	echo $var" "$i
	array[$var]=$i
	((var++))
done

echo "enter your chosen:"
read input

rm -rf /home/lucky/pcd/tmppcd/*
rm bag.log

Bag=${array[$input]}

{
	sleep 9
	rosbag play $Dir$Bag
}&

roslaunch $Launch > bag.log


