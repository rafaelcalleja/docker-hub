#!/bin/bash

user_data=user-data.img
if [ -f "${CLOUD_INIT}"] && [ ! -f "$user_data" ]; then
  envsubst < ${CLOUD_INIT} > user-data
  cloud-localds "$user_data" user-data
  USER_DATA_DRIVE='-drive file="user-data.img,format=raw"'
fi

exec qemu-system-x86_64 \
    -drive file="/image,format=qcow2" \
    ${USER_DATA_DRIVE:-''} \
    -m ${QEMU_MEMORY:-"4G"} \
    -vnc :0 \
    -machine ubuntu,accel=kvm \
    -vga none \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::${EXPOSE_SSH:-5555}-:22,hostfwd=tcp::${EXPOSE_DOCKER:-2378}-:2376 \
    $@ \
;
