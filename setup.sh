#!/bin/bash

#if [ "$EUID" -ne 0 ]
#	then echo "This script must be run as root :("
#	exit
#fi

cd $HOME

echo "Downloading packages..."

# Download and install core stuff
sudo pacman -Sy --needed git base-devel
if ! command -v yay &> /dev/null
then
	echo "Installing yay..."
	
	cd $HOME
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd $HOME
fi

# Download all the extra packages at once
yay -Sy i3-wm dmenu nitrogen neovim alacritty unzip neofetch i3blocks i3lock i3status
# set startx
echo "exec i3" > .xinitrc

# setup i3 widget configs

# Nitrogen config
mkdir -p images
if [ ! -f $HOME/images/lain_wallpaper.jpg ];
then
	curl https://media.animewallpapers.com/wallpapers/lain/lain_57_640.jpg --output images/lain_wallpaper.jpg
else
	echo "Image already downloaded. I won't waste your bandwidth."
fi
echo "nitrogen --no-recurse $HOME/images/lain_wallpaper.jpg" >> .xinitrc


# Alacritty config
mkdir -p $HOME/.config/alacritty
echo "[font.normal]
family = \"JetBrainsMonoNerdFont\"" > $HOME/.config/alacritty/alacritty.toml

# Download/Install jetbrains mono nerd font
if [ -d "/usr/share/fonts/JetBrainsMonoNerdFont" ];
then
	echo "JetBrains Mono Nerd Font already installed, I won't waste your bandwidth."
else
	curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip --output JetBrainsMono.zip
	unzip JetBrainsMono.zip -d JetBrainsMonoNerdFont
	sudo mv ./JetBrainsMonoNerdFont /usr/share/fonts/
fi

# Download astronvim
if [ -d "$HOME/.config/nvim" ];
then
	rm -rf $HOME/.config/nvim-tmp
	rename $HOME/.config/nvim $HOME/.config/nvim-tmp
fi
git clone --depth 1 https://github.com/AstroNvim/template $HOME/.config/nvim
rm -rf $HOME/.config/nvim/.git
echo "Open neovim to set up AstroNvim."

echo
echo
echo

echo "Setup complete! Obligatory neofetch:"
neofetch
