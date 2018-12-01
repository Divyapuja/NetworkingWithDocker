#!/bin/bash
#this is called when L3 is network type#
#src_cont = $1
#dest_cont = $2

sudo brctl addbr br2
sudo brctl addbr br3

sudo ip link set br2 up
sudo ip link set br3 up

sudo ip link add br2_LC1 type veth peer name LC1_br2
sudo ip link add br3_LC2 type veth peer name LC2_br3

sudo brctl addif br2 br2_LC1
sudo brctl addif br3 br3_LC2

sudo ip link set br2_LC1 up
sudo ip link set br3_LC2 up

LC1=sudo sh ./getPID.sh LC1
LC2=sudo sh ./getPID.sh LC2

sudo ip link set LC1_br2 netns $LC1
sudo nsenter -t $LC1 -n ip link set dev LC1_br2 up
sudo nsenter -t $LC1 -n ip addr add 192.168.6.1/24 dev LC1_br2

sudo ip link set LC2_br3 netns $LC2
sudo nsenter -t $LC2 -n ip link set dev LC2_br3 up
sudo nsenter -t $LC2 -n ip addr add 192.168.7.1/24 dev LC2_br3

sudo docker run -itd --privileged --name=$1 ubuntu
sudo docker run -itd --privileged --name=$2 ubuntu

sudo ip link add br2_$1 type veth peer name $1_br2
sudo ip link add br3_$2 type veth peer name $2_br3

sudo brctl addif br2 br2_$1
sudo brctl addif br3 br3_$2

sudo ip link set br2_$1 up
sudo ip link set br3_$2 up

CS3=sudo sh ./getPID.sh $1
CS4=sudo sh ./getPID.sh $2
SC2=sudo sh ./getPID.sh SC2

sudo ip link set $1_br2 netns $CS3
sudo nsenter -t $CS3 -n ip link set dev $1_br2 up
sudo nsenter -t $CS3 -n ip addr add 192.168.6.2/24 dev $1_br2

sudo ip link set $2_br3 netns $CS4
sudo nsenter -t $CS4 -n ip link set dev $2_br3 up
sudo nsenter -t $CS4 -n ip addr add 192.168.7.2/24 dev $2_br3

#sudo docker attach CS3
sudo nsenter -t $CS3 -n ip link set eth0 down
sudo nsenter -t $CS3 -n ip route add default via 192.168.6.1 dev $1_br2

#sudo docker attach CS4
sudo nsenter -t $CS4 -n ip link set eth0 down
sudo nsenter -t $CS4 -n ip route add default via 192.168.7.1 dev $2_br3

#sudo docker attach SC2
sudo nsenter -t $SC2 -n ip route add 192.168.6.0/24 via 192.168.3.1
sudo nsenter -t $SC2 -n ip route add 192.168.7.0/24 via 192.168.5.2
