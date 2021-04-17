# I do my best to keep this updated with tools I use so rebuilding a Kali ISO doesn't take all day
# Script runtime is about 20 minutes. If you have ideas to make this even faster feel free to contribute 
# Kali cant run this as a script. Copy and paste everything all at once.
# Last Tested on Kali 2020.2 on May 14 2020

echo "Setup Burpsuite CA Certificate and set 'Enable Interception at Startup' to 'Always Disable'"

# SERVICES
gzip -d /usr/share/wordlists/rockyou.txt.gz
sudo msfdb init
sudo systemctl enable postgresql

# PIP INSTALLS 
sudo apt-get install cmake -y
sudo apt-get install gdb -y
sudo dpkg --add-architecture i386 && apt-get install wine32 -y
sudo apt-get install python-setuptools -y
sudo apt-get install python3-setuptools -y
sudo apt-get install python-dev -y
sudo apt-get install python3-pip -y
sudo apt-get install python-pip -y
sudo apt-get install seclists -y
python -m easy_install pip
pip install wheel
pip install keystone-engine
pip install capstone
pip install unicorn
pip install ropper
pip install colorama 
pip install pysnmp
pip install win_unicode_console
pip install discovery
pip install Crypto
pip install impacket
pip install iptools
pip install agents
pip install M2Crypto
pip install netifaces
pip install pydispatch
pip install samba
pip install pwn
pip install pwntools
pip install pysmbclient
pip install pytelnet
pip install secret
pip3 install secret
pip3 install stegcracker
pip3 install csvkit
pip install ssh
pip install webapp2
pip install lxml
pip install ssl
pip install pycrypto
pip install virtualenv
pip install cme
pip install bloodhound
pip3 install virtualenv
pip3 install scanless
pip3 install minidump minikerberos aiowinreg msldap winsspi
pip3 install pypykatz
python3 -m pip install web3
# GEF BUILD FOR GDB
python3 -m pip install pwntools
python3 -m pip install keystone-engine
python3 -m pip install capstone
python3 -m pip install unicorn
python3 -m pip install ropper
wget https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh
chmod +x update-trinity.sh
./update-trinity.sh

# GEM INSTALLS 
gem install winrm
gem install winrm-s
gem install winrm-fs
gem install evil-winrm

# APT INSTALLS
sudo apt-get install tmux -y
sudo apt-get install hashcat -y
sudo apt-get install git -y
sudo apt-get install vim -y
sudo apt-get install beef -y
sudo apt-get install ncat -y
sudo apt-get install imagemagick -y
sudo apt-get install ghostscript -y
sudo apt-get install stoken -y
sudo apt-get install recon-ng -y
sudp apt-get install maven -y
sudo apt-get install brutespray -y
sudo apt-get install ismtp -y
sudo apt-get install checksec -y
sudo apt-get install reaver -y
sudo apt-get install seahorse -y
sudo apt-get install catdoc -y
sudo apt-get install seahorse-nautilus -y
sudo apt-get install guake -y
sudo apt-get install wifite -y
sudo apt-get install kismet -y
sudo apt-get install crunch -y
sudo apt-get install cewl -y
sudo apt-get install awscli -y
sudo apt-get install xclip -y
sudo apt-get install crowbar -y
sudo apt-get install jxplorer -y
sudo apt-get install smbmap -y
sudo apt-get install armitage -y
sudo apt-get install wfuzz -y
sudo apt-get install nfs-kernel-server -y
sudo apt-get install sqlmap -y
sudo apt-get install bettercap -y
sudo apt-get install putty-tools -y
sudo apt-get install httptunnel -y
sudo apt-get install exiftool -y
sudo apt-get install squid -y
sudo apt-get install squidclient -y
sudo apt-get install xlsx2csv -y
sudo apt-get install squid-cgi -y
sudo apt-get install squid-common -y
sudo apt-get install encfs -y
sudo apt-get install gdbserver -y
sudo apt-get install qemu-utils -y
sudo apt-get install libcurl4-openssl-dev
sudo apt-get install steghide -y
sudo apt-get install evil-ssdp
sudo apt-get install dnschef -y
sudo apt-get install mingw-w64 -y
sudo apt-get install smtp-user-enum -y 
sudo apt-get install samdump2 -y
sudo apt-get install lftp -y
sudo apt-get install python3-pip -y
sudo apt-get install responder -y
sudo apt-get install unicornscan -y
sudo apt-get install crackmapexec -y
sudo apt-get install shellter -y
sudo apt-get install wpscan -y
sudo apt-get install nbtscan -y
sudo apt-get install firewalk -y
sudo apt-get install hping3 -y
sudo apt-get install gobuster -y
sudo apt-get install rlwrap -y
sudo apt-get install patator -y
sudo apt-get install neo4j -y
sudo apt-get install bloodhound -y
sudo apt-get install wfuzz -y
sudo apt-get install ident-user-enum -y
sudo apt-get install cargo -y
sudo apt-get install npm -y
sudo apt-get install npm --fix-broken -y
sudo apt-get install powershell -y
sudo apt-get install golang -y
sudo go get github.com/ffuf/ffuf
sudo cp /root/go/bin/ffuf /usr/local/bin/ffuf

