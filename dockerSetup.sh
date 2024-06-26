#!/bin/bash
#
# This script derived from the instructions at: https://docs.docker.com/engine/install/ubuntu/
#
set -x

#==#==========+==+=+=++=+++++++++++-+-+--+----- --- -- -  -  -   -
# Uninstall any potentially conflicting packages.
#+++++++++++-+-+--+----- --- -- -  -  -   -

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg
done


#==#==========+==+=+=++=+++++++++++-+-+--+----- --- -- -  -  -   -
# 1. Set up Docker's apt repository.
#+++++++++++-+-+--+----- --- -- -  -  -   -

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


#==#==========+==+=+=++=+++++++++++-+-+--+----- --- -- -  -  -   -
# 2. Install the Docker packages.
#+++++++++++-+-+--+----- --- -- -  -  -   -

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


#==#==========+==+=+=++=+++++++++++-+-+--+----- --- -- -  -  -   -
# 3. Verify that the Docker Engine installation is successful by running the hello-world image.
#+++++++++++-+-+--+----- --- -- -  -  -   -

sudo docker run hello-world


#==#==========+==+=+=++=+++++++++++-+-+--+----- --- -- -  -  -   -
# Custom steps (not from official install instructions).
#+++++++++++-+-+--+----- --- -- -  -  -   -

# Add all users to the docker group.
#
for user in $(ls /users); do
    sudo usermod -aG docker $user
done

# Turn down the docker service temporarily while we change the service definition.
#
sudo systemctl stop docker.service
sudo systemctl stop docker.socket

# Add custom --data-root arg to dockerd.
#
DOCKER_DATA_DIR=/mydata/docker
sudo mkdir -p ${DOCKER_DATA_DIR}
SEARCH_STRING="ExecStart=/usr/bin/dockerd -H fd://"
REPLACE_STRING="ExecStart=/usr/bin/dockerd --data-root ${DOCKER_DATA_DIR} -H fd://"
sudo sed -i "s#$SEARCH_STRING#$REPLACE_STRING#" /lib/systemd/system/docker.service

# Populate the new data dir from the old (default) one.
#
sudo rsync -aqxP /var/lib/docker/ /mydata/docker

# Reload the service definition and stand up docker.
#
sudo systemctl daemon-reload
sudo systemctl start docker
