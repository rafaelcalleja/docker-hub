#!/bin/bash

set -x

docker ps
env

ls -la

echo $PWD

cat /root/.docker/config.json

pwd

ls -la ../
ls -la ../../

exit 0