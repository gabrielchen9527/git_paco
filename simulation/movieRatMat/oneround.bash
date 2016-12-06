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
        matlab -nojvm -r "gaScheduling($workload,$precision,$alpha);"
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
	    exit
        fi
        ;;
    even)
        matlab -nojvm -r "even($workload,$precision,$alpha);"
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
	    exit
        fi
        ;;
    inverse)
        matlab -nojvm -r "inverse($workload,$precision,$alpha);"
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
	    exit
        fi
        ;;
    loadbalance)
        matlab -nojvm -r "loadbalance($workload,$precision,$alpha);"
        if [ $? -ne 1 ]
        then
            printf "\n matlab failed! please check!\n"
	    exit
        fi
        ;;
    all)
        matlab -nojvm -r "gaScheduling($workload,$precision,$alpha);" &
        matlab -nojvm -r "even($workload,$precision,$alpha);" &
        matlab -nojvm -r "inverse($workload,$precision,$alpha);" &
        matlab -nojvm -r "loadbalance($workload,$precision,$alpha);" &
        wait
# comment the following line because need to get the exit status of background process        
#	if [ $? -ne 1 ]
#        then
#            printf "\n matlab failed! please check!\n"
#	    exit
#        fi
        ;;
     *)
         echo "incorrect input arguments"
         usage
         exit
         ;;
esac
