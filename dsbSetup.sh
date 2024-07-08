#!/bin/bash
#
set -Eeuo pipefail

git clone --recurse-submodules --depth 10 https://github.com/delimitrou/DeathStarBench

sudo apt-get update
sudo apt-get install -y libssl-dev libz-dev luarocks
sudo luarocks install luasocket

pip install aiohttp


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
