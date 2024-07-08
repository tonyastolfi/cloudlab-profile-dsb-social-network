#!/bin/bash
#
set -x

mail -s "SocialNetwork instance is setting up!" $(geni-get slice_email)

{
    echo "Start: $(date "+%Y-%m-%dT%H-%M-%S")"

    source /local/repository/aptSetup.sh
    source /local/repository/shcSetup.sh
    source /local/repository/dockerSetup.sh
    source /local/repository/pythonSetup.sh
    source /local/repository/dsbSetup.sh

    echo "Finish: $(date "+%Y-%m-%dT%H-%M-%S")"

} 2>&1 | tee /local/setup.log

mail -s "SocialNetwork instance finished setting up!" $(geni-get slice_email)
