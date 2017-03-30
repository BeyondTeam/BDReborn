THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

# echo the color
gray() {
  printf '\e[1;30m%s\n\e[0;39;49m' "$@"
}
red() {
  printf '\e[1;31m%s\n\e[0;39;49m' "$@"
}
green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}
brown() {
  printf '\e[1;33m%s\n\e[0;39;49m' "$@"
}
blue() {
  printf '\e[1;34m%s\n\e[0;39;49m' "$@"
}
pink() {
  printf '\e[1;35m%s\n\e[0;39;49m' "$@"
}
paleblue() {
  printf '\e[1;36m%s\n\e[0;39;49m' "$@"
}
white() {
  printf '\e[1;37m%s\n\e[0;39;49m' "$@"
}

function logo() {
green "          ____  ____     _____"
green "         |  _ )|  _ \   |_   _|___ ____   __  __"
white "         |  _ \| |_) )    | |/ .__|  _ \_|  \/  |"
red   "         |____/|____/     |_|\____/\_____|_/\/\_|"
}
function logo1() {
green "     >>>>                       We Are Not Attacker                             "
green "     >>>>                       We Are Not Alliance                             "
white "     >>>>                       We Are Family                                   "
red   "     >>>>                       We Are The Best :-)                             "
red   "     >>>>                       @BeyondTeam                                     "
}
update() {
  git pull
  install 
}

install() {
green 'Do you want me to install? (Yy/Nn): '
  read -rp ' ' install
  case "$install" in
    Y|y)
      echo 'Installing update and updating'
      sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
		sudo apt-get install g++-4.7 -y c++-4.7 -y
		sudo apt-get update
		sudo apt-get upgrade
		sudo apt-get install libreadline-dev -y libconfig-dev -y libssl-dev -y lua5.2 -y liblua5.2-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y make unzip git redis-server autoconf g++ -y libjansson-dev -y libpython-dev -y expat libexpat1-dev -y
		sudo apt-get install screen -y
		sudo apt-get install tmux -y
		sudo apt-get install libstdc++6 -y
		sudo apt-get install lua-lgi -y
		sudo apt-get install libnotify-dev
      echo ''
  esac
}

telegram-cli() {
red 'Do you want me to install the telegram-cli? (Yy/Nn): '
  read -rp ' ' install
  case "$install" in
    Y|y)
 echo "telegram-cli-1222 has been downloading..."
 mkdir -p "$THIS_DIR"/tg
echo "Creat folder tg"
 cd tg
 wget "https://valtman.name/files/telegram-cli-1222"
 mv telegram-cli-1222 tgcli
 echo "Chmoded tgcli"
 sudo chmod +x tgcli
 cd ..
 esac
}

if [ "$1" = "install" ]; then
logo
logo1
install
telegram-cli
elif [ "$1" = "update" ]; then
logo
logo1
update
else
if [ ! -f ./tg/tgcli ]; then
echo "tg not found"
echo "Run $0 install"
exit 1
fi
logo
logo1
./tg/tgcli -s ./bot/bot.lua 
fi
