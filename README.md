# Bash
Collection of bash scripts I wrote to make my life easier or test myself that you may find useful. The help switch defined for these scripts is written with the assumption these exist in a PATH environmnet variable. Typically commands such as these should be placed in /usr/local/bin. This is considered best practice for Linux.Most of these tools will be useful to Red Teamers

#### BASH COMMANDS
- __readid.sh__ This is complete. (Disaplys the /etc/passwd, /etc/shadow, or /etc/group files into an easy to read format)

![readid.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/readid_img.png)


- __getip.sh__ I view this as done. (Restrieves and displays the public and private IP addresses on a computer)

![getip.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/getip_img.png)


- __pingsweep.sh__ This works best when fping is installed on your Linux distro. If fping is not installed it will failover to using the ping command instead. The timeout for ping is set to 1 second so if you are using this with proxychains you may need to mess around with this setting.

![pingsweep.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/pingsweep_img.png)


- __portscan.sh__ Works but still needs more input validation and error handling. (Custom port scanner. Check all ports, one port, or a custom range of ports.)

![portscan.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/portscan_img.png)


- __absolutepathit.sh__ This command is used to convert all relative commands in a script to absolute path commands. To play this one safe I have it create a copy of the script you wrote and places it in a file called /tmp/absolutepathit_tmpinfo. This file has all comments removed from it and replaces any commands that have a $(which <cmd>) result value with that absolute path value. Copy and paste the results into your script to ensure you dont lost your comments and to ensure any possible command words you have in echo quotations are what you want. 
 
 ![absolutepathit.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/absolutepathit_img.png) 


- __suidcheck.sh__ Needs a lot of work (Checks for exploitable suid bits and attempts to exploit them if they exist. Also returns cron job scripts)
