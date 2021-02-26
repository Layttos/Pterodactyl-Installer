#!/bin/bash

set -e

SCRIPT_VERSION="v0.2.0"
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

output() {
  echo -e "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

done=false

output "Pterodactyl installation script @ $SCRIPT_VERSION"
output
output "Copyright (C) 2018 - 2021, Layttos, <louisonhachemi97@icloud.com>"
output "https://github.com/vilhelmprytz/pterodactyl-installer"
output
output "Sponsoring/Donations: https://github.com/vilhelmprytz/pterodactyl-installer?sponsor=1"
output "This script is not associated with the official Pterodactyl Project."

output

panel() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/pterodactyl-installer/$SCRIPT_VERSION/install-panel.sh)
}

wings() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/pterodactyl-installer/$SCRIPT_VERSION/install-wings.sh)
}

legacy_panel() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/pterodactyl-installer/$SCRIPT_VERSION/legacy/panel_0.7.sh)
}

legacy_wings() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/pterodactyl-installer/$SCRIPT_VERSION/legacy/daemon_0.6.sh)
}

canary_panel() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/pterodactyl-installer/master/install-panel.sh)
}

canary_wings() {
  bash <(curl -s https://raw.githubusercontent.com/vilhelmprytz/pterodactyl-installer/master/install-wings.sh)
}

while [ "$done" == false ]; do
  options=(
    "Installer le panel"
    "Install les Wings"
    "Installer [0] et [1] sur la même machine (les Wings seront automatiquement lanées)\n"

    "Installer le panel 0.7"
    "Install le Daemon 0.6"
    "Installer [3] et [4] sur la même machine (Le Daemon sera automatiquement lancé)\n"

    "Installer la version en développement (La version MASTER : peut être cassée)"
    "Installer les Wings en développement (La version MASTER : peut être cassée)"
    "Installer [5] et [6] sur la même machine (Les Wings seront automatiquement lancées)"
  )

  actions=(
    "panel"
    "wings"
    "panel; wings"

    "legacy_panel"
    "legacy_wings"
    "legacy_panel; legacy_wings"

    "canary_panel"
    "canary_wings"
    "canary_panel; canary_wings"
  )

  output "What would you like to do?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Input 0-$((${#actions[@]}-1)): "
  read -r action

  [ -z "$action" ] && error "Input is required" && continue

  valid_input=("$(for ((i=0;i<=${#actions[@]}-1;i+=1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && eval "${actions[$action]}"
done
