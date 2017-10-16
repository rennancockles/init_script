#! /bin/bash

function nemoDefault() {
  echo -e "\033[0;36mConfigurando Nemo ... \033[0m"
  # Set Nemo default file manager
  xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

  # Set Nemo default desktop handler
  gsettings set org.gnome.desktop.background show-desktop-icons false
  gsettings set org.nemo.desktop show-desktop-icons true
}

function gitAlias() {
  echo -e "\033[0;36mConfigurando Git ... \033[0m"

  git config --global alias.s 'status -s'
  git config --global alias.co 'checkout'
  git config --global alias.ld 'log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'
  git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
  git config --global alias.ls 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'
  git config --global alias.lg 'log --graph --oneline --decorate --all'
}

function homeBin() {
  [[ -d $HOME/bin ]] || mkdir $HOME/bin

  HOME_ESCAPE=$(echo $HOME | sed 's,/,\\/,g');
  LN=$(sed -n '/secure_path/=' /etc/sudoers)

  # Add to sudo PATH
  sed -ri "${LN}s/(.*)\"/\1:$HOME_ESCAPE\/bin\"/" /etc/sudoers
}

function bashrcConfig() {
  echo -e "\033[0;36mConfigurando Bashrc ... \033[0m"

  echo "export PS1='\[\e[1;32m\]\u\[\e[0;32m\]@\h: \[\e[0;33m\]\w \[\e[0;36m\]`git rev-parse --abbrev-ref HEAD 2> /dev/null | sed \"s/.*/\(&\) /\"`\n\[\033[37m\]$\[\033[00m\] '">>~/.bashrc

  source ~/.bashrc
}

function keybindingsConfig() {
  echo -e "\033[0;36mConfigurando Keybindings ... \033[0m"

  keybindings="['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings $keybindings

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'nemo'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'nemo'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>e'
}

function behaviorConfig() {
  echo -e "\033[0;36mConfigurando Workspaces ... \033[0m"

  profile=$(gsettings get org.compiz current-profile | tr -d "'")

  # Workspaces
  gsettings set org.compiz.core:/org/compiz/profiles/${profile}/plugins/core/ hsize 2
  gsettings set org.compiz.core:/org/compiz/profiles/${profile}/plugins/core/ vsize 2

  # Always show menus
  gsettings set com.canonical.Unity always-show-menus true

  # Show menu in title bar
  gsettings set com.canonical.Unity integrated-menus true
}

function launcherConfig() {
  echo -e "\033[0;36mConfigurando Launcher ... \033[0m"

  # Launcher position
  # gsettings set com.canonical.Unity.Launcher launcher-position 'Top'

  # Launcher intems
  laucherItems="['application://nemo.desktop', 'application://firefox.desktop', 'application://chrome.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
  gsettings set com.canonical.Unity.Launcher favorites $laucherItems
}

function terminatorConfig() {
  echo -e "\033[0;36mConfigurando Terminator ... \033[0m"

  [[ -d ~/.config/terminator ]] || mkdir ~/.config/terminator

  echo '[global_config]
[keybindings]
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      profile = default
      type = Terminal
    [[[window0]]]
      parent = ""
      size = 765, 550
      type = Window
[plugins]
[profiles]
  [[default]]
    background_color = "#300a24"
    background_image = None
    font = Ubuntu Mono 13
    foreground_color = "#ffffff"
    login_shell = True
    scrollback_lines = 1000000
    scrollbar_position = hidden
    show_titlebar = False
    use_system_font = False
' > ~/.config/terminator/config
}

function getWps() {
  echo -e "\033[0;36mObtendo Wps ... \033[0m";

  linuxVersion="$([[ `uname -p` == x86_64 ]] && echo amd64 || echo i386)"
  link="$(curl -s http://wps-community.org/downloads | grep -oE "http:\/\/kdl1[^\"\ ]*?${linuxVersion}\.deb")"
  fileName="wps-office.deb"

  wget $link -O $fileName
  wget http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb -O web-office-fonts.deb
  dpkgInstall $fileName
}

function getWpsFonts() {
  echo -e "\033[0;36mObtendo Wps Fonts ... \033[0m";

  fileName="wps-office-fonts.deb"

  wget http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb -O $fileName
  dpkgInstall $fileName
}

function getVirtualBox() {
  echo -e "\033[0;36mObtendo Virtual Box ... \033[0m";

  linuxVersion="$([[ `uname -p` == x86_64 ]] && echo amd64 || echo i386)"
  linuxName="$(lsb_release -sc)"
  link="$(curl -s https://www.virtualbox.org/wiki/Linux_Downloads | grep -oE "http:\/\/[^\"\ ]*?${linuxName}_${linuxVersion}\.deb")"
  fileName="vbox.deb"

  wget $link -O $fileName
  dpkgInstall $fileName
}

function getTeamviewer() {
  echo -e "\033[0;36mObtendo Team Viewer ... \033[0m";

  fileName="teamviewer.deb"

  wget https://download.teamviewer.com/download/teamviewer_i386.deb -O $fileName
  dpkgInstall $fileName
}

function getChrome() {
  echo -e "\033[0;36mObtendo Chrome ... \033[0m";

  fileName="chrome.deb"

  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $fileName
  dpkgInstall $fileName
}

