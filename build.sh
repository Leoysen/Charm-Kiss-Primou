echo "Clear Up" 
echo "Start Compiling"
#############################################################################################################################
echo "Compile KERNEL for CM9/CM10"
make clean mrproper
make charm-kiss-cm10_defconfig
colormake -j5
echo "Copy Modules to CM10 Ramdisk"
find -name '*.ko' -exec cp -av {} ../bootimg_tools_Charm/ramdisk_cm10/lib/modules/ \;
mv arch/arm/boot/zImage ../bootimg_tools_Charm/
cd ../bootimg_tools_Charm
echo "Pack CM10 Ramdisk"
cd ramdisk_cm10
echo "Strip Modules"
arm-eabi-strip -S lib/modules/*.ko
rm -f ../*.cpio.gz
find . | cpio -o -H newc | gzip > ../initramfs-cm10.cpio.gz
cd ../
echo "Pack CM10 boot.img" 
./mkbootimg --kernel zImage --ramdisk initramfs-cm10.cpio.gz --base 0x13f00000 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=primou' --pagesize 4096 -o Charm-Kiss-CM10-date.img
######## CM10 DONE ####################
read ANS
