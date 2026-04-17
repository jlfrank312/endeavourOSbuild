#!/bin/bash
#----------------------------------------------------------------------------------
# EndeavourOS post-install commands for endeavourOSbuild
# Clones the Ansible repo and sets up prerequisites for bootstrap.sh
# Vault password must be placed at /home/liveuser/vault-password before install,
# or set manually after first boot using ~/setup/set-vault-password.sh
#----------------------------------------------------------------------------------

_PostInstallCommands() {
    local -r username="$1"
    local -r home_dir="/home/$username"
    local -r repo_dir="$home_dir/setup/endeavourOSbuild"

    # Install prerequisites
    pacman -S --noconfirm --needed git ansible python-pexpect tmux

    # Install ansible-galaxy collections
    sudo -u "$username" ansible-galaxy collection install \
        kewlfft.aur \
        community.docker \
        ansible.posix \
        community.general

    # Clone the repo
    sudo -u "$username" git clone \
        https://github.com/jlfrank312/endeavourOSbuild.git \
        "$repo_dir"

    # Set ownership of the cloned repo
    chown -R "$username:$username" "$repo_dir"

    # Copy vault password from live USB if present, otherwise stage helper script
    mkdir -p "$home_dir/setup"
    if [ -f /home/liveuser/vault-password ]; then
        cp /home/liveuser/vault-password "$home_dir/setup/vault-password"
        chmod 600 "$home_dir/setup/vault-password"
    else
        echo "WARNING: vault-password not found at /home/liveuser/vault-password"
        echo "After first boot run: ~/setup/set-vault-password.sh <password>"
        cp "$repo_dir/eos-install/set-vault-password.sh" "$home_dir/setup/set-vault-password.sh"
        chmod +x "$home_dir/setup/set-vault-password.sh"
    fi
    chown -R "$username:$username" "$home_dir/setup"
}

case "$1" in
    --iso-conf* | online | offline | community) ;;
    *) _PostInstallCommands "$1" ;;
esac