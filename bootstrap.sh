#!/bin/bash
#set -e # Exit immediately if a command fails
set -euo pipefail

echo ":: Starting Infrastructure Bootstrap ::"

# 1. Update Package Database & Install Dependencies
# -Sy: Syncs the database so we don't install old versions
# -u: Updates entire system, preventing partial upgrades
# --needed: Skips already installed packages
# --noconfirm: Automates "Yes" prompts
echo ":: Installing Ansible, Git, & Base-Devel if they're missing or outdated ::"
sudo pacman -Syu --needed --noconfirm git ansible base-devel

# 2. Install yay (AUR helper)
if ! command -v yay &> /dev/null; then
	echo ":: Installing yay from AUR ::"
	# Clone to temporary directory to build
	git clone https://aur.archlinux.org/yay.git /tmp/yay-build
	cd /tmp/yay-build
	makepkg -si --noconfirm
	cd - > /dev/null
	rm -rf /tmp/yay-build
else
	echo ":: yay is already installed ::"
fi



# 3. Self-Update
# Ensures you're using the latest version of endeavourOSbuild.git
if [ -d ".git" ]; then
	echo ":: Pulling latest infrastructure changes ::"
	git pull origin main || echo ":: Git pull skipped (local changes detected) ::"
fi

# 4. Install Ansible collections (the playbook's 'dependencies')
echo ":: Installing Ansible collections ::"
ansible-galaxy collection install -r requirements.yml


# 5. Run the playbook
echo ":: Running Ansible Playbook ::"
# --ask-become-pass (-K) prompts for sudo password once at start
ansible-playbook site.yml -i "localhost," --connection=local -K

echo ":: System Bootstrap Complete ::"
