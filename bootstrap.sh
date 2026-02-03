#!/bin/bash
set -e # Exit immediately if a command fails

echo ":: Starting Infrastructure Bootstrap ::"

# 1. Update Package Database & Install Dependencies
# -Sy: Syncs the database so we don't install old versions
# -u: Updates entire system, preventing partial upgrades
# --needed: Skips already installed packages
# --noconfirm: Automates "Yes" prompts
echo ":: Installing Ansible, Git, & Base-Devel if they're missing or outdated ::"
sudo pacman -Syu --needed --noconfirm git ansible base-devel

# 2. Self-Update
# Ensures you're using the latest version of endeavourOSbuild.git
if [ -d ".git" ]; then
	echo ":: Pulling latest infrastructure changes ::"
	git pull origin main || echo ":: Git pull skipped (local changes detected) ::"
fi

# 3. Run the playbook
echo ":: Running Ansible Playbook ::"
# --ask-become-pass (-K) prompts for sudo password once at start
ansible-playbook local.yml -K

echo ":: System Bootstrap Complete ::"
