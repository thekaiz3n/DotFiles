#!/bin/sh

echo "Installing timewizard"
cd ~/downloads

git clone https://github.com/thekaiz3n/timewizard
cd timewizard
sudo cp timewizard.sh /usr/bin/timewizard
mkdir ~/.timewizard
cp -r .timewizard/* ~/.timewizard

echo "Installing exa"
sudo pacman -Sy exa

echo "zathura"
cp ~/downloads/DotFiles/config/zathura/zathurarc ~/.config/zathura/zathurarc
