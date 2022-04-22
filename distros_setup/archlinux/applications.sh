#!/bin/sh

echo "Installing timewizard€ý,€ý,"
cd ~/downloads

git clone https://github.com/thekaiz3n/timewizard
cd timewizard
sudo cp timewizard.sh /usr/bin/timewizard
cp -r .timewizard/* ~/.timewizard

echo "Installing exa"
sudo pacman -Sy exa

echo "Installing brave"
yay -S brave-bin

echo "zathura"
cp $DOTFILES/config/zathura/zathurarc ~/.config/zathura/zathurarc
