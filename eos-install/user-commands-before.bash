#!/bin/bash
#----------------------------------------------------------------------------------
# EndeavourOS pre-install ISO configuration for endeavourOSbuild
# Configures Calamares defaults before the installer starts
#----------------------------------------------------------------------------------

_IsoConfig() {
    local -r install_mode="$1"

    # Set default filesystem to BTRFS so Snapper works automatically
    sed -i 's/^defaultFileSystemType:.*/defaultFileSystemType: "btrfs"/' \
        /etc/calamares/modules/partition.conf
}

case "$1" in
    offline | online) _IsoConfig "$1" ;;
esac