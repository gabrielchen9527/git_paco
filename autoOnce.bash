#!/bin/bash
################################################################################
#define a usage function

function usage(){
printf "Usage:\n  ./auto AppID (1 for face, 2 for movie )  serverIndex(1 2 3 4) precisionIndex(1-10) workload\n" 
}


#define a countdown watch

function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}
################################################################################


#check if number of arguments is correct

if [[ $# -ne 4 ]]
then
printf "Illegal number of parameters, see usage below:\n"
usage
exit
fi

###############################################################################
#uninstall previous packages

printf "\n\n\n\n now uninstall existing packages on device \n\n\n\n"

adb uninstall com.yongboli.paco && adb uninstall com.yongboli.paco.test 


wait 

printf "uninstall finished, now configure the testing parameters\n\n\n\n"

##############################################################################
# define function for faceRec

function faceRec(){


#configure testing server

s=$2

sed -i "55s/.*/ private static final int SERVER_TO_DEBUG = $s;/"   ~/hack/Paco/Paco/src/main/java/com/yongboli/sql/OptimizeEngine.java

case "$s" in

1)
server="centos-yongbo"
;;
2)
server="alien"
;;
4)
server="centos-yurong"
;;
5)
server="mac"
;;

esac


printf "\n\n server is $s \n\n"

####################################################
#configure precision level

p=$3

sed -i "214s/.*/for \(int precision = $p; precision <= $p; precision += 3\) \{/"  ~/hack/Paco/Paco/src/androidTest/java/com/yongboli/paco/PacoEspresso.java



precision="$3precision"

printf "precision is $p\n\n\n"
#####################################################
#configure workloads

w=$4

sed -i "222s/.*/for \(int i = 0; i <$w; i++\)\{/"  ~/hack/Paco/Paco/src/androidTest/java/com/yongboli/paco/PacoEspresso.java
 

printf "workload is $w\n\n\n"
######################################################

}


function movieRating(){


#configure testing server

s=$2

sed -i "55s/.*/ private static final int SERVER_TO_DEBUG = $s;/"   ~/hack/Paco/Paco/src/main/java/com/yongboli/sql/OptimizeEngine.java

case "$s" in

1)
server="centos-yongbo"
;;
2)
server="alien"
;;
4)
server="centos-yurong"
;;
5)
server="mac"
;;

esac


printf "\n\n server is $s \n\n"

####################################################
#configure precision level

p=$3

sed -i "94s/.*/for \(int precision = $p; precision <= $p; precision += 3\) \{/"  ~/hack/Paco/Paco/src/androidTest/java/com/yongboli/paco/MovieEvalActivityTest.java



precision="$3precision"

printf "precision is $p\n\n\n"
#####################################################
#configure workloads

w=$4

sed -i "103s/.*/for \(int i = 0; i < $w; i++\)\{/"   ~/hack/Paco/Paco/src/androidTest/java/com/yongboli/paco/MovieEvalActivityTest.java
 

printf "workload is $w batch\n\n\n"


}




a=$1

case "$a" in
1)
app="faceRec"
class=com.yongboli.paco.PacoEspresso
faceRec 1 $2 $3 $4
;;
2)
app="movieRating"
class=com.yongboli.paco.MovieEvalActivityTest
movieRating 2 $2 $3 $4
;;
esac

printf "\n\n Testing app is $app \n\n"





#the path to pulled data is

pathToData=~/Dropbox/paco/testResults/simulation/$app/$precision/$server/$w
#####################################################
#create the folder if it does not exist

if [ ! -d "$pathToData" ]
then
mkdir -p $pathToData
fi

cp ~/tmp/pullfiles-unrooted.sh $pathToData

####################################################

#install PACO to device 

printf "\n\nInstallation starts, this may take a while...\n\n"


#~/hack/Paco/gradlew build -x test
~/hack/Paco/gradlew installDebug -x test  &&  ~/hack/Paco/gradlew installDebugAndroidTest -x test
exitStatusInstall=$?

if [[ exitStatusInstall -ne 0 ]]
then
printf  "\n\n  Installation failed!!!!!!!!!!!!!!!\n\n"
exit
fi

printf "\n\n\n\n\n Installation Succeeded \n\n\n\n"


# the following few lines are acquired from android studio's run commands
#adb push /home/yurchen/hack/Paco/Paco/build/outputs/apk/Paco-debug.apk /data/local/tmp/com.yongboli.paco
#adb shell pm install -r "/data/local/tmp/com.yongboli.paco"
#adb push /home/yurchen/hack/Paco/Paco/build/outputs/apk/Paco-debug-androidTest-unaligned.apk /data/local/tmp/com.yongboli.paco.test
#adb shell pm install -r "/data/local/tmp/com.yongboli.paco.test"


#####################################################
#run test

printf "Now test app $app precision level $p and workload $w for server $s\n\n\n\n\n"

adb shell am instrument -w -e class $class com.yongboli.paco.test/android.support.test.runner.AndroidJUnitRunner


printf "testing finished!"


####################################################
#pull data



timeToDelay=$((10*$w+100))
echo "now wait $timeToDelay seconds before pulling data..."
countdown $timeToDelay

printf "\n\n\n now pull data to $pathToData \n\n\n"


cd $pathToData

./pullfiles-unrooted.sh

sqlite3 -header -csv ./sqlworkloadhistory.db "select rtt from workHistory;" > totalTime.cvs

sqlite3 -header -csv ./sqlworkloadhistory.db "select trans_time from workHistory;" > transTime.cvs

sqlite3 -header -csv ./sqlworkloadhistory.db "select trans_energy from workHistory;" > transEnergy.cvs


sed -i '1d' ./totalTime.cvs

sed -i '1d' ./transTime.cvs

sed -i '1d' ./transEnergy.cvs

paste -d ' ' ./totalTime.cvs ./transTime.cvs ./transEnergy.cvs > bundle.cvs

cat ./bundle.cvs |awk '{print $3/$2}'>division.cvs

paste -d ' ' ./bundle.cvs ./division.cvs >analysis.cvs

cat ./analysis.cvs |awk -v workload=$w '{ s+=$4}END{print s/workload}'> power.cvs


printf "\n\nresults are now ready for analysis\n\n"

cd -



