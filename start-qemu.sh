#!/bin/bash

qemu-img resize "/image" +128G

user_data=/root/user-data.img
if [ ! -f "$user_data" ]; then
  # For the password.
  # https://stackoverflow.com/questions/29137679/login-credentials-of-ubuntu-cloud-server-image/53373376#53373376
  # https://serverfault.com/questions/920117/how-do-i-set-a-password-on-an-ubuntu-cloud-image/940686#940686
  # https://askubuntu.com/questions/507345/how-to-set-a-password-for-ubuntu-cloud-images-ie-not-use-ssh/1094189#1094189
  envsubst < /root/cloud-init-user-data.yaml > /root/user-data
  cloud-localds "$user_data" /root/user-data
fi


exec qemu-system-x86_64 \
    -drive file="/image,format=qcow2" \
    -drive file="/root/user-data.img,format=raw" \
    -m 4G \
    -vnc :0 \
    -machine ubuntu,accel=kvm \
    -vga none \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22,hostfwd=tcp::2378-:2376 \
    -virtfs local,path=${PWD},mount_tag=host0,security_model=passthrough,id=host0 \
    $@ \
;

#qemu-system-x86_64 \
#  -drive "file=${img},format=qcow2" \
#  -drive "file=${user_data},format=raw" \
#  -device e1000,netdev=net0 \
#  -netdev user,id=net0,hostfwd=tcp::5555-:22  \
#  -m 4G \
#  -netdev user,id=net0 \
#  -smp 2 \
#  -daemonize \
#  -vnc :0 \
#  -machine ubuntu,accel=tcg \
#  -vga none \
#  -daemonize \
#;