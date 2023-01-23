#!/bin/bash
# This script is used to request a wildcard certificate from LetsEncrypt when Cloudflare is your DNS hosting provider
# This script also sets up a renewal cronjob for the wildcard certificate


if [ "$EUID" -ne 0 ]; then
    echo "[x] Script must be executed as root"
    echo "    EXAMPLE CMD: sudo $0"
    exit
fi

CERTBOT_INSTALLED=$(apt-cache policy certbot | grep Installed | grep none)
if [ -n $CERTBOT_INSTALLED ]; then
    echo "[*] The certbot binary is not installed. Installing now."
    apt-get update && apt-get install -y certbot python3-certbot-dns-cloudflare
fi


echo "[*] Setting required variables"
CF_API_KEY="<Your-Global-API-Key-From-Cloudflare-Here>"
CF_EMAIL="Your-Cloudflare-Email-Here@domain.com"
CF_DOMAIN="your-domain.com"
CONFIG_FILE="/etc/letsencrypt/cloudflare.ini"
CERT_DIRECTORY="/etc/letsencrypt/archive/${CF_DOMAIN}"


echo "[*] Building authentication file"
echo "dns_cloudflare_api_key = $CF_API_KEY" > $CONFIG_FILE
echo "dns_cloudflare_email = $CF_EMAIL" >> $CONFIG_FILE


echo "[*] Setting secure file permissions on the config file"
chown root:root $CONFIG_FILE
chmod 600 $CONFIG_FILE


echo "[*] Requesting wildcard certificate"
certbot certonly --dns-cloudflare --dns-cloudflare-credentials "$CONFIG_FILE" -d "*.$CF_DOMAIN" -d "$CF_DOMAIN" --agree-tos -m "$CF_EMAIL" --server https://acme-v02.api.letsencrypt.org/directory


echo "[*] Updating cronjob"
echo "0 0 * * 0 /usr/bin/certbot renew --quiet" > /etc/cron.d/letsencrypt
