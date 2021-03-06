#!/usr/bin/env bash
#
# This script generates an SSH key with ssh-keygen in order to pass
# to the terraform/cloud formation to allow logging into instances
# this is generally a very poor idea, as changing the key will cause
# the infrastructure to be regenerated, keys should be provided/looked
# up from some other secure store and generated elsewhere. This 
# mechanism is used here to serve as a simple demo
#
# This also generates a ssh key with no passphrase, another bad
# practice, and further proof this is only for POC/demo uses and not 
# suitable for any sort of production use case.
TMP_PUBKEY=/tmp/tf_wordpress_ssh_key.pub
if ! which ssh-keygen >/dev/null 2>&1; then 
    echo "ssh-keygen must be in path!"
    exit 1
fi 

# Maybe there's no home set, if not, use tmp
if [[ -z ${HOME} ]]; then
    HOME="/tmp"
fi 
SSH_KEYFILE=${HOME}/wordpress_demo_key

# if a keyfile does not exist, generate a new keypair
if [[ ! -f ${SSH_KEYFILE} || ! -f "${SSH_KEYFILE}.pub" ]]; then
    ssh-keygen -b 2048 -f ${SSH_KEYFILE} -q -N ""
fi

cp "${SSH_KEYFILE}.pub" ${TMP_PUBKEY}
