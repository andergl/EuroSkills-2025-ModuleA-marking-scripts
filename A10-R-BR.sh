#!/bin/bash
#
#	A10-R-BR
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
echo "Marking A1 General configuration (if R-BR is random machine)"
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

	if [  $( hostname  | grep -ic "R-BR") = 1 ]
	#if [  $( hostname -f | grep -ic "R-BR") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
			#hostname -f
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: R-BR"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "203.0.113.10/29") = 1 ] && [  $( ip a | grep "inet.*global" | grep -ic "10.2.10.1/24") = 1 ] && [  $( ip a | grep "inet.*global" | grep -ic "10.2.30.1/24") = 1 ]
	#if [  $( hostname -I | grep -ic "203.0.113.10") = 1 ] && [  $( hostname -I | grep -ic "10.2.10.1") = 1 ] && [  $( hostname -I | grep -ic "10.2.30.1") = 1 ]
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
			#hostname -I
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 203.0.113.10/29 & 10.2.10.1/24 & 10.2.30.1/24"$NC
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
echo "IF this is a random router!!!"
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
echo "Marking A10-R-BR"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""




echo -e $PURPLE"######################################################################################"
echo "J1 - Firewall: public services"
echo -e "######################################################################################"$NC
echo ""

echo -e $CYAN"JUDGEMENT! JUDGEMENT! JUDGEMENT! JUDGEMENT! JUDGEMENT!"$NC
echo ""
echo -e $YELLOW"Judge whether all the necessary services are accessible from the Internet: "$NC
echo -e $YELLOW"3 - All port forwarded and exact defined"$NC
echo -e $YELLOW"2 - Some port forwarded and exact defined"$NC
echo -e $YELLOW"1 - 1:1 NAT"$NC
echo -e $YELLOW"0 - not implemented"$NC
echo ""
echo -e $YELLOW"Are your ready?"$NC
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""

echo -e $YELLOW"See the next output:"$NC
    nft list ruleset
echo -e $YELLOW"Have PAT and port-forwarding? Only needed service port forwarded to inside?"$NC
echo -e $YELLOW"web (tcp 80, 443), dns (udp 53, tcp 53)"$NC
echo ""
echo -e $CYAN"IT IS A TIME FOR JUDGEMENT!"$NC
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "J2 - Firewall: traffic"
echo -e "######################################################################################"$NC
echo ""

echo -e $CYAN"JUDGEMENT! JUDGEMENT! JUDGEMENT! JUDGEMENT! JUDGEMENT!"$NC
echo ""
echo -e $YELLOW"Judge if the implemented solution allow only the necessary traffic"$NC
echo -e $YELLOW"3 - drop policy on input AND forward chain and policies applied,"$NC
echo -e $YELLOW"2 -  drop policy on input or forward chain and policies applied,"$NC
echo -e $YELLOW"1 - drop policy on input or forward chain or some policies applied"$NC
echo -e $YELLOW"0 - not implemented"$NC
echo ""
echo -e $YELLOW"Are your ready?"$NC
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""

echo -e $YELLOW"See the next output:"$NC
    nft list ruleset
echo -e $YELLOW"Is INPUT and FORWARD policy DROP? Have some rules without everything allow from/to everywhere?"$NC
echo -e $YELLOW"Does it only allow the necessary traffic?"$NC
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""







echo -e $PURPLE"######################################################################################"
echo "M1 - Firewall: SNAT"
echo -e "######################################################################################"$NC
echo ""

echo -e $YELLOW"See the next output:"$NC
    nft list ruleset
echo -e $YELLOW"Traffic from 10.2.10.0/24 and 10.2.30.0/24 towards internet is masqueraded?"$NC
echo ""
echo -e $GREEN"IF YES, ITEM iS OK"$NC
echo -e $RED"BUT IF NOT, ITEM IS FAILED"$NC
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M2 - Site-to-site VPN: working"
echo -e "######################################################################################"$NC
echo ""
echo -e $YELLOW"Testing... Please wait."$NC

	if [  $( ping 10.1.10.11 -c 4 |grep -c "100% packet loss") = 0 ] && [  $( ip r | grep -c "10.1.10.0/24.*tun") = 1 ] && [  $( ping 10.1.20.11 -c 4 |grep -c "100% packet loss") = 0 ] && [  $( ip r | grep -c "10.1.20.0/24.*tun") = 1 ]
	then  
		 echo -e $GREEN"OK - Site-to-site VPN: working"$NC
	else
		 echo -e $RED"FAILED - Site-to-site VPN: working"$NC
			echo "-----------------------------------------------------------------"
			ping 10.1.10.11 -c 4
			ping 10.1.20.11 -c 4
			echo "-----------------------------------------------------------------"
			echo "-----------------------------------------------------------------"
			ip r | grep -c "10.1.10.0/24"
			ip r | grep -c "10.1.20.0/24"
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"Correct output: Not 100% packet loss and routes to 10.1.10.0/24 and 10.1.20.0/24 through iface tun."$NC
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
