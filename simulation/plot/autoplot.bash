#!/bin/bash


# this part is only for scalability
#TODO extend to other figures

usage(){

printf "\nThis is a script for extracting data and drawing figures in different modes.\n"
printf "Usage: \n [mode] arg1 arg2\n"
printf "[mode]: scala, alpha  \n"
printf "[arg1]: when in mode scala, arg1 is precision; when in mode alpha, arg1 is precision\n"
printf "[arg2]: when in mode scala, arg2 is alpha; when in mode alpha, arg2 is workload\n"
}







if [ "$#" -ne 3 ]
then
    printf "\nWrong arguments detected, check and rerun\n"
    usage
    exit
fi


rootdir=~/workspace/paco_git/simulation/
rawresultPath=${rootdir}movieRatMat/rawresult-11-10-18-48/
plotdir=${rootdir}plot/
echo $rawresultPath
drawscala(){
precision="$1"
alpha="$2"

if [ $(($alpha % 50)) -ne 0 ]
then 
    printf "\n alpha are the mutiple of 50\n"
    exit
fi



#cd ~/Dropbox/work/paco/matlab/new/rawresult-09-25-22-39
#cd ~/Dropbox/work/paco/matlab/new/rawresult-10-18-21-59
cd  $rawresultPath
cd ga 

cat ga-raw-*-$precision-$alpha |sort -n> ${plotdir}data/scala/ga-raw-$precision-$alpha
cd ../even
cat even-raw-*-$precision-$alpha |sort -n> ${plotdir}data/scala/even-raw-$precision-$alpha
cd ../inverse
cat inverse-raw-*-$precision-$alpha |sort -n> ${plotdir}data/scala/inverse-raw-$precision-$alpha
cd ../loadbalance
cat loadbalance-raw-*-$precision-$alpha |sort -n> ${plotdir}data/scala/loadbalance-raw-$precision-$alpha

cd $plotdir


gnuplot -e "datafile1='./data/scala/ga-raw-$precision-$alpha'; datafile2='./data/scala/even-raw-$precision-$alpha';datafile3='./data/scala/inverse-raw-$precision-$alpha';datafile4='./data/scala/loadbalance-raw-$precision-$alpha'; outfile='./pic/scala/scala-$precision-$alpha.png'; scalatitle='scalability using p=$precision and alpha=$alpha'  "  scalability.p


gnome-open ./pic/scala/scala-$precision-$alpha.png

}

drawalpha(){
precision="$1"
workload="$2"

cd $rawresultPath

cd ga 
cat ga-raw-$workload-$precision-* |sort -n> ${plotdir}data/alpha/ga-raw-$workload-$precision
cd ../even
cat even-raw-$workload-$precision-* |sort -n> ${plotdir}data/alpha/even-raw-$workload-$precision
cd ../inverse
cat inverse-raw-$workload-$precision-* |sort -n> ${plotdir}data/alpha/inverse-raw-$workload-$precision
cd ../loadbalance
cat loadbalance-raw-$workload-$precision-* |sort -n> ${plotdir}data/alpha/loadbalance-raw-$workload-$precision


cd $plotdir


gnuplot -e "datafile1='./data/alpha/ga-raw-$workload-$precision'; datafile2='./data/alpha/even-raw-$workload-$precision';datafile3='./data/alpha/inverse-raw-$workload-$precision';datafile4='./data/alpha/loadbalance-raw-$workload-$precision'; outfile='./pic/alpha/alpha-$workload-$precision.png'; alphatitle='effect of alpha when w=$workload and p=$precision'  "  findalpha.p


gnome-open ./pic/alpha/alpha-$workload-$precision.png

}
case $1 in
    scala)
        drawscala $2 $3
        ;;
    alpha)
        drawalpha $2 $3
        ;;
    *)
        printf "\n Invalid mode detected, check and rerun!\n"
        usage
        ;;
esac
