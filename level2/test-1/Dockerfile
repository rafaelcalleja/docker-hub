FROM docker

RUN apk add --no-cache bash

ARG PWD

COPY test-1/run_test.sh /

WORKDIR ${PWD}

RUN ls -la