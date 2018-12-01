#!/bin/bash
sudo docker exec -i $1 apt-get update
sudo docker exec -i $1 apt-get upgrade -y
sudo docker exec -i $1 apt-get install tcpdump
sudo docker exec -i $1 apt-get install net-tools
sudo docker exec -i $1 apt-get install iproute2 -y
sudo docker exec -i $1 apt install iputils-ping -y

