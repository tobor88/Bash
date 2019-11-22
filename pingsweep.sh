#!/bin/bash

# IMPORTANT: For this script to work you will need fping installed. On Debian based Linux distros it can be installed using the command below
# sudo apt-get -y install fping

if [ -z "$1" ]
then
	echo "Use -h switch to view help information"
	echo ""
else
	if [ "$1" == '-h' ]; then
		# This option displays a help message and command execution examples
		echo ""
		echo "OsbornePro pingsweep 1.0 ( https://roberthosborne.com )"
		echo ""
		echo "USAGE: pingsweep [network] "
		echo ""
		echo "OPTIONS:"
		echo "  -h : Displays the help information for the command."
		echo ""
		echo "EXAMPLES:"
		echo "  pingsweep 192.168.0"
		echo "  # This example performs a ping sweep from 192.168.0.1 to 254"
		echo ""
		echo "  pingsweep 192.168.0 128 192"
		echo "  # This example performs a ping sweep from 192.168.0.128 to 192"
		echo ""

	elif [ -n "$1" ]; then

			if [ -n "$1" ] && [ -n "$2" ] && [ -z "$3" ]; then
				echo "You are required to define a START and END IP Address range. Leave blank to sweep /24 subnet"
				echo ""
				exit
			fi

			if [ -z "$2" ]; then
				START=1
			elif [ -n "$2" ]; then
				START=$2
			fi

			if [ -z "$3" ]; then
				END=254
			elif [ -n "$3" ]; then
				END=$3
			fi
			
			echo "Active Hosts"
			
			for i in $(seq $START $END); do
				HOST=$(echo $1.$i)
					fping -c1 -t200 $HOST 2>/dev/null 1>/dev/null
					# fping's -t option is in miliseconds and can be modified to take loner or shorter. My goal here is speed.
					if [ "$?" = 0 ]
					then
						echo $HOST
					fi
				done
	fi	
fi
