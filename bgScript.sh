#!/bin/bash
#Background script to find processes.

#Assign the given process name argument into a variable
processName=$1

#Declare global variables
found=false

#Check if process name exists
pgrep "$processName" > /dev/null && found=true
pgrep "$processName" > /dev/null || found=false

if [ "$found" == "false" ]
then
echo "process not found"
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
echo "Choice terminated"
fi
fi
