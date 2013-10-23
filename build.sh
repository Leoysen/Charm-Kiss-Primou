echo "Clear Up" 
cd  Charm-CM10-Primou
echo "Start Compiling"
#############################################################################################################################
echo "Compile KERNEL for CM9/CM10"
make clean mrproper
make charm-kiss-cm10_defconfig
make -j84
echo "Copy Modules to CM10 Ramdisk"
find -name '*.ko' -exec cp -av {} ../bootimg_tools_CM10/lib/modules/ \;
cd ../bootimg_tools_CM10
cp -R lib/modules ramdisk_advanced/lib/
cp -R lib/modules ramdisk_stable/lib/
echo "Pack CM10 Ramdisk"
cd ramdisk_advanced
find . | cpio -o -H newc | gzip > ../initramfs-Advanced.cpio.gz
cd ../
cd ramdisk_stable
find . | cpio -o -H newc | gzip > ../initramfs-Stable.cpio.gz
cd ../
echo "Pack CM10 boot.img" 
./mkbootimg --kernel zImage --ramdisk initramfs-Advanced.cpio.gz --base 0x13f00000 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=primou' --pagesize 4096 -o Charm-Kiss-CM10-date-Advanced.img
./mkbootimg --kernel zImage --ramdisk initramfs-Stable.cpio.gz --base 0x13f00000 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=primou' --pagesize 4096 -o Charm-Kiss-CM10-date-Stable.img
######## CM10 DONE ####################
read ANS
