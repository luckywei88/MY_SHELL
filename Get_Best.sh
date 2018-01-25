#!/bin/bash

#set -xv

dir_t=/home/lucky/workspace/shell/reference

test=(
	reference
	keyframe
	no_semantic
	origin
)

outd=compare

compare=$outd/compare.txt

if [ ! -d $outd ]; then
	mkdir -p $outd
else 
	rm -rf $outd
	mkdir -p $outd
fi


GetBest() 
{
	local dir=$1
	local i=$2
	local outdir=$outd/$dir
	if [ ! -d $outdir ]; then
		mkdir -p $outdir
	fi
	local out=$outdir/best.txt
	
	local bestrmse=99.0
	local bestpic=""
	local bestpair=0
	for time in {1..5}
	do
		local tmp=$dir/$i/$time
		local rmse=$(sed -n '3p' $tmp/evaluate.txt | awk '{print $2}')
		local pair=$(sed -n '1p' $tmp/evaluate.txt | awk '{print $2}')
		local com=$(echo "$rmse < $bestrmse" |bc)
		
		if [ $com -eq 1 ]; then
			bestrmse=$rmse
			bestpic=$tmp/evaluate.png
			bestpair=$pair
		fi
	done
	echo $i" "$bestpair" "$bestrmse >> $out
	cp $bestpic $outdir
	mv $outdir/evaluate.png $outdir/$i.png
	echo $bestrmse" "$bestpair
}

PrintResult()
{
	local line=$1
	local array=$2
	for b in ${array[@]}
	do
		line=$line" "$b	
	done
	echo $line >> $compare	
}

GetEachResult()
{
	local i=$1
	local arrayrmse=()
	local arraypair=()
	local k=0
	for typ in ${test[@]}
	do
		local b=$(GetBest $typ $i)
		local rmse=$(echo $b | awk '{print $1}')
		local pair=$(echo $b | awk '{print $2}')
		arrayrmse[$k]=$rmse
		arraypair[$k]=$pair
		((k++))
	done
	
	PrintResult $i "${arrayrmse[*]}"
	PrintResult $i "${arraypair[*]}"
}


result=$(ls $dir_t)

line="dir_name"
for typ in ${test[@]}
do
	line=$line" "$typ	
done
echo $line >> $compare

for i in $result
do
	GetEachResult $i
done

