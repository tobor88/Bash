#!/bin/sh
#
# REQUIREMENTS
# - Set the below variables as applicable to you
# - openssl
# - curl
# - Microsfot Root Certificate Authority
# - Run script as root user
#
# This script is used to
# 1.) automatically create a CSR request
# 2.) Submit the request to your Microsoft Certificate Authority
# 3.) Backup your old SSL certificate
# 4.) Start using the newly issued certificate 



# The service is restarted at the end of the script using ```systemctl``` to ensure your newly issued certificate is used
SERVICE='apache2.service'

TEMPLATE='WebServer' # This is the name of your template. This will not have any spaces in the name
CA='root-ca.domain.com'
#USER='WindowsAdmin'
#PASS='Pass0rd123!'
# OR UNCOMMENT THE BELOW TWO LINES TO STATICALLY SET YOUR VALUES
read -p "Enter your username: " USER
read -s -p "Enter your password: " PASS
echo " "
# COMMENT OUT THE ABOVE 3 LINES TO STOP THE PROMPT AND USE YOUR STATIC VALUES

COUNTRY='US'
STATE='New Jersey'
LOCALITY='Newark'
ORGANIZATION'OsbornePro LLC.'
CN='hostname.domain.com'
KEYSIZE='2048'

read -p "Set location to save your certificate key EXAMPLE: /etc/pki/tls/private/key.key: " KEYFILE #KEYFILE="/etc/pki/tls/private/${CN}.key"
read -p "Set location to save your request file EXAMPLE /etc/pki/tls/request.req: " CSRFILE #CSRFILE="/etc/pki/tls/${CN}.csr"
read -p "Set location to save the certificate file EXAMPLE /etc/pki/tls/certs/cert.crt: " CERTFILE #CERTFILE="/etc/pki/tls/certs/${CN}.crt"
# COMMENT OUT THE ABOVE 3 LINES AND STATICALLY SET YOUR VALUES BELOW
#KEYFILE="/etc/pki/tls/private/${CN}.key"
#CSRFILE="/etc/pki/tls/${CN}.csr"
#CERTFILE="/etc/pki/tls/certs/${CN}.crt"
# UNCOMMENT THE ABOVE 3 LINES TO STOP THE PROMPT AND USE YOUR STATIC VALUES


# BACKUP OLD CERTIFICATE FILES
echo "[*] Backing up old CSR Request File"
mv "${CSRFILE}" "${CSRFILE}.old"

echo "[*] Backing up current Certificate file"
mv "${CERTFILE}" "${CERTFILE}.old"

echo "[*] Backing up Old Key File"
mv "${KEYFILE}" "${KEYFILE}.old"


# NEW CERTIFICATE CREATION
echo -e "[*] Generating private key"
openssl req -newkey rsa:$KEYSIZE -nodes -keyout $KEYFILE -out $CSRFILE -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/CN=${CN}"

if [ ! -f $KEYFILE ]; then
        echo "[*] Failed to create private key. Check your write permissions in /etc/pki/tls/private"
else
        CERT=$(cat $CSRFILE | tr -d '\n\r')
        DATA="Mode=newreq&CertRequest=${CERT}&C&TargetStoreFlags=0&SaveCert=yes"
        CERT=$(echo ${CERT} | sed 's/+/%2B/g')
        CERT=$(echo ${CERT} | tr -s ' ' '+')
        CERTATTRIB="CertificateTemplate:${TEMPLATE}%0D%0A"


        echo -e "[*] Requesting certificate from CA"
        OUTPUTLINK=$(curl -k -u "${USER}":${PASS} --ntlm "https://${CA}/certsrv/certfnsh.asp" -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.5' -H 'Connection: keep-alive' -H "Host: ${CA}" -H "Referer: https://${CA}/certsrv/certrqxt.asp" -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko' -H 'Content-Type: application/x-www-form-urlencoded' --data "Mode=newreq&CertRequest=${CERT}&CertAttrib=${CERTATTRIB}&TargetStoreFlags=0&SaveCert=yes&ThumbPrint=" | grep -A 1 'function handleGetCert() {' | tail -n 1 | cut -d '"' -f 2)
        CERTLINK="https://${CA}/certsrv/${OUTPUTLINK}"


        echo -e "[*] Retriving certificate: $CERTLINK"
        curl -k -u "${USER}":${PASS} --ntlm $CERTLINK -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.5' -H 'Connection: keep-alive' -H "Host: ${CA}" -H "Referer: https://${CA}/certsrv/certrqxt.asp" -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko' -H 'Content-Type: application/x-www-form-urlencoded' > $CERTFILE

        echo -e "[*] Verifying cert for $CN"
        openssl verify -verbose $CERTFILE
        if [ "0" -eq "$?" ] ;
            then
                echo -e "[*] Successfully verified certificate."
                exit 0
            else
                echo -e "[*] Error code: $?. Stopping."
                exit 1
        fi

        systemctl restart $SERVICE
        # Or if apache you can use the below script to ensure functionality before restarting the service
        # VALIDATE APACHE2 SERVICE
        #echo "[*] Restarting the web service"
        #RESULT=$(sudo apachectl configtest 2>&1)
        #
        #if echo $RESULT | grep -q "Syntax OK"; then
        #    systemctl restart $SERVICE
        #fi

fi
