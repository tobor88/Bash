#!/bin/bash

# IMPORTANT: For this script to work you will need fping installed. On Debian based Linux distros it can be installed using the command below
# sudo apt-get -y install fping

if [ "$1" == "" ]
then
        echo "Usage: ./pingsweep.sh [network]"
        echo "Example: ./pingsweep.sh 192.168.0"
else
        for i in {1..254}
        do
                host=$(echo $1.$i)
                fping -c1 -t300 $host 2>/dev/null 1>/dev/null

                if [ "$?" = 0 ]
                then
                        echo $host " Host found"
                fi
        done
fi

