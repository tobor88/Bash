#!/bin/bash

# This command is meant to easily perform a mass dns lookup for all hosts in a subnet range

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
                echo "OsbornePro dnslookup 1.0 ( https://roberthosborne.com )"
                echo ""
                echo "USAGE: dnslookup [network <string format is #.#.#>] [int <start address>] [int <end address>]"
                echo ""
                echo "OPTIONS:"
                echo "  -h : Displays the help information for the command."
                echo " --help: Displays the help information for the command."
                echo ""
                echo "EXAMPLES:"
                echo "  dnslookup 192.168.0"
                echo "  # This example performs a dns host lookup for the IP addresses between 192.168.0.1 and 192.168.0.254"
                echo ""
                echo "  dnslookup 192.168.0 200"
                echo "  # This example performs a dns host lookup for IP addresses between 192.168.0.200 and 192.168.0.254"
                echo ""
                echo "  dnslookup 192.168.0 128 192"
                echo "  # This example performs a dnslookup for IP addresses between 192.168.0.128 and 192.168.0.192"
                echo ""
                exit
        # Variable validation------------------------------------------------
        elif [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || ERROR="Valid IP subnet was not defined. For more help execute 'dnslookup -h' Example Value: 172.16.32 "; then
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

                # Begin DNS Lookups
                echo "--------------------------------------------"
                echo "| IP Address              |     FQDN's     |"
                echo "--------------------------------------------"

                for i in $(seq $START $END); do host $1.$i; done | grep -v "not found" | awk {'print $1, $5'} | sed 's/".in-addr.arpa "/" | "/'
        fi
fi
