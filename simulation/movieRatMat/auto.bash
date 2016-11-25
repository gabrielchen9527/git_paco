#!/bin/bash
usage(){
printf "Usage:\n [mode] [workload-range] [precision-range] [alpha-range]\n"
printf "[mode]:\n ga: our method\n even: even distribution\n inverse: inverse proportional\n loadbalance: load balancing\n all: all modes above\n"
printf "[workload-range]: three integers in the order of start, step, end \n"
printf "[precision-range]: available precision range is 0.82 to 0.92 stepped by 0.01, use three number representing start, step, end\n"
printf "[alpha-range]: three number representing start, step, end\n"
exit
}

if [ "$#" -ne 10 ]
then
    printf "Incorrect number of arguments, follow the usage below:\n"
    usage
fi

if [ ! -d rawresult ]
then
mkdir rawresult
cd rawresult
mkdir ga even inverse loadbalance
cd ..
fi

mode=$1

for workload in $(seq $2 $3 $4)
do
    for precision in $(seq $5 $6 $7)
    do
             for alpha in $(seq $8 $9 ${10})
        do
 #           printf "Now we are testing mode: $mode workload: $workload precision:$precision alpha: $alpha\n"
            ./oneround.bash $mode $workload $precision $alpha
        done
    done
done

mv rawresult "rawresult-`date +%m-%d-%H-%M`"


