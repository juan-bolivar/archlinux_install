read -p 'Ingresar dev: ' dev

read -p 'Ingresar nombre usuario: ' user

read -p 'Ingresar clave de usuario : ' clave

read -p 'Ingresar clave de usuario root : ' root 

size_disk=$(fdisk -l | grep Disk | head -n 1 | cut -d ' ' -f3 | cut -d' ' -f1 | tr ',' '.' | sed 's/\.[0-9][0-9]*//g')

size_root=$((size_disk / 5 ))
size_root_adj=$((size_root < 4 ? 3 : size_root))
size_swap=$(vmstat -s | grep 'total memory' | awk '{print $1/1024/1024}')

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
echo +"$size_root"G
echo n
echo p
echo 
echo 
echo +"$size_swap"G
echo n
echo p
echo 
echo 
echo 
echo w
) | fdisk $dev


( echo t
  echo 1
  echo 1
  echo w) | fdisk $dev

#make filesystem
mkfs.fat -F32 "$dev"p1
mkfs.ext4 "$dev"p2
mkfs.ext4 "$dev"p4

#make swap
mkswap "$dev"p3
swapon "$dev"p3

mount "$dev"p2 /mnt

# make file directory
mkdir /mnt/boot
mkdir /mnt/home


# mount filesystem
mount "$dev"p1 /mnt/boot
mount "$dev"p4 /mnt/home


pacstrap /mnt base base-devel emacs vim linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

curl https://raw.githubusercontent.com/juan-bolivar/archlinux_install/arm64/arch_script.sh > /mnt/arch_script.sh
curl https://raw.githubusercontent.com/juan-bolivar/archlinux_install/arm64/arch_script_user.sh > /mnt/arch_script_user.sh

arch-chroot /mnt bash ./arch_script.sh $dev $user $clave $root

 
