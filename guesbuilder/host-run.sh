#!/bin/bash
CONTAINERNAME=$(cat /dev/urandom | env LC_CTYPE=C tr -dc a-zA-Z0-9 | head -c 16)
CONTAINERSOURCE="rafaelcalleja/guestbuilder:latest"
echo "Building runtime container $CONTAINERNAME from $CONTAINERSOURCE"
docker run --name "$CONTAINERNAME" -d -i -t "$CONTAINERSOURCE" bash
docker cp guest-build.sh "$CONTAINERNAME":/home/builduser/guest-build.sh
docker cp download-branch.sh "$CONTAINERNAME":/home/builduser/download-branch.sh
docker cp daemon.json "$CONTAINERNAME":/home/builduser/daemon.json
docker exec -it "$CONTAINERNAME" bash guest-build.sh
docker cp "$CONTAINERNAME":/home/builduser/ubuntu-18.04-server-cloudimg-amd64.img ubuntu-18.04-server-cloudimg-amd64.img
docker stop "$CONTAINERNAME"
docker rm "$CONTAINERNAME"