# I do my best to keep this updated with tools I use so rebuilding a Kali ISO doesn't take all day
# Script runtime is about 20 minutes. If you have ideas to make this even faster feel free to contribute 
# Kali cant run this as a script. Copy and paste everything all at once.
# Last Tested on Kali 2020.2 on May 14 2020

echo "Setup Burpsuite CA Certificate and set 'Enable Interception at Startup' to 'Always Disable'"

# SERVICES
gzip -d /usr/share/wordlists/rockyou.txt.gz
msfdb init
sudo systemctl enable postgresql

# PIP INSTALLS 
sudo apt install cmake -y
sudo apt install gdb -y
sudo apt install python-setuptools -y
sudo apt install python3-setuptools -y
sudo apt install python-dev -y
sudo apt install python3-pip -y
sudo apt install python-pip -y
sudo apt install seclists -y
python -m easy_install pip
pip install wheel
pip install keystone-engine
pip install capstone
pip install unicorn
pip install ropper
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
pip3 install stegcracker 
pip install ssh
pip install webapp2
pip install lxml
pip install ssl
pip install pycrypto
pip install virtualenv
pip install cme
pip install bloodhound
pip3 install virtualenv
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

# APT INSTALLS
sudo apt install tmux -y
sudo apt install hashcat -y
sudo apt install git -y
sudo apt install vim -y
sudo apt install beef -y
sudo apt install ncat -y
sudo apt install stoken -y
sudo apt install recon-ng -y
sudo apt install checksec -y
sudo apt install reaver -y
sudo apt install guake -y
sudo apt install wifite -y
sudo apt install kismet -y
sudo apt install crunch -y
sudo apt install cewl -y
sudo apt install jxplorer -y
sudo apt install smbmap -y
sudo apt install armitage -y
sudo apt install wfuzz -y
sudo apt install nfs-kernel-server -y
sudo apt install sqlmap -y
sudo apt install putty-tools -y
sudo apt install httptunnel -y
sudo apt install exiftool -y
sudo apt install gdbserver -y
sudo apt install qemu-utils -y
sudo apt install libcurl4-openssl-dev
sudo apt install steghide -y
sudo apt install evil-ssdp
sudo apt install dnschef -y
sudo apt install mingw-w64 -y
sudo apt install smtp-user-enum -y 
sudo apt install samdump2 -y
sudo apt install lftp -y
sudo apt install python3-pip -y
sudo apt install responder -y
sudo apt install unicornscan -y
sudo apt install crackmapexec -y
sudo apt install shellter -y
sudo apt install wpscan -y
sudo apt install nbtscan -y
sudo apt install firewalk -y
sudo apt install hping3 -y
sudo apt install gobuster -y
sudo apt install rlwrap -y
sudo apt install docker -y
sudo apt install docker.io -y
sudo apt install neo4j -y
sudo apt install bloodhound -y
sudo apt install wfuzz -y
sudo apt install ident-user-enum -y
sudo apt install cargo -y
sudo apt install npm -y
sudo apt install npm --fix-broken -y
npm install -g sql-cli
sudo apt install powershell -y
sudo apt install golang -y
sudo go get github.com/ffuf/ffuf
sudo cp /root/go/bin/ffuf /usr/local/bin/ffuf

# EMPIRE
cd /opt
sudo git clone https://github.com/EmpireProject/Empire.git
sudo /opt/Empire/setup/install.sh

# GHIDRA
wget https://ghidra-sre.org/ghidra_9.1.2_PUBLIC_20200212.zip 
unzip /opt/ghidra_9.1.2_PUBLIC_20200212.zip
wget https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz
tar xzvf OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz -C /usr/share/

