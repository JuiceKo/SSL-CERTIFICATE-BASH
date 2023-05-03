mkdir -p ca/{private,certs,newcerts,csr}
chmod -v 700 ca/private
touch ca/index
openssl rand -hex 16 ca/serial

#ROOT KEY
cd ca
openssl genrsa -aes256 -out private/root-ca.key 4096

cat << 'EOF' > "root-ca.conf"
[ ca ]
# 'man ca'
# Used by the ca command
default_ca	= CA_default

[ CA_default ]
# Directory and file locations
dir			= .
certs			= $dir/certs
new_certs_dir   	= $dir/newcerts
database		= $dir/index
serial			= $dir/serial
RANDFILE 		= $dir/private/.rand
# RANDFILE is for storing seed data for random number generation

# Root CA certificate and key locations
certificate		= $dir/certs/root-ca.crt
private_key		= $dir/private/root-ca.key

# Default message digest, we'll opt for SHA2 256bits
default_md		= sha256

name_opt		= ca_default
cert_opt		= ca_default
default_days		= 365
preserve   		= no
policy    		= policy_strict

[ policy_strict ]
countryName		= supplied
stateOrProvinceName	= supplied
organizationName	= supplied
organizationalUnitName  = optional
commonName		= supplied
emailAddress		= optional

[ req ]
# 'man req'
# Used by the req command
default_bits   		= 2048
distinguished_name  	= req_distinguished_name
string_mask   		= utf8only
default_md		= sha256

# Extensions to use for -x509 
x509_extensions   	= server_cert

[ req_distinguished_name ]
# Certificate signing request
countryName		= Country Name (2 letter code)
stateOrProvinceName	= State or Province Name
localityName		= Locality Name
organizationName	= Organization Name
organizationalUnitName	= Organizational Unit Name
commonName              = Common Name
emailAddress		= Email Address
# Defaults
countryName_default		= FR
stateOrProvinceName_default	= France
organizationName_default	= Artifrance

[ v3_ca ]
# ' man x509v3_config' 
# Extensions for root CA
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints  = critical, CA:TRUE
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ usr_cert ]
# `man x509v3_config`
# Extensions for client certificates
basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, emailProtection

[ server_cert ]
# Extensions for server certificates
basicConstraints  = CA:FALSE
nsCertType   = server
nsComment   =  "OpenSSL Generated Server Certificate"
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid,issuer:always
keyUsage   =  critical, digitalSignature, keyEncipherment
extendedKeyUsage  = serverAuth

EOF

openssl req -config root-ca.conf -extensions v3_ca -key private/root-ca.key -new -x509 -days 3650 -out certs/root-ca.crt
