#!/bin/bash
# This script is used to quickly and easily prevent your Linux Debian based distro from falling asleep

/usr/bin/xset s off
/usr/bin/xset -dpms
/usr/bin/xset s noblank

/usr/bin/echo "[*] Sleeping has been turned off"
