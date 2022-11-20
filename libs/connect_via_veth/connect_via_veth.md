### Connect Two Network Namespaces Via veth

**Note**

> Please prefix following commands with `sudo` if we're not logged in as a root user.

Let's start by creating two new network namespaces using the terminal (let's call it `terminal 1`)

```bash
ip netns add "ns1"
ip netns add "ns2"
```

We can use the following command to list the existing namespaces. Here, we should both `n1s` & `n2s`.

```bash
ip netns list
```

Afterward, let's create a `veth` cable with two interfaces `n1e` and `n2e`

```bash
ip link add "n1e" type veth peer name "n2e"
```

We can see details about the interfaces using the following command

```bash
ip addr list
```

Now, let's connect the two namespaces with the `veth`

```bash
ip link set "n1e" netns "ns1"
ip link set "n2e" netns "ns2"
```

Interestingly enough, if we now type `ip addr list` in the terminal, the `n1e` & `n2e` will be missing! Where are they, we ask? The interfaces are now inside the respective namespaces they are assigned with. So, to see them again we are required to get inside a namespace. Let's start with `ns1` 

We can now enter inside the `ns1` using the following command -

```bash
ip netns exec "ns1" bash
```

We're in! Now, if we type `ip addr list`, it will show two interfaces `lo` and `n1e`, both in the `DOWN` state. Let's test the connection `ping localhost`. This should give an error with the message `ping: connect: Cannot assign requested address`. We need to set the state up as follows to make the ping connection work.

```bash
ip link set dev lo up 
```

`ping localhost` will start working. 

Now let's assign the IP address to the interface of each side of the `veth` cable starting with `n1e`. We're required to provide the CIDR notation for the address. Also, let's bring `UP` the `n1e` interface

```bash 
ip addr add 10.10.1.1/32 dev "n1e"
ip link set dev "n1e" up 
```

Now, let's open up another terminal (`terminal 2`) and enter the `ns2` namespace as follows -

```bash
ip netns exec "ns2" bash
```
Now, we bring up the `lo` and `n2e` interfaces and also assign IP to `n2e`

```bash
ip link set dev lo up 
ip addr add 10.10.2.1/32 dev "n2e"
ip link set dev "n2e" up
```

So, now if we try `ping -I n1e 10.10.2.1` from `terminal 1` and listen to the incoming request on `terminal 2` using `tcpdump -v -i n2e`, we will see message `IP 10.10.1.1 > 10.10.2.1: ICMP echo request`. This ensures that the request is coming to `ns2`. However, we do not see anything in `terminal 1`. This suggests that no packet is getting out from `ns2` namespace. This is because the `ns2` doesn't know where to send the response to or, in other words, how to route the packets. We can fix this by adding an entry in the `route table` on `ns2`.    

To specify the `route table` we can do as follows -

```bash 
ip route add default via 10.10.2.1 dev "n2e"
```
We'll see a response in `terminal 1` now. 

Here is a question, what would happen if we do not explicitly define the interface while making the ICMP request i.e. `ping 10.10.2.1` this will show `ping: connect: Network is unreachable`. This is also a routing problem. To fix this just add the following in `ns1` 

```bash 
ip route add default via 10.10.1.1 dev "n1e"
```

Now we can ping without explicitly defining the interface. Awesome, right?

Keep playing with the network namespace and thanks for reading. 
