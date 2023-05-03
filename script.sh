#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Need a domain name"
  exit 1
fi

# Demande à l'utilisateur d'entrer une adresse IP
read -p "IP ADDRESS : " ipAddress

DOMAIN=$1


openssl genrsa -out private/$DOMAIN.key 2048


cat > csr/$DOMAIN.conf << EOF
[ req ]
# 'man req'
# Used by the req command
default_bits            = 2048
distinguished_name      = req_distinguished_name
req_extensions          = req_ext
prompt                          = no

[ req_distinguished_name ]
# Certificate signing request
countryName                     = FR
stateOrProvinceName     = France
organizationName        = Artifrance
commonName                      = $DOMAIN

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $DOMAIN
IP.1 = $ipAddress
EOF


openssl req -new -key private/$DOMAIN.key -sha256 -out csr/$DOMAIN.csr -config csr/$DOMAIN.conf

 openssl ca -config root-ca.conf -notext -in csr/$DOMAIN.csr -out certs/$DOMAIN.crt -extensions req_ext -extfile csr/$DOMAIN.conf
