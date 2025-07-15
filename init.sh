#/bin/bash
# Simple script to setup environment


rm ~/.bashrc
rm ~/.bash_profile

ln -s ~/Dotfiles/.bashrc ~/.bashrc
ln -s ~/Dotfiles/.bash_profile ~/.bash_profile
ln -s ~/Dotfiles/sway ~/.config/sway
ln -s ~/Dotfiles/nvim ~/.config/nvim
ln -s ~/Dotfiles/foot ~/.config/foot
ln -s ~/Dotfiles/waybar ~/.config/waybar
ln -s ~/Dotfiles/blueman ~/.config/blueman
sudo ln -s ~/Dotfiles/proto /usr/share/fonts/proto

sudo pacman -S sway git neovim rust nodejs spotify-launcher foot lua clang gcc ripgrep fzf wget luarocks pavucontrol xorg-xwayland swaybg wmenu waybar networkmanager nm-connection-editor blueman pipewire pipewire-pulse pavucontrol wakatime network-manager-applet

sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
systemctl --user enable --now pipewire.service pipewire-pulse.service

mkdir -p ~/AUR
