#/bin/bash
# Simple script to setup environment


rm ~/.bashrc
rm ~/.bash_profile

ln -s ~/Dotfiles/.bashrc ~/.bashrc
ln -s ~/Dotfiles/.bash_profile ~/.bash_profile
ln -s ~/Dotfiles/sway ~/.config/sway
ln -s ~/Dotfiles/nvim ~/.config/nvim
ln -s ~/Dotfiles/foot ~/.config/foot

sudo pacman -S sway git neovim rust nodejs spotify-launcher foot lua clang gcc ripgrep fzf wget luarocks pavucontrol

