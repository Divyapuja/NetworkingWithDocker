#!/bin/bash
sudo docker exec -it LC1 apt-get update
sudo docker exec -it LC1 apt-get upgrade -y
sudo docker exec -it LC1 apt-get install net-tools
sudo docker exec -it LC1 apt-get install iproute2 -y
sudo docker exec -it LC1 apt install iputils-ping -y
sudo docker exec -it LC2 apt-get update
sudo docker exec -it LC2 apt-get upgrade -y
sudo docker exec -it LC2 apt-get install net-tools
sudo docker exec -it LC2 apt-get install iproute2 -y
sudo docker exec -it LC2 apt install iputils-ping -y
sudo docker exec -it SC1 apt-get update
sudo docker exec -it SC1 apt-get upgrade -y
sudo docker exec -it SC1 apt-get install net-tools
sudo docker exec -it SC1 apt-get install iproute2 -y
sudo docker exec -it SC1 apt install iputils-ping -y
sudo docker exec -it SC2 apt-get update
sudo docker exec -it SC2 apt-get upgrade -y
sudo docker exec -it SC2 apt-get install net-tools
sudo docker exec -it SC2 apt-get install iproute2 -y
sudo docker exec -it SC2 apt install iputils-ping -y
