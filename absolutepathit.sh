#!/bin/bash


REGEX="^[a-z ]"
USAGE='OsbornePro absolutepathit 2.0 ( https://roberthosborne.com )

Usage: absolutepathit [file <string /path/to/script]

OPTIONS:"
 -h : Displays the help information for the command.

EXAMPLES:
  absolutepathit ~/Documents/Bash/script.sh"
  # This example takes the words in script.sh and changes relative paths to absolute paths.
  
'


function allow_ctrlc {

	# Allow Ctrl+C to kill pingsweep
	trap '
	  trap - INT # restore default INT handler
	  kill -s INT "$$"
	' INT

}  # End allow_ctrlc


function print_usage {

	printf "$USAGE\n" >&2
	exit 1

}  # End function print_usage	


function validate_file {

	# Validate script to absoulte path exists
	if [ -f "$script" ] && echo "$script file exists. Please wait..." || echo "$script file does not exist. Please define the path to the script you wish to add absolute command values too."; then
		declare -a ABSOLUTE_CMDS
	else
		printf "[x] The file path defined does not exist or you have inadequate permissions."
		exit 1
	fi

}  # End function validate_file


while [ ! -z "$1" ]; do
	case "$1" in
		-f)
			shift
			script=$1
			;;
		*)
			print_usage
			;;
	esac
shift
done


allow_ctrlc
validate_file

# Ignore lines that are commented out
cp "$script" /tmp/absolutepathit_tmpinfo
sed -i -e 's/#.*$//' -e '/^$/d' /tmp/absolutepathit_tmpinfo

# Build an array of possible absolute path values in a script
mapfile -t COMMAND_LIST < /tmp/absolutepathit_tmpinfo

UNIQUE_CMDS=$(echo ${COMMAND_LIST[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')

# Comment out the below line that sets the word variable if you feel this is overdoing it. This is still a work in progress
word=$(echo $word | rev | cut -f1 -d '(' | rev)

for word in $UNIQUE_CMDS; do
	if [[ $word =~ $REGEX ]]; then
		if [ -n $word ]; then
			THECMD=$(which "$word")
			if [ "$THECMD" != "" ]; then
				echo "$THECMD is being added to array of commands"
				ABSOLUTE_CMDS+=($THECMD) 
			fi
		fi
	fi
done

echo "$ABSOLUTE_CMDS"
	
# Replace the arelative value commands in a script with absolute values
for each_command in ${ABSOLUTE_CMDS[@]}; do
	assumed_path=${each_command##*/}
	sed -i "s|$assumed_path|$each_command|g" /tmp/absolutepathit_tmpinfo
done	
