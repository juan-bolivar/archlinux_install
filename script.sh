read -p 'Ingresar dev: ' dev

read -p 'Ingresar nombre usuario: ' user

read -p 'Ingresar clave de usuario : ' clave

read -p 'Ingresar clave de usuario root : ' root 

sgdisk --zap-all $dev

(echo n
echo p
echo 
echo 
echo +512M
echo n
echo p
echo 
echo 
echo +30G
echo n
echo p
echo 
echo 
echo +8G
echo n
echo p
echo 
echo 
echo 
echo w
) | fdisk $dev

#make filesystem
mkfs.ext4 "$dev"1
mkfs.ext4 "$dev"2
mkfs.ext4 "$dev"4

#make swap
mkswap "$dev"3
swapon "$dev"3

mount "$dev"2 /mnt

# make file directory
mkdir /mnt/boot
mkdir /mnt/home


# mount filesystem
mount "$dev"1 /mnt/boot
mount "$dev"4 /mnt/home


pacstrap /mnt base base-devel emacs vim 

genfstab -U /mnt >> /mnt/etc/fstab

curl https://raw.githubusercontent.com/juan-bolivar/archlinux_install/master/arch_script.sh > /mnt/arch_script.sh
curl https://raw.githubusercontent.com/juan-bolivar/archlinux_install/master/arch_script_user.sh > /mnt/arch_script_user.sh

arch-chroot /mnt bash ./arch_script.sh $dev $user $clave $root

 
