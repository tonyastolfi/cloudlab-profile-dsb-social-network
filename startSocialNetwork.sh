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
# Check for port conflicts.
#
function check_port() {
    port_num=$1
    service_name=$2
    {
        netstat -l | grep ":${port_num}" && {
            echo "Warning: ${service_name} port (${port_num}) in use!" >2
            exit 1
        }
    } || true
}

check_port 8080 "Nginx frontend"
check_port 8081 "media frontend"
check_port 16686 "Jaeger"


#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Start via docker-compose.
#
cd /local/DeathStarBench/socialNetwork

docker-compose -f docker-compose-localhost.yml up "$@"


#=#=#==#==#===============+=+=+=+=++=++++++++++++++-++-+--+-+----+---------------
# Optional/Manual step (once app is running): populate databases.
#
# python3 scripts/init_social_graph.py --graph=socfb-Reed98
# python3 scripts/init_social_graph.py --graph=ego-twitter
# python3 scripts/init_social_graph.py --graph=soc-twitter-follows-mun
