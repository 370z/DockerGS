# DockerGC
Running Grasscutter (*some anime game* server reimplementation) with Docker

## How to create a server:
- Install Docker + MongoDB
- Open Terminal and Enter:
```sh
docker run --rm -it -v resources:/home/Grasscutter/resources -p 22102:22102/udp -p 443:443/tcp siakbary/dockergc:dev-1.9 -d 'mongodb://2.0.0.100:27017' -b 'localhost' -f 'yes'
```
or (if you have compose)
```sh
docker compose up
```
- Then type "account create yuuki" if there is a new response open the game.
- done 🙂

## How to connect:
- Before starting, open game first and then logout if you have logged in before and then exit again.
- Install Fiddler then open Fiddler then click Tools -> Options -> HTTPS Print "Capture Https" and "Decrypt Https" then click "Actions" then click "Trues Root" then click yes if a popup appears.
- In Fiddler in "FiddlerScript" tab, copy script from https://pastebin.com/raw/rfhpS7U5 then click save.
- Login with user yuuki then password random/whatever then login already 🙂

## Bro, I don't want to make a server, so can I just join to your server?
Yes, Simple way is to just change localhost in file in pastebin to address server you want to connect to.

## SERVER FOR TESTING
```sh
Server IP:
game.yuuki.me

* In order to access command, please contact me *
```
This server is located in Germany so Asian players will get high ping, you can login with random username and password, account data will be reset when datebase is reset/error and sometimes server is automatically disconnected due to an error/bug/update.

## HELP
| Func | Info |
| ------ | ------ |
| d | is ip address for your database server , note: use computer ip if you want to run on your own pc, no "localhost" because it is ip in container |
| b | ip public server |
| v | ip private server |
| m | Welcome message for users |
| f | re-download resources if you type "yes" this is useful if you already have a resources folder but there is the latest update |

## Port
| Port | Info |
| ------ | ------ |
| 80 | web server for http, useless so far |
| 443 | web server for https game only works on https so make sure you have ssl or proxy stuff |
| 22102 | game communication with udp line |

Power by Grasscutter ❤️
> https://github.com/Melledy/Grasscutter