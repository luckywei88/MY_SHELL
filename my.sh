#!/bin/bash

EXEC=/home/lucky/workspace/devel/lib/orb_slam/rgbd_tum

Bg=/home/lucky/workspace/src/orb_slam/Vocabulary/ORBvoc.txt

Yolo_Data=/home/lucky/MyLib/darknet/cfg/coco.data
Yolo_Label=/home/lucky/MyLib/darknet/data/labels

Yolo_Weight=/home/lucky/MyLib/darknet/tiny-yolo.weights
Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/high-tiny-yolo.cfg
#Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/tiny-yolo.cfg

#Yolo_Weight=/home/lucky/MyLib/darknet/yolo.weights
#Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/yolo.cfg

World=/map
Base=/robot0_link
Odom=/odom

Dir=/home/lucky/dataset/my_dataset/

rm -rf /home/lucky/pcd/tmppcd/*

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


#Config=xtion.yaml
Config=high_xtion.yaml

Data_Dir=$Dir${array[$input]}
Associate=$Data_Dir/associate.txt

$EXEC $Bg $Config $Yolo_Data $Yolo_Weight $Yolo_Cfg $Yolo_Label $World $Base $Odom $Data_Dir $Associate false true

python evaluate_ate1.py CameraTrajectory.txt CameraTrajectory.txt --plot evaluate.png --verbose > evaluate.txt

cat evaluate.txt
eog evaluate.png 