# NPM INSTALLS
npm install -g sql-cli
npm install -g memcached-cli

# EMPIRE
cd /opt
sudo git clone https://github.com/EmpireProject/Empire.git
sudo /opt/Empire/setup/install.sh

# GHIDRA
sudo wget https://ghidra-sre.org/ghidra_9.1.2_PUBLIC_20200212.zip 
sudo unzip /opt/ghidra_9.1.2_PUBLIC_20200212.zip
sudo wget https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz
sudo tar xzvf OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz -C /usr/share/

# TMUX 
cd /opt
sudo touch /root/.tmux.conf
sudo git clone https://github.com/tmux-plugins/tmux-logging.git
sudo echo "set -g history-limit 50000" >> ~/.tmux.conf
sudo echo "set -g allow-rename off" >> ~/.tmux.conf
sudo echo " " >> ~/.tmux.conf
sudo echo -en "bind-key j command-prompt -p \"join pane from:\" \"join-pane -s \'%%\'\"\n" >> ~/.tmux.conf
sudo echo -en "bind-key s command-prompt -p \"join pane to:\" \"join-pane -t '%%'\"" >> ~/.tmux.conf
sudo echo " " >> ~/.tmux.conf
sudo echo "set-window-option -g mode-keys vi" >> ~/.tmux.conf
sudo echo "run-shell /opt/tmux-logging/logging.tmux" >> ~/.tmux.conf
sudo echo " " >> ~/.tmux.conf
sudo echo "set -g @plugin 'tmux-plugins/tmux-logging'" >> ~/.tmux.conf
sudo echo " " >> ~/.tmux.conf
sudo echo -en "set -g default-terminal \"screen-256color\"\n" >> ~/.tmux.conf
sudo echo "" >> ~/.tmux.conf
sudo echo 'run-shell /opt/tmux-logging/logging.tmux' >> ~/.tmux.conf

# PROXIES
sudo mkdir /usr/share/proxies
cd /usr/share/proxies
sudo git clone https://github.com/sensepost/reGeorg.git
sudo git clone https://github.com/jpillora/chisel.git
sudo git clone https://github.com/sshuttle/sshuttle.git
cd sshuttle
sudo ./setup.py install

# /USR/SHARE
cd /usr/share 
sudo git clone https://github.com/int0x33/nc.exe.git
sudo git clone https://github.com/tennc/fuzzdb.git
sudo git clone https://github.com/RUB-NDS/PRET.git
sudo ln -sf /usr/share/PRET/pret.py /usr/local/bin/pret
sudo git clone https://github.com/AlessandroZ/LaZagne.git
pip3 install -r /usr/share/LaZagne/requirements.txt
pip3 install -r /usr/share/LaZagne/requirements.txt
sudo git clone https://github.com/Keramas/DS_Walk
sudo git clone https://github.com/internetwache/GitTools.git
sudo git clone https://github.com/tarunkant/Gopherus.git
cd /usr/share/Gopherus
/usr/share/Gopherus/install.sh
cd /usr/share
sudo git clone https://boringssl.googlesource.com/boringssl
sudo git clone --recursive https://github.com/cloudflare/quiche
cd quiche
cargo build --examples
QUICHE_BSSL_PATH="/usr/share/boringssl" cargo build --examples
cd /usr/share/
sudo git clone https://github.com/frohoff/ysoserial.git
sudo git clone https://github.com/Tib3rius/AutoRecon.git
sudo git clone https://github.com/skelsec/pypykatz.git
sudo python /usr/share/pypykatz/setup.py install
sudo git clone https://github.com/arthaud/git-dumper.git
sudo git clone https://github.com/trickster0/Enyx.git
sudo cp /usr/share/Enyx/enyx.py /usr/local/bin/enyx
sudo chmod a+x /usr/local/bin/enyx
sudo git clone https://github.com/superkojiman/rfishell.git
sudo git clone https://github.com/ccavxx/Kadimus.git
sudo git clone https://github.com/pwntester/ysoserial.net.git
sudo ln -sf /usr/share/AutoRecon/autorecon.py /usr/local/bin/autorecon
sudo wget http://pentestmonkey.net/tools/finger-user-enum/finger-user-enum-1.0.tar.gz
sudo tar xzf finger-user-enum-1.0.tar.gz

