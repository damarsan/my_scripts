#!/bin/bash
# find which process is eating 99% RAM
counter=0
function check_threshold()
{
        threshold=99 #porcentaje
        total=$(free | grep "Mem:" | awk '{print $2}')
        remaining=$(free | grep "Mem:" | awk '{print $4}')
        current=$(echo "scale=0;100-$remaining * 100 / $total" | bc -l)
        process=$(ps axo %mem,pid,euser,cmd | sort -nr | head -n 1 | awk -F' ' '{print $4}')
        if [ $current -gt $threshold ]
         then
                counter=$((counter+1))
        fi
}

        check_threshold
	/bin/sleep 55
        check_threshold

        if [ "$counter" -eq 2 ]
        then
            echo "on `date +'%d-%m-%Y %H:%M:%S'`. RAM utilization at ${current}% by ${process}" |  mail -s "process info" \
            "damarsan2@gmail.com"
         fi
