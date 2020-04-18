#!/bin/bash

# Allow Ctrl+C to kill pingsweep
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

# Create positional parameter options
if [ "$1" == "" -o "$1" == "-h" -o "$1" == "--help" ]; then
	echo ""
	echo "OsbornePro portscan 1.0 ( https://roberthosborne.com )"
	echo ""
	echo "Usage: portscan [network]"
	echo ""
	echo "EXAMPLES: "
	echo "  #The below example will scan ports 1 through 65535 on host 192.168.227.2"
	echo "  portscan 192.168.227.2"	
	echo ""
	echo "  #The below example will test for port 80 on host 192.168.227.2"
	echo "  portscan 192.168.227.2 80"
	echo ""
	echo "  #The below example will test the port range 20 to 25 on 192.168.227.2"
	echo "  portscan 192.168.227.2 20 25"
	echo ""
	exit	

# If a valid ipv4 address is not defined than exit 
elif [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && echo "Scanning $1" || printf "$1 is not a valid ipv4 address\n\n"; then
	
	# If second positional parameter is not defined than default check all ports
	if [ -z "$2" ] && printf "No ports have been defined. All ports 1-65535 will be tested...\n\n"; then
		echo "$1"
		echo ""
	        echo "Open Ports"
		echo "----------"
        	for port in {1..65535}
        	do
			# (echo > /dev/tcp/$1/$port) 2> /dev/null && echo "$port is open"
			true &>/dev/null </dev/tcp/$1/$port && echo $port
		done
		exit

	# Single Port scan. If the third parameter is not defined and the port is in the valid range test the one port
	elif [ -z "$3" ] && [ "$2" -le 65534 ] && [ "$2" -ge 1 ] && echo "Now scanning port $2 on $1"; then
		true &>/dev/null </dev/tcp/$1/$2 && echo "Port $2 is open"
		exit
	
	# Validate the third positiona parameter is a valid port number between $2 and 65535
	elif [ "$3" -le 65535 ] && [ "$3" -gt "$2" ]; then
		echo "Scanning ports $2 through $3..."
		for p in $(seq $2 $3 2> /dev/null); do 
			true &>/dev/null </dev/tcp/$1/$p && echo "$p is open" || echo "$p is closed"
		done
	else
		echo "Input was invalid. Execute 'portscan -h' for information on how to use this command."
	fi
fi
