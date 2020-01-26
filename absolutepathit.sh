#!/bin/bash

# Allow Ctrl+C to kill pingsweep
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

# Add help message for reference
if [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
		# This option displays a help message and command execution examples
		echo ""
		echo "OsbornePro absolutepathit 1.0 ( https://roberthosborne.com )"
		echo ""
		echo "USAGE: absolutepathit [file <string format is /path/to/script]"
		echo ""
		echo "OPTIONS:"
		echo "  -h : Displays the help information for the command."
		echo ""
		echo "EXAMPLES:"
		echo "  absolutepathit ~/Documents/Bash/script.sh"
		echo "  # This example takes the words in script.sh and changes relative paths to absolute paths."
		echo ""
		exit
# Variable validation------------------------------------------------
elif [ -f "$1" ] && echo "$1 file exists. Please wait..." || echo "$1 file does not exist. Please define the path to the script you wish to add absolute command values too."; then
	declare -a ABSOLUTE_CMDS
	
	# Ignore lines that are commented out
	cp $1 /tmp/absolutepathit_tmpinfo
	sed -i -e 's/#.*$//' -e '/^$/d' /tmp/absolutepathit_tmpinfo

	# Build an array of possible absolute path values in a script
	regex="^[a-z ]"
	mapfile -t COMMAND_LIST < /tmp/absolutepathit_tmpinfo

	UNIQUE_CMDS=$(echo ${COMMAND_LIST[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
	for word in $UNIQUE_CMDS; do
		if [[ $word =~ $regex ]]; then
			if [ -n $word ]; then
				thecmd=$(which "$word")
				if [ "$thecmd" != "" ]; then
					echo "$thecmd is being added to array of commands"
					ABSOLUTE_CMDS+=($thecmd) 
				fi
			fi
		fi
	done

	echo $ABSOLUTE_CMDS
	
	# Replace the arelative value commands in a script with absolute values
	for each_command in ${ABSOLUTE_CMDS[@]}; do
			assumed_path=${each_command##*/}
			echo $assumed_path
			echo $each_command
			sed -i "s|$assumed_path|$each_command|g" /tmp/absolutepathit_tmpinfo
		done	
fi
