#!/bin/bash 
# A simple install script for Debian netinst LXDE

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

####################
# Begin Automation #
####################
clear
echo "Do you want to remove pre-existing DEs? [N/y]" 
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt remove --purge -y gnome. kde. xfce. cinnamon. mate. 
    
    echo -e "\nDEs removed!"
    sleep 3
else
    echo -e "\nNot removing DEs!"
    sleep 3
fi

###########################
# install needed packages #
###########################
clear
echo "Now installing needed system packages..."
sleep 3
sudo apt install -y -m apt-transport-https # install the package for http redirect 
sudo apt install -y --force-yes deb-multimedia-keyring # install the keyring for a repo
sudo apt update
sudo apt install -y  tar unrar zip gzip git aptitude build-essential sudo wget ntp htop gksu e2fsprogs xfsprogs reiserfsprogs reiser4progs jfsutils ntfs-3g fuse gvfs gvfs-fuse fusesmb # install the basic utilities
# add -m later after debugged

echo -e "\nInstalled system packages!"

clear
echo "Rechecking Debian database..."
sudo apt -y --force-yes dist-upgrade

###########################
# NETWORK #
###########################
clear
echo "Network packages..."
sleep 3
sudo apt install -y wireless-tools firmware-iwlwifi firmware-ralink firmware-ipw2x00 firmware-realtek intel-microcode amd64-microcode network-manager-gnome telnet ssh

echo -e "\nInstalled network packages!"
sleep 3

###########################
# SOUND #
###########################
clear
echo "Sound packages..."
sleep 3
sudo apt install -y alsa-base alsa-utils alsa-tools-gui alsamixergui aptitude pulseaudio pavumeter pavucontrol paprefs paman

echo -e "\nInstalled sound packages!"
sleep 3

##############################################################
# install LXDE #
##############################################################
clear
echo "Do you want to install LXDE? [N/y]"
read -rn1 ans

    if [ "${ans:0:1}" = "N" ] || [ "${ans:0:1}" = "n" ]; then
	echo -e "\nNot installing LXDE..."
    else
    	echo -e "\nInstalling LXDE..."
    	sleep 3
    	
	sudo apt install -m -y --no-install-recommends lxde-core lxde lxde-common task-lxde-desktop lxde-settings-daemon lxde-icon-theme lightdm
	sudo apt remove --purge -y wicd.
	sudo apt install -y -m alsamixergui evince-gtk evolution gpicview lxpolkit menu-xdg lxsession lxtask lxterminal lxpanel lxappearance pcmanfm usermode xserver-xorg xscreensaver network-manager
	sudo apt install -y --no-install-recommends xarchiver flashplugin-nonfree gmrun xinput suckless-tools xfce4-power-manager xfce4-power-manager-plugins

	if [ ! -d ~/.config/lxpanel/LXDE/panels ]; then
	    mkdir -p ~/.config/lxpanel/LXDE/panels
	    mkdir -p ~/.config/lxsession/LXDE
	    mkdir -p ~/.config/pcmanfm/LXDE
	    mkdir -p ~/.config/lxterminal
        fi

	if [ -d ~/.config/openbox ]; then
	    mkdir -p ~/.config/openbox/
	fi

	if [ ! -d ~/pic ]; then
	    mkdir ~/pic
	fi
	
	sudo cp wallpaper.jpg $HOME/pic/wallpaper.jpg
	echo "wallpaper=$HOME/pic/wallpaper.jpg" >> /tmp/config/LXDE/desktop-items-0.conf				

	if [ ! -f ~/.config/lxterminal/lxterminal ]; then
	    cp config/LXDE/lxterminal.conf ~/.config/lxterminal
	fi
	if [ ! -f ~/.config/lxsession/LXDE/autostart ]; then
	    cp config/LXDE/autostart ~/.config/lxsession/LXDE
	fi
	if [ ! -f ~/.config/lxsession/LXDE/desktop.conf ]; then
	    cp config/LXDE/desktop.conf ~/.config/lxsession/LXDE
	fi
	if [ ! -f ~/.config/lxpanel/launchtaskbar.cfg ]; then
	    cp config/LXDE/launchtaskbar.cfg ~/.config/lxpanel
	fi
	if [ ! -f ~/.config/lxpanel/LXDE/panels/panel ]; then
	    cp config/LXDE/panel ~/.config/lxpanel/LXDE/panels
	fi
	if [ ! -f ~/.config/pcmanfm/LXDE/desktop-items-0.conf ]; then
	    cp config/LXDE/desktop-items-0.conf ~/.config/pcmanfm/LXDE
	fi
	if [ ! -f ~/.config/openbox/lxde-rc.xml ]; then
	    cp config/LXDE/lxde-rc.xml ~/.config/openbox
	fi
    fi

