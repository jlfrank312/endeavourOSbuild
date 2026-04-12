#!/bin/bash
printf '%s' "$1" > ~/setup/vault-password
chmod 600 ~/setup/vault-password
echo "Vault password set."