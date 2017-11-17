#!/bin/bash

EXEC=/home/lucky/workspace/devel/lib/orb_slam/rgbd_tum

Bg=/home/lucky/workspace/src/orb_slam/Vocabulary/ORBvoc.txt

Yolo_Data=/home/lucky/MyLib/darknet/cfg/coco.data
Yolo_Weight=/home/lucky/MyLib/darknet/tiny-yolo.weights
Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/tiny-yolo.cfg
#Yolo_Cfg=/home/lucky/MyLib/darknet/cfg/high-tiny-yolo.cfg
Yolo_Label=/home/lucky/MyLib/darknet/data/labels

World=/map
Base=/robot0_link
Odom=/odom

Dir=/home/lucky/dataset/TUM/
TestDir=/home/lucky/workspace/shell/result/

rm -rf /home/lucky/pcd/tmppcd/*

if [ ! -d $TestDir ]; then
	mkdir $TestDir
fi
result=$(ls $Dir)
index=0

for time in {1..5}
do 
	for i in $result
	do
		if [ $index -lt 3 ]; then
			n=1
		elif [ $index -lt 6 ]; then
			n=2
		else
			n=3
		fi
	
		Config=Freiburg${n}_low.yaml
		#Config=Freiburg${n}.yaml

		Data_Dir=$Dir$i
		Associate=$Data_Dir/associate.txt
	
		$EXEC $Bg $Config $Yolo_Data $Yolo_Weight $Yolo_Cfg $Yolo_Label $World $Base $Odom $Data_Dir $Associate false true

		GroundTruth=$Data_Dir/groundtruth.txt
		if [ ! -d $TestDir$i ]; then
			mkdir $TestDir$i
		fi
				
		ResultDir=$TestDir$i/$time
		if [ ! -d $ResultDir ]; then
			mkdir $ResultDir
		fi
		python evaluate_ate1.py $GroundTruth CameraTrajectory.txt --plot $ResultDir/evaluate.png --verbose > $ResultDir/evaluate.txt
		
		cat $ResultDir/evaluate.txt
 
		((index++))
	done
done

