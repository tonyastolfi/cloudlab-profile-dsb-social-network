#!/bin/bash
#
set -x

mail -s "SocialNetwork instance is setting up!" $(geni-get slice_email)

script_dir=$(cd "$(dirname "$0")" && pwd)

{
    echo "Start: $(date "+%Y-%m-%dT%H-%M-%S")"

    source "${script_dir}/aptSetup.sh"
    source "${script_dir}/shcSetup.sh"
    source "${script_dir}/dockerSetup.sh"
    source "${script_dir}/pythonSetup.sh"
    source "${script_dir}/dsbSetup.sh"

    echo "Finish: $(date "+%Y-%m-%dT%H-%M-%S")"

} 2>&1 | tee /local/setup.log

mail -s "SocialNetwork instance finished setting up!" $(geni-get slice_email)
