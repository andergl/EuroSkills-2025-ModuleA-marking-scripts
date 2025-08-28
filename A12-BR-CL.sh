#!/bin/bash
#
#	A12-BR-CL
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


################## Per aspect section ##################




echo ""
echo ""
echo -e $BLUE"######################################################################################"
echo "Marking A12-BR-CL"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M1 - DHCP server"
echo -e "######################################################################################"$NC
echo ""

	if [  $( ip a | grep "inet.*global" | grep -ic "10.2.30..*/24") = 1 ] 
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.2.30..*/24"$NC
	fi	


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo ""
echo ""
echo -e $BLUE"######################################################################################"
echo "Marking A12-BR-CL - Ansible tasks"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo "Please, rollback the machine to 'MarkingStart' snapshot."


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M2 - Ansible: 1-basic.yml"
echo -e "######################################################################################"$NC
echo ""

	echo -e $YELLOW"Verify these parameters:"$NC
	hostname	
	timedatectl | grep -i "zone"
	ntpq -p
	echo -e $YELLOW"hostname should not be BR-CL, timezone should not be Europe/Copenhagen and NTP should not be configured"$NC
	echo -e $YELLOW"Go to BR-SRV machine and execute 1-basic.yml ansible playbook."$NC
	pause 'Press [ENTER] key to continue...'

	if [  $( hostname  | grep -ic "BR-CL") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: BR-CL"$NC
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


	echo -e $YELLOW"Look at the NTP configuration:"$NC
	ntpq -p
#### Review this
	echo -e $GREEN"IF the peer is local AND stratum 2 AND clock set, ITEM iS OK"$NC
	echo -e $RED"BUT IF NOT, ITEM IS FAILED"$NC
	echo "-----------------------------------------------------------------"

echo ""
echo -e $YELLOW"If every item before is GREEN, point for this aspect."$NC


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M3 - Ansible: 4-ldap.yml"
echo -e "######################################################################################"$NC
echo ""

	echo -e $YELLOW"Verify this:"$NC
	getent passwd | grep -c "ella:" 
	echo -e $YELLOW"The output should be empty. LDAP user ella should not appear."$NC
	echo -e $YELLOW"Go to BR-SRV machine and execute 4-ldap.yml ansible playbook."$NC
	pause 'Press [ENTER] key to continue...'

	if [  $( getent passwd | grep -c "ella:" ) = 1 ]  && [  $( cat /etc/passwd | grep -c "ella:" ) = 0 ]
	then  
		 echo -e $GREEN"Ansible: 4-ldap.yml OK - IF YOU CAN LOGIN WITH ella"$NC
	else
		 echo -e $RED"Ansible: 4-ldap.yml FAILED"$NC
			echo "-----------------------------------------------------------------"
			getent passwd
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"You can see ella here. AND (press ENTER)"$NC
            echo "-----------------------------------------------------------------"
			cat /etc/passwd
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"You CAN'T see ella here."$NC
	fi
	
	

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M4 - Ansible: 5-share.yml"
echo -e "######################################################################################"$NC
echo ""

	echo -e $YELLOW"Verify this:"$NC
	ls -la /home/ella 
	echo -e $YELLOW"The output should not show /home/ella/share directory"$NC
	echo -e $YELLOW"Go to BR-SRV machine and execute 5-share.yml ansible playbook."$NC
	pause 'Press [ENTER] key to continue...'

	echo ""
	ls -la /home/ella 
	echo -e $GREEN"Ansible: 5-share.yml OK - If the output shows /home/ella/share directory"$NC
	echo -e $RED"Ansible: 5-share.yml FAILED - If the output does NOT show /home/ella/share directory"$NC

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""






echo -e $PURPLE"######################################################################################"
echo "M5 - Ansible: 6-webserver.yml"
echo -e "######################################################################################"$NC
echo ""

	echo -e $YELLOW"Verify this:"$NC
	curl -I http://localhost
	echo -e $YELLOW"The output should be: 'curl: (7) Failed to connect to localhost port 80: Connection refused'"$NC
	echo -e $YELLOW"Go to BR-SRV machine and execute 6-webserver.yml ansible playbook."$NC
	pause 'Press [ENTER] key to continue...'

	if [  $( curl http://localhost | grep -c "Website of BR-CL" ) = 1 ]
	then  
		 echo -e $GREEN"Ansible: 6-webserver.yml OK"$NC
	else
		 echo -e $RED"Ansible: 6-webserver.yml FAILED"$NC
			echo "-----------------------------------------------------------------"
			curl http://localhost
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"Correct output:"
			echo -e "Should show 'Website of BR-CL'"$NC 
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
