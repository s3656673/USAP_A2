#!/bin/bash
#Background script to find processes.
keepChecking()
{
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

while true
do
cd "$DIR"
#Check memory or cpu usage of a process
processNumFloat=0
processNum=0
program=$(<program.txt)
sleepTime=null
#IFS=,$'\n' read -d '' -r -a processArray <processArray.txt
if [[ "$1" = "memory" ]]
then
ps -C "$program" -o %mem > processCheck.txt
fi

if [[ "$1" = "cpu" ]]
then
ps -C "$program" -o %cpu > processCheck.txt
fi

grep -o '[0.0-9.9]*' processCheck.txt > processNumbers.txt
cat processNumbers.txt | awk '{ sum+=$1} END {print sum}' > avg.txt
processNumFloat=$(<avg.txt)
processNum=${processNumFloat%.*}
#echo "sum is $processNum"


#Check range between 1 and 24
if (("$processNum" >=1 && "$processNum" <=24));
then
sleepTime=5
fi

#Check range between 25 and 49
if (("$processNum" >=25 && "$processNum" <=49));
then
sleepTime=2
fi

#Check ranges between 50 and 74
if (("$processNum" >=50 && "$processNum" <=74));
then
sleepTime=1
fi

#Check ranges between 75 and 99
if (("$processNum" >=75 && "$processNum" <=99));
then
sleepTime=.5
fi

cd "$2"
echo 1 > brightness
sleep .5
echo 0 > brightness
sleep $sleepTime
echo 1 > brightness
sleep .5
echo 0 > brightness
sleep $sleepTime

done
}




#Assign the given process name argument into a variable
processName=$1

if [[ "$1" == "true" ]]
then
keepChecking "$2" "$3"
fi
#Declare global variables
found=false

#Check if process name exists
pgrep "$processName" > /dev/null && found=true
pgrep "$processName" > /dev/null || found=false

if [ "$found" == "false" ]
then
echo "process not found"
exit 1
fi

#Invoke the PS command and return the results with the process name
if [ "$found" == "true" ]
then
#print results to screen

#store values into an array
IFS=$(echo -en "\n\b")
targets=$(ps -A | grep $processName | awk '{ print $4 }')
num=1
echo "$targets" > testfile.txt
cat -n testfile.txt | sort -uk2 | sort -nk1 | cut -f2- > processArray.txt
echo chromium-foobar >> processArray.txt
IFS=,$'\n' read -d '' -r -a processArray <processArray.txt

#Calculate lines and check for any repeats
checkNum=1
for each in "${processArray[@]}"
do
let "checkNum=checkNum+1"
done
fi

#If a name conflict occurs, let the user choose which program to monitor
if [[ "$checkNum" -gt 2 ]]
then
echo "I have detected a name conflict. Do you want to monitor: "
for each in "${processArray[@]}"
do
echo "$num. $each"
let "num=num+1"
quitOption=0
let "quitOption=num"
done
echo "$quitOption. Cancel Request"
read -p "Please enter your option (1-$quitOption): " choice
if [[ $choice -eq $quitOption ]]
then
exit 1
fi
let choice=choice-1
echo "${processArray[choice]}" > program.txt
fi



