#!/bin/bash
#=================#
# MASSNMP SCANNER #
#=================#
# This script is meant to enumerate snmpv1 and snmpv2c in a subnet range you define or a single host
#
# REQUIRES: snmp-check and onesixtyone. 
#--------------------------------------------------------
# Install these tools if you do not have them installed.
#--------------------------------------------------------
#   Debian/Ubuntu/Mint/Kali
#     sudo apt-get -y install onesixtyone snmpcheck 
#
#   Fedora/RHEL/CentOS
#	sudo dnf -y install onesixtyone
#	sudo wget http://www.nothink.org/codes/snmpcheck/snmpcheck-1.9.rb
#	sudo cp snmpcheck-1.9.rb /usr/local/bin/snmp-check; sudo chmod a+x /usr/local/bin/snmp-check
#	sudo gem install snmp

TMPPATH="/tmp"
IPV4REGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
USAGE="Syntax: $0 [-h] -n <network> [[[-s <int32: solo/start address>]] [-e <int32: end address>]] -v <int32: <snmp version> [-f <string: community string file>]

OsbornePro massnmp v1.1 ( https://osbornepro.com )

IMPORTANT!!!
    This command requires the tools 'onesixtyone' and 'snmpcheck'
    Installs these tools if you do not have them installed.

    USAGE: massnmp -n <string format is #.#.#> [[[-s <solo/start address>]] [-e <end address>]] -v <int32: <snmp version> [-f <string: community string list file>]

    OPTIONS:
        -h : Displays the help information for the command.
	-n : Set the network subnet to perform the ping sweep on
	-s : Set the solo or starting IP Address to begin the scan from
	-e : Set the ending IP Address to scan too
	-v : Define the version of SNMP to use [1|2c]
	-f : Define the path to a file containing a list of community strings. 
		(If -f is not defined common community string names will be tried)

    EXAMPLES:
          massnmp -n 192.168.0 -v 2c
            # This example scans SNMP version 2c from 192.168.0.1 to 192.168.0.254 testing 121 common community strings

          massnmp -n 192.168.0 -s 200 -v1
            # This example scans SNMP version 1 on 192.168.0.200

	  massnmp -n 192.168.0 -s 128 -e 192 -v 2c -f /tmp/community.txt
	    # This example scans SNMP version 2c from 192.168.0.128 to 192.168.0.192 using a custom list in /tmp/community.txt

"



function allow_ctrlc {

	# Allow Ctrl+C to kill massnmp
	trap '
	  trap - INT # restore default INT handler
	  kill -s INT "$$"
	' INT

}  # End function allow_ctrlc


function print_usage {

	printf "$USAGE\n" >&2
	exit 1

}  # End function print_usage	


function verify_tools {
	# Ensure the required binaries are usable
	if ! command -v onesixtyone &> /dev/null; then
		printf "[x] Requires onesixtyone and snmp-check to run. 
Install using below commands:

  Debian/Ubuntu/Mint/Kali
    CMD:  sudo apt-get -y install onesixtyone snmpcheck 

  Fedora/RHEL/CentOS
    CMD: sudo wget http://www.nothink.org/codes/snmpcheck/snmpcheck-1.9.rb
    CMD: sudo cp snmpcheck-1.9.rb /usr/local/bin/snmp-check; sudo chmod a+x /usr/local/bin/snmp-check
    CMD: sudo gem install snmp\n"
		    exit 1
	elif ! command -v snmp-check &> /dev/null; then
		printf "[x] Requires snmp-check to run. 
Install using below commands

  Debian/Ubuntu/Mint/Kali
    CMD:  sudo apt-get -y install snmpcheck 

  Fedora/RHEL/CentOS
    CMD: sudo wget http://www.nothink.org/codes/snmpcheck/snmpcheck-1.9.rb
    CMD: sudo cp snmpcheck-1.9.rb /usr/local/bin/snmp-check; sudo chmod a+x /usr/local/bin/snmp-check
    CMD: sudo gem install snmp\n"
		exit 1
	else
		return 1
	fi

}

function validate_start {
	
	# Validate start parameter is an integer between 1 and 254
	if [ -z "$start" ]; then
		START=1
	elif [ "$start" -lt 255 ] && [ "$start" -ge 1 ] || ERROR="Start parameter needs to be an integer between 1 and 254"; then
		if [ ! $ERROR ]; then
			START=$start
		else
			printf "$ERROR\n"
			exit 1
		fi
	fi

}  # End function validate_start


function validate_end {
	# Validate positional parameter 3 is an integer between $2 and 254
	if [ -z $end ] && [ -z $start ] ; then
		END=254
	elif [ -z $end ] && [ -n $start ]; then
		END=$start
	elif [ "$end" -lt 255 ] && [ "$end" -ge "$start" ] || ERROR="Last ending IP address needs to be an integer between the value of $start and 254"; then
		if [ ! $ERROR ]; then
			END=$end
		else
			printf "$ERROR\n"
			exit 1
		fi
	fi

}  # End function validate_end


function validate_ipv4 {
	# Verifying $ipv4 value"
	if [[ "$ipv4" =~ "$IPV4REGEX" ]] || IPERROR="Valid IP subnet was not defined. For more help execute 'massnmp -h' Example 172.16.32 "; then
		if [ ! "$IPERROR" ]; then
			printf "[x] A valid network value was not defined, you entered $ipv4. Used -h for more info. Example: 172.16.0\n"
			exit 1
		fi
	fi

}  # End function validate_ipv4


function validate_snmp_version {
	# Ensures a valid SNMP version was selected
	case $version in
		"1")
			printf "[*] Using SNMP version $version \n"
			;;
		"2c")	printf "[*] Using SNMP version $version \n"
			;;
		*)
			printf "[x] SNMP version (-v) must be 1 or 2c\n"
		        exit 1	
			;;
	esac
}


