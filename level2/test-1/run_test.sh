#!/bin/bash

set -x

docker ps
docker network ls

env

ls -la

echo $PWD

pwd

FOLDER=${PWD##*/}
docker-compose --env-file ${ENV_FILE:-.env} -f level2/docker-compose.yml up -d

echo "WAITING FOR SELENIUM"
docker run -it --rm --net="${FOLDER}_default" dokify/wait-for -s selenium-hub:4444 -t 0 -- echo SELENIUM READY
echo "WAITING FOR CHROME"
docker run -it --rm --net="${FOLDER}_default" dokify/wait-for -s chrome:5555 -t 0 -- echo CHROME READY
echo "WAITING FOR FIREFOX"
docker run -it --rm --net="${FOLDER}_default" dokify/wait-for -s firefox:5555 -t 0 -- echo FIREFOX READY

docker-compose --env-file ${ENV_FILE:-.env} -f level2/docker-compose.yml -f level2/nosetest/docker-compose.yml run --rm --no-deps check-nosetest

exit 0