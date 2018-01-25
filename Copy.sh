#!/bin/bash

Dir=/home/lucky/dataset/TUM/

result=$(ls $Dir)

groundDir=groundtruth/

if [ ! -d $groundDir ]; then
	mkdir -p $groundDir
fi

for i in $result
do
	Data_Dir=$Dir$i
	GroundTruth=$Data_Dir/groundtruth.txt
	cp $GroundTruth ${groundDir}${i}.bag_groundtruth.txt	
done
