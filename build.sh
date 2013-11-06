echo "Start Compiling"
############################################################################################################################
echo "COMPILE KERNEL FOR SENSE" 
make clean mrproper
make charm-kiss_defconfig 
make -j84
echo "Copy Modules to Sense Ramdisk"
find -name '*.ko' -exec cp -av {} ../bootimg_tools_Charm/ramdisk_advanced/lib/modules \;
mv arch/arm/boot/zImage ../bootimg_tools_Charm/
cd ../bootimg_tools_Charm/ramdisk_advanced
rm -f ../*.cpio.gz
echo "Strip Modules"
arm-eabi-strip -S lib/modules/*.ko
echo "Packing Ramdisk Of OC Version"
find . | cpio -o -H newc | gzip > ../initramfs-Advanced-OC.cpio.gz
echo "Packing Ramdisk Of Standard Version"
mv init.scripts.sh ../
find . | cpio -o -H newc | gzip > ../initramfs-Advanced.cpio.gz
cd ../
mv init.scripts.sh ramdisk_advanced
echo "Pack Sense Boot Image"
./mkbootimg --kernel zImage --ramdisk initramfs-Advanced-OC.cpio.gz --base 0x13f00000 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=primou' --pagesize 4096 -o Charm-Kiss-date-Advanced-OC-3.0.101.img
sleep 5
./mkbootimg --kernel zImage --ramdisk initramfs-Advanced.cpio.gz --base 0x13f00000 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=primou' --pagesize 4096 -o Charm-Kiss-date-Advanced-3.0.101.img
#############################################################################################################################

echo "Done"
exit