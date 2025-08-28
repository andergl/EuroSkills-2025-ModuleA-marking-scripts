#!/bin/bash
#
#	A8-HQ-DMZ-2
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
echo "Marking A1 General configuration (if HQ-DMZ-2 is random machine)"
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

	if [  $( hostname  | grep -ic "HQ-DMZ-2") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: HQ-DMZ-2"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "10.1.20.12/24") = 1 ] 
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.1.20.12/24"$NC
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
echo "Marking A8-HQ-DMZ-2"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""




echo -e $PURPLE"######################################################################################"
echo "M1 - Email server: SMTP"
echo -e "######################################################################################"$NC
echo ""

    
	if [ $( echo 'QUIT' | nc -w 5 localhost 587 | grep -c 220 ) = 1 ] && [ $( sleep 5 | openssl s_client -connect localhost:587 -starttls smtp 2> /dev/null | grep -c "issuer=C = DK.*O = Lego APS.*CN = Lego APS Intermediate CA" ) = 1 ]
	then  
		 echo -e $GREEN"OK - Email server: SMTP"$NC
	else
		 echo -e $RED"FAILED - Email server: SMTP"$NC
			echo "-----------------------------------------------------------------"
			echo 'QUIT' | nc -w 5 localhost 587 | grep -c 220
			sleep 5 | openssl s_client -connect localhost:587 -starttls smtp 2> /dev/null | grep -c "issuer="
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct output:"$NC
				echo -e $YELLOW"Connection successful"$NC
				echo -e $YELLOW"issuer=C = DK, O = Lego APS, CN = Lego APS Intermediate CA"$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M2 - Email server: IMAP"
echo -e "######################################################################################"$NC
echo ""

    
	if [ $( echo -e 'CLOSE\nCLOSE\nCLOSE' | nc -w 5 localhost 143 | grep -c OK ) = 1 ] && [ $( sleep 5 | openssl s_client -connect localhost:143 2> /dev/null | grep -c "issuer=C = DK.*O = Lego APS.*CN = Lego APS Intermediate CA" ) = 1 ]
	then  
		 echo -e $GREEN"OK - Email server: SMTP"$NC
	else
		 echo -e $RED"FAILED - Email server: SMTP"$NC
			echo "-----------------------------------------------------------------"
			echo -e 'CLOSE\nCLOSE\nCLOSE' | nc -w 5 localhost 143 | grep -c OK
			sleep 5 | openssl s_client -connect localhost:143 2> /dev/null | grep -c "issuer="
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct output:"$NC
				echo -e $YELLOW"Connection successful"$NC
				echo -e $YELLOW"issuer=C = DK, O = Lego APS, CN = Lego APS Intermediate CA"$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""




echo -e $PURPLE"######################################################################################"
echo "M3 - Zabbix: website availability"
echo -e "######################################################################################"$NC
echo ""

    echo -e $YELLOW"Please, stop webservers on HQ-DMZ-1 and HQ-DMZ-2."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Look at the following output to check if the alert has been written to /monitor/webalert.log:"$NC
	tail -n 1 /monitor/webalert.log
	echo -e $YELLOW"Expected output (date should show current time): [2025-08-28 11:20:45] ALERT: Web server https://www.billund.lego.dk is DOWN"$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Look at the following output to check if the alert has been sent to frida:"$NC
	grep "to=<frida@" /var/log/mail.log
	echo -e $YELLOW"Expected output (date should show current time): Aug 28 11:20:45 mail postfix/smtp[1234]: 3D2A3401F4: to=<frida@lego.dk>, XXXXX, status=sent (250 OK)"$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $GREEN"OK - Zabbix: website availability - If the process has been succesful"$NC
	echo -e $RED"FAILED - Zabbix: website availability - If the process has FAILED at some point"$NC


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M4 - Zabbix: CPU usage"
echo -e "######################################################################################"$NC
echo ""

  
#I don't know how to check this



	pause 'Press [ENTER] key to continue...'
	echo -e $GREEN"OK - Zabbix:CPU usage - If the process has been succesful"$NC
	echo -e $RED"FAILED - Zabbix: CPU usage - If the process has FAILED in some point"$NC


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
