#!/bin/bash
#
set -x

mail -s "SocialNetwork instance is setting up!" $(geni-get slice_email)

source /local/repository/aptSetup.sh
source /local/repository/shcSetup.sh
source /local/repository/dockerSetup.sh

mail -s "SocialNetwork instance finished setting up!" $(geni-get slice_email)
