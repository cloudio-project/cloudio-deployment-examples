#!/bin/bash

# Default to one service node (the one serving HTTP).
INSTANCES=1
test $# -eq 1 && INSTANCES=$1

# There is one main instance, so subtract 1 from instance count.
INSTANCES=$(($INSTANCES - 1))

# Check that value makes sense.
test $INSTANCES -lt 0 && exit

# Get in required variables.
export ADMIN_PASSWORD=$(<.admin_pw)
export CA_CERT=$(<certificates/ca.cer)
export CA_KEY=$(<certificates/ca.key)

# Do the actual scaling.
docker-compose scale msgservice=$INSTANCES
