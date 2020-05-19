#!/bin/bash
set -a

wget https://cloud-images.ubuntu.com/releases/18.04/release/ubuntu-18.04-server-cloudimg-amd64.img

qemu-img resize ubuntu-18.04-server-cloudimg-amd64.img +128G

virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --root-password password:ubuntu
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --install apt-transport-https,ca-certificates,curl,gnupg-agent,software-properties-common,make,jq

read -r -d '' RUN_COMMAND <<'EOF'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
apt-get update -y && \
apt-get install -y docker-ce docker-ce-cli containerd.io && \
systemctl enable docker && \
mkdir /etc/docker && \
mkdir -p /etc/systemd/system/docker.service.d && \
echo '[Service]
ExecStart=
ExecStart=/usr/bin/dockerd' > /etc/systemd/system/docker.service.d/simple_dockerd.conf && \
sed -i 's/scripts\-user/[scripts\-user, always]/g' /etc/cloud/cloud.cfg
EOF

virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --run-command "${RUN_COMMAND}"
virt-customize -a ubuntu-18.04-server-cloudimg-amd64.img --copy-in daemon.json:/etc/docker