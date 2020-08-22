#!/bin/bash


# Allow Ctrl+C to kill pingsweep
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT


USAGE="Syntax: $0 [-h] -i <network> [-s <int32 starting port>] [-e <int32 ending port>]

OsbornePro pingsweep 2.0 ( https://roberthosborne.com )
NOTE: This command is most efficient on Linux distros that have fping installed

Usage: pingsweep -i <string format is #.#.#> [[-s <start address>] [-e <end address>]]

    OPTIONS:
        -h : Displays the help information for the command.
	-i : Set the network subnet to perform the ping sweep on
	-s : Set the starting IP address to begin the scan from
	-e : Set the ending IP Address to scan too. Default

    EXAMPLES:
          pingsweep -i 192.168.0
            # This example performs a ping sweep from 192.168.0.1 to 192.168.0.254

          pingsweep -i 192.168.0 -s 200
            # This example performs a ping sweep from 192.168.0.200 to 192.168.0.254

	  pingsweep -i 192.168.0 -s 128 -e 192
	    # This example performs a ping sweep from 192.168.0.128 to 192.168.0.192
	    
	    "

function print_usage {
	printf "$USAGE\n" >&2
	exit 1
    }  # End function print_usage	


while [ ! -z "$1" ]; do
	case "$1" in
		-i)
		        shift	
			ipv4=$1
			;;
		-s)
			shift
			start=$1
			;;
		-e)
			shift
			end=$1
			;;
		-h) 
			print_usage
			;;
		*) 
			print_usage
			;;
	esac
shift
done


if [[ "$ipv4" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || ERROR="Valid IP subnet was not defined. For more help execute 'pingsweep -h' Example 172.16.32 "; then

	# Validate start parameter is an integer between 1 and 254
	if [ -z "$start" ]; then
		START=1
	elif [ "$start" -lt 255 ] && [ "$start" -ge 1 ] || ERROR="Second parameter needs to be an integer between 1 and 254"; then
		if [ ! $ERROR ]; then
			START=$start
		else
			printf "$ERROR\n"
			exit
		fi
	fi


	# Validate positional parameter 3 is an integer between $2 and 254
	if [ -z "$end" ]; then
		END=254
	elif [ "$end" -lt 255 ] && [ "$end" -gt "$start" ] || ERROR="Last IP address needs to be an integer between the value of the $start parameter and 254"; then
		if [ ! $ERROR ]; then
			END=$end
		else
			printf "$ERROR\n"
			exit
		fi
	fi


	printf "[*] Starting Ping Sweep\n"
	echo -e "------------\nActive Hosts\n------------"
		
	PINGCMD=$(which fping)
		
	if [ -z $PINGCMD ]; then
		for i in $(seq $START $END 2> /dev/null); do
			HOST=$(echo $ipv4.$i)
				ping -s 16 -c 1 -i 1 -U -W 1 -4 $HOST 2> /dev/null
				if [ "$?" = 0 ]; then
					printf "$HOST\n"
				fi
			done
	else
		for i in $(seq $START $END 2> /dev/null); do
			HOST=$(echo $ipv4.$i)
			fping -c1 -t300 $HOST 2> /dev/null 1> /dev/null
			# fping's -t option is in miliseconds and can be modified to take loner or shorter. My goal here is speed.
			if [ "$?" = 0 ]; then
				echo $HOST
			fi
		done
	fi
fi
