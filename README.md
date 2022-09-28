# DockerGS
DockerGS is a container that run [Grasscutter](https://github.com/Grasscutters/Grasscutter) (**some anime game**) with just a single command.<br>
## How to connect to server
[Since I don't want to write same post, please visit this](https://www.yuuki.me/2022/09/how-to-connect-genshin-impact-private.html)
## How to create a server:
### Docker Version
- Install [Docker](https://docs.docker.com/engine/install/) + ([MongoDB](https://www.mongodb.com/try/download/community) If you want to run outside container)
- Open Terminal and Enter:
```sh
# Database (just once) (use this if you don't have a database outside container or want to use between containers)
docker run --rm -it --name db_gc -p 2777:27017/tcp -d mongo &
# Game server (just once download resources with -download_resource 'yes' after that you can set -download_resource 'no') (remember replace 2.0.0.100 with your pc's ip and don't use "localhost" this is important)
docker run --rm -it \
--name dockergs \
-v resources:/home/dockergs/resources \
-p 22102:22102/udp \
-p 80:80/tcp \
siakbary/dockergs:alpine-gc-3.1 \
--database 'mongodb://2.0.0.100:2777' \
--web_ip '2.0.0.100' \
--web_port '80' \
--game_ip '2.0.0.100' \
--game_port '22102' \
--download_resource 'yes' \
--ssl 'false'
--web_url_ssl "false"
```
or if you have [Docker Compose](https://docs.docker.com/compose/install/)
```sh
git clone https://github.com/akbaryahya/DockerGS
cd DockerGS
# docker compose up  # windows
docker-compose up -d # linux
```
- Then type "account create yourusername" if there is a new response open the game.
- Yay

### Windows Java Version

TODO

### Ubuntu Java Version

TODO

## Available
| Versions | OS | Download |
| ------ | ------ | ------ |
| Patch-2.6 | Alpine | ? |
| Patch-2.6-Early | Alpine | ? |
| Patch-2.7 | Alpine | ? |
| Patch-2.7-Early | Alpine | ? |
| Patch-2.8 | Alpine | ? |
| Patch-2.8-Early | Alpine | ? |
| 3.0 | Alpine | [Docker Image](https://hub.docker.com/r/siakbary/dockergs/tags?page=1&name=alpine-gc-3.0) - [Jar File](https://nightly.link/akbaryahya/DockerGS/workflows/DockerGS_GC_Alpine_3.0/main/DockerGS-GC.zip) |
| 3.1 | Alpine | [Docker Image](https://hub.docker.com/r/siakbary/dockergs/tags?page=1&name=alpine-gc-3.1) - [Jar File](https://nightly.link/akbaryahya/DockerGS/workflows/DockerGS_GC_Alpine_3.1/main/DockerGS-GC.zip) |

### Some Tips:
* [Running a JVM in a Container Without Getting Killed](https://blog.csanchez.org/2017/05/31/running-a-jvm-in-a-container-without-getting-killed/)
* [10 best practices to build a Java container with Docker](https://snyk.io/blog/best-practices-to-build-java-containers-with-docker/)

### What is "**Early**"?
Always updated from developer version and some from Pull requests. Version Without "Early" is same except that we check very carefully if any feature doesn't work or function doesn't work we ignore commits.

## How to build this? 
### Source code (Patch Version) is closed now because many are remove "source link" from their server, so at this time you can only do pull from Docker Image  or Jar File.
### Remember [Grasscutter](https://github.com/Grasscutters/Grasscutter) source code is still open, you can do your own custom server with your own hard work.
## Required
- [Java 17 JDK](https://adoptium.net/temurin/releases) 
- [Docker](https://docs.docker.com/engine/install/)
- [Gradle](https://gradle.org/install/)
- [MongoDB](https://www.mongodb.com/try/download/community)
- [Lombok](https://stackoverflow.com/questions/67899014/vs-code-did-not-recognize-lombok)

Clone this with
```sh
git clone https://github.com/akbaryahya/DockerGS
cd DockerGS
cd gs
# 0=Patch-2.6, 1=Patch-2.6-Early, 2=Patch-2.7, 3=Patch-2.7-Early, 4=Patch-2.8, 7=3.0, 8=3.1

# 2.0.0.100 is your ip computer, make sure you have mongodb installed

sh run.sh # default build localhost

sh run.sh local res 8 # Get Resources File Based Version Server

sh run.sh local start 8 # run localhost server for without docker
sh run.sh alpine start 8 2.0.0.100 # run localhost server for with docker alpine
sh run.sh ubuntu start 8 2.0.0.100 # run localhost server for with docker ubuntu

sh run.sh local build 8 # Build local aja jar only
sh run.sh alpine build 8 # Build Docker Image Alpine
sh run.sh ubuntu build 8 # Build Docker Image Ubuntu

sh run.sh local sync 8 # Sync Grasscutters to 3.1 Yuuki

sh run.sh data core # Clone Patch Version
```
## Note:
* If you have a problem with **not foundsh**: Change **CRLF** to **LF**

## Command
| Variable | Info |
| ------ | ------ |
| -db --database | IP Address for your database server, note: use computer ip if you want to run on your own pc/server, no "localhost" because it is IP in Container |
| -webip --web_ip | IP/Domain Public Web Server |
| -webport --web_port | Port Public Web Server, if you want http use port 80 and if you want https use 443 (default 80) |
| -ssl --ssl | If this is set to "true" it will make https not working and if it is "false" it will make http not working. please select: (default false) |
| -weburlssl --web_url_ssl | This changes URL "https" or "http", This is useful if you have a reverse proxy and have your own SSL. (default false) |
| -gameip --game_ip | IP Public Game Server |
| -gameport --game_port | Port Public Game Server |
| -msgwc --message_welcome | Chat Welcome Message |
| -nmsv --name_server | Name Server |
| -nmow --name_owner | Server Owner Name |
| -nmrg --name_region | Server Region Name |
| -mailmsg --mail_message | Email welcome when registering for first time |
| -po --player_online | Player limit online (-1 for unlimited) |
| -loginpass --login_password | If you want to be more secure by using password feature at login |
| -dlres --download_resource | Re-download resources if you type "yes" this is useful if you already have a resources folder but there is latest update |
| -lang --language | Server Language and includes commands [more info](https://github.com/Grasscutters/Grasscutter/tree/development/src/main/resources/languages) |
| -j --java | -Xms500M -Xmx8G [more info](https://www.baeldung.com/ops/docker-jvm-heap-size) |
| -h --help | todo |
## Port
| Port | Info |
| ------ | ------ |
| 80 | Web Server for HTTP. (Not required) |
| 443 | Web Server for HTTPS. (required) |
| 22102 | Game Communication (udp) (required) |

Power by [Grasscutter](https://github.com/Grasscutters/Grasscutter) ❤️