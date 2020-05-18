#!/bin/bash
set -a

GITHUB_TOKEN=05d055d5ebf34e798ed5d259144b6d1d1d5aff23

wget https://cloud-images.ubuntu.com/releases/18.04/release/ubuntu-18.04-server-cloudimg-amd64.img

mv ubuntu-18.04-server-cloudimg-amd64.img orig.ubuntu-18.04-server-cloudimg-amd64.img
truncate -r orig.ubuntu-18.04-server-cloudimg-amd64.img ubuntu-18.04-server-cloudimg-amd64.img
truncate -s +5G ubuntu-18.04-server-cloudimg-amd64.img
virt-resize --expand /dev/sda1 orig.ubuntu-18.04-server-cloudimg-amd64.img ubuntu-18.04-server-cloudimg-amd64.img
rm orig.ubuntu-18.04-server-cloudimg-amd64.img

virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --copy-in download-branch.sh:/usr/local/bin/
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "/usr/local/bin/download-branch.sh ${GITHUB_TOKEN} dokify Dokify master /vagrant"
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "/usr/local/bin/download-branch.sh ${GITHUB_TOKEN} dokify docker master /home/ubuntu/docker"

virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --root-password password:ubuntu

virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --install apt-transport-https,ca-certificates,curl,gnupg-agent,software-properties-common
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'apt-get update -y'
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'apt-get install -y docker-ce docker-ce-cli containerd.io'

virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'systemctl enable docker'
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command 'mkdir /etc/docker'
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --copy-in daemon.json:/etc/docker
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "mkdir -p /etc/systemd/system/docker.service.d"
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "echo '[Service]
ExecStart=
ExecStart=/usr/bin/dockerd' > /etc/systemd/system/docker.service.d/simple_dockerd.conf"

virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "grub-install /dev/sda"

virt-sparsify ubuntu-18.04-server-cloudimg-amd64.img --convert qcow2 ubuntu-18.04-server-cloudimg-amd64.img.qcow2
mv ubuntu-18.04-server-cloudimg-amd64.img.qcow2 ubuntu-18.04-server-cloudimg-amd64.img