#!/bin/bash

#Defining the variables

if [ -z "$1" ]
then
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

elif [ -z "$2" ]
then
	echo "No ports have been defined. All ports 1-65535 will be tested..."
        function portscanner
        {
                for port in {1..65535}
                do
			(echo > /dev/tcp/$1/$port) 2> /dev/null && echo "$port is open"
                done
        } # End function portscan
        portscanner

elif [ -z "$3" ]
then
	echo "Testing whether or not port $2 is open on $1"
	(echo > /dev/tcp/$1/$2) 2> /dev/null && echo "$2 is open" || echo "$2 is closed"

elif [ "$3" != "" ]
then
	echo "Custom port range $2 through $3 is being tested..."
	for(( port=$2; port<=$3; port++ ))
	do
		(echo > /dev/tcp/$1/$port) 2> /dev/null && echo "$port is open"
	done
	fi
