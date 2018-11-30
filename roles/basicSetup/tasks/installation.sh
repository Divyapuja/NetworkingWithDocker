#!/bin/bash
sudo docker exec -i LC1 apt-get update
sudo docker exec -i LC1 apt-get upgrade -y
sudo docker exec -i LC1 apt-get install tcpdump
sudo docker exec -i LC1 apt-get install net-tools
sudo docker exec -i LC1 apt-get install iproute2 -y
sudo docker exec -i LC1 apt install iputils-ping -y
sudo docker exec -i LC2 apt-get update
sudo docker exec -i LC2 apt-get upgrade -y
sudo docker exec -i LC2 apt-get install tcpdump
sudo docker exec -i LC2 apt-get install net-tools
sudo docker exec -i LC2 apt-get install iproute2 -y
sudo docker exec -i LC2 apt install iputils-ping -y
sudo docker exec -i SC1 apt-get update
sudo docker exec -i SC1 apt-get upgrade -y
sudo docker exec -i SC1 apt-get install tcpdump
sudo docker exec -i SC1 apt-get install net-tools
sudo docker exec -i SC1 apt-get install iproute2 -y
sudo docker exec -i SC1 apt install iputils-ping -y
sudo docker exec -i SC2 apt-get update
sudo docker exec -i SC2 apt-get upgrade -y
sudo docker exec -i SC2 apt-get install tcpdump
sudo docker exec -i SC2 apt-get install net-tools
sudo docker exec -i SC2 apt-get install iproute2 -y
sudo docker exec -i SC2 apt install iputils-ping -y
