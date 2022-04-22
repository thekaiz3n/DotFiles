#!/bin/sh

echo "Setting Go dev environment"

version="go1.18"
wget https://dl.google.com/go/${version}.linux-amd64.tar.gz $DEBUG_STD
sudo tar -C /usr/local -xzf ${version}.linux-amd64.tar.gz $DEBUG_STD
rm -rf go$LATEST_GO*

echo "Set your env!"
echo "echo 'export GOROOT=/usr/local/go' >> ~/.zshrc"
echo "echo 'export GOPATH=\$HOME/go' >> ~/.zshrc"
echo "echo 'export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin' >> ~/.zshrc"
