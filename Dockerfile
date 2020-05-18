FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y qemu \
    qemu-system-x86 \
    cloud-image-utils \
    gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

WORKDIR /root

COPY start-qemu.sh /usr/local/bin/
COPY cloud-init-user-data.yaml /root/

ENTRYPOINT ["/usr/local/bin/start-qemu.sh"]

#docker run --privileged --cap-add=ALL --device /dev/kvm --mount type=tmpfs,destination=/var/tmp -p 5555:5555 -p 2378:2378 -v /dev/shm:/dev/shm -it --rm -d rafa/qemu

#docker run --device /dev/kvm --mount type=tmpfs,destination=/var/tmp -p 5555:5555 -v /dev/shm:/dev/shm -d -it --rm rafa/qemu