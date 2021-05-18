sudo pacman -Sy lib32-pam lib32-libx11  gufw                                      --noconfirm
sudo pacman -S noto-fonts xorg xfce4 pulseaudio lightdm-gtk-greeter  vi vim       --noconfirm
sudo pacman -S network-manager-applet git openssh thunderbird firefox pavucontrol --noconfirm
sudo pacman -S dmenu elinks feh xcompmgr sxhkd acpi newsboat mpv  mupdf           --noconfirm
sudo pacman -S textlive-most wget youtube-dl                                      --noconfirm
sudo pacman -S ansible                                                            --noconfirm

sudo ufw enable    ## firewall enabled

sudo systemctl enable ufw 
sudo systemctl enable lightdm.service

cd /home/$2 && mkdir scripts   && git clone https://github.com/juan-bolivar/custom_scripts.git /home/$2/scripts
cd /home/$2 && mkdir suckless  && git clone https://github.com/juan-bolivar/suckless_tools.git /home/$2/suckless

cd $HOME                       && git clone https://aur.archlinux.org/transset-df.git
cd $HOME/transset-df           && makepkg -si





cd /home/$2/suckless/dwmblocks && sudo make install 
cd /home/$2/suckless/dwm       && sudo make install
cd /home/$2/suckless/st        && sudo make install



#linking config files
mkdir /home/$2/.config
mkdir /home/$2/.config/sxhkd
mkdir /home/$2/.newsboat/


sudo cp    /home/$2/scripts/config/sxhkdrc         /home/$2/.config/sxhkd/sxhkdrc
sudo cat   /home/$2/scripts/config/.xprofile   >>  /home/$2/.xprofile
sudo cp    /home/$2/scripts/config/dwm.desktop     /usr/share/xsessions/dwm.desktop
sudo cp    /home/$2/scripts/config/config          /home/$2/.newsboat/config
sudo cp    /home/$2/scripts/config/urls            /home/$2/.newsboat/urls



mkdir /home/$2/.config/pulse
chown $2 /home/$2/.config/pulse
chown $2 /home/$2/scripts/helpers



sudo echo "$2 ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo
sudo sed -i "s/\%sudo *ALL=(ALL:ALL) NOPASS.*//g" /etc/sudoers


