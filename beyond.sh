THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR
TDCLI='https://valtman.name/files/telegram-cli-1222'
TDCLI_DIR="$THIS_DIR/tg"
Bot_DIR="$THIS_DIR/bot"
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
 
upstart() {
  printf '%s\n' "
description 'telegrambots upstart script.'

respawn
respawn limit 15 5

start on runlevel [2345]
stop on shutdown

setuid $(whoami)
exec /bin/sh $(pwd)/telegrambots
" | sudo tee /etc/init/telegrambots.conf > /dev/null

  [[ -f /etc/init/telegrambots.conf ]] && printf '%s\n' '

  Upstart script installed to /etc/init/telegrambots.conf.
  Now you can:
  Start telegrambots with     : sudo start telegrambots
  See telegrambots status with: sudo status telegrambots
  Stop telegrambots with      : sudo stop telegrambots

'
}

tgcli_config() {
  mkdir -p "$TDCLI_DIR"/telegram-cli
  printf '%s\n' "
default_profile = \"BDReborn\";

Tabadolbot = {
  config_directory = \"$TDCLI_DIR/telegram-cli\";
  test = false;
  msg_num = true;
  log_level = 2;
  wait_dialog_list = true;
};
" > "$TDCLI_DIR"/tgcli.config
}

install() {
green 'Do you want me to install? (Yy/Nn): '
  read -rp ' ' install
  case "$install" in
    Y|y)
    echo '>> Create tg folder'
      mkdir -p tg data
      echo 'installing update and updating'
      sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
		sudo apt-get install g++-4.7 -y c++-4.7 -y
		sudo apt-get update
		sudo apt-get upgrade
		sudo apt-get install libreadline-dev -y libconfig-dev -y libssl-dev -y lua5.2 -y liblua5.2-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y make unzip git redis-server autoconf g++ -y libjansson-dev -y libpython-dev -y expat libexpat1-dev -y
		sudo apt-get install screen -y
		sudo apt-get install tmux -y
		sudo apt-get install libstdc++6 -y
		sudo apt-get install lua-lgi -y
		sudo apt-get install libnotify-dev -y
      echo '>> Fetching latest Tabadolbot source code'
      echo '>> Tabadolbot successfully installed!'
      echo ">> Change values in config file and run $0"
  esac
}

luarocks() {
blue 'Do you want me to install the luarocks? (Yy/Nn): '
  read -rp ' ' install
  case "$install" in
    Y|y)
echo "luarocks has been downloading..."
wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
echo "Extracting luarocks-2.2.2.tar.gz..."
tar zxpf luarocks-2.2.2.tar.gz
echo "Change name has been luarocks..."
mv luarocks-2.2.2 luarocks
echo "Luarocks-2.2.2.tar.gz has been removed..."
rm -rf 'luarocks-2.2.2.tar.gz'
echo "Open folder luarocks"
cd luarocks
 ./configure; sudo make bootstrap
 echo "Installing rocks"
 sudo apt-get install lua-lgi
 sudo apt-get install libnotify-dev
 sudo luarocks install luasocket
 sudo luarocks install luasec
 sudo luarocks install redis-lua
 sudo luarocks install lua-term
 sudo luarocks install serpent
 sudo luarocks install dkjson
 sudo luarocks install lanes
 sudo luarocks install Lua-cURL
 echo ""
cd ..
esac
tgcli_config
}

telegram-cli() {
red 'Do you want me to install the telegram-cli? (Yy/Nn): '
  read -rp ' ' install
  case "$install" in
    Y|y)
 echo "telegram-cli-1222 has been downloading..."
 wget "$TDCLI" -O "$TDCLI_DIR"/telegram-cli-1222
 cd "$TDCLI_DIR"
 mv telegram-cli-1222 tgcli
 echo "Chmoded tgcli"
 sudo chmod +x tgcli
 cd ..
 esac
 tgcli_config
}

commands() {
  cat <<EOF

  Usage: $0 [options]

    Options:
      install           Install ${0##*/}
      update            Update ${0##*/}
      start             Start ${0##*/}
	  upstart           upstart ${0##*/}
	  on                Dont off your bot
	  help              Print this message
	  logo              Show logo

EOF
}

if [ "$1" = "install" ]; then
logo
logo1
install
luarocks
telegram-cli
elif [ "$1" = "update" ]; then
  logo
  logo1
  update
  elif [[ "$1" = "upstart" ]]; then
  logo
  logo1
  upstart
  elif [[ "$1" = "help" ]]; then
  logo
  logo1
  commands
  elif [[ "$1" = "logo" ]]; then
  logo
  logo1
  elif [[ "$1" = "on" ]]; then
  logo
  logo1
  tgcli_config
  while true; do
  screen "$TDCLI_DIR"/tgcli -WRs "$Bot_DIR"/bot.lua -c "$TDCLI_DIR"/tgcli.config -p BDReborn "$@"
  done
  elif [[ "$1" = "start" ]]; then
  if [ ! -f ./tg/tgcli ]; then
    echo "tg not found"
    echo "Run $0 install"
    exit 1
 fi
 logo
 logo1
  tgcli_config
  "$TDCLI_DIR"/tgcli -WRs "$Bot_DIR"/bot.lua -c "$TDCLI_DIR"/tgcli.config -p BDReborn "$@"
  else
  logo
  logo1
  commands
fi
