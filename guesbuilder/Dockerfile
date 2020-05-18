FROM debian:buster
RUN useradd -ms /bin/bash builduser
RUN apt update && apt install -y wget libguestfs-tools
RUN apt-get update && \
    apt-get install -y qemu && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

USER builduser
WORKDIR /home/builduser