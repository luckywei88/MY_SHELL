#!/bin/bash

EXEC=/home/lucky/workspace/devel/lib/orb_slam/rgbd_tum

Bg=/home/lucky/workspace/src/orb_slam/Vocabulary/ORBvoc.txt

Yolo_Data=/home/lucky/MyLib/darknet/cfg/coco.data
Yolo_Weight=/home/lucky/MyLib/darknet/tiny-yolo.weights
Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/high-tiny-yolo.cfg

World=/map
Base=/robot0_link
Odom=/odom

Dir=/home/lucky/dataset/TUM/

result=$(ls $Dir)

index=0

for i in $result
do
	echo $index" "$i

	if [ $input -lt 3 ]; then
		n=1
	elif [ $input -lt 6 ]; then
		n=2
	else
		n=3
	fi

	Config=Freiburg$n.yaml

	Data_Dir=$Dir$i/
	Associate=$Data_Dir/associate.txt

	$EXEC $Bg $Config $Yolo_Data $Yolo_Weight $Yolo_Cfg $World $Base $Odom $Data_Dir $Associate false true

	((index++))
done

