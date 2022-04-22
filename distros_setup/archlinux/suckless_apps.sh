#!/bin/sh

# Suckless, yay and init files

# Make the suckless softwares

echo "Installing suckless softwares"
cd suckless

# dmenu
cd dmenu
echo "Installing dmenu"
sudo make install

# dwm
echo "Installing dwm"
cd ../dwm
sudo make install

# dwmblocks
echo "Instaling dwmblocks"
cd ../dwmblocks
sudo make install

# st terminal
echo "Installing st terminal"
cd ../st
sudomake install

cd ..

echo "Moving statubar configs to ~/.local/bin/statusbar"
mkdir ~/.config
cp -r statusbar/ ~/config

echo "Installing yay"

cd ~/downloads

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

cd dotfiles/distros_setup/archlinux/config_files
cp xprofile xresources ~/.config/x11/
