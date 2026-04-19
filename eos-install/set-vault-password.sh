#!/bin/bash
mkdir -p ~/.config/ansible
printf '%s' "$1" > ~/.config/ansible/vault-password
chmod 600 ~/.config/ansible/vault-password
echo "Vault password set."