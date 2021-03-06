#!/usr/bin/env bash
#
# this script copies a public key to a temporary file
TMP_PUBKEY=/tmp/tf_wordpress_ssh_key.pub

# Maybe there's no home set, if not, use tmp
if [[ -z ${HOME} ]]; then
    HOME="/tmp"
fi 
SSH_KEYFILE=${HOME}/wordpress_demo_key

# if the pubkey does not exist, script will exit and cause 
# execution to fail (desirable)
cp "${SSH_KEYFILE}.pub" ${TMP_PUBKEY}
