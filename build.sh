echo "Start Compiling"
############################################################################################################################
echo "COMPILE KERNEL FOR SENSE" 
make clean mrproper
make charm-kiss_defconfig 
make -j84
echo "Copy Modules to Sense Ramdisk"
find -name '*.ko' -exec cp -av {} ../bootimg_tools_Charm/lib/modules/ \;
cd ../bootimg_tools_Charm
cp -R lib/modules ramdisk_advanced/lib
cp -R lib/modules ramdisk_stable/lib
cd ramdisk_advanced
find . | cpio -o -H newc | gzip > ../initramfs-Advanced.cpio.gz
cd ../
cd ramdisk_stable
find . | cpio -o -H newc | gzip > ../initramfs-Stable.cpio.gz
cd ../
echo "Pack Sense boot.img"
./mkbootimg --kernel zImage --ramdisk initramfs-Advanced.cpio.gz --base 0x13f00000 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=primou' --pagesize 4096 -o Charm-Kiss-date-Advanced-OC-3.0.100.img
sleep 5
./mkbootimg --kernel zImage --ramdisk initramfs-Advanced.cpio.gz --base 0x13f00000 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=primou' --pagesize 4096 -o Charm-Kiss-date-Advanced-OC-3.0.100.img
#############################################################################################################################

echo "Done"
read ANS