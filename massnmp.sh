#!/bin/bash

# This script is meant to enumerate snmpv1 and snmpv2c in a subnet range you define
#
# I wrote this script on Linux kali 5.4.0-kali4-amd64 #1 SMP Debian 5.4.19-1kali1 (2020-02-17) x86_64 GNU/Linux while studying for the OSCP. 
#
# As such it uses snmp-check and onesixtyone. Installs these tools if you do not have them installed.
#     sudo apt-get -y install onesixtyone
#     sudo apt-get -y install snmp-check 
#
# If you are a poser who uses Parrot ;) then just remove the absoulte paths to commands.
#     sed -i 's|/usr/bin|""|g' masscan.sh


# Allow Ctrl+C to kill massnmp
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

if [ -z "$1" ]; then
	/usr/bin/printf "Use -h switch to view help information\n\n"
else
	if [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
		# This option displays a help message and command execution examples
		/usr/bin/printf "\n"
		/usr/bin/printf "OsbornePro massnmp 1.0 ( https://roberthosborne.com )\n"
		/usr/bin/printf "\n"
		/usr/bin/printf "USAGE: massnmp [network <string format is #.#.#>] [int <start address>] [int <end address>]\n"
		/usr/bin/printf "\n"
		/usr/bin/printf "OPTIONS:\n"
		/usr/bin/printf "  -h : Displays the help information for the command.\n"
		/usr/bin/printf "\n"
		/usr/bin/printf "EXAMPLES:\n"
		/usr/bin/printf "  massnmp 192.168.0\n"
		/usr/bin/printf "  # This example performs an SNMP sweep from 192.168.0.1 to 192.168.0.254\n"
		/usr/bin/printf "\n"
		/usr/bin/printf "  massnmp 192.168.0 200\n"
		/usr/bin/printf "  # This example performs an SNMP sweep from 192.168.0.200 to 192.168.0.254\n"
		/usr/bin/printf "\n"
		/usr/bin/printf "  massnmp 192.168.0 128 192\n"
		/usr/bin/printf "  # This example performs an SNMP sweep from 192.168.0.128 to 192.168.0.192\n"
		/usr/bin/printf "\n"
		exit

# Variable validation------------------------------------------------
	elif [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || ERROR="Valid IP subnet was not defined. For more help execute 'massnmp -h' Example 172.16.32 "; then
		
		# Validate first parameter was defined correctly
		if [ ! $ERROR ]; then
			# Validate correct amount of positional parameters are defined
			if [ -n "$4" ]; then
				/usr/bin/printf "Too many positional parameters have been defined. Execute 'massnmp -h' for more options\n\n"
				exit
			fi
		else
			/usr/bin/printf "$ERROR\n"
			exit
		fi

		# Validate positional parameter 2 is an integer between 1 and 254
		if [ -z "$2" ]; then
			START=1
		elif [ "$2" -lt 255 ] && [ "$2" -ge 1 ] || ERROR="Second parameter needs to be an integer between 1 and 254"; then
			if [ ! $ERROR ]; then
				START=$2
			else
				/usr/bin/printf "$ERROR\n\n"
				exit
			fi
		fi
			
		# Validate positional parameter 3 is an integer between $2 and 254
		if [ -z "$3" ]; then
			END=254
		elif [ "$3" -lt 255 ] && [ "$3" -gt "$2" ] || ERROR="Third parameter needs to be an integer between the value of positional parameter two and 254"; then
			if [ ! $ERROR ]; then
				END=$3
			else
				/usr/bin/printf "$ERROR\n\n"
				exit
			fi
		fi

		# Create community list
		if [ ! -f /tmp/community.list ]; then
			/usr/bin/printf "[i] I would suggest using FuzzDB's wordlist-common-snmp-community-strings.txt for the best results.\n"
			/usr/bin/printf "[i] To do this copy that wordlist to the current directory and rename it too community.list\n\n"
			/usr/bin/echo $'private\npublic\nmanager' >> /tmp/community.list
		else
			/usr/bin/printf "[*] Wordlist $PWD/community.list has been found to already exist\n"
		fi

		# Create file containing desired ipv4 address range if it doesnt exist
		/usr/bin/printf "[*] Creating ip.list file using the range you defined\n"
		for ip in $(seq $START $END); do 
		    /usr/bin/echo $1.$ip
		done  > /tmp/ip.list

		# Discovering SNMP enabled hosts
		/usr/bin/printf "[*] Discovering SNMP enabled hosts\n"
		/usr/bin/onesixtyone -c /tmp/community.list -i /tmp/ip.list -o /tmp/snmp_hosts.txt
		
		/usr/bin/printf "--------------------\n"
		/usr/bin/printf " SNMP Enabled Hosts \n"
		/usr/bin/printf "--------------------\n"
		
		/usr/bin/cat /tmp/snmp_hosts.txt | /usr/bin/awk {'print $1'}

		for i in $(/usr/bin/cat /tmp/snmp_hosts.txt | /usr/bin/awk {'print $1'}); do 
			IP=($(/usr/bin/cat /tmp/snmp_hosts.txt | /usr/bin/awk {'print $1'}))
			COMMUNITY=($(/usr/bin/cat /tmp/snmp_hosts.txt | /usr/bin/awk {'print $2'} | /usr/bin/tr -d '[]'))

			/usr/bin/snmp-check -c $COMMUNITY -p 161 -v1 $IP > "$IP.txt" 2>&1 || /usr/bin/snmp-check -c $COMMUNITY -p 161 -v2c $IP > "$IP.txt" 2>&1
		done
		/usr/bin/printf "[*] Text files created for each ip address contain enumerated SNMPv1 or 2c information.\n"
	fi
fi
