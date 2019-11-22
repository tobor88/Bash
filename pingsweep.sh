#!/bin/bash

# IMPORTANT: For this script to work you will need fping installed. On Debian based Linux distros it can be installed using the command below
# sudo apt-get -y install fping

if [ -z "$1" ]
then
	echo "Use -h switch to view help information\n"
else
	if [ "$1" == '-h' ]; then
		# This option displays a help message and command execution examples
		echo ""
		echo "OsbornePro pingsweep 1.0 ( https://roberthosborne.com )"
		echo ""
		echo "USAGE: pingsweep [network] "
		echo ""
		echo "OPTIONS:"
		echo " -h : Displays the help information for the command."
		echo ""
		echo "EXAMPLES:"
		echo "  pingsweep 192.168.0"
	elif [ -n "$1" ]; then
			echo "=================="
			echo "|  Active Hosts  |"
			echo "=================="
			for i in {1..254}
			do
				host=$(echo $1.$i)
				fping -c1 -t200 $host 2>/dev/null 1>/dev/null
				# fping's -t option is in miliseconds and can be modified to take loner or shorter. My goal here is speed.
				if [ "$?" = 0 ]
				then
					echo $host
				fi
			done
	fi	
fi
