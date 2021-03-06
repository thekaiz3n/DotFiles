#!/bin/sh

# Suckless, yay and init files

# Make the suckless softwares

echo "Installing suckless softwares"

# dmenu
echo "Installing dmenu"
cp -f ~/downloads/DotFiles/config/suckless/dmenu/config.h ~/.local/src/dmenu/
cd ~/.local/src/dmenu/
sudo make install

# dwm
echo "Installing dwm"
cp -f ~/downloads/DotFiles/configsuckless/dwm/config.h ~/.local/src/dwm/
cd ~/.local/src/dwm/
sudo make install

# dwmblocks
echo "Instaling dwmblocks"
cp -f ~/downloads/DotFiles/config/suckless/dwmblocks/config.h ~/.local/src/dwmblocks/
cd ~/.local/src/dwmblocks/
sudo make install

# st terminal
echo "Installing st terminal"
cp -f ~/downloads/DotFiles/config/suckless/st/config.h ~/.local/src/st/
cd ~/.local/src/st/
sudo make install

echo "Moving statubar configs to ~/.local/bin/statusbar"
cp -r ~/downloads/DotFiles/config/suckless/statusbar/ ~/.local/bin/statusbar/

echo "Files x11"
cd ~/downloads/DotFiles/distros_setup/archlinux/config_files/x11
cp xprofile xresources ~/.config/x11/
