#!/bin/bash
#
#	A7-HOME
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
echo "Marking A1 General configuration (if HQ-DMZ-1 is random machine)"
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

	if [  $( hostname  | grep -ic "HQ-DMZ-1") = 1 ]
	#if [  $( hostname -f | grep -ic "HQ-DMZ-1") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
			#hostname -f
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: HQ-DMZ-1"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "10.1.20.11/24") = 1 ] 
	#if [  $( hostname -I | grep -ic "10.1.20.11") = 1 ]
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
			#hostname -I
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.1.20.11/24"$NC
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
echo "Marking A7-HQ-DMZ-1"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo ""
echo -e $PURPLE"######################################################################################"
echo "M1 - CRL"
echo -e "######################################################################################"$NC

	if [ $(curl -s http://crl.lego.dk | openssl crl -noout -text | grep "Issuer:.*C=DK.*O=Lego APS.*CN=Lego APS") = 1 ] || [ $(curl -s http://crl.lego.dk | openssl crl -inform DER -noout -text | grep "Issuer:.*C=DK.*O=Lego APS.*CN=Lego APS") = 1 ]
	# Maybe use these:
	# http://crl.lego.dk/root_crl.pem
	# http://crl.lego.dk/sub_crl.pem
	then  
		 echo -e $GREEN"OK - CRL"$NC
	else
		 echo -e $RED"FAILED - CRL"$NC
			echo "-----------------------------------------------------------------"
			curl -s http://crl.lego.dk | openssl crl -noout -text | grep "Issuer:.*C=DK.*O=Lego APS.*CN=Lego APS"
			curl -s http://crl.lego.dk | openssl crl -inform DER -noout -text | grep "Issuer:.*C=DK.*O=Lego APS.*CN=Lego APS"
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"Correct output: One of the two commands should show Subject: C = DK, O = Lego APS, CN = Lego APS..."$NC
	fi
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



#######
# DNS checkings prepared using dig. Can use nslookup instead
#######



echo -e $PURPLE"######################################################################################"
echo "M2 - DNS: billund.lego.dk forward zone"
echo -e "######################################################################################"$NC
echo ""

	counter=0
    if [  $( dig www.billund.lego.dk @10.1.20.11 | grep -c "www.billund.lego.dk.*10.1.20.11" ) = 1 ]
    # minimum: r-hq, hq-dc, hq-sam-1, hq-sam-2, hq-dmz-1, hq-dmz-2, www, mail, monitor.
	# If this is the minimum, should be defined in the TP
	
	then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig www.billund.lego.dk @10.1.20.11 | grep -c "www.billund.lego.dk"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "www.billund.lego.dk XXXX IN A 10.1.20.11"$NC
    fi
	if [  $( dig mail.billund.lego.dk @10.1.20.11 | grep -c "mail.billund.lego.dk.*10.1.20.12" ) = 1 ]
    then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig mail.billund.lego.dk @10.1.20.11 | grep -c "mail.billund.lego.dk"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "mail.billund.lego.dk XXXX IN A 10.1.20.12"$NC
    fi

	if [  $counter = 2 ]
	then  
		 echo -e $GREEN"OK - DNS: billund.lego.dk forward zone"$NC
	elif [  $counter = 1 ]
	then 
		 echo -e $YELLOW"PARTIAL - DNS: billund.lego.dk forward zone - Only one record correct"$NC
	else
		 echo -e $RED"FAILED - DNS: billund.lego.dk forward zone"$NC
				echo -e $YELLOW"Correct output:"
				echo -e "Some records not exists."$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M3 - DNS: billund.lego.dk reverse zone"
echo -e "######################################################################################"$NC
echo ""

	counter=0
    if [  $( dig 10.1.20.11 @10.1.20.11 | grep -c "10.1.20.11.*www.billund.lego.dk" ) = 1 ]
    
	# minimum:  10.1.10.1, 10.1.10.11, 10.1.10.21, 10.1.10.22, 10.1.20.1, 10.1.20.11, 10.1.20.12, 10.1.30.1
	# If this is the minimum, should be defined in the TP

	then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig dig 10.1.20.11 @10.1.20.11 | grep -c "10.1.20.11"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "10.1.20.11 XXXX IN PTR www.billund.lego.dk"$NC
    fi
	if [  $( dig 10.1.20.12 @10.1.20.11 | grep -c "10.1.20.12.*mail.billund.lego.dk" ) = 1 ]
    then
        counter=$((counter+1))
    else
        echo -e $RED"FAILED"$NC
		echo "-----------------------------------------------------------------"
		dig dig 10.1.20.12 @10.1.20.11 | grep -c "10.1.20.12"
		echo "-----------------------------------------------------------------"
		echo -e $YELLOW"Correct output:"
		echo -e "10.1.20.12 XXXX IN PTR mail.billund.lego.dk"$NC
    fi

	if [  $counter = 2 ]
	then  
		 echo -e $GREEN"OK - DNS: billund.lego.dk reverse zone"$NC
	elif [  $counter = 1 ]
	then 
		 echo -e $YELLOW"PARTIAL - DNS: billund.lego.dk reverse zone - Only one record correct"$NC
	else
		 echo -e $RED"FAILED - DNS: billund.lego.dk reverse zone"$NC
				echo -e $YELLOW"Correct output:"
				echo -e "Some records not exists."$NC
	fi
	
	
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""





echo -e $PURPLE"######################################################################################"
echo "M4 - DNS: Secondary herning.lego.dk zones"
echo -e "######################################################################################"$NC
echo ""

    if [  $( dig www.herning.lego.dk @10.1.20.11 | grep -c "www.herning.lego.dk.*10.2.10.11" ) = 1 ] && [  $( dig 10.2.10.11 @10.1.20.11 | grep -c "10.2.10.11.*www.herning.lego.dk" ) = 1 ] && [ $( grep -r 'zone.*herning.lego.dk' /etc/bind/ | grep -c "slave" ) = 1 ] && [ $( grep -r 'zone.*10.2.10.in-addr.arpa' /etc/bind/ | grep -c "slave" ) = 1 ]
    
	# ALternative: you can see slave zones and database files - HOW?


	then
    	 echo -e $GREEN"OK - DNS: Secondary herning.lego.dk zones"$NC
	else
		echo -e $RED"FAILED - DNS: Secondary herning.lego.dk zones"$NC
		dig www.herning.lego.dk @10.1.20.11 | grep -c "www.herning.lego.dk.*10.2.10.11"
		grep -r 'zone.*herning.lego.dk' /etc/bind/ | grep -c "slave"
		dig 10.2.10.11 @10.1.20.11 | grep -c "10.2.10.11.*www.herning.lego.dk"
		grep -r 'zone.*10.2.10.in-addr.arpa' /etc/bind/ | grep -c "slave"		
				echo -e $YELLOW"Correct output:"$NC
				echo -e $YELLOW"www.herning.lego.dk IN A 10.2.10.11 && zone herning.lego.dk slave"$NC
				echo -e $YELLOW"10.2.10.11 IN PTR www.herning.lego.dk && zone 10.2.10.in-addr.arpa slave"$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M5 - HA web server: web server"
echo -e "######################################################################################"$NC
echo ""

    if [  $( curl -I http://localhost | grep -c "301 Moved Permanently" ) = 1 ] && [  $( curl -I https://localhost | grep -c "200" ) = 1 ] && [  $( sleep 5 | openssl s_client -connect localhost:443 -showcerts 2> /dev/null | grep -c "issuer=C = DK.*O = Lego APS.*CN = Lego APS Intermediate CA.*") = 1 ]
    then
    	 echo -e $GREEN"OK - HA web server: web server"$NC
	else
		echo -e $RED"FAILED - HA web server: web server"$NC
			curl -I http://localhost | grep -c "301 Moved Permanently"
			curl -I https://localhost
			openssl s_client -connect localhost:443 -showcerts 2> /dev/null | grep -c "issuer=C = DK.*O = Lego APS.*CN = Lego APS Intermediate CA"
			echo -e $YELLOW"Correct output:"
			echo -e "301 Moved permanently and 200 OK and certificate issuer C = DK, O = Lego APS, CN = Lego APS Intermediate CA"$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M6 - HA web server: HA"
echo -e "######################################################################################"$NC
echo ""

    
	# Alternative: Web server works in HA with Haproxy, check /etc/haproxy/haproxy.cfg and status of the service 
	# Haproxy configured and running

	echo -e $YELLOW"Look at the following output. Should say 'Served by HQ-DMZ-X':"$NC
	curl -I https://localhost | grep "HQ-DMZ"
	echo -e $YELLOW"Please, stop webserver on HQ-DMZ-1 machine."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Look at the following output. Should say 'Served by HQ-DMZ-2':"$NC
	curl -I https://localhost | grep "HQ-DMZ"
	echo -e $YELLOW"Please, stop webserver on HQ-DMZ-2 machine."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Look at the following output. It should be empty (both webservers are stopped):"$NC
	curl -I https://localhost | grep "HQ-DMZ"
	echo -e $YELLOW"Please, start webserver on HQ-DMZ-1 machine."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $YELLOW"Look at the following output. Should say 'Served by HQ-DMZ-1':"$NC
	curl -I https://localhost | grep "HQ-DMZ"
	echo -e $YELLOW"Please, start webserver on HQ-DMZ-2 machine."$NC
	pause 'Press [ENTER] key to continue...'
	echo -e $GREEN"OK - HA web server: HA - If the process has been succesful"$NC
	echo -e $RED"FAILED - HA web server: HA - If the process has FAILED in some point"$NC
	

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
