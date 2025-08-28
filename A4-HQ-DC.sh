#!/bin/bash
#
#	A4-HQ-DC
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
echo "Marking A1 General configuration (if HQ-DC is random machine)"
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

	if [  $( hostname  | grep -ic "HQ-DC") = 1 ]
	then  
		 echo -e $GREEN"OK - Check hostname"$NC
	else
		 echo -e $RED"FAILED - Check hostname"$NC
			echo "-----------------------------------------------------------------"
			hostname
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct hostname is: HQ-DC"$NC
	fi

	if [  $( ip a | grep "inet.*global" | grep -ic "10.1.10.11/24") = 1 ] 
	then  
		 echo -e $GREEN"OK - Check ip address"$NC
	else
		 echo -e $RED"FAILED - Check ip address"$NC
			echo "-----------------------------------------------------------------"
			ip a | grep "inet.*global"
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Must contain 10.1.10.11/24"$NC
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
echo "Marking A4-HQ-DC"
echo -e "######################################################################################"$NC
echo ""
echo ""

echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo ""
echo -e $PURPLE"######################################################################################"
echo "M1 - Root CA"
echo -e "######################################################################################"$NC

	if [ $(openssl x509 -in /ca/CA.crt -text -noout | grep -ic "Subject:.*C = DK.*O = Lego APS.*CN = Lego APS Root CA" ) = 1 ]
	then  
		 echo -e $GREEN"OK - Root CA"$NC
	else
		 echo -e $RED"FAILED - Root CA"$NC
			echo "-----------------------------------------------------------------"
			openssl x509 -in /ca/CA.crt -text -noout | grep -ic "Subject:"
			echo "-----------------------------------------------------------------"
			echo -e $YELLOW"Correct output: Should be Subject: C = DK, O = Lego APS, CN = Lego APS Root CA"$NC
	fi
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo ""
echo -e $PURPLE"######################################################################################"
echo "M2 - LDAP server: structure"
echo -e "######################################################################################"$NC

	echo -e $YELLOW"Checking LDAP implementation"$NC
	ldap=0
	if [  $( ldapsearch -x -b dc=lego,dc=dk -H ldapi:/// |grep -c "result: 0 Success" ) = 1 ]
	then  
		 ldap=1
		 echo -e $GREEN"OK - LDAP server implemented"$NC
	else
		 echo -e $RED"FAILED - LDAP server not implemented"$NC
			echo "-----------------------------------------------------------------"
			ldapsearch -x -b dc=lego,dc=dk -H ldapi:///
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct output:"
				echo -e "Query successful"$NC
	fi
	echo -e $YELLOW"Checking LDAP objects"$NC
	ldapobjects=0
	#LDAP OUs
	if [ $( ldapsearch -x -b "ou=Billund,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	if [ $( ldapsearch -x -b "ou=Herning,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	#LDAP Groups
	if [ $( ldapsearch -x -b "cn=admins,ou=Billund,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	if [ $( ldapsearch -x -b "cn=billund,ou=Billund,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	if [ $( ldapsearch -x -b "cn=herning,ou=Herning,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	#LDAP Users
	if [ $( ldapsearch -x -b "uid=admin,cn=admins,ou=Billund,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	if [ $( ldapsearch -x -b "uid=frida,cn=billund,ou=Billund,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	if [ $( ldapsearch -x -b "uid=ella,cn=billund,ou=Billund,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi
	if [ $( ldapsearch -x -b "uid=carl,cn=herning,ou=Herning,dc=lego,dc=dk" -H ldapi:/// |grep -c -e "result: 0 Success" ) = 1 ]
	then
		ldapobjects=$((ldapobjects+1))
	fi

	if [  $ldap = 1 && $ldapobjects = 9]
	then
 		 echo -e $GREEN"LDAP server implemented and there are $ldapobjects./9 correct LDAP objects"$NC
	elif  [  $ldap = 1 ] 
	then
		 echo -e $YELLOW"LDAP server implemented and there are $ldapobjects./9 correct LDAP objects"$NC
	else
		 echo -e $RED"FAILED - LDAP server not implemented"$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""




echo ""
echo -e $PURPLE"######################################################################################"
echo "M3 - LDAP server: security"
echo -e "######################################################################################"$NC

	if [ $(openssl s_client -connect localhost:636 | grep -c "return code: 0 (ok)") = 1 ]
	then  
		 echo -e $GREEN"OK - LDAP server: security"$NC
	else
		 echo -e $RED"FAILED - LDAP server: security"$NC
				echo -e $YELLOW"Correct output:"
				echo -e "Should be return code: 0 (ok)."$NC
	fi


echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""



echo -e $PURPLE"######################################################################################"
echo "M4 - ZFS array"
echo -e "######################################################################################"$NC
echo ""


	if [  $( zfs list | grep -c "/share") = 1 ] && [  $( zpool status | grep -c "sd.*ONLINE") = 4 ]
	then  
		 echo -e $GREEN"OK - ZFS array"$NC
	else
		 echo -e $RED"FAILED - ZFS array"$NC
			echo "-----------------------------------------------------------------"
			zfs list
			zpool status
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct output:'zfs list' should show one ZFS (tank) mounted on /share and 'zpool status' four HDDs (probably sdb, sdc, sdd and sde) on that ZFS (tank)"$NC
	fi
echo ""
pause 'Press [ENTER] key to continue...'
clear
echo ""


echo -e $PURPLE"######################################################################################"
echo "M5 - CIFS"
echo -e "######################################################################################"$NC
echo ""


	if [  $( smbclient //localhost/users -U ella%Passw0rd! -c 'ls' | grep -c "..") = 1 ] && [  $( smbclient //localhost/users -U frida%Passw0rd! -c 'cd ../ella; ls' | grep -c "ACCESS_DENIED") = 1 ]
	then  
		 echo -e $GREEN"OK - CIFS"$NC
	else
		 echo -e $RED"FAILED - CIFS"$NC
			echo "-----------------------------------------------------------------"
			smbclient //localhost/users -U ella%Passw0rd! -c 'ls' | grep -c ".."
			smbclient //localhost/users -U frida%Passw0rd! -c 'cd ../ella; ls' | grep -c "ACCESS_DENIED"
				echo "-----------------------------------------------------------------"
				echo -e $YELLOW"Correct output:First command should show ella's shared directory and second command should show ACCESS_DENIED to ella's directory to frida"$NC
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
