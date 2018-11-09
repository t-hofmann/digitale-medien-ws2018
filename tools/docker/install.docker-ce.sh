#!/usr/bin/env bash

# according to
# https://docs.docker.com/engine/installation/linux/ubuntu/#os-requirements

export lang=en_US.UTF-8

KEY_ID='0EBFCD88'
KEY_SOURCE='https://download.docker.com/linux/ubuntu/gpg'
FINGERPRINT="9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"

#parent of mint 18.1 # for ubuntu: UBUNTU_PARENT=$(lsb_release -cs)
UBUNTU_PARENT="xenial"

function usage() {
	echo "usage: $0"
}

function install_prerequisites() {
	sudo apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		software-properties-common \
		lsb-release
}

function add_repository() {
	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$UBUNTU_PARENT \
		stable"
}

function install_key() {
	curl -fsSL $KEY_SOURCE \
	| sudo apt-key add -
}

function _installed_fingerprint() {
	key_id=$1
	apt-key fingerprint $key_id \
	| head -2 \
	| tail -1 \
	| sed 's/.* = //' \
	| sed 's/  / /' # fixing the double-space-character of apt-key output
}

function _isKeyValid() {
	expected=$FINGERPRINT
	installed=`_installed_fingerprint $KEY_ID`

	if [ "$expected" == "$installed" ];
	then
		echo 1
	else
		echo 0
	fi
}

function install_docker() {
	sudo apt-get update
	sudo apt-get install docker-ce
}

# *** MAIN ****************************************************

install_prerequisites

installed_fingerprint=`_installed_fingerprint $KEY_ID`;
if [ -z "$installed_fingerprint" ]; then
	echo "install key"
	install_key
fi

if [ `_isKeyValid` -eq 1 ]; then
	echo "add repository"
	add_repository
else
	echo "ERROR: could not add repository"
	echo "       comparison of keys's fingerprints failed"
	installed_fingerprint=`_installed_fingerprint $KEY_ID`;
	echo "installed: $installed_fingerprint"
	echo "expected:  $FINGERPRINT"
	echo "manually perform: apt-key fingerprint $KEY_ID"
	exit 1
fi

install_docker \
&& echo \
&& echo 'note: add users to usergroup "docker",' \
&& echo 'e. g. "sudo addgroup USER GROUP"' \
&& echo