# TMUX 
cd /opt
sudo touch /root/.tmux.conf
git clone https://github.com/tmux-plugins/tmux-logging.git
echo "set -g history-limit 50000" >> ~/.tmux.conf
echo "set -g allow-rename off" >> ~/.tmux.conf
echo " " >> ~/.tmux.conf
echo -en "bind-key j command-prompt -p \"join pane from:\" \"join-pane -s \'%%\'\"\n" >> ~/.tmux.conf
echo -en "bind-key s command-prompt -p \"join pane to:\" \"join-pane -t '%%'\"" >> ~/.tmux.conf
echo " " >> ~/.tmux.conf
echo "set-window-option -g mode-keys vi" >> ~/.tmux.conf
echo "run-shell /opt/tmux-logging/logging.tmux" >> ~/.tmux.conf
echo " " >> ~/.tmux.conf
echo "set -g @plugin 'tmux-plugins/tmux-logging'" >> ~/.tmux.conf
echo " " >> ~/.tmux.conf
echo -en "set -g default-terminal \"screen-256color\"\n" >> ~/.tmux.conf
echo "" >> ~/.tmux.conf
echo 'run-shell /opt/tmux-logging/logging.tmux' >> ~/.tmux.conf

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
sudo git clone https://github.com/tennc/fuzzdb.git &
sudo git clone https://boringssl.googlesource.com/boringssl
sudo git clone --recursive https://github.com/cloudflare/quiche
cd quiche
cargo build --examples
QUICHE_BSSL_PATH="/usr/share/boringssl" cargo build --examples
cd /usr/share/
sudo git clone https://github.com/frohoff/ysoserial.git
sudo git clone https://github.com/Tib3rius/AutoRecon.git
sudo git clone https://github.com/trickster0/Enyx.git
cp /usr/share/Enyx/enyx.py /usr/local/bin/enyx
chmod a+x /usr/local/bin/enyx
sudo git clone https://github.com/superkojiman/rfishell.git
sudo git clone https://github.com/ccavxx/Kadimus.git
sudo git clone https://github.com/pwntester/ysoserial.net.git
sudo git clone https://github.com/Hackplayers/evil-winrm.git
ln -sf /usr/share/AutoRecon/autorecon.py /usr/local/bin/autorecon

