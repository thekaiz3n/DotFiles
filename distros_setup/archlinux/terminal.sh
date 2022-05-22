#!/bin/sh

echo "Installig zsh plugins"
sudo pacman -Sy zsh-autosuggestions
cp  $DOTFILES/config/zsh/.zshrc ~/.config/zsh/.zshrc
source ~/.config/zsh/.zshrc
