sudo ip netns add ns1
sudo ip netns add ns2

ip netns exec ns1 sudo brctl addbr br6
ip netns exec ns2 sudo brctl addbr br7

ip netns exec ns1 ip link set br6 up
ip netns exec ns2 ip link set br7 up

sudo ip link add ns1_LC1new type veth peer name LC1new_ns1
sudo ip link add ns2_LC2new type veth peer name LC2new_ns2

ip link set ns1_LC1new netns ns1
ip link set ns2_LC2new netns ns2

#sudo brctl addif br6 br6_LC1
#sudo brctl addif br7 br7_LC2

ip netns exec ns1 ip link set ns1_LC1new up
ip netns exec ns1 ip addr add 192.168.11.5/24 dev ns1_LC1new

ip netns exec ns2 ip link set ns2_LC2new up
ip netns exec ns2 ip addr add 192.168.11.6/24 dev ns2_LC2new

sudo docker inspect -f {{.State.Pid}} LC1
sudo docker inspect -f {{.State.Pid}} LC2

sudo ip link set LC1new_ns1 netns $LC1
sudo nsenter -t $LC1 -n ip link set dev LC1new_ns1 up
sudo nsenter -t $LC1 -n ip addr add 192.168.11.1/24 dev LC1new_ns1

sudo ip link set LC2new_ns2 netns $LC2
sudo nsenter -t $LC2 -n ip link set dev LC2new_ns2 up
sudo nsenter -t $LC2 -n ip addr add 192.168.11.3/24 dev LC2new_ns2

sudo docker run -itd --privileged --name=CS7 ubuntu
sudo docker run -itd --privileged --name=CS8 ubuntu

sudo ip link add br6_CS7 type veth peer name CS7_br6
sudo ip link add br7_CS8 type veth peer name CS8_br7

sudo brctl addif br6 br6_CS7
sudo brctl addif br7 br7_CS8

sudo ip link set br6_CS7 up
sudo ip link set br7_CS8 up

sudo docker inspect -f {{.State.Pid}} CS7
sudo docker inspect -f {{.State.Pid}} CS8

sudo ip link set CS7_br6 netns $CS7
sudo nsenter -t $CS7 -n ip link set dev CS7_br6 up
sudo nsenter -t $CS7 -n ip addr add 192.168.11.2/24 dev CS7_br6

sudo ip link set CS8_br7 netns $CS8
sudo nsenter -t $CS8 -n ip link set dev CS8_br7 up
sudo nsenter -t $CS8 -n ip addr add 192.168.11.4/24 dev CS8_br7

sudo docker attach CS7
ip link set eth0 down
ip route add default via 192.168.11.1 dev CS7_br6

sudo docker attach CS8
ip link set eth0 down
ip route add default via 192.168.12.1 dev CS8_br7

ip netns exec ns1 ip link add name vxlan0 type vxlan id 42 dev ns1_LC1new remote 192.168.11.6 dstport 4789
ip netns exec ns1 ip link set dev vxlan0 up
ip netns exec ns1 brctl addif br6 vxlan0

ip netns exec ns2 ip link add name vxlan0 type vxlan id 42 dev ns2_LC2new remote 192.168.11.5 dstport 4789
ip netns exec ns2 ip link set dev vxlan0 up
ip netns exec ns2 brctl addif br7 vxlan0

sudo docker attach LC1
sudo ip route add 192.168.11.0/24 dev gretun1

sudo docker attach LC2
sudo ip route add 192.168.11.0/24 dev gretun1
