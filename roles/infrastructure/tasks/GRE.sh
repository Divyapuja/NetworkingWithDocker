#!/bin/bash
#this is called when GRE is network type#
#src_cont = $1
#dest_cont = $2
sudo brctl addbr br4
sudo brctl addbr br5

sudo ip link set br4 up
sudo ip link set br5 up

sudo ip link add br4_LC1 type veth peer name LC1_br4
sudo ip link add br5_LC2 type veth peer name LC2_br5

sudo brctl addif br4 br4_LC1
sudo brctl addif br5 br5_LC2

sudo ip link set br4_LC1 up
sudo ip link set br5_LC2 up

LC1=sudo sh ./getPID.sh LC1
LC2=sudo sh ./getPID.sh LC2

sudo ip link set LC1_br4 netns $LC1
sudo nsenter -t $LC1 -n ip link set dev LC1_br4 up
sudo nsenter -t $LC1 -n ip addr add 192.168.8.1/24 dev LC1_br4

sudo ip link set LC2_br5 netns $LC2
sudo nsenter -t $LC2 -n ip link set dev LC2_br5 up
sudo nsenter -t $LC2 -n ip addr add 192.168.9.1/24 dev LC2_br5

sudo docker run -itd --privileged --name=$1 ubuntu
sudo docker run -itd --privileged --name=$2 ubuntu

sudo ip link add br4_$1 type veth peer name $1_br4
sudo ip link add br5_$2 type veth peer name $2_br5

sudo brctl addif br4 br4_$1
sudo brctl addif br5 br5_$2

sudo ip link set br4_$1 up
sudo ip link set br5_$2 up

CS5=sudo sh ./getPID.sh $1
CS6=sudo sh ./getPID.sh $2

sudo ip link set $1_br4 netns $CS5
sudo nsenter -t $CS5 -n ip link set dev $1_br4 up
sudo nsenter -t $CS5 -n ip addr add 192.168.8.2/24 dev $1_br4

sudo ip link set $2_br5 netns $CS6
sudo nsenter -t $CS6 -n ip link set dev $2_br5 up
sudo nsenter -t $CS6 -n ip addr add 192.168.9.2/24 dev $2_br5

#sudo docker attach CS5
sudo nsenter -t $CS5 -n ip link set eth0 down
sudo nsenter -t $CS5 -n ip route add default via 192.168.8.1 dev $1_br4

#sudo docker attach CS6
sudo nsenter -t $CS6 -n ip link set eth0 down
sudo nsenter -t $CS6 -n ip route add default via 192.168.9.1 dev $2_br5

#sudo docker attach LC1
sudo nsenter -t $LC1 -n ip tunnel add gretun1 mode gre local 192.168.3.1 remote 192.168.5.2
sudo nsenter -t $LC1 -n ip link set dev gretun1 up
sudo nsenter -t $LC1 -n ip route add 192.168.9.0/24 dev gretun1

#sudo docker attach LC2
sudo nsenter -t $LC2 -n ip tunnel add gretun1 mode gre local 192.168.5.2 remote 192.168.3.1
sudo nsenter -t $LC2 -n ip link set dev gretun1 up
sudo nsenter -t $LC2 -n ip route add 192.168.8.0/24 dev gretun1
