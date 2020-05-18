#!/bin/bash
set -a

FOLDER=${PWD##*/}
BUILD_CODE=$(realpath $PWD)
sudo mkdir -p /src/$(dirname ${BUILD_CODE})
sudo chown $USER /src/$(dirname ${BUILD_CODE})
ln -s ${BUILD_CODE} /src/$(dirname ${BUILD_CODE})

docker-compose -p ${FOLDER}_test -f docker-compose.test.yml down -v --rmi local
docker-compose -p ${FOLDER}_test -f docker-compose.test.yml up --build -V --exit-code-from sut

rm /src/${BUILD_CODE}