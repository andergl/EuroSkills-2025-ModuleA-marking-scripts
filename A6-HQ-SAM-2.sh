#!/bin/bash
#
#	A5-HQ-SAM-2
#
################## General section ##################
function pause(){
 read -p "$*"
}

#### COLORS ####
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

################## Marking start ##################
echo ""
echo ""
echo -e $BLUE"######################################################################################"
echo "Marking A1 General configuration (if HQ-SAM-2 is random machine)"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""

################## Per aspect section ##################
echo ""
echo ""
echo -e $PURPLE"######################################################################################"
echo "IF this is a random machine!!!"
echo "Hostname, network config and timezone"
echo -e "######################################################################################"$NC
echo ""

	if [  $( hostname  | grep -ic "HQ-SAM-2") = 1 ]
	#if [  $( hostname -f | grep -ic "HQ-SAM-2") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
			#hostname -f
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: HQ-SAM-2"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "10.1.10.22/24") = 1 ] 
	#if [  $( hostname -I | grep -ic "10.1.10.22") = 1 ]
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
			#hostname -I
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.1.10.22/24"$NC
	fi	

	if [  $( timedatectl | grep -i "zone" | grep -ic "Europe/Copenhagen" ) = 1 ]
	then  
		echo -e $GREEN"OK - Check Timezone"$NC
	else
		echo -e $RED"FAILED - Check Timezone"$NC
			echo "-----------------------------------------------------------------"
			timedatectl | grep -i "zone"
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Time zone: Europe/Copenhagen"$NC
	fi
 
	if [  $( cat /etc/default/keyboard | grep XKBLAYOUT | grep -ic "us" ) = 1 ]
	then  
		 echo -e $GREEN"OK - Check keyboard"$NC
	else
		 echo -e $RED"FAILED - Check keyboard"$NC
	fi

	#if [  $( echo $LANG  | grep -ic "en_US.UTF-8" ) = 1 ]
	#then  
	#	 echo -e $GREEN"OK - Check Language"$NC
	#else
	#	 echo -e $RED"FAILED - Check Language"$NC
	#		echo "-----------------------------------------------------------------"
	#		echo $LANG
	#			echo "-----------------------------------------------------------------"
	#			echo -e $YELLOW"en_US.UTF-8"$NC
	#fi


echo -e $YELLOW"If every item before is GREEN, point for first aspect."$NC
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "IF this is a random server!!!"
echo "NTP"
echo -e "######################################################################################"$NC
echo ""

echo -e $CYAN"MANUAL CHECKING! MANUAL CHECKING! MANUAL CHECKING!"$NC
echo ""
echo ""
ntpq -p
echo ""
#### Review this

echo -e $GREEN"IF the peer is local AND stratum 2 AND clock set, ITEM iS OK"$NC
echo -e $RED"BUT IF NOT, ITEM IS FAILED"$NC
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo ""
echo ""
echo -e $BLUE"######################################################################################"
echo "Marking A6-HQ-SAM-2"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo ""
echo -e $PURPLE"######################################################################################"
echo "M1 - Backup"
echo -e "######################################################################################"$NC

	
	echo "Is A4-HQ-DC.sh script already executed in HQ-DC server?"
	echo "    If not, please go to HQ-DC machine and create a .txt file with a random name in /share/users directory"
	echo "    The exact hour now is:"
	date
	echo "    Backup task should be scheduled every 5 minutes, if necessary Wait until XX:X0:00 or XX:X5:00"
	echo "  If yes, or if you have waited:"
	pause 'Press [ENTER] key to continue...'
	echo "Look at this output:"
	ls -la /backup/users | grep ".txt"

	echo -e $GREEN"OK - Backup: If there is a txt file with the random name AND has been updated recently."$NC
    echo -e $RED"FAILED - Backup: f there is NOT a txt file with the random name OR has NOT been updated recently."$NC
			
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""














################## Ending section ##################
echo ""
echo ""
echo -e $BLUE"######################################################################################"
echo "The marking of this VM is finished. The script is terminating."
echo -e "######################################################################################"$NC
echo ""
echo ""
