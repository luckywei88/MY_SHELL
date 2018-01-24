#!/bin/bash

if [ -z $1 ]; then
	echo "empty"
	exit 0
fi

echo "no empty"

EXEC=/home/lucky/MyLib/OriginLib/ORB_SLAM2/Examples/RGB-D/rgbd_tum

Bg=/home/lucky/workspace/src/orb_slam/Vocabulary/ORBvoc.txt

Dir=/home/lucky/dataset/TUM/
TestDir=/home/lucky/workspace/shell/$1/

rm -rf /home/lucky/pcd/tmppcd/*

if [ ! -d $TestDir ]; then
	mkdir -p $TestDir
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
	
		#Config=Freiburg${n}_low.yaml
		Config=Freiburg${n}.yaml

		Data_Dir=$Dir$i
		Associate=$Data_Dir/associate.txt
	
		$EXEC $Bg $Config $Data_Dir $Associate

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

