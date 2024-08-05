#!/bin/bash

ANSIBLE_VAULT_PASSWORD=$(
  security find-generic-password -a $USER -s ansible-vault -w 2>/dev/null
)

set -e

if [ -z "$ANSIBLE_VAULT_PASSWORD" ] ; then
  read -sp "Enter vault password:" ANSIBLE_VAULT_PASSWORD
  security add-generic-password -U -a $USER -s ansible-vault -w "$ANSIBLE_VAULT_PASSWORD"
  echo
else
  echo "Already logged in for ansible vault"
fi
