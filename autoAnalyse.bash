#!/bin/bash

rootDir=~/Dropbox/paco/testResults/simulation/movieRating
cd $rootDir

for f_p in */ 
do
    cd  $rootDir/${f_p}
for f_s in */
  do
      
      cd $rootDir/${f_p}${f_s}
      plength=${#f_p}
      newplen=$((plength -1))
      slength=${#f_s}
      newslen=$((slength -1))
      boundlename=boundletime-${f_p:0:$newplen}-${f_s:0:$newslen}
      resultname=tt-workload-${f_p:0:$newplen}-${f_s:0:$newslen}
      cp ~/Dropbox/paco/scripts/expNanalyse/reg.m  ./   
      sed -i "2s/.*/dataname='$boundlename';/"  reg.m
      sed -i "3s/.*/filename='$resultname';/"  reg.m
    for f_w in */
    do
         targetDir=${f_w}
        
        sqlite3 -header -csv $targetDir/sqlworkloadhistory.db "select rtt from workHistory;" > $targetDir/totalTime.csv

 #       sqlite3 -header -csv ./sqlworkloadhistory.db "select trans_time from workHistory;" > transTime.csv

        
        sed -i '1d' $targetDir/totalTime.csv
        awk 'END {print NR}' $targetDir/totalTime.csv >$targetDir/time.row
        awk '{x+=$1}END {print x/1000}' $targetDir/totalTime.csv >$targetDir/time.sum
        paste -d ' ' $targetDir/time.row $targetDir/time.sum>> $boundlename

    done  
    matlab -nojvm<reg.m
    sed -i "1i $resultname" $resultname
  done
done
