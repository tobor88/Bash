#!/bin/bash

echo "Getting IP Addresses, Please Wait..."

public=$(curl -s http://whatismijnip.nl | cut -d " " -f 5)

private=$(ip a | grep 'inet ' | awk {'print $2'})

if [ "$public" != "" ]
then
	echo "=========================" 
	echo "Public: "
	echo "-------------------------"
	echo "$public"
else
	echo "Public IP address could not be found."
fi

echo "========================="
echo "Private: "
echo "-------------------------"
echo "$private"
echo "========================="
