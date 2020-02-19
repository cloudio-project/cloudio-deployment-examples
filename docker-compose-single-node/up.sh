#!/bin/bash

# Create all required certificates (CA, Server, cloudio-services).
make -C certificates all

# Create random password for admin user of different services if it has not yet be done.
if [ -f ".admin_pw" ]; then
    export ADMIN_PASSWORD=$(<.admin_pw)
else 
    export ADMIN_PASSWORD=$(openssl rand -base64 32)
    echo -n "${ADMIN_PASSWORD}" > ".admin_pw"
fi
echo "Using ${ADMIN_PASSWORD} as password for admin user"

# Load certificates to environment variables.
export CA_CERT=$(<certificates/ca.cer)
export CA_KEY=$(<certificates/ca.key)
export SERVER_CERT=$(<certificates/server.cer)
export SERVER_KEY=$(<certificates/server.key)

# Start application stack.
docker-compose up -d
