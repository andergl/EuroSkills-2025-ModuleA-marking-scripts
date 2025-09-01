#!/bin/bash
#
#	A11-BR-SRV
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
echo "Marking A1 General configuration (if BR-SRV is random machine)"
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

	if [  $( hostname  | grep -ic "BR-SRV") = 1 ]
	#if [  $( hostname -f | grep -ic "BR-SRV") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
			#hostname -f
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: BR-SRV"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "10.2.10.11/24") = 1 ] 
	#if [  $( hostname -I | grep -ic "10.2.10.11") = 1 ]
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
			#hostname -I
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.2.10.11/24"$NC
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
echo "Marking A11-BR-SRV"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



#######
# DNS checkings prepared using dig. Can use nslookup instead
#######


echo -e $PURPLE"######################################################################################"
echo "M1 - DNS: herning.lego.dk forward zone"
echo -e "######################################################################################"$NC
echo ""

	counter=0
    if [  $( dig www.herning.lego.dk @10.2.10.11 | grep -c "www.herning.lego.dk.*10.2.10.11" ) = 1 ]
    
	# br-srv, r-br, www
	# # If this is the minimum, should be defined in the TP
	
	then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig www.herning.lego.dk @10.2.10.11 | grep -c "www.herning.lego.dk"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "www.herning.lego.dk XXXX IN A 10.2.10.11"$NC
    fi
	
	if [  $counter = 1 ]
	then  
		 echo -e $GREEN"OK - DNS: herning.lego.dk forward zone"$NC
	else
		 echo -e $RED"FAILED - DNS: herning.lego.dk forward zone"$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M2 - DNS: herning.lego.dk reverse zone"
echo -e "######################################################################################"$NC
echo ""

	counter=0
    if [  $( dig 10.2.10.11 @10.2.10.11 | grep -c "10.2.10.11.*www.herning.lego.dk" ) = 1 ]
    
	# 10.2.10.1, 10.2.10.11, 10.2.30.1
	# If this is the minimum, should be defined in the TP
	
	then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig dig 10.2.10.11 @10.2.10.11 | grep -c "10.2.10.11"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "10.2.10.11 XXXX IN PTR www.herning.lego.dk"$NC
    fi
	

	if [  $counter = 1 ]
	then  
		 echo -e $GREEN"OK - DNS: herning.lego.dk reverse zone"$NC
	else
		 echo -e $RED"FAILED - DNS: herning.lego.dk reverse zone"$NC
	fi
	
	
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M3 - DNS: Secondary billund.lego.dk zones"
echo -e "######################################################################################"$NC
echo ""

    if [  $( dig www.billund.lego.dk @10.2.10.11 | grep -c "www.billund.lego.dk.*10.1.20.11" ) = 1 ] && [  $( dig 10.1.20.11 @10.2.10.11 | grep -c "10.1.20.11.*www.billund.lego.dk" ) = 1 ] && [ $( grep -r 'zone.*billund.lego.dk' /etc/bind/ | grep -c "slave" ) = 1 ] && [ $( grep -r 'zone.*10.1.10.in-addr.arpa' /etc/bind/ | grep -c "slave" ) = 1 ]
    then
    	 echo -e $GREEN"OK - DNS: Secondary billund.lego.dk zones"$NC
	else
		echo -e $RED"FAILED - DNS: Secondary billund.lego.dk zones"$NC
		dig www.billund.lego.dk @10.2.10.11 | grep -c "www.billund.lego.dk.*10.1.20.11"
		grep -r 'zone.*billund.lego.dk' /etc/bind/ | grep -c "slave"
		dig 10.2.10.11 @10.2.10.11 | grep -c "10.1.20.11.*www.billund.lego.dk"
		grep -r 'zone.*10.1.10.in-addr.arpa' /etc/bind/ | grep -c "slave"		
				echo -e $YELLOW"Correct output:"$NC
				echo -e $YELLOW"www.billund.lego.dk IN A 10.1.20.11 && zone billund.lego.dk slave"$NC
				echo -e $YELLOW"10.1.20.11 IN PTR www.billund.lego.dk && zone 10.1.10.in-addr.arpa slave"$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M4 - Web server"
echo -e "######################################################################################"$NC
echo ""

    if [  $( curl -k https://localhost | grep -c "Welcome to Herning" ) = 1 ] && [  $( sleep 5 | openssl s_client -connect localhost:443 -showcerts 2> /dev/null | grep -c "issuer=C = DK.*O = Lego APS.*CN = Lego APS Intermediate CA.*") = 1 ] && [ $( curl -k -I https://localhost | grep -E 'Server|X-Powered-By') = 0]
    then
    	 echo -e $GREEN"OK - Web server"$NC
	else
		echo -e $RED"FAILED - Web server"$NC
			curl -k https://localhost
			openssl s_client -connect localhost:443 -showcerts 2> /dev/null | grep -c "issuer=C = DK.*O = Lego APS.*CN = Lego APS Intermediate CA"
			curl -k -I https://localhost
			echo -e $YELLOW"Correct output:"
			echo -e "Should show 'Welcome to Herning' AND certificate issuer C = DK, O = Lego APS, CN = Lego APS Intermediate CA AND should NOT show 'Server' or 'X-Powered-By' "$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""





echo -e $PURPLE"######################################################################################"
echo "M5 - Syslog: DHCP"
echo -e "######################################################################################"$NC
echo ""

	# TLS checking missing

	echo -e $YELLOW"Verufy syslog is working, look at the following output:"$NC
	ss -tlnp | grep 6514
	echo -e $YELLOW"Expected output example:"$NC
	echo -e $YELLOW"LISTEN 0 100 *:6514 *:* users:(("rsyslogd",pid=1234,fd=10))"$NC
    pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Look at the following output:"$NC
	tail -n 6 /log/dhcp.log
	echo -e $YELLOW"Expected output, DHCP conversation. Examples: "$NC
	echo -e $YELLOW"Aug 28 12:05:21 BR-CL dhcpd[123]: DHCPREQUEST for 10.2.10.11 from ..."$NC
	echo -e $YELLOW"Aug 28 12:05:22 BR-CL dhclient[456]: DHCPDISCOVER on ens192 to 255.255.255.255 port 67 interval 3"$NC
	echo -e $GREEN"OK - Syslog: DHCP - If syslog is active and DHCP conversation appears"$NC
	echo -e $RED"FAILED - Syslog: DHCP - If syslog is NOT active or NO DHCP conversation appears"$NC


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""




echo -e $PURPLE"######################################################################################"
echo "M5 - Syslog: other"
echo -e "######################################################################################"$NC
echo ""


	# TLS checking missing
    
	echo -e $YELLOW"Verufy syslog is working, look at the following output:"$NC
	ss -tlnp | grep 6514
	echo -e $YELLOW"Expected output example:"$NC
	echo -e $YELLOW"LISTEN 0 100 *:6514 *:* users:(("rsyslogd",pid=1234,fd=10))"$NC
    echo -e $YELLOW"Performe some action. For example, try accessing via ssh (ssh localadmin@localhost)."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Look at the following output:"$NC
	tail -n 6 /log/dump.log
	echo -e $YELLOW"Expected output, the action that has been performed: "$NC
	echo -e $YELLOW"Aug 28 12:06:02 BR-SRV sshd[789]: Accepted password for localadmin from 127.0.0.1 port XXXXX"$NC
	echo -e $GREEN"OK - Syslog: other - If syslog is active and SSH connection appears on dump.log"$NC
	echo -e $RED"FAILED - Syslog: other - If syslog is NOT active or NO SSH connection appears on dump.log"$NC


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
