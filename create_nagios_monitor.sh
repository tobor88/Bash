#!/bin/bash

USAGE="

SYNTAX: $0 [-h] -H <hostname> [-i <string ipv4 address>] [-f <string template file path>]


DESCRIPTION:
   This script is used to duplicate a Nagios monitoring template in Nagios Core. 
   After running this script you can start monitoring your newly created device.


REQUIREMENTS:
   1.) Template file should NOT end with a .cfg extension to prevent extraneous monitor. New file is saved to same location as the template file
   2.) Use the cfg_dir value in /usr/local/nagios/etc/nagios.cfg to define a directory(s) where cfg files become monitoring files
   3.) Uses the following default values which this script replaces in the template files. These are the default values of these config files
      a.) LINUX: localhost.cfg hostname localhost gets replaced and IP 192.168.1.2 gets replaced
      b.) WINDOWS: windows.cfg hostname winserver gets replaced and IP 192.168.1.2 gets replaced and Alias My Windows Server gets replaced
      c.) PRINTERS: printer.cfg hostname hplj2605dn gets replaced and IP 192.168.1.2 gets replaced and Alias HP LaserJet 2605dn gets replaced


CONTACT INFORMATION
   Company: OsbornePro LLC.
   Website: https://osbornepro.com 
   Author: Robert H. Osborne
   Contact: rosborne@osbornepro.com


USAGE: $0 -H <hostname> [-i <ipv4 address>] [-f <template file path>]

    OPTIONS:
  	-h : Displays the help information for the command.
	-H : Define the hostname to monitor
	-i : Set the IPv4 address of the server to monitor
	-t : Define the location of the template file

    EXAMPLES:
        $0 -H dc01.domain.com
        # This example create a Nagios Core monitoring file for dc01.domain.com in /usr/local/nagios/etc/objects/windows_servers/dc01.domain.com.cfg

        $0 -H dhcp.domain.com -i 10.20.11.67
        # This example create a Nagios Core monitoring file for dhcp.domain.com in /usr/local/nagios/etc/objects/windows_servers/dhcp.domain.com.cfg
	 
        $0 -H files.domain.com -i 10.20.44.5 -t /usr/local/nagios/etc/objects/windows_servers/windows_template.cfg.orig
	  # This example create a Nagios Core monitoring file for files.domain.com in /usr/local/nagios/etc/objects/windows_servers/files.domain.com.cfg
	    
"

IPV4=$(dig +short $DNSNAME A | head -n 1)


function allow_ctrlc {

	# Allow Ctrl+C to stop execution
	trap '
	  trap - INT # restore default INT handler
	  kill -s INT "$$"
	' INT

}  # End function allow_ctrlc


function print_usage {

	printf "$USAGE\n" >&2
	exit 1

}  # End function print_usage


function validate_ipv4 {
	printf "[*] Verifying $IPV4 value \n"
	IPV4REGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
	if [[ "$IPV4" =~ "$IPV4REGEX" ]] || IPERROR="Valid IP subnet was not defined. For more help execute '$0 -h' \n"; then
		if [ ! "$IPERROR" ]; then
			printf "[x] A valid network value was not defined, you entered $IPV4. Use -h for help info. \n"
			exit 1
		fi
	fi

}  # End function validate_ipv4


function get_hostname {

	if [ -z $DNSNAME ]; then
		printf "[?] Enter the Windows Server's hostname or FQDN you wish to monitor: "
		read DNSNAME
	fi

	if [ -z $DNSNAME ]; then
		exit 1
	fi

	LOWERCASE=$(printf $DNSNAME | tr '[:upper:]' '[:lower:]')
	FILENAME=$(printf $TEMPLATEFILE | tr "/" "\n" | tail -n 1)
	DESTINATION=$(printf $TEMPLATEFILE | sed "s|$FILENAME|$LOWERCASE.cfg|")

}


function verify_ipaddress {

	printf "[?] What is the IP Address? \n Press ENTER to keep the value $IPV4 : "
	read IPADDRESS
	
	if [ -z "$IPADDRESS" ]; then
		IPV4=$(printf $IPADDRESS)
	fi

	if [ -z $IPADDRESS ]; then
		exit 1
	fi

}


function verify_changes {

	printf "[*] The below values are going to be set for this server \n"
	printf "[i]   Hostname: $DNSNAME \n"
	printf "[i]   IP Address: $IPV4 \n"
	printf "[i]   Alias: $LOWERCASE \n"
	printf "[i]   File Path: $DESTINATION \n"
	read -p "[*] Press [ENTER] key to continue "

}


function create_cfg {

	sed "s|localhost|$LOWERCASE|g; s|winserver|$LOWERCASE|g; s|hplj2605dn|$LOWERCASE|g; s|HP LaserJet 2605dn|$DNSNAME|g; s|My Windows Server|$DNSNAME|g; s|192.168.1.2|$IPV4|g"  "$TEMPLATEFILE" > "$DESTINATION"
	printf "[*] You will need to restart the nagios service to apply your changes. \n[i]\tsystemctl restart nagios.service\n"

}



while [ ! -z "$1" ]; do
	case "$1" in
		-H)
		  shift
			DNSNAME=$1
			;;
		-i)
			shift
			IPV4=$1
			;;
		-t)
			shift
			TEMPLATEFILE=$1
			;;
		*)
			print_usage
			;;
	esac
shift
done



allow_ctrlc
get_hostname 
get_ipaddress
verify_changes
create_cfg
