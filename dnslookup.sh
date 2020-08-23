#!/bin/bash
# This command is meant to easily perform a dns lookup for all hosts in a subnet range


IPV4_REGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ "
USAGE="Syntax: dnslookup [-h] -i <network> [-s <int32 starting port>] [-e <int32 ending port>]

OsbornePro dnslookup 2.3 ( https://roberthosborne.com )

USAGE: dnslookup -i [network <string format is #.#.#>] 

    OPTIONS:
        -h : Displays the help information for the command.
	-i : Set the network subnet to perform the dns lookups on
	-s : Set the starting IP address to begin the lookups from
	-e : Set the last IP Address to lookup

    EXAMPLES:
          dnslookup -i 192.168.0 
            # This example performs a dns lookup from 192.168.0.1 to 192.168.0.254

          dnslookup-i 192.168.0 -s 10
            # This example performs a dns lookup from 192.168.0.10 to 192.168.0.254

	  dnslookup -i 192.168.0 -s 1 -e 10
	    # This example performs a dns lookup from 192.168.0.1 to 192.168.0.10
	    
"


function allow_ctrl {

	# Allow Ctrl+C to kill dnslookup
	trap '
	  trap - INT # restore default INT handler
	  kill -s INT "$$"
	' INT

}  # End function allow_ctrl


function print_usage {
	# Prints the commands help information
	printf "$USAGE\n" >&2
	exit 1

}  # End function print_usage	


function validate_start {

	# Validate parameter $START is an integer between 1 and 254
	if [ -z "$starting" ]; then
		START=1
	elif [ "$starting" -lt 255 ] && [ "$starting" -ge 1 ] || ERROR="Start parameter needs to be an integer between 1 and 254"; then
		if [ ! $ERROR ]; then
			START=$starting
		else
			printf "[x] $ERROR\n"
			exit 1
		fi
	fi		
}  # End function validate_start


function validate_end {

	# Validate parameter $END is an integer between $START and 254
	if [ -z "$end" ]; then
		END=254
	elif [ "$end" -lt 255 ] && [ "$end" -gt "$starting" ] || ERROR="End parameter needs to be an integer between the value of positional parameter two and 254"; then
		if [ ! $ERROR ]; then
			END=$end
		else
			printf "[x] $ERROR\n"
			exit 1
		fi
	fi

}  # End function validate_end


function validate_ipv4 {

	# Validate first parameter was defined correctly
	if [[ "$ipv4" =~ "$IPV$_REGEX" ]] || ERROR="Valid IP subnet was not defined. For more help execute 'dnslookup -h' Example Value: 172.16.32 "; then
		if [ -n "$ERROR" ]; then
			printf "[x] $ERROR\n"
			exit 1
		fi
	fi

}  # End function validate_ipv4


function execute_dnslookup {

	# Begin DNS Lookups
	printf "%s\n---------------------------------------------------"
	printf "%s\n| IP Address             |         FQDN's         |"
	printf "%s\n---------------------------------------------------%s\n"
	
	for i in $(seq $START $END); do 
		unset HOSTSNAME 2> /dev/null
		
		THEIP="$ipv4.$i"
		HOSTSNAME=$(host "$THEIP" | awk '{print $5}')

		if [ $HOSTSNAME != "3(NXDOMAIN)" ]; then
			echo "$THEIP             | $HOSTSNAME"
		fi
	done 

}  # End function execute_dnslookup


while [ ! -z "$1" ]; do
	case "$1" in
		-i) 
			shift
		   	ipv4=$1
			;;
		-s) 
			shift
		   	starting=$1
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

allow_ctrl
validate_start
validate_end
validate_ipv4
execute_dnslookup
