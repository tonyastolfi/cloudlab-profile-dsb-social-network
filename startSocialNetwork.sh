#!/bin/bash
#
set -Eeuo pipefail

cd /local/DeathStarBench/socialNetwork

#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Change docker compose yaml using yq to limit port binding
#
which jq || {
    sudo apt update && sudo apt install -y jq
}
which yq || {
    pip install yq
    export PATH=${PATH}:${HOME}/.local/bin
}

#
#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------

cat docker-compose.yml | \
    yq -y '.services |= with_entries(if (.value|has("ports")) then .value.ports |= map("127.0.0.1:"+.) else . end)' \
       >docker-compose-localhost.yml

docker-compose -f docker-compose-localhost.yml up -d

# --graph=<socfb-Reed98, ego-twitter, or soc-twitter-follows-mun>
#
python3 scripts/init_social_graph.py --graph=socfb-Reed98
