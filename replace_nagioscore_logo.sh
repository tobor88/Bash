#!/bin/bash
# This script is used to replace the logo used on a Nagios Core servers web GUI with your own image

USAGE="
SYNTAX: $0 [-h] -u <url> | [ -f <file> ]

DESCRIPTION:
   This script is used to replace the Nagios Core web GUI logo with your company logo

REQUIREMENTS:
   1.) Access to a website hosting or a file location for your company logo
   2.) Wget or Curl command to download files
   3.) PNG file type logo
   4.) Not required but for asthetics the dimensions should be 142x40

CONTACT INFORMATION
   Company: OsbornePro LLC.
   Website: https://osbornepro.com
   Author: Robert H, Osborne
   Contact: rosborne@osbornepro.com

USAGE: $0 [-u <url>] [-f <file path>]

    OPTIONS:
        -h : Displays the help information for the command.
        -u : Set the URL to download your logo file from
        -f : Set the path to your logo file

    EXAMPLES:
        $0 -u https://customwebsite.domain.com/your-logo.png
        # This example replaces the Nagios Core logo with a company logo downloaded from https://customwebsite.domain.om/your-logo.png

        $0 -f ~/Pictures/logo.png
        # This example replaces the Nagios Core logo with a company logo using the file ~/Pictures.logo.png

"

# VARIABLES
NAGIOSLOGOFILES=("/usr/local/nagios/html/images/sblogo.png" "/usr/local/nagios/share/images/sblogo.png" "/var/www/html/images/sblogo.png" "/usr/local/nagios/html/images/logofullsize.png" "/usr/local/nagios/share/images/logofullsize.png" "/var/www/html/images/logofullsize.png")
DLFILE="/tmp/company-logo.png"

# FUNCTIONS
function allow_ctrlc {

        # Allow Ctrl+C to stop execution
        trap '
          trap - INT # restore default INT handler
          kill -s INT "$$"
        ' INT

}  # End function allow_ctrlc

function print_usage {

        printf "$USAGE\n" >&2
        exit 1

}  # End function print_usage

function get_download_command {

        if which wget > /dev/null; then
                wget --no-check-certificate $URL -O $DLFILE

        elif which curl > /dev/null; then
                curl -skL $URL -O $DLFILE
        else
                printf "[x] You do not have a way to download your image file. Install wget or curl and try again. \n"
                exit 1
        fi

}  # End function get_download_command

function verify_file_type {

        FILEID=$(file $DLFILE | cut -d" " -f2)
        if [ "$FILEID" != "PNG" ]; then
                printf "[x] You are required to use a PNG file type \n"
                exit 1
        fi

}  # End function verify_type

function backup_nagios_logo {

        if [ -f "$NAGIOSLOGOFILES" ]; then
                printf "[*] Backing up original Nagios Core logo files \n"
                for F in "${NAGIOSLOGOFILES[@]}"; do
                        cp "${F}" "${F}.bak"
                done
        else
                printf "[x] Expected sblogo.png Nagios Logo file was not found at  \n"
                exit 1
        fi

}  # End function backup_nagios_logo

function update_logo {

        if [ -f $DLFILE ]; then
                printf "[*] Updating the Nagios Core web GUI logo with your image \n"
                for F in "${NAGIOSLOGOFILES[@]}"; do
                        cp "${DLFILE}" "${F}"
                done

        elif [ -f $LOGOFILE ]; then
                printf "[*] Updating the Nagios Core web GUI logo with your image \n"
                for F in "${NAGIOSLOGOFILES[@]}"; do
                        cp "${LOGOFILE}" "${F}"
                done
        else
                printf "[x] Unable to find the replacement logo file \n"
        fi

}  # End function update_logo

function file_cleanup {
	
	if [ -f $DLFILE ]; then
		rm -rf $DLFILE
	fi

}  # End function file_cleanup


# EXECUTION
while [ ! -z "$1" ]; do
        case "$1" in
                -u)
                        shift
                        URL=$1
                        get_download_command
                        wait
                        verify_file_type
                        ;;
                -f)
                        shift
                        LOGOFILE=$1
                        ;;
                *)
                        print_usage
                        ;;
        esac
shift
done

allow_ctrlc
backup_nagios_logo
update_logo
file_cleanup
printf "[i] You will need to restart the hosting web service (apache,nginx,etc.) to display your new logo \n"
