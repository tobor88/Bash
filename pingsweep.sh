#!/bin/bash

# IMPORTANT: For this script to work you will need fping installed. On Debian based Linux distros it can be installed using the command below
# sudo apt-get -y install fping

# Allow Ctrl+C to kill pingsweep
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

if [ -z "$1" ]; then
	echo "Use -h switch to view help information"
	echo ""
else
	if [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
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
		echo "  pingsweep 192.168.0 200"
		echo "  # This example performs a ping sweep from 192.168.0.200 to 192.168.0.254"
		echo ""
		echo "  pingsweep 192.168.0 128 192"
		echo "  # This example performs a ping sweep from 192.168.0.128 to 192.168.0.192"
		echo ""
		exit
	# Variable validation------------------------------------------------
	elif [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || ERROR="Valid IP subnet was not defined. For more help execute 'pingsweep -h' Example 172.16.32 "; then
		
		# Validate first parameter was defined correctly
		if [ ! $ERROR ]; then
			# Validate correct amount of positional parameters are defined
			if [ -n "$4" ]; then
				echo "Too many positional parameters have been defined. Execute 'pingsweep -h' for more options"
				echo ""
				exit
			fi
		else
			echo $ERROR
			echo ""
			exit
		fi

		# Validate positional parameter 2 is an integer between 1 and 254
		if [ -z "$2" ]; then
			START=1
		elif [ "$2" -lt 255 ] && [ "$2" -ge 1 ] || ERROR="Second parameter needs to be an integer between 1 and 254"; then
			if [ ! $ERROR ]; then
				START=$2
			else
				echo $ERROR
				echo ""
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
				echo $ERROR
				echo ""
				exit
			fi
		fi

		# Begin Ping Sweep 
		echo "Active Hosts"
		echo "------------"
		
		for i in $(seq $START $END 2> /dev/null); do
			HOST=$(echo $1.$i)
				fping -c1 -t300 $HOST 2> /dev/null 1> /dev/null
				# fping's -t option is in miliseconds and can be modified to take loner or shorter. My goal here is speed.
				if [ "$?" = 0 ]
				then
					echo $HOST
				fi
			done
	fi
fi
