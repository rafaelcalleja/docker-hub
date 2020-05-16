ARG PWD=/
FROM alpine
ARG PWD

RUN apk add --no-cache bash

COPY test-1/run_test.sh /

WORKDIR ${PWD}

RUN env