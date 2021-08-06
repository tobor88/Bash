#!/bin/bash
# OsbornePro LLC.
#
# This was made to run as root on Linux Mint with Version info below. Other OS's may require different values
# Linux 5.4.0-74-generic #83-Ubuntu SMP Sat May 8 02:35:39 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
# Description:    Linux Mint 20.1
# Release:        20.1
# Codename:       ulyssa


USERFILES=$(/usr/bin/find / -user www-data 2>/dev/null)
GROUPFILES=$(/usr/bin/find / -group www-data 2>/dev/null)

/bin/echo "[*] Creating group 'apache' to be used by the apache2.service"
/usr/sbin/groupadd apache

/bin/echo "[*] Creating user 'apache' to be used by the apache2.service"
/usr/sbin/useradd apache -g apache -d /dev/null -s /usr/sbin/nologin

/bin/echo "[*] Changing group ownership permissions of apache directories"
for g in $GROUPFILES; do
    /bin/chgrp apache $g
done

/bin/echo "[*] Changing user ownership permissions of apache directories"
for u in $USERFILES; do
    /bin/chown apache $u
done

/bin/echo "[*] Replacing the www-data user in /etc/apache2/envvars with the newly created 'apache' user id"
/bin/sed -i 's/www-data/apache/g' /etc/apache2/envvars

/bin/echo "[*] Restarting the apache2 service"
/bin/systemctl restart apache2
