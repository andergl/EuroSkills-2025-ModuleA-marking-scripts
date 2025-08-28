#!/bin/bash
#
#	A2-HOME
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
echo "Marking A1 General configuration (if HOME is random machine)"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""

################## Random section ##################
echo ""
echo ""
echo -e $PURPLE"######################################################################################"
echo "IF this is a random machine!!!"
echo "Hostname, network config and timezone"
echo -e "######################################################################################"$NC
echo ""

	if [  $( hostname  | grep -ic "HOME") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: HOME"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "203.0.114.50/25") = 1 ] 
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 203.0.114.50/25"$NC
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


################## Per aspect section ##################
echo ""
echo ""
echo -e $BLUE"######################################################################################"
echo "Marking A2-HOME"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M1 - Remote access VPN: working"
echo -e "######################################################################################"$NC
echo ""
echo -e $YELLOW"Testing... Please wait."$NC

	if [  $( ping 10.1.10.11 -c 4 |grep -c "100% packet loss") = 0 ] && [  $( ping 10.1.20.11 -c 4 |grep -c "100% packet loss") = 0 ]
	then  
		 echo -e $GREEN"OK - Remote access VPN: working"$NC
	else
		 echo -e $RED"FAILED - Remote access VPN: working"$NC
			echo "-----------------------------------------------------------------"
			ping 10.1.10.11 -c 4
			echo "-----------------------------------------------------------------"
			echo "-----------------------------------------------------------------"
			ping 10.1.20.11 -c 4
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"Correct output: Not 100% packet loss."$NC
	fi
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M2 - LDAP client"
echo -e "######################################################################################"$NC
echo ""

	if [  $( getent passwd | grep -c "frida:" ) = 1 ]  && [  $( cat /etc/passwd | grep -c "frida:" ) = 0 ]
	then  
		 echo -e $GREEN"OK - IF YOU CAN LOGIN WITH frida, LDAP client"$NC
	else
		 echo -e $RED"FAILED - LDAP client"$NC
			echo "-----------------------------------------------------------------"
			getent passwd
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"You can see frida here. AND (press ENTER)"$NC
            echo "-----------------------------------------------------------------"
            pause 'Press [ENTER] key to continue...'
			cat /etc/passwd
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"You CAN'T see frida here."$NC
	fi
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M3 - LDAP client when VPN is down"
echo -e "######################################################################################"$NC
echo ""

	echo -e $YELLOW"Disable the Remote Access VPN"$NC
	echo -e $YELLOW"Try to log in with localadmin user"$NC
	echo "-----------------------------------------------------------------"
	echo -e $GREEN"OK - IF YOU CAN LOGIN WITH localadmin, LDAP client when VPN is down"$NC
	echo -e $RED"FAILED - IF YOU CANNOT LOGIN WITH localadmin, LDAP client when VPN is down"$NC
	echo "-----------------------------------------------------------------"
	echo -e $YELLOW"Enable again the Remote Access VPN"$NC
	echo "-----------------------------------------------------------------"

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M4 - Email client"
echo -e "######################################################################################"$NC
echo ""

	echo -e $YELLOW"Open Thunderbird - frida account should be configured"$NC
	echo -e $YELLOW"Try sending an email to ella"$NC
	echo "-----------------------------------------------------------------"
	echo -e $GREEN"OK - IF frida ACCOUNT IS CONFIGURED AND YOU CAN SEND AN EMAIL TO ELLA, Email Client"$NC
	echo -e $RED"FAILED - IF frida ACCOUNT IS NOT CONFIGURED OR YOU CANNOT SEND AN EMAIL TO ELLA, Email Client"$NC
	echo "-----------------------------------------------------------------"
		
	
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""

echo -e $PURPLE"######################################################################################"
echo "M5 - SFTP client"
echo -e "######################################################################################"$NC
echo ""

	echo -e $YELLOW"Open Filezilla client - connection with carl account should be preconfigured"$NC
	echo -e $YELLOW"Access to SFTP server on BR-SRV"$NC
	echo "-----------------------------------------------------------------"
	echo -e $GREEN"OK - IF carl ACCOUNT IS PRECONFIGURED AND YOU CAN ACCESS TO SFTP SERVER ON BR-SRV, SFTP Client"$NC
	echo -e $RED"FAILED - IF carl ACCOUNT IS NOT CONFIGURED OR YOU CANNOT ACCESS TO SFTP SERVER ON BR-SRV, SFTP Client"$NC
	echo "-----------------------------------------------------------------"
		
	
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



#echo -e $PURPLE"######################################################################################"
#echo "M6 - DNS: lego.dk public"
#echo -e "######################################################################################"$NC
#echo ""

#	counter=0
#    if [  $( nslookup crl.lego.dk 203.0.113.2 | grep -c "203.0.113.2" ) = 2 ]
#    then
#        counter=$((counter+1))
#    else
#        echo -e $RED"FAILED"$NC
#		echo "-----------------------------------------------------------------"
#		nslookup crl.lego.dk 203.0.113.2
#		echo "-----------------------------------------------------------------"
#		echo -e $YELLOW"Correct output:"
#		echo -e "address: 203.0.113.2"$NC
#    fi
	
#	if [  $counter = 1 ]
#	then  
#		 echo -e $GREEN"OK - DNS: lego.dk public"$NC
#	else
#		 echo -e $RED"FAILED - DNS: lego.dk public"$NC
#				echo -e $YELLOW"Correct output:"
#				echo -e "Some records not exists."$NC
#	fi


#echo ""
#pause 'Press [ENTER] key to continue...'
#clear
#echo ""





echo -e $PURPLE"######################################################################################"
echo "M6 - DNS: billund.lego.dk public"
echo -e "######################################################################################"$NC
echo ""

	counter=0
    if [  $( dig www.billund.lego.dk @203.0.113.2 | grep -c "www.billund.lego.dk.*203.0.113.2") = 1 ]
    then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig www.billund.lego.dk @203.0.113.2 | grep "www.billund.lego.dk"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "www.billund.lego.dk XXXX IN A 203.0.113.2"$NC
    fi
	if [  $( dig mail.billund.lego.dk @203.0.113.2 | grep -c "mail.billund.lego.dk.*203.0.113.2") = 1 ]
    then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig mail.billund.lego.dk @203.0.113.2 | grep "mail.billund.lego.dk"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "mail.billund.lego.dk XXXX IN A 203.0.113.2"$NC
    fi
	
	if [  $counter = 2 ]
	then  
		 echo -e $GREEN"OK - DNS: billund.lego.dk public"$NC
	else
		 echo -e $RED"FAILED - DNS: billund.lego.dk public"$NC
				echo -e $YELLOW"Correct output:"
				echo -e "Some records not exists."$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M7 - DNS: herning.lego.dk public"
echo -e "######################################################################################"$NC
echo ""

	counter=0
    if [  $( dig www.herning.lego.dk @203.0.113.10 | grep -c "www.herning.lego.dk.*203.0.113.10" ) = 1 ]
    then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig www.herning.lego.dk @203.0.113.10 | grep "www.herning.lego.dk"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "www.herning.lego.dk XXXX IN A 203.0.113.10"$NC
    fi
	
	if [  $counter = 1 ]
	then  
		 echo -e $GREEN"OK - DNS: herning.lego.dk public"$NC
	else
		 echo -e $RED"FAILED - DNS: herning.lego.dk public"$NC
				echo -e $YELLOW"Correct output:"
				echo -e "Some records not exists."$NC
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
