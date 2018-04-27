#! /bin/bash

if [[ `id -u` -eq 0 ]]; then
  echo -e "\033[0;33mTira o sudo aí e roda de novo \033[0m";
  exit 1;
fi

major=$(lsb_release -rs | cut -d'.' -f1)

alias ips='ip addr show | grep inet\ '
alias webcam='vlc v4l2:///dev/video0:chroma=mjpg:width=800:height=600 '

echo -e "\033[0;36mConfigurando Keybindings ... \033[0m"
keybindings="['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings $keybindings
# keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'nemo'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'nemo'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>e'
# show desktop
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ show-desktop-key '<Super>m'
# show launcher 'start menu'
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ show-launcher '<Super>'

echo -e "\033[0;36mConfigurando Desktop ... \033[0m"
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/Dinner.jpg'
gsettings set org.gnome.desktop.background picture-options 'scaled'
# screensaver
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/Dinner.jpg'
gsettings set org.gnome.desktop.screensaver picture-options 'scaled'
gsettings set org.gnome.desktop.screensaver lock-enabled false

echo -e "\033[0;36mConfigurando Touchpad ... \033[0m"
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

if [[ $major > 16 ]]; then 
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
  gsettings set org.gnome.shell favorite-apps $launcherItems

  echo -e "\033[0;36mConfigurando Workspaces ... \033[0m"
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.mutter workspaces-only-on-primary false

  echo -e "\033[0;36mConfigurando Menu ... \033[0m"
  gsettings set org.gnome.desktop.interface clock-show-date true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  
elif [[ $major == 16 ]]; then 
  echo -e "\033[0;36mConfigurando Workspaces ... \033[0m"
  profile=$(gsettings get org.compiz current-profile | tr -d "'")
  gsettings set org.compiz.core:/org/compiz/profiles/${profile}/plugins/core/ vsize 4

  echo -e "\033[0;36mConfigurando Barra Superior ... \033[0m"
  gsettings set com.canonical.Unity always-show-menus true
  gsettings set com.canonical.indicator.power show-percentage true
  gsettings set com.canonical.indicator.datetime time-format 'custom'
  gsettings set com.canonical.indicator.datetime custom-time-format '%d-%m  \|/ %H:%M'

  echo -e "\033[0;36mConfigurando Launcher ... \033[0m"
  launcherItems="['application://nemo.desktop', 'application://firefox.desktop', 'application://google-chrome.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
  gsettings set com.canonical.Unity.Launcher favorites $launcherItems

fi

echo -e "\033[0;36mConfigurando Nemo ... \033[0m"
gsettings set org.nemo.preferences show-new-folder-icon-toolbar true
gsettings set org.nemo.preferences show-home-icon-toolbar true
gsettings set org.nemo.preferences show-location-entry true
gsettings set org.nemo.preferences close-device-view-on-device-eject true
gsettings set org.nemo.preferences show-full-path-titles true
gsettings set org.nemo.preferences show-open-in-terminal-toolbar true





