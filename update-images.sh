#!/bin/bash
set -a
LIBGUESTFS_BACKEND=direct
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --root-password password:ubuntu

sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --install apt-transport-https,ca-certificates,curl,gnupg-agent,software-properties-common
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'apt-get update -y'
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'apt-get install -y docker-ce docker-ce-cli containerd.io'

sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'systemctl enable docker'
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'mkdir /etc/docker'
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --copy-in daemon.json:/etc/docker
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "mkdir -p /etc/systemd/system/docker.service.d"
sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "echo '[Service]
ExecStart=
ExecStart=/usr/bin/dockerd' > /etc/systemd/system/docker.service.d/simple_dockerd.conf"

sudo virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "apt autoremove -y --purge && apt clean -y && rm -rf /var/lib/apt/lists/*"

