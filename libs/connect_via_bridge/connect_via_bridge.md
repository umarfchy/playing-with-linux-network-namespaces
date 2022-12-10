Let's start by creating two name spaces `ns1` & `ns2`

```bash
ip netns add ns1
ip netns add ns2
```

Now, let's create a bridge `br0` and two `veth` cables `n1e` & `n1br` and `n2e` & `n2br` interfaces respectively.

```bash
ip link add br0 type bridge
ip link add n1e type veth peer name n1br
ip link add n2e type veth peer name n2br
```

Now, let's connect the `veth` cables to the namespaces and the bridge

```bash
ip link set n1e netns ns1
ip link set n2e netns ns2
ip link set n1br master br0
ip link set n2br master br0
```

Now, let's assign IP addresses to the interfaces

```bash
ip addr add 192.168.0.0/16 dev br0
ip netns exec ns1 ip addr add 192.168.1.0/24 dev n1e
ip netns exec ns2 ip addr add 192.168.2.0/24 dev n2e
```

Now, let's bring the interfaces up

```bash
ip link set dev n1br up
ip link set dev n2br up
ip netns exec ns1 ip link set dev lo up
ip netns exec ns1 ip link set dev n1e up
ip netns exec ns2 ip link set dev lo up
ip netns exec ns2 ip link set dev n2e up
ip link set dev br0 up
```

Now, let's test the connectivity. Type the following command in `terminal 1`

```bash
ip netns exec ns1 ping -I n1e 192.168.2.0
```

and in `terminal 2`

```bash
ip netns exec ns2 tcpdump -v -i n2e
```

You should see the following output in `terminal 2`

```bash
root@fd72c74eba8e:/app# ip netns exec ns2 tcpdump -v -i n2e
tcpdump: listening on n2e, link-type EN10MB (Ethernet), snapshot length 262144 bytes
18:20:49.655730 IP (tos 0x0, ttl 64, id 32573, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 1, length 64
18:20:50.684104 IP (tos 0x0, ttl 64, id 32607, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 2, length 64
18:20:51.704173 IP (tos 0x0, ttl 64, id 32717, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 3, length 64
18:20:52.732171 IP (tos 0x0, ttl 64, id 32739, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 4, length 64
18:20:53.752192 IP (tos 0x0, ttl 64, id 32759, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 5, length 64
18:20:54.776169 IP (tos 0x0, ttl 64, id 32815, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 6, length 64
18:20:55.800180 IP (tos 0x0, ttl 64, id 33055, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 7, length 64
18:20:56.824128 IP (tos 0x0, ttl 64, id 33066, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 8, length 64
18:20:57.848172 IP (tos 0x0, ttl 64, id 33182, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 9, length 64
18:20:58.872180 IP (tos 0x0, ttl 64, id 33314, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 10, length 64
18:20:58.936097 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 192.168.2.0 tell 192.168.1.0, length 28
18:20:58.936107 ARP, Ethernet (len 6), IPv4 (len 4), Reply 192.168.2.0 is-at 56:fe:e4:d6:fd:e2 (oui Unknown), length 28
18:20:59.900175 IP (tos 0x0, ttl 64, id 33539, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 11, length 64
18:21:00.920170 IP (tos 0x0, ttl 64, id 33793, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 12, length 64
18:21:01.944174 IP (tos 0x0, ttl 64, id 33823, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 13, length 64
18:21:02.968177 IP (tos 0x0, ttl 64, id 33946, offset 0, flags [DF], proto ICMP (1), length 84)
192.168.1.0 > 192.168.2.0: ICMP echo request, id 57326, seq 14, length 64
```
