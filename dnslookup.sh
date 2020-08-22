#!/bin/bash
# This command is meant to easily perform a dns lookup for all hosts in a subnet range

# Allow Ctrl+C to kill dnslookup
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT


USAGE="Syntax: dnslookup [-h] -i <network> [-s <int32 starting port>] [-e <int32 ending port>]

OsbornePro dnslookup 2.2 ( https://roberthosborne.com )

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
		*) 
			print_usage
			;;
	esac
shift
done


function validate_start {

	# Validate parameter $START is an integer between 1 and 254
	if [ -z "$start" ]; then
		START=1
	elif [ "$start" -lt 255 ] && [ "$start" -ge 1 ] || ERROR="Start parameter needs to be an integer between 1 and 254"; then
		if [ ! $ERROR ]; then
			START=$start
		else
			printf "$ERROR\n"
			exit 1
		fi
	fi		
}  # End function validate_start


function validate_end {

	# Validate parameter $END is an integer between $START and 254
	if [ -z "$end" ]; then
		END=254
	elif [ "$end" -lt 255 ] && [ "$end" -gt "$start" ] || ERROR="End parameter needs to be an integer between the value of positional parameter two and 254"; then
		if [ ! $ERROR ]; then
			END=$end
		else
			printf "$ERROR\n"
			exit 1
		fi
	fi

}  # End function validate_end

if [[ "$ipv4" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || ERROR="Valid IP subnet was not defined. For more help execute 'dnslookup -h' Example Value: 172.16.32 "; then

		# Validate first parameter was defined correctly
		if [ "$ERROR" ]; then
			printf "$ERROR\n"
			exit 1
		fi
	
		validate_start

		validate_end
		
		hostname_regex = "^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$"

		# Begin DNS Lookups
		printf "%s\n---------------------------------------------------"
		printf "%s\n| IP Address             |         FQDN's         |"
		printf "%s\n---------------------------------------------------%s\n"
		
		for i in $(seq $START $END); do 
			unset HOSTSNAME 2> /dev/null
			THEIP="$ipv4.$i"
			HOSTSNAME=$(host "$THEIP" | awk '{print $5}')
			if [[ $HOSTSNAME =~ "$hostname_regex" ]] && [ $HOSTSNAME != "3(NXDOMAIN)" ]; then
				echo "$THEIP             | $HOSTSNAME"
			fi
		done 

fi
