#!/bin/bash

IPV4REGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
USAGE="Syntax: $0 [-h] -n <network> -p <int32 ports>
OsbornePro portscan 1.1 ( https://osbornepro.com )

Usage: portscan -n <string format is #.#.#> -p [int array]

    OPTIONS:
        -h : Displays the help information for the command
	-n : Set the hostname or ip address to test for open ports on
	-p : Set the ports to check
	-t : Set the timeout value for testing connections

    EXAMPLES:
          portscan -n 192.168.0.1 -p 22 -t 1
	  # This examples tests for port 22 being open on 192.168.0.1 using a 1 second timeout
"


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


	
function validate_port {
	
	if ((65535 <= $port)); then
		printf "[x] Port needs to be between 1 and 65535\n"
		exit 1
	fi

}  # End function validate_port


function test_port {

	(timeout $timeout bash -c "cat < /dev/null > /dev/tcp/$ipv4/$port") && printf "[*] Port $port is open on $ipv4\n" 

}  # End function test_port



while [ ! -z "$1" ]; do
	case "$1" in
		-n)
		        shift
			ipv4=$1
			;;
		-p)
			shift
			port=$1
			;;
		-t)	
			shift
			timeout=$1
			;;
		*)
			print_usage
			;;
	esac
shift
done



allow_ctrlc
validate_port
test_port
