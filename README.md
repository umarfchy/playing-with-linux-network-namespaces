# Playing 🎮 with Linux Network Namespaces 

### Objectives

Main tasks
- [ ] create new network namespaces
- [ ] connect two network namespaces via virtual ethernet (veth) 
- [ ] connect to a `python HTTP server` from a separate namespace
- [ ] connect two network namespaces via a virtual switch bridge
- [ ] use IP masquerading to establish an ingress connection

Meta tasks
- [x] docker test environment setup
- [x] apply color in bash at docker startup 
- [x] run container forever
- [x] test network types



### Connect Two Namespaces

Outline for basic command and process. Prefix with `sudo` if not accessed as root. 

1. Create a new network namespace -

```bash

ip netns add <NAMESPACE_NAME>

```

2. Create a veth cable and assign interface to a particular namespace

```bash

ip link add <INTERFACE_NAME> type veth peer name <OTHER_INTERFACE_NAME> 

ip link set <INTERFACE_NAME> netns <NAMESPACE_NAME>

```

Note: This step must to be done after interface assignment to a namespace is complete. 

Now, enter into one of the namespaces 

```bash

ip netns exec <NAMESPACE_NAME> bash

```

3. Assign IP address to interface

```bash

ip addr add <SUBNET_WITH_CIDR> dev <INTERFACE_NAME>

```

4. Bring up the interface

```bash

ip link set dev <INTERFACE_NAME> up

```

5. Configure route

```bash

ip route add <GATEWAY_IP> dev <INTERFACE_NAME>

```

You can optionally make it default gateway 

```bash

ip route add default via <GATEWAY_IP> dev <INTERFACE_NAME>

```

6. Test with `ping`

```bash

ping <OTHER_NAMESAPCE_IP>

```

you can also specify the interface

```bash

ping -I <INTERFACE> <OTHER_NAMESAPCE_IP>

```

