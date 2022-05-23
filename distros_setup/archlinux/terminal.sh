#!/bin/sh

echo "Installig zsh plugins"
sudo pacman -Sy zsh-autosuggestions
cp  ~/downloads/DotFiles/config/zsh/.zshrc ~/.config/zsh/.zshrc
source ~/.config/zsh/.zshrc

echo "Installing comic-mono fonts"
sudo mkdir /usr/share/fonts/comic
cd /usr/share/fonts/comic
sudo curl -O https://dtinth.github.io/comic-mono-font/ComicMono.ttf
sudo curl -O https://dtinth.github.io/comic-mono-font/ComicMono-Bold.ttf
fc-cache