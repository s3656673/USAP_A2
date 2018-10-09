#!/bin/bash
#Led C0nfigurat0r by Jonathan Ciminelli
#Unix Systems Administration and Programming - Assignment 02

#Global variables

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

#Force quit function - Handle signal kills
forceQuit(){
echo 'Please close program gracefully, via the Quit command from the main menu'
mainMenu
}

#Welcome details
trap 'forceQuit' 2
echo 'W3lc0me t0 L3d_C0nfigurat0r'
echo '============================'
echo 'Please select an led to configure:'
contents=0
num=1
proceed=true
	#Loop through file content, and print out the file names and content numbers
	for each in "${array[@]}"
	do
	#echo "$each" $num"." $file
	echo "$num. $each"
	let "num=num+1"
	let "contents=contents+1"
	done
#Increment contents by 1 to compensate for the quit option
let quitNum="$contents+1"
echo $num"." "Quit"
	#Read option from user, then call the LED manipulation menu
	read -p "Please enter a number (1-$quitNum) for the led to configure or quit: " choice

	#Check number input,
	if [ $choice -le 0 ]
	then
	echo "Invalid option, please try again"
	proceed=false
	mainMenu
	fi
	if [ $choice -gt $quitNum ]
	then
	echo "Invalid option, please try again"
	proceed=false
	mainMenu
	fi
	if [ $choice -eq $quitNum ]
	then
	echo "G00dbye, see y0u next time!"
	exit 0
	fi
	if [ "$proceed" = "true" ]
	then
	ledManipulation $choice
	fi
}


#LED Manipulation menu, this is called after user selects an LED option
ledManipulation(){
trap 'forceQuit' 2
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
#If choice is 1, call the turn on led function
if [ $choice -eq 1 ]
then
turnOnLed
fi
#If choice is 2, call the turn off led function
if [ $choice -eq 2 ]
then
turnOffLed
fi
#If choice is 3, call associateEvent
if [ $choice -eq 3 ]
then
associateEvent
fi
#If choice is 4, call associateProcess
if [ $choice -eq 4 ]
then
	associateProcess
fi	
#If choice is 6, go back to main menu
if [ $choice -eq 6 ]
then
mainMenu
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

#Associate LED with a system event function
associateEvent(){
#Local variables
contents=0
num=1
#Store contents of trigger into a variable
triggerEvent=$(<trigger)
#Store triggerEvent variable into an array to be displayed on screen
read -r -a eventArray <<< "$triggerEvent"

echo "Associate LED with a system event"
echo "================================="
echo "Available events are:"
echo "----------------------"

#Loop through eventArray and present on screen
for each in "${eventArray[@]}"
do
echo "$num. $each"
let "num=num+1"
let "contents=contents+1"
done
#Increment contents by 1, to compensate for the quit option
let quitNum="$contents+1"
echo "$quitNum. Quit to previous menu"
read -p "Please select an option (1-$quitNum): " choice
echo ${eventArray[$choice-1]}>trigger
echo "LED now associated with ${eventArray[$choice-1]}"
#If choice is quitNum, go back to previous menu
if [ $choice -eq $quitNum ]
then
ledManipulation
fi
}

#Function to associate an LED with a system process
associateProcess()
{
echo "Associate LED with the performance of a process"
echo "==============================================="
read -p "Please enter the name of the program to monitor(partial names are ok:) " program

#CHECK IF NAME EXISTS WITH PS
cd /home/pi/USAP_A2
./bgScript.sh "$program"
read -p "Do you wish to 1) monitor memory or 2) monitor cpu? [enter memory or cpu]: " programType
}
#Call main menu
mainMenu
