#!/usr/bin/env bash
set -e

KEY_FINGERPRINT="BC52 8686 B50D 79E3 39D3  721C EB3E 94AD BE12 29CF"

if [ ! -f microsoft.asc ]; then
	echo "downloading microsoft.asc"
	wget https://packages.microsoft.com/keys/microsoft.asc
fi

fingerprint_of_downloaded_file=$(gpg --with-fingerprint microsoft.asc \
	| grep "Key fingerprint" \
	| sed "s/ *Key fingerprint = //"\
)

echo "$KEY_FINGERPRINT"
echo "$fingerprint_of_downloaded_file"

if [ "$KEY_FINGERPRINT" != "$fingerprint_of_downloaded_file" ]; then
	echo "ERROR: key fingerprints do not match - quitting."
	exit 1
fi

echo "unpacking microsoft.asc to microsoft.gpg"
cat microsoft.asc | gpg --dearmor > microsoft.gpg

echo "installing key"
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/

echo "adding repository"
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
