#!/bin/bash


USAGE="Syntax: $0 [-h] -d <string domain name> [-s <string dns server name>]

OsbornePro enum_dns_servers 2.0 ( https://roberthosborne.com )
NOTE: You may need to have the domains local DNS servers configured as your DNS servers for this to work. 
	You are also able to manually defined the DNS server to use for your lookup.

USAGE: enum_dns_servers -d <string domain name>

    OPTIONS:
        -h : Displays the help information for the command.
	-d : Set the domain name to enumerate the DNS servers of 
	-s : Set the DNS server to use to perform the lookups on

    EXAMPLES:
	   enum_dns_servers -d osbornepro.com 
	   This example returns the dns servers of a domain. Ensure your /etc/resolv.conf server is using the domains local servers.

"


function print_usage {

	printf "$USAGE\n" >&2
	exit 1

}  # End function print_usage


function allow_ctrlc {

	# Allow Ctrl+C to kill pingsweep
	trap '
	  trap - INT # restore default INT handler
	  kill -s INT "$$"
	' INT

}  # End function allow_ctrlc


function execute_enum_dns_servers {

	# Begin DNS Server Enumeration
	echo "-------------------------"
	echo "|      DNS Servers      |"
	echo "-------------------------"
	
	if test $# -gt 1; then
		host -4 -t ns "$domain" "$server" | cut -d " " -f4
	else
		host -4 -t ns "$domain" | cut -d " " -f4
	fi

}  # End function enum_dns_servers


while [ ! -z "$1" ]; do
	case "$1" in
		-d)
			shift
			domain=$1
			;;
		-s)
			shift
			server=$1
			;;
		*)
			print_usage
			;;
	esac
shift
done


allow_ctrlc
execute_enum_dns_servers
