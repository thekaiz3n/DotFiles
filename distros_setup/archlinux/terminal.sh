#!/bin/sh

echo "Installig zsh plugins"
sudo pacman -Sy zsh-autosuggestions
echo "source /usr/share/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null" >> ~/.config/zsh/.zshrc
source ~/.config/zsh/.zshrc
