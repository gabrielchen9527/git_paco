#!/bin/bash

workload=$2
precision=$3
alpha=$4


function usage(){
printf "Usage:\n ./oneround [mode] workload precision alpha\n" 
printf "[mode]:\n ga: our method\n even: even distribution\n inverse: inverse proportional\n loadbalance: load balancing\n all: all modes above\n"
}

if [ "$#" -ne 4 ]; then
        echo "Illegal number of parameters"
        usage;
        exit
    fi


case "$1" in
    ga)
        echo "now testing our strategy with workload=$2, precision=$3, alpha=$4"
        sed -i "1s/.*/W=$workload/" runga.m
        sed -i "2s/.*/R=$precision/" runga.m
        sed -i "3s/.*/a=$alpha/" runga.m
        matlab -nojvm <runga.m
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
        fi
        ;;
    even)
        echo "now testing even distribution with workload=$2, precision=$3, alpha=$4"
        sed -i "1s/.*/W=$workload/" runeven.m
        sed -i "2s/.*/R=$precision/" runeven.m
        sed -i "3s/.*/a=$alpha/" runeven.m
        matlab -nojvm<runeven.m
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
        fi
        ;;
    inverse)
        echo "now testing inverse proportional distribution with workload=$2, precision=$3, alpha=$4"
        sed -i "1s/.*/W=$workload/" runinverse.m
        sed -i "2s/.*/R=$precision/" runinverse.m
        sed -i "3s/.*/a=$alpha/" runinverse.m
        matlab -nojvm<runinverse.m
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
        fi
        ;;
    loadbalance)
        echo "now testing load balancingwith workload=$2, precision=$3, alpha=$4 "
        sed -i "1s/.*/W=$workload/" runloadbalance.m
        sed -i "2s/.*/R=$precision/" runloadbalance.m
        sed -i "3s/.*/a=$alpha/" runloadbalance.m
        matlab -nojvm<runloadbalance.m
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
        fi
        ;;
    all)
        echo "now testing all strategies with workload=$2, precision=$3, alpha=$4"
        sed -i "1s/.*/W=$workload/" runga.m
        sed -i "2s/.*/R=$precision/" runga.m
        sed -i "3s/.*/a=$alpha/" runga.m
        sed -i "1s/.*/W=$workload/" runeven.m
        sed -i "2s/.*/R=$precision/" runeven.m
        sed -i "3s/.*/a=$alpha/" runeven.m
        sed -i "1s/.*/W=$workload/" runinverse.m
        sed -i "2s/.*/R=$precision/" runinverse.m
        sed -i "3s/.*/a=$alpha/" runinverse.m
        sed -i "1s/.*/W=$workload/" runloadbalance.m
        sed -i "2s/.*/R=$precision/" runloadbalance.m
        sed -i "3s/.*/a=$alpha/" runloadbalance.m
        matlab -nojvm<runga.m &
        matlab -nojvm<runeven.m &
        matlab -nojvm<runinverse.m &
        matlab -nojvm<runloadbalance.m &
        wait
       # cat <(echo "ga") ./result/ga-breakdown-$2-$3-$4 <(echo "even") ./result/even-breakdown-$2-$3-$4 <(echo "inverse") ./result/inverse-breakdown-$2-$3-$4 <(echo "loadbalance") ./result/loadbalance-breakdown-$2-$3-$4>./breakdown/breakdown-$2-$3-$4
       # cat  ./result/ga-workload-eval-$2-$3-$4  ./result/even-workload-eval-$2-$3-$4 ./result/inverse-workload-eval-$2-$3-$4 ./result/loadbalance-workload-eval-$2-$3-$4>./workload-eval/workload-eval-$2-$3-$4
        ;;
     *)
         echo "incorrect input arguments"
         usage
         exit
         ;;
esac
