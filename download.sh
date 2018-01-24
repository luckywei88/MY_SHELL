#!/bin/bash
#!/bin/bash

Dir=/home/lucky/dataset/TUM/
DownloadDir=/home/lucky/dataset/TUM_ros_bag

if [ ! -d $DownloadDir ];then
	mkdir -p $DownloadDir
fi

result=$(ls $Dir)

index=0

for i in $result
do
	echo $i
	if [ $index -lt 3 ]; then
        	n=1
        elif [ $index -lt 6 ]; then
                n=2
        else
                n=3
        fi
	file=$DownloadDir/$i.bag
	if [ ! -f $file ]; then
		tsocks wget -O $file https://vision.in.tum.de/rgbd/dataset/freiburg${n}/${i}.bag --no-check-certificate &
	fi
	((index++))
done
