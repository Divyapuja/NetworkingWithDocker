#!/bin/bash
#this is called when bridge is network type#
#src_cont = $1
#dest_cont = $2
sudo docker run -itd --privileged --name=$1 --hostname=$1 ubuntu
sh ./onFlyInstallation.sh $1
pid_LC1=sudo sh ./getPID.sh LC1
pid_src=sudo sh ./getPID.sh $1
pid_dest=sudo sh ./getPID.sh $2

pid_LC1=sudo sh ./getPID.sh LC1
pid_src=sudo sh ./getPID.sh $1

sudo docker run -itd --privileged --name=$2 --hostname=$2 ubuntu
sh ./onFlyInstallation.sh $2

sudo ip link add $1_br1 type veth peer name br1_$1

sudo ip link add $2_br1 type veth peer name br1_$2

sudo ip link add br1_LC1 type veth peer name LC1_br1

sudo brctl addbr br1
sudo ip link set br1 up
#attach br1_LC1 to br1
sudo brctl addif br1 br1_LC1
sudo ip link set br1_LC1 up
sudo brctl addif br1 br1_$1
sudo ip link set br1_$1 up
sudo brctl addif br1 br1_$2
sudo ip link set br1_$2 up
#add this interface $1_br1 into $1 container
sudo nsenter -t "$pid_LC1" -n ip link set dev LC1_br1 up
sudo nsenter -t "$pid_LC1" -n ip addr add 192.168.10.1/24 dev LC1_br1

sudo nsenter -t "$pid_src" -n ip link set dev br1_$1 up
sudo nsenter -t "$pid_src" -n ip addr add 192.168.10.2/24 dev br1_$1

sudo nsenter -t "$pid_dest" -n ip link set dev br1_$2 up
sudo nsenter -t "$pid_dest" -n ip addr add 192.168.10.3/24 dev br1_$2

