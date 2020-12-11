#!/bin/bash

# Stop application stack.
docker-compose down

# Delete password for admin user.
rm -f ".admin_pw"

# Remove all certificates (CA, Server, cloudio-services).
make -C certificates clean
