# Playing 🎮 with Linux Network Namespaces

### Objectives

Main tasks

- [x] create new network namespaces
- [ ] connect two network namespaces via virtual ethernet (veth)
- [ ] connect to a `python HTTP server` from a separate namespace
- [ ] connect two network namespaces via a virtual switch bridge
- [ ] use IP masquerading to establish an ingress connection

Meta tasks

- [x] docker test environment setup
- [x] apply color in bash at docker startup
- [x] run container forever
- [x] test network types

<details>
<summary>Connect Two Namespaces - TL;DR 👇</summary>
<br/>

Outline for basic command and process.

**Note**

> Please prefix following commands with `sudo` if we're not logged in as a root user.

1. Create a new network namespace -

```bash
ip netns add <NAMESPACE_NAME>
```

2. Create a veth cable and assign an interface to a particular namespace

```bash
ip link add <INTERFACE_NAME> type veth peer name <OTHER_INTERFACE_NAME>
ip link set <INTERFACE_NAME> netns <NAMESPACE_NAME>
```

**Note**

> This step must be done after the interface assigning to a namespace is complete.

Now, enter into one of the namespaces

```bash
ip netns exec <NAMESPACE_NAME> bash
```

3. Assign an IP address to an interface

```bash
ip addr add <SUBNET_WITH_CIDR> dev <INTERFACE_NAME>
```

4. Bring up the interface

```bash
ip link set dev <INTERFACE_NAME> up
```

5. Configure route

If we just want the namespace to send packets to the server that is making the request, we need to configure routes in both namespaces as follows -

```bash
ip route add default via <GATEWAY_IP> dev <INTERFACE_NAME>
```

6. Test with `ping`

```bash
ping <OTHER_NAMESAPCE_IP>
```

We can also specify the interface

```bash
ping -I <INTERFACE> <OTHER_NAMESAPCE_IP> # 👈 from the other namespace
tcpdump -v -i <OTHER_INTERFACE> # 👈 from the other namespace
```

</details>

Find the step-by-step example to connect two network namespaces [here](./libs/connect_via_veth/connect_via_veth.md).
