FROM ubuntu:jammy
RUN apt update -y
RUN apt install -y net-tools telnet curl \
    iproute2 iputils-ping tcpdump wget \
    vim nano python3
WORKDIR /app
COPY . .
CMD [ "sleep", "infinity" ]

# build the image and run as follows
# docker run -d --name="network-linux" --network=none --privileged <image>:<tag>