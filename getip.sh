#!/bin/bash


function get_public_ip {
	curl -s http://whatismijnip.nl | cut -d " " -f 5
}  # end function get_public_ip


function get_private_ip {
        ifconfig | grep 'inet ' | awk {'print $2'}
}  # end function get_prviate_ip


echo "[*] Getting IP Addresses, Please Wait..."

PUBLIC=$( get_public_ip )
PRIVATE=$( get_private_ip )

if [ "$PUBLIC" != "" ]
then
        echo "========================="
        echo "Public: "
        echo "-------------------------"
        echo "$PUBLIC"
else
        echo "[!] Public IP address could not be found."
fi

echo "========================="
echo "Private: "
echo "-------------------------"
echo "$PRIVATE"
echo "========================="
