#!/bin/bash

dir=/media/android/TUM_ros_bag
grounddir=/media/android/TUM_ros_bag/groundtruth
result=/media/android/result

datalist=$(ls $dir)

output=$result/output.txt

for i in $datalist
do
    if [ -d ${dir}/${i} ];then 
        continue
    fi
    
    roslaunch rgbdslam test_settings.launch bagfile_name:="${dir}/${i}" | while read myline
    do
        if [ "$myline"x = "Evaluation Donex" ]; then
            pid=$(ps -e | grep rgbdslam | awk '{print $1}')
            echo $pid
            kill $pid
        fi
    done
    python evaluate_ate1.py ${dir}/${i}iteration_3_estimate.txt ${grounddir}/${i}_groundtruth.txt --plot ${result}/${i}_3.png --verbose > ${result}/${i}_3.log
    python evaluate_ate1.py ${dir}/${i}iteration_4_estimate.txt ${grounddir}/${i}_groundtruth.txt --plot ${result}/${i}_4.png --verbose > ${result}/${i}_4.log
    rm ${dir}/${i}iteration_*
    rmse3=$(sed -n '3p' ${result}/${i}_3.log | awk '{print $2}') 
    rmse4=$(sed -n '3p' ${result}/${i}_4.log | awk '{print $2}')
    echo $i" "$rmse3" "$rmse4 >> $output
done