function create_community_list {
	# Create community list
	if [ ! -f "$file" ]; then
		CLIST="/tmp/community.lst"
		echo $'private\npublic\nmanagerpublic\n0\n0392a0\n1234\n2read\n4changes\nANYCOM\nAdmin\nC0de\nCISCO\nCR52401\nIBM\nILMI\nIntermec\nNoGaH$@!\nOrigEquipMfr\nPRIVATE\nPUBLIC\nPrivate\nPublic\nSECRET\nSECURITY\nSNMP\nSNMP_trap\nSUN\nSWITCH\nSYSTEM\nSecret\nSecurity\ns!a@m#n$p%c\nSwitch\nSystem\nTENmanUFactOryPOWER\nTEST\naccess\nadm\nadmin\nagent\nagent_steal\nall\nall private\nall public\napc\nbintec\nblue\nc\ncable-d\ncanon_admin\ncc\ncisco\ncommunity\ncore\ndebug\ndefault\ndilbert\nenable\nfield\nfield-service\nfreekevin\nfubar\nguest\nhello\nhp_admin\nibm\nilmi\nintermec\ninternal\nl2\nl3\nmanager\nmngt\nmonitor\nnetman\nnetwork\nnone\nopenview\npass\npassword\npr1v4t3\nproxy\npubl1c\nread\nread-only\nread-write\nreadwrite\nred\nregional\nrmon\nrmon_admin\nro\nroot\nrouter\nrw\nrwa\nsan-fran\nsanfran\nscotty\nsecret\nsecurity\nseri\nsnmp\nsnmpd\nsnmptrap\nsolaris\nsun\nsuperuser\nswitch\nsystem\ntech\ntest\ntest2\ntiv0li\ntivoli\ntrap\nword\nwrite\nxyzzy\nyellow' > $CLIST
		printf "[*] Using 121 of the most common SNMP community strings defined in $CLIST\n"
	else
		CLIST="$file"
		printf "[*] Using the community list defined in $CLIST\n"
	fi
}


function create_ipv4_list {
	# Create file containing desired ipv4 address range if it doesnt exist
	for ip in $(seq $START $END); do 
	    echo $ipv4.$ip
	done  > /tmp/ip.lst
}


function discover_snmp_hosts {
	# Discovering SNMP enabled hosts
	printf "[*] Discovering SNMP enabled hosts\n"
	onesixtyone -c "$CLIST" -i "$TMPPATH/ip.lst" -o "$TMPPATH/snmp_hosts.txt" 1>/dev/null
		
	SNMP_HOSTS=$(cat "$TMPPATH/snmp_hosts.txt" | awk {'print $1 $2'} | sort | uniq)
	printf "\n#====================#\n|   SNMP Discovery   |\n#====================#\n"
	echo $SNMP_HOSTS

	printf "\nEnumerating SNMP info from discovered devices. Please wait...\n"
	for i in $(/usr/bin/cat /tmp/snmp_hosts.txt | /usr/bin/awk {'print $1'}); do 
		IP=($(/usr/bin/cat /tmp/snmp_hosts.txt | /usr/bin/awk {'print $1'}))
		COMMUNITY=($(cat "$TMPPATH/snmp_hosts.txt" | awk {'print $2'} | tr -d '[]'))

		snmp-check -c $COMMUNITY -p 161 -v1 $IP > "$i-snmp$version.txt" 2>&1 || snmp-check -c $COMMUNITY -p 161 -v2c $IP > "$i-snmp$version.txt" 2>&1
	done

	printf "\n[*] OneSixtyOne Results\n"
	cat "$TMPPATH/snmp_hosts.txt" | sort | uniq
	printf "\n[*] View Detailed SNMP Info in Below Files\n"
	ls *-snmp$version.txt
}

function remove_files {
	# Removes files that were created to run commands
	rm -rf "$TMPPATH/ip.lst" "$TMPPATH/snmp_hosts.txt"
}


while [ ! -z "$1" ]; do
	case "$1" in
		-n)
		        shift
			ipv4=$1
			;;
		-s)
			shift
			start=$1
			;;
		-e)
			shift
			end=$1
			;;
		-v)	shift
			version=$1
			;;
		-f)	shift
			file=$1
			;;
		*)
			print_usage
			;;
	esac
shift
done


allow_ctrlc
verify_tools
validate_ipv4
validate_start
validate_end
validate_snmp_version
create_community_list
create_ipv4_list
discover_snmp_hosts
