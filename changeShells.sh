#!/bin/bash
#
# Make bash the default login shell for all users.
#
for user in $(ls /users)
do
    sudo chsh $user --shell /bin/bash
done