function getPostman() {
  echo -e "\033[0;36mObtendo Postman ... \033[0m";

  fileName="postman.tar.gz"

  wget https://dl.pstmn.io/download/latest/linux64 -O $fileName
  sudo tar -xzf $fileName -C /opt
  rm $fileName
  sudo ln -s /opt/Postman/Postman /usr/bin/postman

  cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL
}

function getSlack() {
  echo -e "\033[0;36mObtendo Slack ... \033[0m";

  lastVersion="$(curl -s https://slack.com/downloads/linux | grep Version | grep -oe [0-9.]*)"
  link="https://downloads.slack-edge.com/linux_releases/slack-desktop-${lastVersion}-amd64.deb"
  fileName="slack.deb"

  wget $link -O $fileName
  dpkgInstall $fileName
}

function getDbeaver() {
  echo -e "\033[0;36mObtendo DBeaver ... \033[0m";

  link="https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb"
  fileName="dbeaver.deb"

  wget https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb -O $fileName
  dpkgInstall $fileName
}

function dpkgInstall() {
    dpkg -i $1
    apt-get install -fy>/dev/null
    rm $1
}

function aptInstall() {
    echo -e "\033[0;36mIniciando instalação do $1 ... \033[0m"
    if ! apt-get install $1 -y>/dev/null
    then
        echo -e "\033[0;31mNão foi possível instalar $1 \033[0m\n"
    else
        echo -e "\033[0;32mInstalação concluída\033[0m\n"
    fi
}

function repoInstall() {
    echo -e "\033[0;36mIniciando instalação do repositório $1 ... \033[0m"
     if ! add-apt-repository $1 -y>/dev/null
    then
        echo -e "\033[0;31mNão foi possível instalar o repositório $1 \033[0m\n"
    else
        echo -e "\033[0;32mRepositório instalado com sucesso\033[0m\n"
    fi
}

function aptUpdate() {
    echo -e "\033[0;36mIniciando update ... \033[0m"
    if ! apt-get update -y>/dev/null
    then
        echo -e "\033[0;31mNão foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list\033[0m"
        exit 1
    fi
    echo -e "\033[0;32mUpdate realizado com sucesso\033[0m\n"
}

function aptUpgrade() {
    echo -e "\033[0;36mIniciando upgrade ... \033[0m"
    if ! apt-get upgrade -y>/dev/null
    then
        echo -e "\033[0;31mNão foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list\033[0m"
        exit 1
    fi
    echo -e "\033[0;32mUpgrade realizado com sucesso\033[0m\n"
}

function aptDistUp() {
    echo -e "\033[0;36mIniciando dist-upgrade ... \033[0m"
    if ! apt-get dist-upgrade -y>/dev/null
    then
        echo -e "\033[0;31mNão foi possível atualizar o sistema. Verifique seu arquivo /etc/apt/sources.list\033[0m"
        exit 1
    fi
    echo -e "\033[0;32mDist Upgrade realizado com sucesso\033[0m\n"
}

function afterScript() {
  echo -e "\n\n"
  echo -e "\e[1;34m          PROCEDIMENTOS FINAIS\e[0m"
  echo -e "\e[1;32m[*] \e[1;36mJAVA\e[0m: configurar variável JAVA_HOME"
  echo -e "\e[1;32m[*] \e[1;36mBURP SUITE\e[0m: baixar e instalar https://portswigger.net/burp"
  echo -e "\e[1;32m[*] \e[1;36mDEFAULT BROWSER\e[0m: update-alternatives --config gnome-www-browser"
  echo -e "\e[1;32m[*] \e[1;36mDEFAULT TERMINAL\e[0m: update-alternatives --config x-terminal-emulator"
}





##############################
#            MAIN            #
##############################

if [[ `id -u` -ne 0 ]]; then
  echo -e "\033[0;33mBota o sudo aí e roda de novo \033[0m";
  exit 1;
fi

repos=(
  'ppa:webupd8team/atom'
)

arr=(
  'default-jdk'
  'vim'
  'git'
  'htop'
  'nemo'
  'terminator'
  'minicom'
  'nmap'
  'zenmap'
  'wireshark'
  'pinta'
  'atom'
  'vlc'
  'browser-plugin-vlc'
  'audacity'
  'python-dev'
  'python-qt4'
  'python-qt4-dev'
)

arrCalls=(
  'getDbeaver'
  'getSlack'
  'getPostman'
  'getChrome'
  'getTeamviewer'
  'getVirtualBox'
  'getWps'
  'getWpsFonts'
)

aptUpdate
aptUpgrade
aptDistUp

for i in ${repos[*]}; do
  repoInstall $i;
done

aptUpdate

for i in ${arr[*]}; do
  echo -e "\033[1;33mDeseja instalar $i (Y/n)? \033[0m";
  read -rsn1;
  [[ $REPLY =~ [sSyY\ ] ]] || [[ $REPLY == '' ]] && aptInstall $i;
done

homeBin
bashrcConfig
keybindingsConfig
behaviorConfig

gitAlias
terminatorConfig
nemoDefault

for i in ${arrCalls[*]}; do
  echo -e "\033[1;33m$i (Y/n)? \033[0m";
  read -rsn1;
  [[ $REPLY =~ [sSyY\ ] ]] || [[ $REPLY == '' ]] && eval $1
done

launcherConfig
afterScript
