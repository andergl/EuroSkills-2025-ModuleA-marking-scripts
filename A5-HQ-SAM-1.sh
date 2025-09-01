#!/bin/bash
#
#	A5-HQ-SAM-1
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
echo "Marking A1 General configuration (if HQ-SAM-1 is random machine)"
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

	if [  $( hostname  | grep -ic "HQ-SAM-1") = 1 ]
	#if [  $( hostname -f | grep -ic "HQ-SAM-1") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
			#hostname -f
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: HQ-SAM-1"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "10.1.10.21/24") = 1 ] 
	#if [  $( hostname -I | grep -ic "10.1.10.21") = 1 ] 
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
			#hostname -I
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.1.10.21/24"$NC
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
echo "Marking A5-HQ-SAM-1"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo ""
echo -e $PURPLE"######################################################################################"
echo "M1 - Intermediate CA"
echo -e "######################################################################################"$NC

	if [ $(openssl x509 -in /ca/SUBCA.crt -text -noout | grep -ic "Issuer:.*C = DK.*O = Lego APS.*CN = Lego APS Root CA" ) = 1 ] && [ $(openssl x509 -in /ca/SUBCA.crt -text -noout | grep -ic "Subject:.*C = DK.*O = Lego APS.*CN = Lego APS Intermediate CA" ) = 1 ]
	# cdp parameter?????
	then  
		 echo -e $GREEN"OK - Intermediate CA"$NC
	else
		 echo -e $RED"FAILED - Intermediate CA"$NC
			echo "-----------------------------------------------------------------"
			openssl x509 -in /ca/CA.crt -text -noout | grep -ic "Subject:"
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"Correct output: Should be Subject: C = DK, O = Lego APS, CN = Lego APS Intermediate CA"$NC
	fi
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
