#!/usr/bin/env bash
set -ex

cd "$(dirname "$0")"

docker build -t dominolabs/rust .

read -r rustc version _ < <(docker run dominolabs/rust rustc --version)
[[ $rustc = rustc ]]
docker tag dominolabs/rust:latest dominolabs/rust:"$version"
docker push dominolabs/rust:"$version"
docker push dominolabs/rust:latest
