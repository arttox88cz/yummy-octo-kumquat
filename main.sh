#!/bin/bash 
# A simple install script for Debian netinst

echo -e "\nWelcome! \n$(date)"
sleep 3
clear

###################
# Hide the cursor #
###################
tput civis

#############################################
# Exit bash on errors. Useful for debugging #
#############################################
set -e

##########################
# copy folders for later #
##########################
cp -R {config,apt} /tmp

##############
# Ask Script #
##############
echo -e "Do you want to continue with installation? [Y/n]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    echo -e "\nStarting..."
    sleep 3
 else
       echo -e "\Aborting..."
       sleep 1
       exit
fi

############
# Last echo #
############
clear
echo -e "Started! If you wish to quit, perform: su -c killall main.sh in a separate terminal."

#################
# Prerequisites #					  
#################
echo -e "\nPreparing the system..."
sleep 1
echo -e "\nCopying new sources.list..."
sleep 1

sudo cp apt/sources.list /etc/apt/sources.list
echo -e "\nCopied!"
sleep 1

sudo apt update
sudo apt install -y firmware-linux

echo -e "\nInstalled basic firmware!"
sleep 3

###########################
# install needed packages #
###########################
clear
echo "Now installing needed system packages..."
sleep 3
sudo apt install -y -m apt-transport-https 
sudo apt install -y --force-yes deb-multimedia-keyring 
sudo apt update
sudo apt install -y -m tar unrar zip gzip git aptitude build-essential sudo wget ntp htop gksu e2fsprogs xfsprogs reiserfsprogs reiser4progs jfsutils ntfs-3g fuse gvfs gvfs-fuse fusesmb flashplugin-nonfree suckless-tools

echo -e "\nInstalled system packages!"

clear
echo "Rechecking Debian database..."
sudo apt -y --force-yes dist-upgrade

#############################################################
# some moved appearance related programs which I want installed no matter what #
################################################################################
clear
echo "Appearance packages..."
sleep 3
sudo apt install -m -y gtk-chtheme gtk-smooth-themes gtk-theme-config gtk-theme-switch gtk2-engines gtk2-engines-aurora gtk2-engines-cleanice gtk2-engines-magicchicken gtk2-engines-moblin gtk2-engines-murrine gtk2-engines-nodoka gtk2-engines-oxygen gtk2-engines-pixbuf gtk2-engines-qtcurve gtk2-engines-wonderland clearlooks-phenix-theme hunspell-en-us hyphen-en-us fonts-inconsolata fonts-dejavu fonts-droid fonts-freefont-ttf fonts-liberation ttf-mscorefonts-installer

echo -e "\nAppearance packages installed!"
sleep 3

####################################
# Add some good, everyday programs #
####################################
clear
echo "Now installing basic programs..."
sleep 3
sudo apt install -y --no-install-recommends openjdk-7-jdk openjdk-7-jre icedtea-plugin libreoffice libreoffice-gtk transmission-gtk synaptic gimp mg gdebi zsh mpd ncmpcpp yelp offlineimap galculator 
sudo apt install -y -m bash-completion lintian libnss-mdns gvfs-bin gvfs-backends python-keybinder xdg-utils rsync anacron usbutils wmctrl menu bc screen cowsay figlet whois rpl cpufrequtils debconf-utils apt-xapian-index build-essential user-setup avahi-utils avahi-daemon ftp openssh-client sshfs dconf-editor

echo -e "\nBasic programs installed!"
sleep 3

####################
# Use a nice shell #
####################

clear
echo -e "\nWould you like to use zsh? [N/y]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt install -y zsh
    echo -e "\nzsh installed! Now configuring..."
    sleep 3
    sudo cp /tmp/config/General/zshrc ~/.zshrc
    sudo chsh -s /bin/zsh $USER
    echo -e "\nzsh configured!"
    sleep 3
    
    #echo "# do not prompt" > ~/.zshrc
    #zsh -c "
    #cd /tmp
    #git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    #setopt EXTENDED_GLOB
    #for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    #    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    #done
    #exit
else
    echo -e "\nNot using zsh..."
    sleep 3
fi

######################################################
# Cursor Packages                                    #
# THESE ARE A DEPENDENCY FURTHER IN THE SCRIPT If    #
# you remove them, remember to delete the references #
# to it!                                             #
######################################################
clear
echo "Cursor packages..."
sleep 3
sudo apt install -y --no-install-recommends dmz-cursor-theme
sudo apt install -y --no-install-recommends xcursor-themes

echo -e "Cursor packages installed!"
sleep 3

#########################################################
# Installing some optional utilies which we find useful #
#########################################################
clear
echo "Utility packages..."
sleep 3

sudo apt install -y wipe bleachbit gnupg vlc lame sox vorbis-tools

echo -e "\nUtility packages installed!"
sleep 3

###################
# Redshift script #
###################
clear
echo "Would you like to install Redshift? [N/y]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt install -y gtk-redshift redshift
    
    echo -e "\nRedshift installed!"
    sleep 3
else
    echo -e "\nRedshift not installed!"
    sleep 3
fi

####################
# Text Editor      #
####################
clear
echo "Would you like to install another text editor or IDE? [Y/n]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    
    echo -e "\nWould you like to install Geany? [Y/n]"
    read -rn1 ans
	
    	if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
		sudo apt install -y geany geany-plugins
		echo -e "\nGeany installed!"
		sleep 3
    	fi
    
    echo -e "\nWould you like to install vim? [Y/n]"
    read -rn1 ans
    
    	if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
		sudo apt install -y vim vim-gnome
		echo -e "\nVim installed!"
		sleep 3
    	fi
    
    echo -e "\nWould you like to install Atom? [Y/n]"
    read -rn1 ans
    
    	if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
		cd /tmp   
		rm -f atom*
		wget "https://github.com/atom/atom/releases/download/v1.2.4/atom-amd64.deb"
		sudo dpkg -i atom-amd64.deb
		echo -e "\nAtom installed!"
		sleep 3
    	fi
fi

#############
# arc theme #
#############
clear
echo "Installing arc theme..."
sleep 3
sudo apt -y install autoconf automake pkg-config libgtk-3-dev git

if [ ! -d arc-theme ]; then
    git clone https://github.com/horst3180/arc-theme --depth 1 && cd arc-theme
else
    cd arc-theme

fi

./autogen.sh --prefix=/usr
sudo make install

echo -e "\nArc theme installed!"
sleep 3

###############
# numix stuff #									### CHECK THIS
###############
clear
echo "Installing numix..."
cd /tmp
sudo apt-key add config/General/numix.key
sudo apt update
sudo apt install -y -m numix-{gtk,icon}-theme numix-wallpaper-{notd,saucy,fs,halloween,winter-chill,lightbulb,simple-things,mr-numix,kitty,mesh,aurora} numix-icon-theme-circle

echo -e "\nNumix installed!"
sleep 3
#############
# Chromium #
#############
clear
echo "Installing chromium..."
sudo apt remove --purge -y iceweasel
sudo apt install -y chromium chromium-l10n

echo -e "\nChromium installed!"
sleep 3

if [ -f ~/.Xresources ]; then
    mv ~/.Xresources ~/.Xresources.old
fi

cp config/General/Xresources ~/.Xresources

###############
# Final steps #
###############
clear
echo "Finishing..."
sleep 3

sudo apt update
sudo apt upgrade -y
sudo apt -f -y install
sudo apt-get autoremove --purge 
sudo apt-get autoclean

#######
# End #
#######
echo -e "\a\nThe script has finished!\n"
sleep 5
clear
exit
