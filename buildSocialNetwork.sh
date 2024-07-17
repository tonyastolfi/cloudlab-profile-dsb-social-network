#!/bin/bash
#
set -Eeuo pipefail

#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Check to make sure dsbSetup.sh successfully ran.
#
test -f /local/.dsbSetup.ts || {
    echo "Error: dsbSetup.sh must be run before this script!" >2
    exit 1
}
                                

#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Docker build will compile and build the deployed image.
#
cd /local/DeathStarBench/socialNetwork

docker build -t deathstarbench/social-network-microservices:latest .
