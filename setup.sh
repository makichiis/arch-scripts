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
yay -Sy vim i3-wm feh neovim alacritty unzip neofetch i3blocks i3lock i3status polybar picom rofi pfetch
# set startx
echo "exec i3" > .xinitrc
echo "exec picom" >> .xinitrc

# set vimrc
cp /usr/share/vim/vim91/vimrc_example.vim $HOME/arch-i3-dots.vimrc
echo ":set number" >> arch-i3-dots.vimrc
echo "\" remove this if you dont want my vim customization :(" >> .vimrc
echo "source $HOME/arch-i3-dots.vimrc" >> .vimrc

# setup i3 widget configs

# Nitrogen config
#mkdir -p images
#if [ ! -f $HOME/images/lain_wallpaper.jpg ];
#then
#	curl https://media.animewallpapers.com/wallpapers/lain/lain_57_640.jpg --output images/lain_wallpaper.jpg
#else
#	echo "Image already downloaded. I won't waste your bandwidth."
#fi
#echo "nitrogen --no-recurse $HOME/images/lain_wallpaper.jpg" >> .xinitrc

# Install dots
cd $HOME/.config
git clone https://github.com/zaruhev/arch-i3-dots.git
mv ./arch-i3-dots/* .
rm -rf arch-i3-dots
cd $HOME

# Symbolic links and permissions. Am I using the best permissions here?
sudo chmod a+rwx $HOME/.config/i3/scripts/fetch.sh
sudo chmod a+rwx $HOME/.config/i3/scripts/motd.sh
sudo ln $HOME/.config/i3/scripts/fetch.sh /usr/sbin/fetch
sudo ln $HOME/.config/i3/scripts/motd.sh /usr/bin/motd

echo "PS1='\[\033[1;33m\]\W -> \{\033[0m\]'" > arch-i3-dots.bashrc
echo "source $HOME/arch-i3-dots.bashrc" >> .bashrc

# Alacritty config - removed because it is located in the dots repo
#mkdir -p $HOME/.config/alacritty
#echo "[font.normal]
#family = \"JetBrainsMonoNerdFont\"" > $HOME/.config/alacritty/alacritty.toml

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
#if [ -d "$HOME/.config/nvim" ];
#then
#	rm -rf $HOME/.config/nvim-tmp
#	rename $HOME/.config/nvim $HOME/.config/nvim-tmp
#fi
#git clone --depth 1 https://github.com/AstroNvim/template $HOME/.config/nvim
#rm -rf $HOME/.config/nvim/.git
#echo "Open neovim to set up AstroNvim."

#echo "Not setting up AstroNvim, for now."

# Setup ly
read -r -p "Install and load ly greeter via systemd? [Y/n]" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    yay -Sy ly
    systemctl enable ly.service
    systemctl disable getty@tty2.service
fi

echo "NvChad will install on the first run of Neovim. Delete ~/.config/nvim to opt out."

echo
echo
echo

echo "Setup complete! Obligatory fetch:"
fetch
