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
cp -R {config,apt,docs} /tmp

##############
# Ask Script #
##############
echo -e "Do you want to continue with installation? [Y/n]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    echo -e "Starting..."
    sleep 3
 else
       echo -e "Aborting..."
       sleep 1
       exit
fi

############
# Last echo #
############
clear
echo -e "Started! If you wish to quit, perform: su -c killall newbie.sh in a separate terminal."

#################################################################
# Update, make sure sudo is installed, make sure user is sudoer #
#################################################################
su --preserve-environment -c "apt update && apt install sudo && echo -e '$USER ALL=(ALL:ALL) ALL' >> /etc/sudoers"

################
# Auto install #
################

#################
# Prerequisites #						### JUST CHANGE SOURCES.LIST, CHECK ON DRIVERS  ### CAN CHOOSE STABLE/TESTING/UNSTABLE??
#################
echo -e "\nPreparing the system..."
echo -e "e\nWould you like to install these NON-FREE Drivers? [N/y]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo su -c "echo 'deb http://www.deb-multimedia.org testing main non-free' > /etc/apt/sources.list"
    sudo cp Apt/{testing,unstable,experimental}-nonfree.list /etc/apt/sources.list.d
    sleep 1
    sudo apt update
    sudo apt install -y firmware-linux-nonfree # My fucking god READ COMMENTS BEFORE CHANGING LoC
    clear
    echo -e "The Non-free Repos will be used.You should consider getting a new computer if you require these packages." # stop using random -e's
else
    sudo su -c "echo 'deb http://www.deb-multimedia.org testing main' > /etc/apt/sources.list"
    sudo cp Apt/{testing,unstable,experimental,security}.list /etc/apt/sources.list.d
    clear
    echo -e "The FREE Repos will be used. This might mean that some parts of your system (for instance your actual wifi card) are broken due to missing drivers. In case this occurs please use the non-free version instead."
    sleep 1
    sudo apt update
fi

#############################################################################################
# The point security contains non-free and contrib packages is moot as it will only provide #
# Security updates for the pre-existing software on the system                              #
#############################################################################################
sudo cp Apt/{testing,unstable,experimental,security}.pref /etc/apt/preferences.d 					### THE SAME

####################
# Begin Automation #
####################
sleep 2
clear
echo "Do you want to remove pre-existing DEs? [N/y]" 
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt remove --purge -y gnome. kde. xfce. cinnamon. mate. 
    clear
    echo -e "DEs removed...\n"
    sleep 2
else
    echo -e "\nNot removing DEs...\n"
    sleep 2
fi

###########################
# install needed packages #
###########################
clear
echo "Now installing needed system packages..."
sleep 1
sudo apt install -y -m apt-transport-https # install the package for http redirect 
sudo apt install -y --force-yes deb-multimedia-keyring # install the keyring for a repo
sudo apt update
sudo apt install -y -m firmware-linux-free tar unrar zip gzip git aptitude build-essential sudo wget ntp htop gksu # install the basic utilities

clear

echo "Rechecking Debian database..."
sudo apt -y --force-yes dist-upgrade

###########################
# more essential packages #
###########################
sleep 1
sudo apt install -y alsa-base alsa-utils alsa-tools-gui alsamixergui aptitude network-manager-gnome pulseaudio pavumeter pavucontrol paprefs paman telnet ssh

##############################################################
# install LXDE #
##############################################################
clear
echo "Do you want to install LXDE? [N/y]"
read -rn1 ans

###############################################
# Create the needed directories a bit earlier #
###############################################
if [ ! -d ~/docs ]; then
    mkdir ~/docs
fi

if [ ! -d ~/docs/misc ]; then
    mkdir ~/docs/misc
    mkdir ~/docs/tools
