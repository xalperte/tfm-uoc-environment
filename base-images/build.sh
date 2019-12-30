#!/bin/sh
echo "Building images"
VERSION=0.1

docker build -t xalperte/base-environment:$VERSION --build-arg ssh_prv_key="$(cat $1)" --build-arg ssh_pub_key="$(cat $2)" base-environment/

docker build -t xalperte/base-caravaggio:$VERSION base-caravaggio/

docker build -t xalperte/base-davinci:$VERSION base-davinci/