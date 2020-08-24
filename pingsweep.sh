#!/bin/bash


IPV4REGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
PINGCMD=$(command -v fping)
USAGE="Syntax: $0 [-h] -i <network> [-s <int32 starting port>] [-e <int32 ending port>]

OsbornePro pingsweep 2.1 ( https://roberthosborne.com )
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


function get_cmd {

	# Determines whether fping or ping will be used
	if [ -z $PINGCMD ]; then
		CMD="ping -s 16 -c 1 -i 1 -U -W 1 -4 \$HOST 2> /dev/null"
	else
		CMD="fping -c1 -t300 \$HOST 2> /dev/null 1> /dev/null"
	fi
	
}  # End function get_cmd


function allow_ctrlc {

	# Allow Ctrl+C to kill pingsweep
	trap '
	  trap - INT # restore default INT handler
	  kill -s INT "$$"
	' INT

}  # End function allow_ctrlc


function print_usage {

	printf "$USAGE\n" >&2
	exit 1

    }  # End function print_usage	


function validate_start {
	
	# Validate start parameter is an integer between 1 and 254
	if [ -z "$start" ]; then
		START=1
	elif [ "$start" -lt 255 ] && [ "$start" -ge 1 ] || ERROR="Start parameter needs to be an integer between 1 and 254"; then
		if [ ! $ERROR ]; then
			START=$start
		else
			printf "$ERROR\n"
			exit
		fi
	fi

}  # End function validate_start


function validate_end {
	
	# Validate positional parameter 3 is an integer between $2 and 254
	if [ -z "$end" ]; then
		END=254
	elif [ "$end" -lt 255 ] && [ "$end" -gt "$start" ] || ERROR="Last ending IP address needs to be an integer between the value of $start and 254"; then
		if [ ! $ERROR ]; then
			END=$end
		else
			printf "$ERROR\n"
			exit
		fi
	fi

}  # End function validate_end


function validate_ipv4 {

	if [[ "$ipv4" =~ "$IPV4REGEX" ]] || ERROR="Valid IP subnet was not defined. For more help execute 'pingsweep -h' Example 172.16.32 "; then
		if [ -n "$ERROR" ]; then
			printf "[x] A valid network value was not defined. Used -h for more info. Example: 172.16.0\n"
			exit 1
		fi
	fi

}  # End function validate_ipv4


function execute_pingsweep {

	printf "[*] Starting Ping Sweep\n"
	echo -e "------------\nActive Hosts\n------------"

	for i in $(seq $START $END 2> /dev/null); do
		HOST=$(echo $ipv4.$i)
			eval $CMD
			if [ "$?" = 0 ]; then
				printf "$HOST\n"
			fi
	done

	printf "[*] Ping Sweep execution completed\n"

}  # End function execute_pingsweep


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
		*)
			print_usage
			;;
	esac
shift
done

get_cmd
allow_ctrlc
validate_ipv4
validate_start
validate_end
execute_pingsweep