fi

    if [ "${ans:0:1}" = "N" ] || [ "${ans:0:1}" = "n" ]; then
	echo "Not installing LXDE..."
    else
	sudo apt install -m -y --no-install-recommends lxde-core lxde lxde-common task-lxde-desktop  lxde-settings-daemon lxde-icon-theme lightdm
	sudo apt remove --purge -y wicd.
	sudo apt install -y -m alsamixergui evince-gtk evolution gpicview lxpolkit menu-xdg lxsession lxtask lxterminal lxpanel lxappearance pcmanfm usermode xserver-xorg xscreensaver network-manager
	sudo apt install -y --no-install-recommends xarchiver

	if [ ! -d ~/.config/lxpanel/LXDE/panels ]; then
	    mkdir -p ~/.config/lxpanel/LXDE/panels
	    mkdir -p ~/.config/lxsession/LXDE
	    mkdir -p ~/.config/pcmanfm/LXDE
	    mkdir -p ~/.config/lxterminal
        fi

	if [ -d ~/.config/openbox ]; then
	    mkdir -p ~/.config/openbox/
	fi
	
	#echo "wallpaper=$HOME/Pictures/Wallpapers/PDP-11.jpg" >> /tmp/config/LXDE/desktop-items-0.conf				### WOT??? CHECK IT

	if [ ! -f ~/.config/lxterminal/lxterminal ]; then
	    cp Stuff/LXDE/lxterminal.conf ~/.config/lxterminal
	fi
	if [ ! -f ~/.config/lxsession/LXDE/autostart ]; then
	    cp Stuff/LXDE/autostart ~/.config/lxsession/LXDE
	fi
	if [ ! -f ~/.config/lxsession/LXDE/desktop.conf ]; then
	    cp Stuff/LXDE/desktop.conf ~/.config/lxsession/LXDE
	fi
	if [ ! -f ~/.config/lxpanel/launchtaskbar.cfg ]; then
	    cp Stuff/LXDE/launchtaskbar.cfg ~/.config/lxpanel
	fi
	if [ ! -f ~/.config/lxpanel/LXDE/panels/panel ]; then
	    cp Stuff/LXDE/panel ~/.config/lxpanel/LXDE/panels
	fi
	if [ ! -f ~/.config/pcmanfm/LXDE/desktop-items-0.conf ]; then
	    cp Stuff/LXDE/desktop-items-0.conf ~/.config/pcmanfm/LXDE
	fi
	if [ ! -f ~/.config/openbox/lxde-rc.xml ]; then
	    cp Stuff/LXDE/lxde-rc.xml ~/.config/openbox
	fi
    fi

################################################################################
# some moved appearance related programs which I want installed no matter what #
################################################################################
sudo apt install -m -y gtk-chtheme gtk-smooth-themes gtk-theme-config gtk-theme-switch gtk2-engines gtk2-engines-aurora gtk2-engines-cleanice gtk2-engines-magicchicken gtk2-engines-moblin gtk2-engines-murrine gtk2-engines-nodoka gtk2-engines-oxygen gtk2-engines-pixbuf gtk2-engines-qtcurve gtk2-engines-wonderland clearlooks-phenix-theme hunspell-en-us hyphen-en-us fonts-inconsolata

####################################
# Add some good, everyday programs #
####################################
clear
echo "Now installing basic programs..."
sleep 1
sudo apt install -y --no-install-recommends aspell aspell-en openjdk-7-jdk openjdk-7-jre icedtea-plugin leafpad libreoffice libreoffice-gtk nano screenfetch shutter transmission-gtk synaptic gimp mg feh gdebi zsh mutt mpd ncmpcpp deadbeef yelp offlineimap

#############################
# Move a prompt bit earlier #
#############################
clear
echo "Now prompting for optional programs..."
sleep 3

####################
# Use a nice shell #
####################
clear
echo "Would you like to use zsh? [N/y]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt install -y zsh
    sudo cp /tmp/Stuff/General/zshrc ~/.zshrc
    sudo chsh -s /bin/zsh $USER
    
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
fi

######################################################
# Cursor Packages                                    #
# THESE ARE A DEPENDENCY FURTHER IN THE SCRIPT If    #
# you remove them, remember to delete the references #
# to it!                                             #
######################################################
sudo apt install -y --no-install-recommends dmz-cursor-theme
sudo apt install -y --no-install-recommends xcursor-themes

#########################################################
# Installing some optional utilies which we find useful #
#########################################################
clear
sleep 1

if [ ! -d ~/docs/misc ]; then
    mkdir ~/docs/misc
fi

sudo apt install -y wipe keepass2 bleachbit gnupg evolution vlc lame sox vorbis-tools shutter 

#############
# wgetpaste #
#############
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


##########################################################
# remove some other packages that (may) come pre-bundled #
##########################################################
clear
echo "Now removing un-needed Programs"
sleep 1
sudo apt remove --purge -y clipit dillo

###################
# Redshift script #
###################
clear
echo -e "\aWould you like to install Redshift?\nRedshift is a tool that is designed to change your monitor brightness, gamma, etc. depending on the time of day. It has been proven to reduce eye strain and help people get to sleep on time!\nWould you like to install Redshift? [N/y]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt install -y gtk-redshift redshift

    cd /tmp
    cp docs/Redshift ~/docs/misc/Redshift
    
    echo "Redshift has been installed."
