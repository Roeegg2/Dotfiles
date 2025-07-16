#!/bin/bash

# Arch Linux Setup Script
# Sets up a new Arch machine with Sway WM and essential tools

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root"
   exit 1
fi

# Check if Dotfiles directory exists
if [[ ! -d "$HOME/Dotfiles" ]]; then
    error "Dotfiles directory not found at $HOME/Dotfiles"
    exit 1
fi

log "Starting Arch Linux setup..."

# ==================== DOTFILES SETUP ====================
log "Setting up dotfiles..."

# Backup existing configs
backup_dir="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# Backup and remove existing configs
configs=(.bashrc .bash_profile .config/sway .config/nvim .config/foot .config/waybar .config/blueman)
for config in "${configs[@]}"; do
    if [[ -e "$HOME/$config" ]]; then
        mv "$HOME/$config" "$backup_dir/"
        log "Backed up $config to $backup_dir"
    fi
done

# Create symlinks
log "Creating symlinks..."
ln -sf "$HOME/Dotfiles/.bashrc" "$HOME/.bashrc"
ln -sf "$HOME/Dotfiles/.bash_profile" "$HOME/.bash_profile"
ln -sf "$HOME/Dotfiles/sway" "$HOME/.config/sway"
ln -sf "$HOME/Dotfiles/nvim" "$HOME/.config/nvim"
ln -sf "$HOME/Dotfiles/foot" "$HOME/.config/foot"
ln -sf "$HOME/Dotfiles/waybar" "$HOME/.config/waybar"
ln -sf "$HOME/Dotfiles/blueman" "$HOME/.config/blueman"

# Install custom fonts
if [[ -d "$HOME/Dotfiles/proto" ]]; then
    sudo mkdir -p /usr/share/fonts/proto
    sudo cp -r "$HOME/Dotfiles/proto"/* /usr/share/fonts/proto/
    sudo fc-cache -f
    log "Installed custom fonts"
fi

# ==================== PACKAGE INSTALLATION ====================
log "Installing packages..."

# Core packages
packages=(
    # Window manager and display
    sway swaybg wmenu waybar xorg-xwayland
    
    # Terminal and shell
    foot bash-completion
    
    # Development tools
    git neovim rust nodejs npm
    base-devel clang gcc
    
    # CLI utilities
    ripgrep fzf wget curl tree htop
    luarocks lua
    
    # Audio
    pipewire pipewire-pulse pavucontrol
    
    # Network
    networkmanager nm-connection-editor network-manager-applet
    
    # Bluetooth
    blueman
    
    # File manager
    thunar thunar-archive-plugin
    
    # System utilities
    wl-clipboard xdg-utils
    
    # Applications
    spotify-launcher firefox
    
    # Fonts
    ttf-dejavu ttf-liberation noto-fonts
    
    # Development extras
    wakatime
)

# Install packages
sudo pacman -S --needed "${packages[@]}"

# ==================== SYSTEM SERVICES ====================
log "Enabling system services..."

# Enable services
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service

# Enable user services
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service

# ==================== THUNAR CONFIGURATION ====================
log "Configuring Thunar..."

# Set foot as default terminal for Thunar
xfconf-query -c thunar -p /misc-terminal-emulator -n -t string -s foot 2>/dev/null || \
xfconf-query -c thunar -p /misc-terminal-emulator -s foot

xfconf-query -c thunar -p /misc-use-terminal -n -t bool -s true 2>/dev/null || \
xfconf-query -c thunar -p /misc-use-terminal -s true

# ==================== AUR PACKAGES ====================
log "Installing AUR packages..."

# Create AUR directory
mkdir -p "$HOME/AUR"
cd "$HOME/AUR"

# AUR packages to install
aur_packages=(
    "jellyfin-media-player"
    "zoom"
    "paru"  # Better AUR helper
)

install_aur_package() {
    local package=$1
    log "Installing $package from AUR..."
    
    if [[ -d "$package" ]]; then
        rm -rf "$package"
    fi
    
    git clone "https://aur.archlinux.org/$package.git"
    cd "$package"
    makepkg -si --noconfirm
    cd ..
}

for package in "${aur_packages[@]}"; do
    install_aur_package "$package"
done

# ==================== FINAL SETUP ====================
log "Performing final setup..."

# Create common directories
mkdir -p "$HOME/Documents/Projects"
mkdir -p "$HOME/Downloads"
mkdir -p "$HOME/Pictures/Screenshots"

# Set up Git (if not already configured)
if ! git config --global user.name >/dev/null 2>&1; then
    warn "Git user.name not configured. Set it with: git config --global user.name 'Your Name'"
fi

if ! git config --global user.email >/dev/null 2>&1; then
    warn "Git user.email not configured. Set it with: git config --global user.email 'your.email@example.com'"
fi

# Source the new bashrc
source "$HOME/.bashrc" 2>/dev/null || true

log "Setup complete! 🎉"
log "Backup of old configs saved to: $backup_dir"
log "Please reboot or log out and back in for all changes to take effect."

# ==================== POST-INSTALL NOTES ====================
echo
echo "=========================="
echo "POST-INSTALL CHECKLIST:"
echo "=========================="
echo "• Configure Git: git config --global user.name/user.email"
echo "• Set up SSH keys for GitHub/GitLab"
echo "• Configure Sway keybindings in ~/.config/sway/config"
echo "• Install Rust tools: cargo install exa bat fd-find"
echo "• Set up development environment (nvm, rustup, etc.)"
echo "• Configure firewall: sudo ufw enable"
echo "• Install additional fonts if needed"
echo "• Configure Waybar modules"
echo "• Set up backup solution"
