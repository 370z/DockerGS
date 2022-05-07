#!/bin/sh

folder_gc="/home/Grasscutter"
folder_resources="$folder_gc/resources"
update=false
timems=date

cd $folder_gc

ls languages

OSVS=$(. /etc/os-release && printf '%s\n' "$NAME")
SUB="Alpine"
version=$(cat VERSION)

# Time Server
mv /etc/localtime /etc/localtime-old
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

echo "$(date) - Start Server: version $version - $OSVS" #TODO: check if empty string

while getopts d:b:v:m:e:f:p: flag
do
    case "${flag}" in
        d) DBIP=${OPTARG};;
        b) IPSERVERPB=${OPTARG};;
        v) IPSERVER=${OPTARG};;
        m) msgserver=${OPTARG};;
        e) msgemail=${OPTARG};;
        f) force=${OPTARG};;
        p) proxy=${OPTARG};;
    esac
done

# Building Data Source and Generated Resources
if [ -d "$folder_resources" ] 
then
    echo "Resources folder already exists..."
    if [ "$force" = "yes" ]; then
     echo "But keep update it"
     update=true
    fi
    # TODO: check vaild file and update maybe next time? 
else
    update=true
fi
if $update
then 
   git clone https://gitlab.com/akbaryahya91/dockergc-data.git
   ls
   cp -rf dockergc-data/resources/* resources   
   rm -R -f dockergc-data ls
fi

# Proxy Mode
if [ "$proxy" = "yes" ]; then
     echo "Proxy Server..."
     apt-get update && apt-get --no-install-recommends install -y python3 python3-pip && apt-get autoremove && apt-get clean
     pip3 install mitmproxy
     sed -i "s/game.yuuki.me/$IPSERVERPB/" proxy_config.py
     #sed -i "s/True/False/" proxy_config.py
     mitmdump -s proxy.py -k --allow-hosts ".*.yuanshen.com|.*.mihoyo.com|.*.hoyoverse.com" &
fi

if [ ! -f "config.json" ]; then
 # If there is no config file
 echo "No config file was found, try to use from command file"
 # get config.json
 java -jar grasscutter.jar -handbook
 # gacha for id name (or just use -f 'yes' for download miss file)
 # java -jar grasscutter.jar -gachamap
 # Ip private node to node
 if [ -z "$IPSERVER" ]; then
  IPSERVER=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
  echo "Server IP PRIVATE: $IPSERVER"
 else
  echo "Server IP PRIVATE: $IPSERVER"
 fi

 # ip public for user (Outside docker)
 if [ -z "$IPSERVERPB" ]; then
  IPSERVERPB=localhost
  echo "Server IP PUBLIC: $IPSERVERPB"
 else
  echo "Server IP PUBLIC: $IPSERVERPB"
 fi

 # Welcome message
 if [ -z "$msgserver" ]; then
  msgserver="Currently server run in version DockerGC $version\n\nUse !help for help\n\n~Yuuki"
 fi

 # Send Email When Registration
 if [ -z "$msgemail" ]; then
  msgemail="Hi, Thank you for registering on Yuuki Server, as a sign of gratitude for you we give gifts, you can also get more gifts with !giveall on console, please visit us for help and type !help for more info.<type=\"browser\" text=\"Discord\" href=\"https://discord.gg/tRYMG7Nm2D\"/>\n\nThis server use <type=\"browser\" text=\"Grasscutter\" href=\"https://github.com/Grasscutters\"/>Please support them by giving stars :)"
 fi

 # Need database (Outside docker)
 if [ -z "$DBIP" ]; then
  echo "No Datebase? exit!"
  exit 1
 else      
  echo "Server IP SERVER MongoDB: $DBIP"
  json -q -I -f config.json -e "this.DatabaseUrl='$DBIP'"
  json -q -I -f config.json -e "this.GameServer.DispatchServerDatabaseUrl='$DBIP'"
 fi

 # Config ip
 json -q -I -f config.json -e "this.GameServer.Ip='$IPSERVER'"
 json -q -I -f config.json -e "this.DispatchServer.Ip='$IPSERVER'"

 json -q -I -f config.json -e "this.DispatchServer.PublicIp='$IPSERVERPB'"
 json -q -I -f config.json -e "this.GameServer.PublicIp='$IPSERVERPB'"

 # Config Game
 json -q -I -f config.json -e "this.DispatchServer.defaultPermissions=['server.spawn','server.drop','player.give','player.godmode','player.clearinv','player.setstats','player.heal','player.changescene','player.givechar','player.setworldlevel','server.killall','player.giveall','player.resetconstellation','player.giveart','player.setfetterlevel','player.enterdungeon','player.settalent','player.killcharacter','player.teleport','player.weather']"
 json -q -I -f config.json -e "this.DispatchServer.AutomaticallyCreateAccounts='true'"
 #json -q -I -f config.json -e "this.DebugMode='ALL'" 
 #json -q -I -f config.json -e "this.GameServer.CMD_NoGiveTes='true'"

 # Config Email
 json -q -I -f config.json -e "this.GameServer.WelcomeMotd='$msgserver'"
 json -q -I -f config.json -e "this.GameServer.WelcomeMailContent='$msgemail'"
 json -q -I -f config.json -e 'this.GameServer.WelcomeMailItems=[{"itemId": 223,"itemCount": 1000,"itemLevel": 1},{"itemId": 224,"itemCount": 1000,"itemLevel": 1},{"itemId": 202,"itemCount": 1000000,"itemLevel": 1},{"itemId": 201,"itemCount": 10000,"itemLevel": 1},{"itemId": 203,"itemCount": 3000,"itemLevel": 1},{"itemId": 204,"itemCount": 500,"itemLevel": 1}]'

else
 # If found config file
 echo "Found config files, ignore from command"
fi

#printenv

# Game Server
java -jar grasscutter.jar