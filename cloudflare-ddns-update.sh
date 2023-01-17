#!/bin/bash
# A bash script to update a Cloudflare DNS A record using the external IP of the local machine
#
# CRONJOB EXAMPLE
# crontab -e
# 0 9 * * * /bin/bash /usr/share/scripts/ddns-update.sh

ZONE=domain.com
DNSRECORD=subdomain.domain.com
CLOUDFLARE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
IPV4REGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
IP=$(/usr/bin/curl -s -X GET https://cloudflare.com/cdn-cgi/trace | grep ip | cut -d"=" -f2)
DNSCHECK=$(/usr/bin/host $DNSRECORD 1.1.1.1 | /bin/grep "has address" | /bin/grep "$IP")

/bin/echo "[*] Current IPv4 Address: $IP"
if [[ $DNSCHECK =~ $IPVREGEX ]]; then

	/bin/echo "[*] $DNSRECORD is currently set to $IP, no changes needed"
  
else

	ZONEID=$(/usr/bin/curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$ZONE&status=active" -H "Authorization: Bearer ${CLOUDFLARE_KEY}" -H "Content-Type: application/json" | /usr/bin/jq -r '{"result"}[] | .[0] | .id')

	/bin/echo "[*] Zone    : $ZONE"
  /bin/echo "[*] Zone ID : $ZONEID"
	DNSRECORDID=$(/usr/bin/curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records?type=A&name=$DNSRECORD" -H "Authorization: Bearer ${CLOUDFLARE_KEY}" -H "Content-Type: application/json" | /usr/bin/jq -r '{"result"}[] | .[0] | .id')

	/bin/echo "[*] DNS Record    : $DNSRECORD"
  /bin/echo "[*] DNS Record ID : $DNSRECORDID"
	/usr/bin/curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records/$DNSRECORDID" -H "Authorization: Bearer ${CLOUDFLARE_KEY}" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$DNSRECORD\",\"content\":\"$IP\",\"ttl\":1,\"proxied\":false}" | /usr/bin/jq

fi
