#!/bin/bash

mv rawresult rawresult-bk
mkdir -p rawresult/ga
mkdir -p rawresult/even
mkdir -p rawresult/inverse
mkdir -p rawresult/loadbalance

function usage(){
printf "Usage:\n ./scale [mode] workload precision alpha minserver maxserver\n" 
printf "[mode]:\n ga: our method\n even: even distribution\n inverse: inverse proportional\n loadbalance: load balancing\n all: all modes above\n"
}

if [ "$#" -ne 6 ]; then
        echo "Illegal number of parameters"
        usage;
        exit
    fi

workload=$2
precision=$3
alpha=$4
minserver=$5
maxserver=$6

# Time limit for paper deadline: hard code for scalability exp


for i in $(seq $minserver 4 $maxserver)
do
    echo "Now testing $i servers"
    case "$1" in
        ga)
            matlab -nojvm -r "gaScheduling($workload,$precision,$alpha,$i);"
            if [ $? -ne 1 ]
            then
                printf "\n matlab failed! please check!\n"
    	    exit
            fi
            ;;
        even)
            matlab -nojvm -r "even($workload,$precision,$alpha,$i);"
            if [ $? -ne 1 ]
            then
                printf "\n matlab failed! please check!\n"
    	    exit
            fi
            ;;
        inverse)
            matlab -nojvm -r "inverse($workload,$precision,$alpha,$i);"
            if [ $? -ne 1 ]
            then
                printf "\n matlab failed! please check!\n"
    	    exit
            fi
            ;;
        loadbalance)
            matlab -nojvm -r "loadbalance($workload,$precision,$alpha,$i);"
            if [ $? -ne 1 ]
            then
                printf "\n matlab failed! please check!\n"
    	    exit
            fi
            ;;
        all)
            matlab -nojvm -r "gaScheduling($workload,$precision,$alpha,$i);" &
            matlab -nojvm -r "even($workload,$precision,$alpha,$i);" &
            matlab -nojvm -r "inverse($workload,$precision,$alpha,$i);" &
            matlab -nojvm -r "loadbalance($workload,$precision,$alpha,$i);" &
            wait
            ;;
         *)
             echo "incorrect input arguments"
             usage
             exit
             ;;
    esac
done
