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
	
	local best=99.0
	local bestpic=""
	for time in {1..5}
	do
		local tmp=$dir/$i/$time
		local line=$(sed -n '3p' $tmp/evaluate.txt | awk '{print $2}')
		local com=$(echo "$line < $best" |bc)
		if [ $com -eq 1 ]; then
			best=$line
			bestpic=$tmp/evaluate.png
		fi
	done
	echo $i" "$best >> $out
	cp $bestpic $outdir
	mv $outdir/evaluate.png $outdir/$i.png
	echo $best
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
	array=()
	k=0
	for typ in ${test[@]}
	do
		b=$(GetBest $typ $i)
		array[$k]=$b
		((k++))
	done

	line=$i
	for b in ${array[@]}
	do
		line=$line" "$b	
	done 
	echo $line >> $compare
done

