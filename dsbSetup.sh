#!/bin/bash
#
set -Eeuo pipefail

#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Install prerequisites.
#
sudo apt-get update
sudo apt-get install -y libssl-dev libz-dev luarocks
sudo luarocks install luasocket

which jq || {
    sudo apt update && sudo apt install -y jq
}
which yq || {
    pip install yq
    export PATH=${PATH}:${HOME}/.local/bin
}

pip install aiohttp


#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Clone DeathStarBench.
#
cd /local
git clone --recurse-submodules --depth 10 https://github.com/delimitrou/DeathStarBench


#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Change docker compose yaml using yq to limit port binding
#
cd /local/DeathStarBench/socialNetwork

cat docker-compose.yml | \
    yq -y '.services |= with_entries(if (.value|has("ports")) then .value.ports |= map("127.0.0.1:"+.) else . end)' \
       >docker-compose-localhost.yml

#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Success!
#
touch /local/.dsbSetup.ts

