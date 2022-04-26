#!/bin/sh
echo "==============================================================================="
echo "Upgrading"
sudo apt upgrade -y
sudo apt update -y
echo "==============================================================================="
echo " "
echo "==============================================================================="
echo "Installing base-dev libs"
sudo apt install -y build-essential git neovim zsh curl wget
echo "==============================================================================="
echo " "
echo "==============================================================================="
echo "Configuring zsh"
mkdir /usr/share/zsh/plugins/
sudo apt install -y unzip

# exa install
EXA_VERSION=$(curl -s "https://api.github.com/repos/ogham/exa/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo exa.zip "https://github.com/ogham/exa/releases/latest/download/exa-linux-x86_64-v${EXA_VERSION}.zip"
sudo unzip -q exa.zip bin/exa -d /usr/local
rm -rf exa.zip

# Plugins
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting /usr/share/zsh/plugins/fast-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh/plugins/zsh-autosuggestions/

# .zshrc
wget https://raw.githubusercontent.com/thekaiz3n/DotFiles/main/config/zsh/.zshrc
sudo chsh -s /usr/bin/zsh
echo ""
echo "==============================================================================="
echo "Configuring Neovim"
mkdir .config/nvim
mkdir .config/nvim/autoload
wget https://raw.githubusercontent.com/thekaiz3n/DotFiles/main/config/nvim/init.vim -P ~/.config/nvim/
wget https://raw.githubusercontent.com/thekaiz3n/DotFiles/main/config/nvim/autoload/plug.vim -P ~/.config/nvim/autoload
echo "Open nvim and execute:"
echo ":PlugInstall"
echo " "

echo "==============================================================================="
echo "Executar goinstall.sh"
echo "==============================================================================="
echo " "

echo "==============================================================================="
echo "Tools"
echo "==============================================================================="
sudo apt install -y docker.io docker-compose
