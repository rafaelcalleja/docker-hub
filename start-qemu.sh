#!/usr/bin/env bash

# This is already in qcow2 format.
img=ubuntu-18.04-server-cloudimg-amd64.img
if [ ! -f "$img" ]; then
  wget "https://cloud-images.ubuntu.com/releases/18.04/release/${img}"

  # sparse resize: does not use any extra space, just allows the resize to happen later on.
  # https://superuser.com/questions/1022019/how-to-increase-size-of-an-ubuntu-cloud-image
fi

qemu-img resize "$img" +128G

user_data=user-data.img
if [ ! -f "$user_data" ]; then
  # For the password.
  # https://stackoverflow.com/questions/29137679/login-credentials-of-ubuntu-cloud-server-image/53373376#53373376
  # https://serverfault.com/questions/920117/how-do-i-set-a-password-on-an-ubuntu-cloud-image/940686#940686
  # https://askubuntu.com/questions/507345/how-to-set-a-password-for-ubuntu-cloud-images-ie-not-use-ssh/1094189#1094189
  cloud-localds "$user_data" cloud-init-user-data.yaml
fi


exec qemu-system-x86_64 -drive file="ubuntu-18.04-server-cloudimg-amd64.img,format=qcow2" -drive file="user-data.img,format=raw" -m 4G -vnc :0 -machine ubuntu,accel=kvm -vga none -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22,hostfwd=tcp::2378-:2376

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