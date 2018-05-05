#!/bin/bash

Rate=0
if [ ! -z $1 ]; then
	Rate=$1
fi

Yolo_Label=/home/lucky/MyLib/darknet/data/labels
Yolo_Weight=/home/lucky/MyLib/darknet/tiny-yolo.weights
Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/high-tiny-yolo.cfg
#Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/tiny-yolo.cfg

#Yolo_Weight=/home/lucky/MyLib/darknet/yolo.weights
#Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/yolo.cfg

Launch=/home/lucky/workspace/launch/bag_orb_slam.launch
Send=/home/lucky/workspace/launch/send_dataset.launch
Dir=/home/lucky/dataset/my_dataset/

rm -rf /home/lucky/pcd/tmppcd/*
rm bag.log

result=$(ls $Dir)

index=0
array=()

for i in $result
do
	echo $index" "$i
	array[$index]=$i	
	((index++))
done

echo "enter your chosen"
read input

DataSet=${array[$input]}

Config=$(pwd)/high_xtion.yaml

{
	sleep 9
	roslaunch $Send dataset:=my_dataset sequence:=$DataSet time:=$Rate
}&

roslaunch $Launch config:=$Config yolo_cfg:=$Yolo_Cfg yolo_weights:=$Yolo_Weights yolo_data:=$Yolo_Data yolo_label:=$Yolo_Label > bag.log
