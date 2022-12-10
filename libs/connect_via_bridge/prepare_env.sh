ip netns add ns1
ip netns add ns2

ip link add br0 type bridge
ip link add n1e type veth peer name n1br
ip link add n2e type veth peer name n2br

ip link set n1e netns ns1
ip link set n2e netns ns2
ip link set n1br master br0
ip link set n2br master br0

ip addr add 192.168.0.0/16 dev br0
ip netns exec ns1 ip addr add 192.168.1.0/24 dev n1e
ip netns exec ns2 ip addr add 192.168.2.0/24 dev n2e

ip link set dev n1br up
ip link set dev n2br up
ip netns exec ns1 ip link set dev lo up
ip netns exec ns1 ip link set dev n1e up
ip netns exec ns2 ip link set dev lo up
ip netns exec ns2 ip link set dev n2e up
ip link set dev br0 up

# use the following commands to test the connectivity
# ip netns exec ns1 ping -I n1e 192.168.2.0
# ip netns exec ns2 tcpdump -v -i n2e
