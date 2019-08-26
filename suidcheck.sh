#!/bin/bash

# This script is for finding commands with root SUID permissions and printing info for possible exploitation

suid=$(/usr/bin/find / -perm -u=s -type f 2>/dev/null)
guid=$(/usr/bin/find / -user root -perm 2000 -print 2> /dev/null)
exploit_cmds=(nmap vim find netcat less cp)

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
	fi
done
