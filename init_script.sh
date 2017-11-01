#! /bin/bash

##############################
#           CONFIG           #
##############################

function homeBin() {
  [[ -d $HOME/bin ]] || mkdir $HOME/bin

  chown $(users):$(users) -R $HOME/bin

  HOME_ESCAPE=$(echo $HOME | sed 's,/,\\/,g');
  LN=$(sed -n '/secure_path/=' /etc/sudoers)

  # Add to sudo PATH
  sed -ri "${LN}s/(.*)\"/\1:$HOME_ESCAPE\/bin\"/" /etc/sudoers

  git clone -q https://github.com/rennancockles/bin_files.git $HOME/bin
}

function backgrounds() {
  wget -q http://wallpaperswide.com/download/homer_loves_donuts-wallpaper-1920x1080.jpg -O /usr/share/backgrounds/Hommer.jpg
  wget -q http://wallpaperswide.com/download/galactic_dinner-wallpaper-1920x1080.jpg -O /usr/share/backgrounds/Dinner.jpg
  wget -q http://wallpaperswide.com/download/blame_the_bunny-wallpaper-1920x1080.jpg -O /usr/share/backgrounds/Bunny.jpg
  wget -q http://wallpaperswide.com/download/bike_chase-wallpaper-1920x1080.jpg -O /usr/share/backgrounds/Chase.jpg
}

function bashrcConfig() {
  echo -e "\033[0;36mConfigurando Bashrc ... \033[0m"

  echo "
export PS1='\[\e[1;32m\]\u\[\e[0;32m\]@\h: \[\e[0;33m\]\w \[\e[0;36m\]\`git rev-parse --abbrev-ref HEAD 2> /dev/null | sed \"s/.*/\(&\) /\"\`\n\[\033[37m\]$\[\033[00m\] '

transfer() {
  if [ \$# -eq 0 ]; then
    echo -e \"No arguments specified. \nUsage: transfer /tmp/test.md \n       cat /tmp/test.md | transfer test.md\";
    return 1;
  fi

  tmpfile=\$( mktemp -t transferXXX );

  if tty -s; then
    basefile=\$(basename \"\$1\" | sed -e 's/[^a-zA-Z0-9._-]/-/g');
    curl --progress-bar --upload-file \"\$1\" \"https://transfer.sh/\$basefile\" >> \$tmpfile;
  else
    curl --progress-bar --upload-file \"-\" \"https://transfer.sh/\$1\" >> \$tmpfile ;
  fi;

  cat \$tmpfile;
  rm -f \$tmpfile;
}
" >>~/.bashrc

  source ~/.bashrc
}

function gitConfig() {
  echo -e "\033[0;36mConfigurando Git ... \033[0m"

  echo -e "\033[1;33mDigite um nome para a config user.name \033[0m";
  read -r NAME

  echo -e "\033[1;33mDigite um email para a config user.email \033[0m";
  read -r MAIL

  git config --global user.name "$NAME"
  git config --global user.email $MAIL

  git config --global alias.s 'status -s'
  git config --global alias.co 'checkout'
  git config --global alias.ld 'log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'
  git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
  git config --global alias.ls 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'
  git config --global alias.lg 'log --graph --oneline --decorate --all'

  git config --global core.editor "vim"
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
    # background_color = "#300a24"
    background_type = 'transparent'
    background_color = "#2d2c2d"
    background_darkness = 0.9
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



##############################
#         SOFTWARES          #
##############################

function getDbeaver() {
  echo -e "\033[0;36mObtendo DBeaver ... \033[0m";

  link="https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb"
  fileName="dbeaver.deb"

  wget -q https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb -O $fileName
  dpkgInstall $fileName
}

function getSlack() {
  echo -e "\033[0;36mObtendo Slack ... \033[0m";

  lastVersion="$(curl -s https://slack.com/downloads/linux | grep Version | grep -oe [0-9.]*)"
  link="https://downloads.slack-edge.com/linux_releases/slack-desktop-${lastVersion}-amd64.deb"
  fileName="slack.deb"

  wget -q $link -O $fileName
  dpkgInstall $fileName
}

function getChrome() {
  echo -e "\033[0;36mObtendo Chrome ... \033[0m";

  fileName="chrome.deb"

  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $fileName
  dpkgInstall $fileName
}

function getTeamviewer() {
  echo -e "\033[0;36mObtendo Team Viewer ... \033[0m";

  fileName="teamviewer.deb"

  wget -q https://download.teamviewer.com/download/teamviewer_i386.deb -O $fileName
  dpkgInstall $fileName
}

function getWps() {
  echo -e "\033[0;36mObtendo Wps ... \033[0m";

  linuxVersion="$([[ `uname -p` == x86_64 ]] && echo amd64 || echo i386)"
  link="$(curl -s http://wps-community.org/downloads | grep -oE "http:\/\/kdl1[^\"\ ]*?${linuxVersion}\.deb")"
  fileName="wps-office.deb"

  wget -q $link -O $fileName
  dpkgInstall $fileName
}

function getWpsFonts() {
  echo -e "\033[0;36mObtendo Wps Fonts ... \033[0m";

  fileName="wps-office-fonts.deb"

  wget -q http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb -O $fileName
  dpkgInstall $fileName
}



##############################
#          HELPERS           #
##############################

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
  echo -e "\e[1;32m[*] \e[1;36mSETTINGS\e[0m: execute settings.sh sem SUDO"
  echo -e "\e[1;32m[*] \e[1;36mJAVA\e[0m: configurar variável JAVA_HOME"
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

pkgs=(
  'default-jdk'
  'vim'
  'curl'
  'crunch'
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
  'virtualbox'
)

getCalls=(
  'getDbeaver'
  'getSlack'
  'getChrome'
  'getTeamviewer'
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

for i in ${pkgs[*]}; do
  echo -e "\033[1;33mDeseja instalar $i (Y/n)? \033[0m";
  read -rsn1;
  [[ $REPLY =~ [sSyY\ ] ]] || [[ $REPLY == '' ]] && aptInstall $i;
done

homeBin
backgrounds
bashrcConfig
gitConfig
terminatorConfig

for i in ${getCalls[*]}; do
  echo -e "\033[1;33m$i (Y/n)? \033[0m";
  read -rsn1;
  [[ $REPLY =~ [sSyY\ ] ]] || [[ $REPLY == '' ]] && ${i}
done

aptUpdate
afterScript