# WINDOWS RESOURCES
cd /usr/share/windows-resources
sudo git clone https://github.com/besimorhino/powercat.git
sudo git clone https://github.com/trustedsec/unicorn.git
sudo git clone https://github.com/irsdl/IIS-ShortName-Scanner
sudo git clone https://github.com/byt3bl33d3r/SprayingToolkit.git
cd /usr/share/windows-resources/SprayingToolkit
sudo pip3 install -r requirements.txt
sudo git clone https://github.com/peewpw/Invoke-WCMDump.git
sudo git clone https://github.com/rasta-mouse/Sherlock.git
sudo git clone https://github.com/rasta-mouse/Watson.git
sudo git clone https://github.com/cyberark/RiskySPN.git
sudo git clone https://github.com/EliteLoser/Invoke-PsExec.git
sudo git clone https://github.com/ZilentJack/Spray-Passwords.git
sudo git clone https://github.com/fox-it/BloodHound.py.git
sudo git clone https://github.com/SafeBreach-Labs/SirepRAT.git
sudo git clone https://github.com/AonCyberLabs/Windows-Exploit-Suggester.git
sudo git clone https://github.com/bitsadmin/wesng.git
sudo git clone https://github.com/tobor88/ReversePowerShell.git
sudo git clone https://github.com/tobor88/PowerShell-Red-Team.git
sudo git clone https://github.com/TsukiCTF/Lovely-Potato.git
sudo git clone https://github.com/SecWiki/windows-kernel-exploits.git
sudo git clone https://github.com/Arvanaghi/SessionGopher.git
sudo git clone https://github.com/411Hall/JAWS.git
sudo git clone https://github.com/davehardy20/sysinternals.git
sudo git clone https://github.com/AlessandroZ/BeRoot.git
sudo mkdir /usr/share/linux-resources/BeRoot
sudo mv /usr/share/windows-resources/BeRoot/Linux/* /usr/share/linux-resources/BeRoot/
sudo mv /usr/share/windows-resources/BeRoot/Windows/* /usr/share/windows-resources/BeRoot/
sudo rm -r /usr/share/windows-resources/BeRoot/Windows/
sudo rm -r /usr/share/windows-resources/BeRoot/Linux/

# LINUX RESOURCES
sudo mkdir /usr/share/linux-resources
cd /usr/share/linux-resources
sudo git clone https://github.com/mzet-/linux-exploit-suggester.git
sudo git clone https://github.com/rebootuser/LinEnum.git
sudo git clone https://github.com/DominicBreuker/pspy.git
sudo git clone https://github.com/huntergregal/mimipenguin
sudo cp /usr/share/linux-resources/mimipenguin.sh /var/www/html/mimipenguin.sh
cp /usr/share/linux-resources/mimipenguin.py /var/www/html/mimipenguin.py
sudo git clone https://github.com/jondonas/linux-exploit-suggester-2.git
sudo git clone https://github.com/saghul/lxd-alpine-builder.git
sudo /usr/share/linux-resources/lxd-alpine-builder/build-alpine
sudo cp /usr/share/linux-resources/lxd-apline/builder/alpine-v*.tar.gz /var/www/html/
sudo git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
sudo mv privilege-escalation-awesome-scripts-suite/linPEAS/ /usr/share/linux-resources/
sudo mv privilege-escalation-awesome-scripts-suite/winPEAS/ /usr/share/windows-resources/
sudo cp privilege-escalation-awesome-scripts-suite/README.md /usr/share/windows-resources/
sudo cp privilege-escalation-awesome-scripts-suite/README.md /usr/share/linux-resources/
sudo rm -r -- /usr/share/linux-resources/privilege-escalation-awesome-scripts-suite

# WEBSHELLS
cd /usr/share/webshells/php
sudo git clone https://github.com/flozz/p0wny-shell.git
sudo git clone https://github.com/WhiteWinterWolf/wwwolf-php-webshell.git
sudo git clone https://github.com/jgor/php-jpeg-shell.git
sudo git clone https://github.com/epinna/weevely3.git

# APACHE2 SITE
cd /var/www
sudo git clone https://github.com/tobor88/PayloadSiteForPenTesters.git
sudo cp /var/www/PayloadSiteForPenTesters/* /var/www/html/
sudo cp /usr/share/windows-resources/Lovely-Potato/* /var/www/html/

# WORDLISTS
echo "Building all inclusive wordlist for URL fuzzing"
sudo cp /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt /usr/share/seclists/Discovery/Web-Content/
sudo cat /usr/share/seclists/Discovery/Web-Content/*.txt | cut -d' ' -f2 |  sort -u  > /usr/share/seclists/Discoery/Web-Content/all-inclusive.txt

# DEBUGGERS
sudo wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# CONFIGURE FTP SERVER ALLOW DOWNLOADS ONLY
sudo apt-get install vsftpd -y
sudo mkdir -p /var/ftp/public
sudo chown nobody:nogroup /var/ftp/public
sudo useradd ftpsecure
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
sudo echo '# VSFTP SERVER ANONYMOUS DOWNLOADS' > /etc/vsftpd.conf
sudo echo "listen=YES" >> /etc/vsftpd.conf
sudo echo "listen_ipv6=NO" >> /etc/vsftpd.conf
sudo echo "anonymous_enable=YES" >> /etc/vsftpd.conf
sudo echo "local_enable=NO" >> /etc/vsftpd.conf
sudo echo "write_enable=NO" >> /etc/vsftpd.conf
sudo echo "local_umask=022" >> /etc/vsftpd.conf
sudo echo "anon_upload_enable=NO" >> /etc/vsftpd.conf
sudo echo "anon_mkdir_write_enable=NO" >> /etc/vsftpd.conf
sudo echo "anon_other_write_enable=NO" >> /etc/vsftpd.conf
sudo echo "dirmessage_enable=YES" >> /etc/vsftpd.conf
sudo echo "use_localtime=YES" >> /etc/vsftpd.conf
sudo echo "xferlog_enable=YES" >> /etc/vsftpd.conf
sudo echo "connect_from_port_20=YES" >> /etc/vsftpd.conf
sudo echo "chown_uploads=YES" >> /etc/vsftpd.conf
sudo echo "chown_username=nobody" >> /etc/vsftpd.conf
sudo echo "xferlog_file=/var/log/vsftpd.log" >> /etc/vsftpd.conf
sudo echo "idle_session_timeout=60" >> /etc/vsftpd.conf
sudo echo "data_connection_timeout=120" >> /etc/vsftpd.conf
sudo echo "accept_timeout=60" >> /etc/vsftpd.conf
sudo echo "connect_timeout=60" >> /etc/vsftpd.conf
sudo echo "nopriv_user=ftpsecure" >> /etc/vsftpd.conf
sudo echo "async_abor_enable=YES" >> /etc/vsftpd.conf
sudo echo "ascii_upload_enable=NO" >> /etc/vsftpd.conf
sudo echo "ascii_download_enable=NO" >> /etc/vsftpd.conf
sudo echo "ftpd_banner=FTP Anonymous Download Server" >> /etc/vsftpd.conf
sudo echo "anon_root=/var/ftp/public/" >> /etc/vsftpd.conf
sudo echo "no_anon_password=YES" >> /etc/vsftpd.conf
sudo echo "anon_max_rate=30000" >> /etc/vsftpd.conf
sudo echo "hide_ids=YES" >>/etc/vsftpd.conf
sudo echo "pasv_min_port=40000" >> /etc/vsftpd.conf
sudo echo "pasv_max_port=42000" >> /etc/vsftpd.conf
sudo echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf
sudo echo "pam_service_name=vsftpd" >> /etc/vsftpd.conf
sudo echo "ls_recurse_enable=NO" >> /etc/vsftpd.conf
sudo echo "utf8_filesystem=YES" >> /etc/vsftpd.conf
sudo echo "one_process_model=YES" >> /etc/vsftpd.conf
sudo echo "ssl_enable=NO" >> /etc/vsftpd.conf
sudo echo "rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/vsftpd.conf
sudo echo "rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/vsftpd.conf
sudo systemctl enable vsftpd
sudo systemctl start vsftpd

# BASH PROFILES
sudo  ln -sf /dev/null /root/.bash_history
ln -sf /dev/null /home/kali/.bash_history

sed -i 's/HISTSIZE=1000/HISTSIZE=10000/g' /home/kali/.bashrc
sed -i 's/HISTFILESIZE=2000/HISTSIZE=20000/g' /home/kali/.bashrc
sudo sed -i 's/HISTSIZE=1000/HISTSIZE=10000/g' /root/.bashrc
sudo sed -i 's/HISTFILESIZE=2000/HISTSIZE=20000/g' /root/.bashrc
echo 'export EDITOR="vim"' >> /home/kali/.bashrc
echo 'export VISUAL="vim"' >> /home/kali/.bashrc
echo 'NMAP="/usr/share/nmap/scripts"' >> /home/kali/.bashrc
echo 'IMPACKET="/usr/share/doc/python3-impacket/examples"' >> /home/kali/.bashrc

sudo cp /home/kali/.bashrc /root/
sudo cp /home/kali/.profile /root/

sudo mkdir -p /root/HTB/Boxes
sudo mkdir /root/HTB/Challenges
sudo mkdir /root/HTB/Labs
sudo mkdir /media/hgfs

echo "Creating bash aliases"
# Bash Aliases
sudo echo "alias ls='ls --color=auto'" > /root/.bash_aliases
sudo echo "alias dir='dir --color=auto'" >> /root/.bash_aliases
sudo echo "alias vdir='vdir --color=auto'">> /root/.bash_aliases
sudo echo "alias grep='grep --color=auto'" >> /root/.bash_aliases
sudo echo "alias fgrep='fgrep --color=auto'" >> /root/.bash_aliases
sudo echo "alias egrep='egrep --color=auto'" >> /root/.bash_aliases
sudo echo "alias ll='ls -la'" >> /root/.bash_aliases
sudo echo "alias la='ls -lashF'" >> /root/.bash_aliases
sudo echo "alias l='ls -CF'" >> /root/.bash_aliases
sudo echo "alias cd..='cd ..'" >> /root/.bash_aliases
sudo echo "alias cls='clear'" >> /root/.bash_aliases
sudo echo "alias pyhton='python'" >> /root/.bash_aliases
sudo echo "alias pyhton3='python3'" >> /root/.bash_aliases

echo "alias ls='ls --color=auto'" > /home/kali/.bash_aliases
echo "alias dir='dir --color=auto'" >> /home/kali/.bash_aliases
echo "alias vdir='vdir --color=auto'">> /home/kali/.bash_aliases
echo "alias grep='grep --color=auto'" >> /home/kali/.bash_aliases
echo "alias fgrep='fgrep --color=auto'" >> /home/kali/.bash_aliases
echo "alias egrep='egrep --color=auto'" >> /home/kali/.bash_aliases
echo "alias ll='ls -la'" >> /home/kali/.bash_aliases
echo "alias la='ls -lashF'" >> /home/kali/.bash_aliases
echo "alias l='ls -CF'" >> /home/kali/.bash_aliases
echo "alias cd..='cd ..'" >> /home/kali/.bash_aliases
echo "alias cls='clear'" >> /home/kali/.bash_aliases
echo "alias pyhton='python'" >> /home/kali/.bash_aliases
echo "alias pyhton3='python3'" >> /home/kali/.bash_aliases
sudo chown kali:kali /home/kali/.bash_aliases

sudo systemctl stop nfs-server.service
sudo systemctl disable nfs-server.service

cd /root
sudo git clone https://github.com/tobor88/Bash
cd Bash
sudo chmod u+x *.sh
files=$(ls "*.sh")
sudo for f in $files; do cp "$f" /usr/local/bin/"${f%.sh}"; done
sudo ssh-keygen -b 4096 -t rsa -f /root/.ssh
su -c "ssh-keygen -b 4096 -t rsa -f /home/kali/.ssh" kali
echo 'Running ghidra for the first time. Enter the following location for the JDK install: /usr/share/jdk-11.0.7+10'
bash /opt/ghidra_*_PUBLIC/ghidraRun
source ~/.bashrc
source ~/.profile

sudo updatedb

# Computer needs a restart after docker-compose is installed
# DOCKER INSTALLS
sudo apt-get install docker -y
sudo apt-get install docker.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo apt-get install docker-compose -y
