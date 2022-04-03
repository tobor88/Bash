#!/bin/bash

# readid.sh is used to make the contents of /etc/passwd, /etc/group, and /etc/shadow easy to interpret quickly

if [ -z "$1" ]
then
	echo "Use -h switch to view help information"
	echo ""
fi

while [ -n "$1" ]; do
	case "$1" in
		-u)
			# This option is used to read the contents of /etc/passwd and place its output into an easy to read format
			awk -F":" '
			BEGIN {
			print "==================================================================================================================="
			printf "%-18s %-5s %-5s %-35s %-22s %-22s\n" , "USER", "UID", "GID", "GROUP", "HOME", "SHELL"
			print "===================================================================================================================" }
			NR==1,NR==400{ printf "%-18s %5d %5d %-35s %-22s %-22s\n" , $1,$3,$4,$5,$6,$7 } ' /etc/passwd
			;;
		-g) param="$2"
			# This option is used to read the contents of the /etc/group file and place its output into an easy to read format
			awk -F":" '
			BEGIN {
			print "==================================================================================================================="
			printf "%-28s %-5s %-5s %-35s\n" , "GROUP_NAME", "   PWD", "  GID", " MEMBERS"
			print "===================================================================================================================" }
			NR==1,NR==400{ printf "%-28s %5d %5d %-35s\n" , $1,$2,$3,$4 } ' /etc/group
			;;
		-s) param="$3"
			# This option is used to read the contents of the /etc/shadow file and requires root permissions
			awk -F":" '
			BEGIN {
			print "================================================================================================================================================="
			printf "%-18s %-98s %-10s %-10s\n" , "USER", "PASSWORD_HASH", "LAST_CHANGED", "INACTIVE", "EXPIRY"
			print "=================================================================================================================================================" }
			NR==1,NR==400{ printf "%-18s %-98s %-10s %-10s\n" , $1,$2,$3,$7,$8 } ' /etc/shadow
			;;
		-h) param="$4"
			# This option displays a help message and command execution examples
			echo ""
			echo "OsbornePro readid 1.0 ( https://osbornepro.com )"
			echo ""
			echo "Usage: readid '[Options'] "
			echo ""
			echo "OPTIONS:"
			echo " -u : Reads the /etc/passwd file and places it into a neat table."
  			echo " -g : Reads the /etc/group file and places it into a neat table."
			echo " -h : Displays the help information for the command."
			echo ""
		        echo "EXAMPLES:"
			echo "  readid -u"
			echo "  readid -g"
			echo "  sudo readid -s"
			echo "  readid -h"
			echo "  readid -u | more"
			echo ""
			;;
	esac
	shift
done
