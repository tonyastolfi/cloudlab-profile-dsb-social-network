#!/bin/bash
#
set -Eeuo pipefail

sudo apt update && sudo apt install -y cmake libthrift-dev libmongoc-dev nlohmann-json3-dev
