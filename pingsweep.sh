#!/bin/bash

# IMPORTANT: For this script to work you will need fping installed. On Debian based Linux distros it can be installed using the command below
# sudo apt-get -y install fping

trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

if [ -z "$1" ]; then
	echo "Use -h switch to view help information"
	echo ""
else
	if [ "$1" == '-h' ]; then
		# This option displays a help message and command execution examples
		echo ""
		echo "OsbornePro pingsweep 1.0 ( https://roberthosborne.com )"
		echo ""
		echo "USAGE: pingsweep [network <string format is #.#.#>] [int <start address>] [int <end address>]"
		echo ""
		echo "OPTIONS:"
		echo "  -h : Displays the help information for the command."
		echo ""
		echo "EXAMPLES:"
		echo "  pingsweep 192.168.0"
		echo "  # This example performs a ping sweep from 192.168.0.1 to 192.168.0.254"
		echo ""
		echo "  pingsweep 192.168.0 128 192"
		echo "  # This example performs a ping sweep from 192.168.0.128 to 192.168.0.192"
		echo ""

	elif [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || printf "Valid IP subnet was not defined. For more help execute 'pingsweep -h' Example 172.16.32\n\n "; then
	
			if [ -n "$1" ] && [ -n "$2" ] && [ -z "$3" ]; then
				echo "You are required to define a START and END IP Address range. Leave positional parameters 2 and 3 blank to sweep entire /24 subnet"
				echo ""
				exit
			fi



			if [ -z "$2" ]; then
				START=1
			elif [ -n "$2" ] && [ "$2" -lt 255 ] && [ "$2" -ge 1 ]; then
				START=$2
			else
				echo "Positional parameter 2 and 3 need to be an integer between 1 and 254"
				exit
			fi

			
			
			if [ -z "$3" ]; then
				END=254
			elif [ -n "$3" ] && [ "$3" -lt 255 ] && [ "$3" -gt "$2" ]; then
				END=$3
			
				echo "Active Hosts"
			
				for i in $(seq $START $END 2>/dev/null); do
					HOST=$(echo $1.$i)
						fping -c1 -t300 $HOST 2>/dev/null 1>/dev/null
						# fping's -t option is in miliseconds and can be modified to take loner or shorter. My goal here is speed.
						if [ "$?" = 0 ]
						then
							echo $HOST
						fi
					done
			else
				echo "Positional parameters 2 and 3 need to be an integer between 1 and 254"
				echo ""
				exit
			fi	
	fi
fi
