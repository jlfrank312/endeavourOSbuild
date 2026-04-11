# endeavourOSbuild
Linux build-scripts and config files

# EOS Reinstall URLs
eos-welcome --ni="https://raw.githubusercontent.com/jlfrank312/endeavourOSbuild/main/eos-install/user_commands.bash"

# Fetch before-script manually:
wget -O ~/user-commands-before.bash "https://raw.githubusercontent.com/jlfrank312/endeavourOSbuild/main/eos-install/user-commands-before.bash"

# Bootstrap
cd ~/setup/endeavourOSbuild && ./bootstrap.sh

# Make targets
make run-laptop
make run-pc
make run-pi
make update-ii
make snapshot-ii

# Manual II install
cd ~/.cache/dots-hyprland
SKIP_ALLGREETING=1 ./setup install --skip-sysupdate --skip-backup -f