################################################################################
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
sudo apt install -y --no-install-recommends aspell aspell-en openjdk-7-jdk openjdk-7-jre icedtea-plugin leafpad libreoffice libreoffice-gtk nano screenfetch shutter transmission-gtk synaptic gimp mg feh gdebi zsh mpd ncmpcpp yelp offlineimap galculator 
sudo apt install -y bash-completion lintian libnss-mdns gvfs-bin gvfs-backends python-keybinder xdg-utils rsync anacron usbutils wmctrl menu bc screen cowsay figlet whois rpl cpufrequtils debconf-utils apt-xapian-index build-essential user-setup avahi-utils avahi-daemon ftp openssh-client sshfs
#add -m later
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

sudo apt install -y wipe bleachbit gnupg vlc lame sox vorbis-tools shutter 

echo -e "\nUtility packages installed!"
sleep 3

#############
# wgetpaste #
#############
clear
echo "Installing wgetpaste..."
sleep 3
cd /tmp
rm -Rf wgetpaste*
wget "http://wgetpaste.zlin.dk/wgetpaste-current.tar.bz2"
tar xf wgetpaste*
rm -f wgetpaste-current.tar.bz2
cd wgetpaste*
sudo cp wgetpaste /usr/bin
cd ..
rm -Rf wgetpaste*

sudo apt install xsel

cp /tmp/docs/wgetpaste ~/docs

echo -e "\nWgetpaste installed!"
sleep 3

##########################################################
# remove some other packages that (may) come pre-bundled #
##########################################################
clear
echo "Removing bloat..."
sleep 3
sudo apt remove --purge -y clipit dillo

echo "Bloat removed!"
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
	
    echo -e "\nWould you like to install Sublime Text? [Y/n]"
    read -rn1 ans
    
    	if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
		cd /tmp   
		rm -f sublime*
		wget "http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb"
		sudo dpkg -i sublime-text_build-3083_amd64.deb
		echo -e "\nSublime installed!"
		sleep 3
    	fi
fi
	
###########
# Compton #
###########
clear
echo -e "\nWould you like to download compton? [N/y]"
read -rn1 ans

if [ ! "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt install -y -m compton compton-conf
    echo -e "\nCompton installed!"
    sleep 3
else
    echo -e "\nCompton not installed!"
    sleep 3

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

./autogen.sh --prefix=/usr --disable-transparency --disable-cinnamon --disable-gnome-shell --disable-metacity --disable-unity --disable-xfwm
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
sudo apt install -y chromium

echo -e "\nChromium installed!"
sleep 3

#######################
# Configuration files #
#######################
clear
echo "Copying Xresources..."
sleep 3
cp config/General/Xresources ~/.Xresources
echo -e "\nCopied!"
sleep 1

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
sudo chown -R $USER:$USER $HOME/* 
sudo dpkg-reconfigure ntp
sudo alsactl store

if [ -f ~/.Xauthority ]; then				## sometimes becomes corrupted after installing lightdm
    mv ~/.Xauthority ~/.Xauthority.old
fi

sudo update-menus && update-menus && echo -e "\nMenus updated!" && sleep 3 || echo -e "\nFailed to update menus!"

#######
# End #
#######
echo -e "\a\nThe script has finished!\n"
sleep 5
clear
exit
