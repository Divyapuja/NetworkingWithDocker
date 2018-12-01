#!/bin/bash
#this is called when VXLAN is network type#
#src_cont = $1
#dest_cont = $2
sudo ip netns add ns1
sudo ip netns add ns2

LC1=sudo sh ./getPID.sh LC1
LC2=sudo sh ./getPID.sh LC2

ip netns exec ns1 sudo brctl addbr br6
ip netns exec ns2 sudo brctl addbr br7

ip netns exec ns1 ip link set br6 up
ip netns exec ns2 ip link set br7 up

sudo ip link add ns1_LC1new type veth peer name LC1new_ns1
sudo ip link add ns2_LC2new type veth peer name LC2new_ns2


sudo ip link add br6_LC1 type veth peer name LC1_br6
sudo ip link add br7_LC2 type veth peer name LC2_br7

sudo ip link set LC1_br6 netns $LC1
sudo ip link set LC2_br7 netns $LC2

sudo nsenter -t $LC1 -n ip link set dev LC1_br6 up
sudo nsenter -t $LC1 -n ip addr add 192.168.11.1/24 dev LC1_br6

sudo nsenter -t $LC2 -n ip link set dev LC2_br7 up
sudo nsenter -t $LC2 -n ip addr add 192.168.14.1/24 dev LC2_br7

ip link set br6_LC1 netns ns1
ip link set br7_LC2 netns ns2

sudo brctl addif br6 br6_LC1
sudo brctl addif br7 br7_LC2

ip link set ns1_LC1new netns ns1
ip link set ns2_LC2new netns ns2

ip netns exec ns1 ip link set br6_LC1 up
ip netns exec ns1 ip link set br7_LC2 up

ip netns exec ns1 ip link set ns1_LC1new up
ip netns exec ns1 ip addr add 192.168.11.2/24 dev ns1_LC1new

ip netns exec ns2 ip link set ns2_LC2new up
ip netns exec ns2 ip addr add 192.168.14.2/24 dev ns2_LC2new

sudo ip link set LC1new_ns1 netns $LC1
sudo nsenter -t $LC1 -n ip link set dev LC1new_ns1 up
sudo nsenter -t $LC1 -n ip addr add 192.168.12.1/24 dev LC1new_ns1

sudo ip link set LC2new_ns2 netns $LC2
sudo nsenter -t $LC2 -n ip link set dev LC2new_ns2 up
sudo nsenter -t $LC2 -n ip addr add 192.168.12.3/24 dev LC2new_ns2

sudo docker run -itd --privileged --name=$1 ubuntu
sudo docker run -itd --privileged --name=$2 ubuntu

sudo ip link add br6_$1 type veth peer name $1_br6
sudo ip link add br7_$2 type veth peer name $2_br7

sudo brctl addif br6 br6_$1
sudo brctl addif br7 br7_$2

sudo ip link set br6_$1 up
sudo ip link set br7_$2 up

CS7=sudo sh ./getPID.sh $1
CS8=sudo sh ./getPID.sh $2

sudo ip link set $1_br6 netns $CS7
sudo nsenter -t $CS7 -n ip link set dev $1_br6 up
sudo nsenter -t $CS7 -n ip addr add 192.168.12.2/24 dev $1_br6

sudo ip link set $2_br7 netns $CS8
sudo nsenter -t $CS8 -n ip link set dev $2_br7 up
sudo nsenter -t $CS8 -n ip addr add 192.168.12.4/24 dev $2_br7

#sudo docker attach CS7
sudo nsenter -t $CS7 -n ip link set eth0 down
sudo nsenter -t $CS7 -n ip route add default via 192.168.12.1 dev $1_br6

#sudo docker attach CS8
sudo nsenter -t $CS8 -n ip link set eth0 down
sudo nsenter -t $CS8 -n ip route add default via 192.168.12.3 dev $2_br7

ip netns exec ns1 ip link add name vxlan0 type vxlan id 42 dev ns1_LC1new remote 192.168.14.2 dstport 4789
ip netns exec ns1 ip link set dev vxlan0 up
ip netns exec ns1 brctl addif br6 vxlan0

ip netns exec ns2 ip link add name vxlan0 type vxlan id 42 dev ns2_LC2new remote 192.168.11.1 dstport 4789
ip netns exec ns2 ip link set dev vxlan0 up
ip netns exec ns2 brctl addif br7 vxlan0

#sudo docker attach LC1
sudo nsenter -t $LC1 -n sudo ip route add 192.168.11.0/24 dev gretun1

#sudo docker attach LC2
sudo nsenter -t $LC2 -n sudo ip route add 192.168.14.0/24 dev gretun1
