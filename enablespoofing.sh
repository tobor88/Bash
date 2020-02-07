#!/bin/bash

# I place this script in /usr/local/sbin/enablespoofing.
# This allows your Linux system to act as a router by forwarding traffic. Then it allows DNS traffic as well as DNS forwarding

echo "Enabling port forward"
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "Allowing DNS traffic through IP Tables Firewall"
iptables -A INPUT -i eth0 -p udp --dport 53 -j ACCEPT
iptables -A PREROUTING -t nat -i eth0 -p udp --dport 53 -j REDIRECT --to-port 53

echo "The below value should be the number 1"
cat /proc/sys/net/ipv4/ip_forward

echo "Verify iptables is configured below"
iptables --list