# WINDOWS RESOURCES
cd /usr/share/windows-resources
git clone https://github.com/besimorhino/powercat.git
git clone https://github.com/trustedsec/unicorn.git
git clone https://github.com/irsdl/IIS-ShortName-Scanner
git clone https://github.com/peewpw/Invoke-WCMDump.git
git clone https://github.com/rasta-mouse/Sherlock.git
git clone https://github.com/rasta-mouse/Watson.git
git clone https://github.com/cyberark/RiskySPN.git
git clone https://github.com/EliteLoser/Invoke-PsExec.git
git clone https://github.com/ZilentJack/Spray-Passwords.git
git clone https://github.com/fox-it/BloodHound.py.git
git clone https://github.com/AonCyberLabs/Windows-Exploit-Suggester.git
git clone https://github.com/bitsadmin/wesng.git
git clone https://github.com/tobor88/ReversePowerShell.git
git clone https://github.com/tobor88/PowerShell-Red-Team.git
git clone https://github.com/TsukiCTF/Lovely-Potato.git
git clone https://github.com/SecWiki/windows-kernel-exploits.git
git clone https://github.com/Arvanaghi/SessionGopher.git
git clone https://github.com/411Hall/JAWS.git
git clone https://github.com/davehardy20/sysinternals.git
git clone https://github.com/AlessandroZ/BeRoot.git
sudo mkdir /usr/share/linux-resources/BeRoot
sudo mv /usr/share/windows-resources/BeRoot/Linux/* /usr/share/linux-resources/BeRoot/
sudo mv /usr/share/windows-resources/BeRoot/Windows/* /usr/share/windows-resources/BeRoot/
sudo rm -r /usr/share/windows-resources/BeRoot/Windows/
sudo rm -r /usr/share/windows-resources/BeRoot/Linux/

# LINUX RESOURCES
sudo mkdir /usr/share/linux-resources
cd /usr/share/linux-resources
git clone https://github.com/mzet-/linux-exploit-suggester.git
git clone https://github.com/rebootuser/LinEnum.git
git clone https://github.com/DominicBreuker/pspy.git
git clone https://github.com/jondonas/linux-exploit-suggester-2.git
git clone https://github.com/saghul/lxd-alpine-builder.git
/usr/share/linux-resources/lxd-alpine-builder/build-alpine
cp /usr/share/linux-resources/lxd-apline/builder/alpine-v*.tar.gz /var/www/html/
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
sudo mv privilege-escalation-awesome-scripts-suite/linPEAS/ /usr/share/linux-resources/
sudo mv privilege-escalation-awesome-scripts-suite/winPEAS/ /usr/share/windows-resources/
sudo cp privilege-escalation-awesome-scripts-suite/README.md /usr/share/windows-resources/
sudo cp privilege-escalation-awesome-scripts-suite/README.md /usr/share/linux-resources/
sudo rm -r -- /usr/share/linux-resources/privilege-escalation-awesome-scripts-suite

# WEBSHELLS
cd /usr/share/webshells/php
git clone https://github.com/flozz/p0wny-shell.git
git clone https://github.com/WhiteWinterWolf/wwwolf-php-webshell.git
git clone https://github.com/jgor/php-jpeg-shell.git
git clone https://github.com/epinna/weevely3.git

# APACHE2 SITE
cd /var/www
git clone https://github.com/tobor88/PayloadSiteForPenTesters.git
sudo cp /var/www/PayloadSiteForPenTesters/* /var/www/html/
cp /usr/share/windows-resources/Lovely-Potato/* /var/www/html/

# WORDLISTS
echo "Building all inclusive wordlist for URL fuzzing"
cp /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt /usr/share/seclists/Discovery/Web-Content/
ls /usr/share/seclists/Discovery/Web-Content/*.txt | cut -d' ' -f2 |  sort -u  > all-inclusive.txt

# DEBUGGERS
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# CONFIGURE FTP SERVER ALLOW DOWNLOADS ONLY
sudo apt install vsftpd -y
mkdir -p /var/ftp/public
sudo chown nobody:nogroup /var/ftp/public
sudo useradd ftpsecure
cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
echo '# VSFTP SERVER ANONYMOUS DOWNLOADS' > /etc/vsftpd.conf
echo "listen=YES" >> /etc/vsftpd.conf
echo "listen_ipv6=NO" >> /etc/vsftpd.conf
echo "anonymous_enable=YES" >> /etc/vsftpd.conf
echo "local_enable=NO" >> /etc/vsftpd.conf
echo "write_enable=NO" >> /etc/vsftpd.conf
echo "local_umask=022" >> /etc/vsftpd.conf
echo "anon_upload_enable=NO" >> /etc/vsftpd.conf
echo "anon_mkdir_write_enable=NO" >> /etc/vsftpd.conf
echo "anon_other_write_enable=NO" >> /etc/vsftpd.conf
echo "dirmessage_enable=YES" >> /etc/vsftpd.conf
echo "use_localtime=YES" >> /etc/vsftpd.conf
echo "xferlog_enable=YES" >> /etc/vsftpd.conf
echo "connect_from_port_20=YES" >> /etc/vsftpd.conf
echo "chown_uploads=YES" >> /etc/vsftpd.conf
echo "chown_username=nobody" >> /etc/vsftpd.conf
echo "xferlog_file=/var/log/vsftpd.log" >> /etc/vsftpd.conf
echo "idle_session_timeout=60" >> /etc/vsftpd.conf
echo "data_connection_timeout=120" >> /etc/vsftpd.conf
echo "accept_timeout=60" >> /etc/vsftpd.conf
echo "connect_timeout=60" >> /etc/vsftpd.conf
echo "nopriv_user=ftpsecure" >> /etc/vsftpd.conf
echo "async_abor_enable=YES" >> /etc/vsftpd.conf
echo "ascii_upload_enable=NO" >> /etc/vsftpd.conf
echo "ascii_download_enable=NO" >> /etc/vsftpd.conf
echo "ftpd_banner=FTP Anonymous Download Server" >> /etc/vsftpd.conf
echo "anon_root=/var/ftp/public/" >> /etc/vsftpd.conf
echo "no_anon_password=YES" >> /etc/vsftpd.conf
echo "anon_max_rate=30000" >> /etc/vsftpd.conf
echo "hide_ids=YES" >>/etc/vsftpd.conf
echo "pasv_min_port=40000" >> /etc/vsftpd.conf
echo "pasv_max_port=42000" >> /etc/vsftpd.conf
echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf
echo "pam_service_name=vsftpd" >> /etc/vsftpd.conf
echo "ls_recurse_enable=NO" >> /etc/vsftpd.conf
echo "utf8_filesystem=YES" >> /etc/vsftpd.conf
echo "one_process_model=YES" >> /etc/vsftpd.conf
echo "ssl_enable=NO" >> /etc/vsftpd.conf
echo "rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/vsftpd.conf
echo "rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/vsftpd.conf
sudo systemctl enable vsftpd
sudo systemctl start vsftpd

# BASH PROFILES
ln -sf /dev/null /root/.bash_history
ln -sf /dev/null /home/kali/.bash_history

sed -i 's/HISTSIZE=1000/HISTSIZE=10000/g' /home/kali/.bashrc
sed -i 's/HISTFILESIZE=2000/HISTSIZE=20000/g' /home/kali/.bashrc
sudo sed -i 's/HISTSIZE=1000/HISTSIZE=10000/g' /root/.bashrc
sudo sed -i 's/HISTFILESIZE=2000/HISTSIZE=20000/g' /root/.bashrc
echo 'export EDITOR="vim"' >> /root/.bashrc
echo 'export VISUAL="vim"' >> /root/.bashrc
echo 'export EDITOR="vim"' >> /home/kali/.bashrc
echo 'export VISUAL="vim"' >> /home/kali/.bashrc
sudo cp /home/kali/.bashrc /root/
sudo cp /home/kali/.profile /root/

sudo mkdir /root/HTB
sudo mkdir /root/HTB/Boxes
sudo mkdir /root/HTB/Challenges
sudo mkdir /root/HTB/Labs
sudo mkdir /media/hgfs

echo "Creating bash aliases"
# Bash Aliases
echo "alias ls='ls --color=auto'" > /root/.bash_aliases
echo "alias dir='dir --color=auto'" >> /root/.bash_aliases
echo "alias vdir='vdir --color=auto'">> /root/.bash_aliases
echo "alias grep='grep --color=auto'" >> /root/.bash_aliases
echo "alias fgrep='fgrep --color=auto'" >> /root/.bash_aliases
echo "alias egrep='egrep --color=auto'" >> /root/.bash_aliases
echo "alias ll='ls -la'" >> /root/.bash_aliases
echo "alias la='ls -lashF'" >> /root/.bash_aliases
echo "alias l='ls -CF'" >> /root/.bash_aliases
echo "alias cd..='cd ..'" >> /root/.bash_aliases
echo "alias cls='clear'" >> /root/.bash_aliases
echo "alias pyhton='python'" >> /root/.bash_aliases
echo "alias pyhton3='python3'" >> /root/.bash_aliases

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
git clone https://github.com/tobor88/Bash
cd Bash
sudo chmod u+x *.sh
files=$(ls "*.sh")
for f in $files; do cp "$f" /usr/local/bin/"${f%.sh}"; done
sudo ssh-keygen -b 4096 -t rsa -f /root/.ssh
su -c "ssh-keygen -b 4096 -t rsa -f /home/kali/.ssh" kali
echo 'Running ghidra for the first time. Enter the following location for the JDK install: /usr/share/jdk-11.0.7+10'
bash /opt/ghidra_*_PUBLIC/ghidraRun

sudo updatedb

# Computer needs a restart after docker-compose is installed
sudo apt install docker-compose -y
