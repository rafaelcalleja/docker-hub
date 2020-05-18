#!/bin/bash -ex

# arguments:
# token = $1
# organization = $2
# repo name = $3
# branch = $4
# output-folder = $5

mkdir -p $5
wget --header="Authorization: token ${1}" --header="Accept:application/vnd.github.v3.raw" -O - https://api.github.com/repos/${2}/${3}/tarball/${4} | tar -xz --directory $5 --strip 1