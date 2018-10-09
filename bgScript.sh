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
targets=$(ps -A | grep $processName | awk '{ print $1, $4 }')
num=1
echo "$targets" > testfile.txt
IFS=,$'\n' read -d '' -r -a processArray <testfile.txt

#Print array elements to screen
num=1
for each in "${processArray[@]}"
do
echo "$num. $each"
let "num=num+1"
done
fi
