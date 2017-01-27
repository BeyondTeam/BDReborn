#!/usr/bin/env bash

cd $HOME/BDReborn

install() {
	    cd tg
		sudo add-apt-repository ppa:ubuntu-toolchain-r/test
		sudo apt-get install g++-4.7 c++-4.7
		sudo apt-get update		
        sudo apt-get upgrade
		sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev
		sudo apt-get install lua-lgi
		sudo apt-get install libnotify-dev
		sudo apt-get install screen
		sudo apt-get install tmux
		wget https://valtman.name/files/telegram-cli-1222
		mv telegram-cli-1222 tgcli
		chmod +x tgcli
		cd ..
		chmod +x bot
		chmod +x tg
}

if [ "$1" = "install" ]; then
  install
  else

if [ ! -f ./tg/tgcli ]; then
    echo "tg not found"
    echo "Run $0 install"
    exit 1
fi
   echo -e "\033[38;5;208m"
   echo -e "     > BeyondTeam Source :D                        "
   echo -e "                                              \033[0;00m"
   echo -e "\e[36m"
   ./tg/tgcli -s ./bot/bot.lua $@
fi

# Now All Argument Support after ./beyond.sh !
#	Arguments :
#			#			#			#			#			#			#			#			#			#
#  --phone/-u                           specify username (would not be asked during authorization)
#  --verbosity/-v                       increase verbosity (0-ERROR 1-WARNIN 2-NOTICE 3+-DEBUG-levels)
#  --enable-msg-id/-N                   message num mode
#  --config/-c                          config file name
#  --profile/-p                         use specified profile
#  --wait-dialog-list/-W                send dialog_list query and wait for answer before reading input
#  --disable-colors/-C                  disable color output
#  --disable-readline/-R                disable readline
#  --alert/-A                           enable bell notifications
#  --daemonize/-d                       daemon mode
#  --logname/-L <log-name>              log file name
#  --username/-U <user-name>            change uid after start
#  --groupname/-G <group-name>          change gid after start
#  --disable-output/-D                  disable output
#  --tcp-port/-P <port>                 port to listen for input commands
#  --udp-socket/-S <socket-name>        unix socket to create
#  --exec/-e <commands>                 make commands end exit
#  --disable-names/-I                   use user and chat IDs in updates instead of names
#  --help/-h                            prints this help
#  --accept-any-tcp                     accepts tcp connections from any src (only loopback by default)
#  --disable-link-preview               disables server-side previews to links
#  --bot/-b                             bot mode
#  --json                               prints answers and values in json format
#  --permanent-msg-ids                  use permanent msg ids
#  --permanent-peer-ids                 use permanent peer ids
#			#			#			#			#			#			#			#			#			#
#Example To launch with second profile :
# ./beyond.sh -p second-profile

#			  OR

# ./beyond.sh --profile second-profile
