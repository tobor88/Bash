# Bash
Collection of bash scripts I wrote to make my life easier or test myself that you may find useful. The help switch defined for these scripts is written with the assumption these exist in a PATH environmnet variable. Typically commands such as these should be placed in /usr/local/bin. This is considered best practice for Linux.Most of these tools will be useful to Red Teamers

#### BASH COMMANDS
- __readid.sh__ This is complete. (Disaplys the /etc/passwd, /etc/shadow, or /etc/group files into an easy to read format)
![readid.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/readid_img.png)

- __getip.sh__ I view this as done. (Restrieves and displays the public and private IP addresses on a computer)
![getip.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/getip_img.png)

- __pingsweep.sh__ This works best when fping is installed on your Linux distro. If fping is not installed it will failover to using the ping command instead. The timeout for ping is set to 1 second so if you are using this with proxychains you may need to mess around with this setting.
- __suidcheck.sh__ Needs a lot of work (Checks for exploitable suid bits and attempts to exploit them if they exist. Also returns cron job scripts)
- __portscan.sh__ Works but still needs more input validation and error handling. (Custom port scanner. Check all ports, one port, or a custom range of ports.)
