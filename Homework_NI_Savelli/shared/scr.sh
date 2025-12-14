#!/bin/bash

# --- LA TUA MATRICOLA QUI SOTTO ---
MY_ID="1947954"
# ----------------------------------

echo "--- 1. Creo la CA (L'Autorità) ---"
# Chiave privata della CA (protetta da password = matricola)
openssl genrsa -aes256 -passout pass:$MY_ID -out ca.key 4096
# Certificato pubblico della CA (quello che nell'esempio si chiamava ca.crt)
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -passin pass:$MY_ID \
    -subj "/C=IT/ST=Italy/L=Rome/O=Pazienza_Roma1/OU=Student/CN=$MY_ID"

echo "--- 2. Creo il Certificato per il SERVER (s3) ---"
# Chiave privata server (senza password, per avvio automatico)
openssl genrsa -out server.key 4096
# Richiesta di firma
openssl req -new -key server.key -out server.csr \
    -subj "/C=IT/ST=Italy/L=Rome/O=Pazienza_Roma1/OU=Server/CN=vpn_server"
# Firma del certificato usando la CA
openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt -passin pass:$MY_ID

echo "--- 3. Creo il Certificato per il CLIENT 1 (pc1) ---"
openssl genrsa -out client1.key 4096
openssl req -new -key client1.key -out client1.csr \
    -subj "/C=IT/ST=Italy/L=Rome/O=Pazienza_Roma1/OU=Client/CN=vpn_client_1"
openssl x509 -req -days 3650 -in client1.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client1.crt -passin pass:$MY_ID

echo "--- 4. Creo il Certificato per il CLIENT 2 (pc2) ---"
openssl genrsa -out client2.key 4096
openssl req -new -key client2.key -out client2.csr \
    -subj "/C=IT/ST=Italy/L=Rome/O=Pazienza_Roma1/OU=Client/CN=vpn_client_2"
openssl x509 -req -days 3650 -in client2.csr -CA ca.crt -CAkey ca.key -set_serial 03 -out client2.crt -passin pass:$MY_ID

echo "--- 5. Creo i parametri Diffie-Hellman (Sicurezza) ---"
# Questo comando ci metterà qualche secondo
openssl dhparam -out dh.pem 2048

echo "--- FATTO! Ecco i tuoi file: ---"
ls -l
