#!/bin/bash

# This command is used to enumerate the dns servers once connected to a local DNS server
# Ensure /etc/resolv.conf has a local dns server set for the domain you are enumerating in

# Allow Ctrl+C to kill pingsweep

trap '
  trap - INT # restore default INT handler
  /usr/bin/kill -s INT "$$"
' INT

if [ -z "$1" ]; then
        /usr/bin/echo "Use -h switch to view help information"
        /usr/bin/echo "Use --help switch to view help information"

else
        if [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
                /usr/bin/echo ""
                /usr/bin/echo "OsbornePro enum_dns_servers 1.0 ( https://roberthosborne.com )"
                /usr/bin/echo ""
                /usr/bin/echo "USAGE: enum_dns_servers <string domain name>"
                /usr/bin/echo ""
                /usr/bin/echo "OPTIONS:"
                /usr/bin/echo "  -h : Displays the help information for the command."
                /usr/bin/echo " --help: Displays the help information for the command."
                /usr/bin/echo ""
                /usr/bin/echo "EXAMPLES:"
                /usr/bin/echo "  enum_dns_servers osbornepro.com"
		/usr/bin/echo "  This example returns the dns servers of a domain. Ensure your /etc/resolv.conf server is using the domains local servers."
                /usr/bin/echo ""
                exit

	# Variable validation------------------------------------------------
	elif [ -n "$1" ]; then
		# Begin DNS Server Enumeration
		echo "---------------"
		echo "| DNS Servers |"
		echo "---------------"
		/usr/bin/host -t ns $1 | cut -d " " -f4
	fi
fi