else
    echo "Redshift will not be installed."

fi

####################
# Text Editor      #
####################
clear
echo "Would you like to install another text editor or IDE? [Y/n]"
read -rn1 ans

if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    echo -e "\nWould you like to install Emacs? [Y/n]"
    read -rn1 ans

    if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
	sudo apt install -y emacs
	echo -e "VISUAL='emacs -nw'\nEDITOR='emacs'" >> ~/.bashrc
	
	cp /tmp/Stuff/General/emacs ~/.emacs
	cp --recursive /tmp/Stuff/General/emacs.d ~/.emacs.d
	cp /tmp/docs/Emacs ~/docs
    fi
    
    echo -e "\nWould you like to install Geany? [Y/n]"
    read -rn1 ans
	
    if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
	sudo apt install -y geany geany-plugins
	# insert configuration files here
    fi
    
    echo -e "\nWould you like to install vim? [Y/n]"
    read -rn1 ans
    
    if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
	sudo apt install -y vim vim-gnome
	
	# configuration files here plox
    fi
    
    #echo -e "\nWould you like to install Atom? [Y/n]"
    #read -rn1 ans
    #
    #if [ "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
	# instructions here
    #fi
fi
	
###########
# Compton #
###########
clear
echo -e "\aWould you like to download compton?\nCompton is a lightweight compositor for X.\nThis means it adds things like transparency and shadows to your desktop.\nWould you like to download Compton? [N/y]"
read -rn1 ans

if [ ! "${ans:0:1}" = "Y" ] || [ "${ans:0:1}" = "y" ]; then
    sudo apt install -y -m compton compton-conf
    echo "Compton has been installed."
else
    echo "Compton will not be installed."

fi

#############
# arc theme #
#############
sudo apt -y install autoconf automake pkg-config libgtk-3-dev git

if [ ! -d arc-theme ]; then
    git clone https://github.com/horst3180/arc-theme --depth 1 && cd arc-theme
else
    cd arc-theme

fi

./autogen.sh --prefix=/usr --disable-transparency --disable-cinnamon --disable-gnome-shell --disable-metacity --disable-unity --disable-xfwm
sudo make install

###############
# numix stuff #									### CHECK THIS
###############
cd /tmp
#sudo cp apt/numix.list /etc/apt/sources.list.d/			### add lines to sources.list
sudo apt-key add Stuff/General/numix.key
sudo apt update
sudo apt install -y -m numix-{gtk,icon}-theme numix-wallpaper-{notd,saucy,fs,halloween,winter-chill,lightbulb,simple-things,mr-numix,kitty,mesh,aurora} numix-icon-theme-circle

#############
# Chromium #
#############

sudo apt install -y chromium

#######################
# Documentation files #
#######################
cd /tmp
cp docs/Bleachbit ~/docs/misc/Bleachbit
cp docs/GPG ~/docs/misc/GPG
cp docs/Keepass2 ~/docs/misc/Keepass2
cp docs/Post-install ~/docs/Post-install
cp docs/Shutter ~/docs/misc/Shutter
cp docs/Ice ~/docs/misc/Ice
cp docs/Startup ~/docs/startup
cp docs/EXE ~/docs/EXE
cp docs/Packagelist ~/docs/

# Copy ALL the description files for reference.
if [ ! -d /usr/share/doc/script ]; then
    sudo mkdir /usr/share/doc/script
fi

sudo cp /tmp/docs/* /usr/share/doc/script

#######################
# Configuration files #
#######################
cp config/General/Xresources ~/.Xresources

######################
# Desktop background #								### CHECK THIS
######################
if [ ! -d ~/Pictures/Wallpapers ]; then
    mkdir -p ~/Pictures/Wallpapers
fi
# add some nice, wallpaper selection
wget https://imgrush.com/mCnbtcV_CedN.png -O "$HOME/Pictures/Wallpapers/Arch.png"

###############
# Final steps #
###############
sudo apt update
sudo apt upgrade -y
sudo apt -f -y install
sudo apt-get autoremove --purge 
sudo apt-get autoclean
sudo chown -R $USER:$USER $HOME/* 
sudo dpkg-reconfigure ntp
sudo alsactl store
sudo update-menus
update-menus

#####################################################################
# Keep this in please!                                              #
# Sometimes when LightDM is installed, that file becomes corrupted. #
#####################################################################
if [ -f ~/.Xauthority ]; then
    mv ~/.Xauthority ~/.Xauthority.old
fi

#######
# End #
#######
echo -e "\a\nThe script has finished!\n"
sleep 5
clear
exit
