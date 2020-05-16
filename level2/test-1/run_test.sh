#!/bin/bash

set -x

docker ps
docker login
env

ls -la

echo $PWD

pwd

ls -la ../
ls -la ../../
ls -la ../../../

exit 0