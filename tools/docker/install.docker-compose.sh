#!/usr/bin/env bash

VERSION=1.23.1
KERNEL=`uname -s`
MACHINE=`uname -m`

sudo curl -L "https://github.com/docker/compose/releases/download/$VERSION/docker-compose-$KERNEL-$MACHINE" -o /usr/local/bin/docker-compose \
&& sudo chmod a+x /usr/local/bin/docker-compose
