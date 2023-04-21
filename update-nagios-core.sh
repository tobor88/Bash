#!/bin/bash
START_DIR=$(pwd)
USAGE="
#===============================================#
#   ___     _                      ___          #
#  / _ \ __| |__  ___ _ _ _ _  ___| _ \_ _ ___  #
# | (_) (_-< '_ \/ _ \ '_| ' \/ -_)  _/ '_/ _ \ #
#  \___//__/_.__/\___/_| |_||_\___|_| |_| \___/ #
#-----------------------------------------------#
#      If you can't beat 'em, tech 'em!         #
#===============================================#
COMMAND:
    $0 v1.0 ( https://osbornepro.com/ )

SYNTAX:
    $0 [-h] -v <new version number>

DESCRIPTION:
    Used to update Nagios Core version 4.4.x to the version number that you specify

USAGE:
    $0 -v <string format is #.#.#>

OPTIONS:
    -h : Displays the help information for the command.
    -v : Set the new version to upgrade Nagios too

EXAMPLES:
    $0 -v 4.4.11
    # This example upgrades Nagios Core to verions 4.4.11

"

function allow_ctrlc {

        # Allow Ctrl+C to kill pingsweep
        trap '
          trap - INT # restore default INT handler
          kill -s INT "$$"
        ' INT

}  # End function allow_ctrlc


function print_usage {

        printf "$USAGE\n" >&2
        exit 1

}  # End function print_usage

if [[ "$1" == *"4.4."* ]]; then
    /bin/echo "[*] Nagios Core version compatible"
else
    /bin/echo "[x] Nagios Core Version required is 4.4.x"
    print_usage
fi

while [ ! -z "$1" ]; do
        case "$1" in
                -v)
                    shift
                    NEWVERSION=$1
                    ;;
                *)
                        print_usage
                    ;;
        esac
shift
done


echo "[*] Stopping Nagios service to change files"
systemctl stop nagios.service


CURRENTVERSION=$(/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg | grep -m 1 Nagios\ Core | cut -d' ' -f 3)
echo "[*] Downloading the latest version $NEWVERSION"
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-${NEWVERSION}.tar.gz -O /tmp/nagios-${NEWVERSION}.tar.gz


echo "[*] Extracting the downloaded compressed archive file"
tar xzf /tmp/nagios-${NEWVERSION}.tar.gz -C /usr/local/nagios-${NEWVERSION}


echo "[*] Getting the Nagios group and username"
NAGIOSGROUP=$(grep nagios_group /usr/local/nagios/etc/nagios.cfg | cut -d= -f 2)
NAGIOSUSER=$(grep nagios_user /usr/local/nagios/etc/nagios.cfg | cut -d= -f 2)


echo "[*] Build compilation files with nagios group ${NAGIOSGROUP}"
cd /usr/local/nagios-${NEWVERSION}
/usr/local/nagios-${NEWVERSION}/configure --with-command-group=${NAGIOSGROUP}
make all
make install


echo "[*] Rename the current nagios directory for backup. Waiting 10 seconds for opertaion to complete"
mv /usr/local/nagios /usr/local/nagios-${CURRENTVERSION}
sleep 10s


echo "[*] Rename the newly downloaded directory to the expected Nagios location"
mv /usr/local/nagios-${NEWVERSION} /usr/local/nagios
cp -r /usr/local/nagios-${CURRENTVERSION}/etc /usr/local/nagios/
cp -r /usr/local/nagios-${CURRENTVERSION}/share /usr/local/nagios/
cp -r /usr/local/nagios-${CURRENTVERSION}/bin /usr/local/nagios/
cp -r /usr/local/nagios-${CURRENTVERSION}/sbin /usr/local/nagios/
cp -r /usr/local/nagios-${CURRENTVERSION}/libexec /usr/local/nagios/
cp -r /usr/local/nagios-${CURRENTVERSION}/nagiosgraph /usr/local/nagios/
cp -r /usr/local/nagios-${CURRENTVERSION}/var /usr/local/nagios/


/bin/echo "[*] Verifying file counts in old and new directory"
OLDCOUNT=$(ls -1 /usr/local/nagios-${CURRENTVERSION}/ | wc -l)
NEWCOUNT=$(ls -1 /usr/local/nagios | wc -l)
if [ $OLDCOUNT == $NEWCOUNT ]; then
    /bin/echo "[*] The number of files in the old directory matches the current directory count]"
else
    /bin/echo "[!] The number of files in the old directory is different than the new directory"
fi


echo "[*] Setting group and username permissions"
chown -R ${NAGIOSUSER}:${NAGIOSGROUP} /usr/local/nagios

# UNCOMMENT THIS IF YOU ARE USING NAGIOS BPI ADD ON
#echo "[*] Update NagiosBPI permissions"
#chmod +x /usr/local/nagios/share/nagiosbpi/set_bpi_perms.sh
#cd /usr/local/nagios/share/nagiosbpi
#./set_bpi_perms.sh


/bin/echo "[*] Verifying configuration"
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg


/bin/echo "[*] Resarting Nagios services"
/bin/systemctl restart nagios.service httpd.service mariadb.service ndo2db.service


/bin/echo "[*] Removing temporary files"
/bin/rm -rf -- /tmp/nagios-${NEWVERSION}.tar.gz
/bin/cd $START_DIR
