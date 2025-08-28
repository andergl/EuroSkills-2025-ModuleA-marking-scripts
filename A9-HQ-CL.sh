#!/bin/bash
#
#	A9-HQ-CL
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
echo "Marking A1 General configuration (if HQ-CL is random machine)"
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

	if [  $( hostname  | grep -ic "HQ-CL") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: HQ-CL"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "10.1.30..*/24") = 1 ] 
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.1.30..*/24"$NC
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
echo "Marking A9-HQ-CL"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M1 - GUI"
echo -e "######################################################################################"$NC
echo ""

    echo -e $YELLOW"Visual checking. Is there a GUI installed?"$NC
	echo -e $GREEN"OK - GUI - If there is a GUI"$NC
	echo -e $RED"FAILED - GUI - If there is NOT a GUI"$NC


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M2 - LDAP"
echo -e "######################################################################################"$NC
echo ""

    echo -e $YELLOW"Log in as ella user. If it's not possible, log in as localuser."$NC
	pause 'Press [ENTER] key to continue...'
	if [  $( getent passwd | grep -c "ella:" ) = 1 ]  && [  $( cat /etc/passwd | grep -c "ella:" ) = 0 ]
	then  
		 echo -e $GREEN"OK - IF YOU CAN LOGIN WITH ella, LDAP client"$NC
	else
		 echo -e $RED"FAILED - LDAP client"$NC
			echo "-----------------------------------------------------------------"
			getent passwd
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"You can see ella here. AND (press ENTER)"$NC
            echo "-----------------------------------------------------------------"
            pause 'Press [ENTER] key to continue...'
			cat /etc/passwd
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"You CAN'T see ella here."$NC
	fi



echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M3 - Email client"
echo -e "######################################################################################"$NC
echo ""

    echo -e $YELLOW"Visual checking. Open Thunderbird email client. Is ella's account configured? Try to send an email to frida@lego.dk."$NC
	echo -e $GREEN"OK - Email client - If ella's account is configured AND can send an email to frida"$NC
	echo -e $RED"FAILED - Email client - If ella's account is NOT configured OR can NOT send an email to frida"$NC


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M4 - Share auto mount"
echo -e "######################################################################################"$NC
echo ""

    echo -e $YELLOW"Visual checking. Look at the following output:"$NC
	ls -la /home/ella/share
	echo -e $GREEN"OK - Share auto mount - If ella's share directory is present"$NC
	echo -e $RED"FAILED - Share auto mount - If ella's share directory is NOT present"$NC


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""

echo -e $PURPLE"######################################################################################"
echo "M5 - HA DHCP"
echo -e "######################################################################################"$NC
echo ""

    echo -e $YELLOW"Look at the following output:"$NC
	ip a | grep "inet.*global" 
	echo -e $YELLOW"Should have an IP address like 10.1.30..*/24 dynamically obtained (dynamic)"$NC
	echo -e $YELLOW"Please, disconnect the wire from HQ-SAM-1 or stop the DHCP server on HQ-SAM-1."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Restart the network and look at the following output:"$NC
	#### Maybe it's necessary to stop the VM and change the network adapter 
	ip a | grep "inet.*global" 
	echo -e $YELLOW"Should have an IP address like 10.1.30..*/24 dynamically obtained (dynamic)"$NC
	echo -e $YELLOW"Please, disconnect the wire from HQ-SAM-2 or stop the DHCP server on HQ-SAM-2."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Restart the network and look at the following output:"$NC
	#### Maybe it's necessary to stop the VM and change the network adapter 
	ip a | grep "inet.*global" 
	echo -e $YELLOW"Should NOT obtain an IP address"$NC
	echo -e $YELLOW"Please, connect the wire from HQ-SAM-1 or start the DHCP server on HQ-SAM-1."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Restart the network and look at the following output:"$NC
	#### Maybe it's necessary to stop the VM and change the network adapter 
	ip a | grep "inet.*global" 
	echo -e $YELLOW"Should have an IP address like 10.1.30..*/24 dynamically obtained (dynamic)"$NC
	echo -e $YELLOW"Please, connect the wire from HQ-SAM-2 or start the DHCP server on HQ-SAM-2."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $GREEN"OK - HA DHCP - If the process has been succesful"$NC
	echo -e $RED"FAILED - HA DHCP - If the process has FAILED at some point"$NC


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
