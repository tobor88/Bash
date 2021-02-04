#!/bin/bash
# CREATED ON: Linux kali 5.10.0-kali2-amd64 #1 SMP Debian 5.10.9-1kali1 (2021-01-22) x86_64 GNU/Linux
# This script is used to mount the Type 2 Hypervisor VMWare Workstation's "shared folder" to /media/hgfs/Shared
# The shared folder that gets mapped is the one configured by right clicking your VM in VMWare Worksations library > Going to Settings > Options tab > View the Shared Folder Setting
#
# NOTE: I made this on a Kali machine. If you wish to remove the absolute paths to the below commands issue the below command I have commented out which will update the file for working with different Linux Distros
# sed -i 's|/usr/bin/||g' MountDriveVMWworkstation.sh


if [ ! -d /media/hgfs ]; then
        /usr/bin/printf "Creating the folder /media/hgfs\n"
        /usr/bin/sudo /usr/bin/mkdir /media/hgfs && /usr/bin/chmod 555 /media/hgfs
fi


if [ ! -d /media/hgfs/Share ]; then
        /usr/bin/printf "Mounting Share to /media/hgfs/Share\n"
        /usr/bin/sudo /usr/bin/mount -t fuse.vmhgfs-fuse .host:/ /media/hgfs
else
        /usr/bin/printf "Share is already mapped to /media/hgfs\n"
fi
