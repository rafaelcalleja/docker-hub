#!/bin/bash
set -a

FOLDER=${PWD##*/}

docker-compose -p ${FOLDER}_test -f docker-compose.1.test.yml down -v --rmi local
docker-compose -p ${FOLDER}_test -f docker-compose.1.test.yml up --build -V --exit-code-from sut
