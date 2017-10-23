#! /bin/bash

if [[ `id -u` -eq 0 ]]; then
  echo -e "\033[0;33mTira o sudo aí e roda de novo \033[0m";
  exit 1;
fi

alias ips='ip addr show | grep inet\ '

echo -e "\033[0;36mConfigurando Keybindings ... \033[0m"
keybindings="['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings $keybindings
# keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'nemo'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'nemo'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>e'

echo -e "\033[0;36mConfigurando Desktop ... \033[0m"
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/Dinner.jpg'
gsettings set org.gnome.desktop.background picture-options 'scaled'
# screensaver
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/Dinner.jpg'
gsettings set org.gnome.desktop.screensaver picture-options 'scaled'
gsettings set org.gnome.desktop.screensaver lock-enabled false

echo -e "\033[0;36mConfigurando Touchpad ... \033[0m"
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

echo -e "\033[0;36mConfigurando Dock ... \033[0m"
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock preferred-monitor 1
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30
gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#777777'
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-worspaces true
# favorites
launcherItems="['nemo.desktop', 'firefox.desktop', 'atom.desktop']"
gsettings set org.gnome.shell favorite-apps $laucherItems

echo -e "\033[0;36mConfigurando Workspaces ... \033[0m"
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.mutter workspaces-only-on-primary false

echo -e "\033[0;36mConfigurando Menu ... \033[0m"
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface show-battery-percentage true

echo -e "\033[0;36mConfigurando Nemo ... \033[0m"
gsettings set org.nemo.preferences show-new-folder-icon-toolbar true
gsettings set org.nemo.preferences show-home-icon-toolbar true
gsettings set org.nemo.preferences show-location-entry true
gsettings set org.nemo.preferences close-device-view-on-device-eject true
gsettings set org.nemo.preferences show-full-path-titles true
gsettings set org.nemo.preferences show-open-in-terminal-toolbar true

