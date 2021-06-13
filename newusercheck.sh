#!/bin/bash
# Send an email alert if a new account is added to the /etc/passwd file
# CRONJOB BELOW RUNS EVERY 5 MINUTES
# */5 * * * * /bin/bash /root/scripts/newusercheck.sh 1>/dev/null 2>/dev/null


HOSTNAME=$(hostname)
TO="<to@domain.com>"
FROM="<from@domain.com>"
USERLIST="/root/scripts/.user.lst"
NEWUSERLIST="/root/scripts/.userlist.txt"
PASSWDFILE="/etc/passwd"
COMPARE=0

trap "/bin/rm -rf --preserve-root -- $NEWUSERLIST" 0


if [ -s "$USERLIST" ] ; then
	/usr/bin/printf "[*] Checking previously known list of users\n"
	LASTREV="$(/bin/cat $USERLIST)"
	COMPARE=1
fi


/usr/bin/printf "[*] Obtaining current user list\n"
/bin/cat $PASSWDFILE | /usr/bin/cut -d: -f1 > $NEWUSERLIST


CURRENT="$(/bin/cat $NEWUSERLIST)"


if [ $COMPARE -eq 1 ] ; then
	if [ "$CURRENT" != "$LASTREV" ] ; then
		/usr/bin/printf "[!] WARNING: password file has changed\n"
		/usr/bin/diff $USERLIST $NEWUSERLIST | /bin/grep '^[<>]' | /bin/sed 's/</Removed: /;s/>/Added:/'
    
    /usr/bin/printf "[*] Sending email alert\n"
		/usr/bin/mail -r $FROM -A $NEWUSERLIST -s "WARNING: New Account Created on $HOSTNAME" $TO <<< "You are receiving this email because a new user account has been created on $HOSTNAME. Attached to this email is a file containing the CURRENT user accounts on the system. The user list has been updated so you will not receive this alert until an account is created again."
    
    /usr/bin/printf "[!] WARNING: Previously known user list has been updated so you do not keep receiving this warning\n" 
    /bin/mv $NEWUSERLIST $USERLIST
	else
		/usr/bin/printf "[*] No new users have been created since the last check\n"
	fi
else
	/usr/bin/printf "[*] Creating initial database of previously known users\n"
	/bin/mv $NEWUSERLIST $USERLIST
fi

/bin/chmod 600 $USERLIST

exit 0
