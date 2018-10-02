#!/bin/bash

#Background script to record background process.
#ps -A | grep chromium | awk '{ print $1, $4 }'

#Global variables
found=false

#Check if the process can be found
if [ -z `ps -A | grep chromium` ]
then
found=false
else
found=true
fi

#If found, present the information to the user
if [ "$found" == "true" ]
then
ps -A | grep chromium | awk '{ print $1, $4 }'
else
echo "Could not find the request"
fi
