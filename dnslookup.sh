#!/bin/bash

# This command is meant to easily perform a dns lookup for all hosts in a subnet range

# Allow Ctrl+C to kill pingsweep

trap '
  trap - INT # restore default INT handler
  /usr/bin/kill -s INT "$$"
' INT

if [ -z "$1" ]; then
        /usr/bin/echo "Use -h switch to view help information"
        /usr/bin/echo ""

else
        if [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
                /usr/bin/echo ""
                /usr/bin/echo "OsbornePro dnslookup 1.0 ( https://roberthosborne.com )"
                /usr/bin/echo ""
                /usr/bin/echo "USAGE: dnslookup [network <string format is #.#.#>] [int <start address>] [int <end address>]
                /usr/bin/echo ""
                /usr/bin/echo "OPTIONS:"
                /usr/bin/echo "  -h : Displays the help information for the command."
                /usr/bin/echo " --help: Displays the help information for the command."
                /usr/bin/echo ""
                /usr/bin/echo "EXAMPLES:"
                /usr/bin/echo "  dnslookup 192.168.0"
		/usr/bin/echo "  This example performs a dns host lookup from 192.168.0.1 to 192.168.0.254"
                /usr/bin/echo ""
                /usr/bin/echo "  dnslookup 192.168.0 200"
                /usr/bin/echo "  This example performs a dns host lookup from 192.168.0.200 to 192.168.0.254"
                /usr/bin/echo ""
                /usr/bin/echo "  dnslookup 192.168.0 128 192"
                /usr/bin/echo "  This example performs a dns host lookup from 192.168.0.128 to 192.168.0.192"
                /usr/bin/echo ""
                exit

	# Variable validation------------------------------------------------
	elif [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || ERROR="Valid IP subnet was not defined. For more help execute 'dnslookup -h' Example Value: 172.16.32 "; then
		# Validate first parameter was defined correctly
		if [ ! $ERROR ]; then
			# Validate correct amount of positional parameters are defined
			if [ -n "$4" ]; then
				/usr/bin/echo "Too many positional parameters have been defined. Execute 'pingsweep -h' for more options"
				/usr/bin/echo ""
				exit
			fi
		else
			/usr/bin/echo $ERROR
			/usr/bin/echo ""
			exit
		fi

		# Validate positional parameter 2 is an integer between 1 and 254
		if [ -z "$2" ]; then
			START=1
		elif [ "$2" -lt 255 ] && [ "$2" -ge 1 ] || ERROR="Second parameter needs to be an integer between 1 and 254"; then
			if [ ! $ERROR ]; then
				START=$2
			else
				/usr/bin/echo $ERROR
				/usr/bin/echo ""
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
				/usr/bin/echo $ERROR
				/usr/bin/echo ""
				exit
			fi
		fi

		# Begin DNS Lookups
		echo "--------------------------------------------"
		echo "| IP Address              |     FQDN's     |"
		echo "--------------------------------------------"
		
		for i in $(/usr/bin/seq $START $END); do /usr/bin/host $1.$i; done | /usr/bin/grep -v "not found" | /usr/bin/awk {'print $1, $5'} | /usr/bin/sed 's/".in-addr.arpa "/" | "/'
	fi
fi
