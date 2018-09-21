#!/bin/bash
#Led C0nfigurat0r by Jonathan Ciminelli
#Unix Systems Administration and Programming - Assignment 02



#Global variables
contents=0
num=1



#Populate contents

cd /sys/class/leds
i=0
while read line
do
	array[ $i ]="$line"
	(( i++ ))
done < <(for n in *; do printf '%s\n' "$n"; done)

#Main menu function - First function that launches
mainMenu(){

#Welcome details
echo 'W3lc0me t0 L3d_C0nfigurat0r'
echo '============================'
echo 'Please select an led to configure:'

	#Loop through file content, and print out the file names and content numbers
	for each in "${array[@]}"
	do
	#echo "$each" $num"." $file
	echo "$num. $each"
	let "num=num+1"
	let "contents=contents+1"
	done
#Increment contents by 1 to compensate for the quit option
let "contents=contents+1"
echo $num"." "Quit"
	#Read option from user, then call the LED manipulation menu
	read -p "Please enter a number (1-$contents) for the led to configure or quit: " choice
	ledManipulation $choice
}


#LED Manipulation menu, this is called after user selects an LED option
ledManipulation(){
#Retrieve choice number, and retrieve LED name from array element
ledNum="$1"
let "ledNum=ledNum-1"
led="${array[ledNum]}"

#Manipulation menu Icons
cd /sys/class/leds/$led
echo "$led"
echo "==========="
echo "What would you like to do with this led?"
echo "1) turn on"
echo "2) turn off"
echo "3) associate with a system event"
echo "4) associate with the performance of a process"
echo "5) stop association with a process performance"
echo "6) quit to main menu"
#Read number choice
read -p "Please enter a number (1-6) for your choice: " choice
if [ $choice -eq 1 ]
then
turnOnLed
fi
if [ $choice -eq 2 ]
then
turnOffLed
fi
}

#Turn on led function
turnOnLed()
{
echo 1 > brightness
}

#Turn off led function
turnOffLed()
{
echo 0 > brightness
}
#Call main menu
mainMenu
