#!/bin/bash


pacman -S linux linux-firmware --noconfirm

pacman -S grub --noconfirm
pacman -S efibootmgr --noconfirm

#bootctl --path=/boot install


#echo 'default arch\n timeout 3\n editor 0' > /boot/loader/loader.conf


grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub_uefi

grub-mkconfig -o /boot/grub/grub.cfg

mkdir /boot/loader
mkdir /boot/loader/entries

temp="$1"1
echo "
title Archlinux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value $temp ) rw
" > /boot/loader/entries/arch.conf



pacman -S networkmanager --noconfirm

systemctl enable NetworkManager

sed -i 's/# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen

locale-gen

ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime

echo 'arch' > /etc/hostname


#add multilib for checkpointvpn
echo '[multilib]'                          >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist'  >> /etc/pacman.conf


useradd $2 --create-home  --shell /bin/bash 
echo "$2:$3"   | chpasswd
echo "root:$4" | chpasswd
#echo "$2 ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

#echo "$2 ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

sudo groupadd sudo
gpasswd -a $2 sudo

echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
#echo "$2 ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

#sed -i "s/root ALL=.*/Cmnd_Alias   TESTCOMM = \/bin\/bash\nroot    ALL=(ALL:ALL) ALL\n%admin  ALL=(ALL) ALL\n%sudo   ALL=(ALL:ALL) ALL\n$2    ALL=NOPASSWD:TESTCOMM/g" /etc/sudoers


#sudo -i -u $2 bash /arch_script_user.sh $1 $2 $3

