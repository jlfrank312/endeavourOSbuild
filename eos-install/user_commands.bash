#!/bin/bash
#----------------------------------------------------------------------------------
# EndeavourOS post-install commands for endeavourOSbuild
# Clones the Ansible repo and sets up prerequisites for bootstrap.sh
# Vault password must be placed at /home/liveuser/vault-password before install,
# or set manually after first boot using the set-vault-password helper function.
#----------------------------------------------------------------------------------

_PostInstallCommands() {
    local -r username="$1"
    local -r home_dir="/home/$username"
    local -r repo_dir="$home_dir/setup/endeavourOSbuild"

    # Install prerequisites
    pacman -S --noconfirm --needed git ansible python-pexpect

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

    # Copy vault password from live USB if present
    if [ -f /home/liveuser/vault-password ]; then
        mkdir -p "$home_dir/setup"
        cp /home/liveuser/vault-password "$home_dir/setup/vault-password"
        chmod 600 "$home_dir/setup/vault-password"
        chown "$username:$username" "$home_dir/setup/vault-password"
        chown "$username:$username" "$home_dir/setup"
    else
        echo "WARNING: vault-password not found at /home/liveuser/vault-password"
        echo "Use the set-vault-password helper function after first boot."

        # Add one-time helper function to .bashrc

cat >> "$home_dir/.bashrc" << 'EOF'

# BEGIN set-vault-password
set-vault-password() {
    mkdir -p ~/setup
    printf "$1" > ~/setup/vault-password
    chmod 600 ~/setup/vault-password
    sed -i '/# BEGIN set-vault-password/,/# END set-vault-password/d' ~/.bashrc
    echo "Vault password set. Helper function removed."
}
# END set-vault-password
EOF
        chown "$username:$username" "$home_dir/.bashrc"
    fi
}

case "$1" in
    --iso-conf* | online | offline | community) ;;
    *) _PostInstallCommands "$1" ;;
esac