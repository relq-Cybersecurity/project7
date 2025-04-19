#!/bin/bash

# Տեղադրեք այն, որտեղ ցանկանում եք պահել սերտիֆիկատներն ու բանալին
#CERTS_DIR="./ssl"
#KEYOUT="$CERTS_DIR/privkey.pem"
#CERTS="$CERTS_DIR/cert.pem"
#
## Ստեղծեք ssl ֆոլդեր, եթե դեռ գոյություն չունի
#mkdir -p $CERTS_DIR
#
## Ստեղծեք self-signed սերտիֆիկատ
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#  -keyout $KEYOUT \
#  -out $CERTS \
#  -subj "/C=AM/ST=Yerevan/L=Yerevan/O=Dev/OU=Dev/CN=localhost"
#
#echo "Self-signed certificate has been generated at $CERTS_DIR."
##chmod 600 $CERTS_DIR/privkey.pem
#chmod 644 $CERTS_DIR/cert.pem


mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
  -subj "/C=AM/ST=Yerevan/L=Yerevan/O=Dev/OU=Dev/CN=localhost" \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/privkey.pem \
  -out /etc/nginx/ssl/cert.pem

echo "Self-signed certificate has been generated at /etc/nginx/ssl."
chmod 644 /etc/nginx/ssl/cert.pem
chmod 600 /etc/nginx/ssl/privkey.pem
