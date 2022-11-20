#!/bin/bash

# prepare enviroment script 

# create namespaces 
ip netns add "ns1"
ip netns add "ns2"

# create veth
ip link add "n1e" type veth peer name "n2e"

# link interface with namespace
ip link set "n1e" netns "ns1"
ip link set "n2e" netns "ns2"

# assign IP
ip netns exec "ns1" ip addr add 10.10.1.1/32 dev "n1e"
ip netns exec "ns2" ip addr add 10.10.2.1/32 dev "n2e"

# 'UP' the lo interfaces
ip netns exec "ns1" ip link set dev lo up 
ip netns exec "ns2" ip link set dev lo up 

# UP the veth interfaces  
ip netns exec "ns1" ip link set dev "n1e" up 
ip netns exec "ns2" ip link set dev "n2e" up

# add routing information
ip netns exec "ns1" ip route add default via 10.10.1.1 dev "n1e"
ip netns exec "ns2" ip route add default via 10.10.2.1 dev "n2e"
