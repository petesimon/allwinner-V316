#!/bin/bash
#24 September 2019
#backup.sh shell script for Linux to backup Allwinner V316 firmware
#RAR 5 compression http://rarlab.com and UNIX rwx permissions are saved
#this script may also work for other Allwinner chipsets
#this script assumes that the 'dd' command is available inside the camera
#see www.Goprawn.com forums and www.fb.com/groups/allwinner4kcamerasusergroup onlilne
#contact me directly at petesimon (@) yahoo.com

do_rar () {
	[ -f backup.rar ] && mv --backup=numbered -T backup.rar backup.rar.old && echo "old backup.rar found and renamed it to backup.old"
	echo ""
    rar a -logAFU -isnd -s -ma5 -m5 -idc -md128m backup.rar backup/0-uboot.img backup/1-boot.img backup/2-system.img backup/3-config.img backup/4-blogo.img backup/5-slogo.img backup/6-env.img backup/full_img.fex backup/mtdblock3-data backup/hwinfo.txt;
    rar c -idq -scA -zgoprawncomment.txt backup.rar
}

pause () {
	echo
	read -n1 -t 20 -p "press the Enter key to continue"
	echo
}

clear
echo "Allwinner V3(s) action cam firmware backup script by hphde adopted"
echo "from nutsey for www.GoPrawn.com forums"
echo "modified by petesimon of www.Goprawn.com forums to work with V316 firmware"
echo ""
[ -z "$(which adb)" ] && echo "No 'adb' found. You need to install that first" && pause && exit 1
[ -z "$(which rar)" ] && echo "No 'rar' found. You need to install that first" && pause && exit 1
[ -z "$(which iconv)" ] && echo "No 'iconv' found. You need to install that first" && pause && exit 1

echo "Enter password for using 'sudo' when needed ..."
echo ""
# add new udev rule files for android adb devices
# ATTR{idVendor}=="1f3a", ATTR{idProduct}=="1002"
# and
# ATTR{idVendor}=="18d1", ATTR{idProduct}="0002"
echo "Adding a udev rule file to your Linux system ..."
echo "Executing command 'sudo udevadm control -R'"
echo ""
if [ -f "/etc/udev/rules.d/51-android.rules" ]; then
    sudo cp 51-android.rules /etc/udev/rules.d/52-android.rules
    sudo udevadm control -R
 else
    sudo cp 51-android.rules /etc/udev/rules.d/
    sudo udevadm control -R
fi

if [ -f "/etc/udev/rules.d/53-android.rules" ]; then
    sudo cp 53-android.rules /etc/udev/rules.d/54-android.rules
    sudo udevadm control -R
 else
    sudo cp 53-android.rules /etc/udev/rules.d/
    sudo udevadm control -R
fi

echo "Please wait ..."
adb kill-server 2>&1>/dev/null
sleep 3
adb kill-server 2>&1>/dev/null
sleep 3
adb get-state 2>&1>/dev/null
[ $? -gt 0 ] && echo "Device not found. Check camera and USB connection and try again" && pause && exit 1

echo ""
echo "Be sure that a SD card is in the camera..."
pause
adb root 2>&1>/dev/null
adb remount 2>&1>/dev/null
adb shell cd / 2>&1>/dev/null
adb shell rm -rf /mnt/extsd/backup 2>&1>/dev/null
adb shell mkdir /mnt/extsd/backup 2>&1>/dev/null

echo ""
echo "Generating blocks of data from the camera onto the SD card..."
FILES="0-uboot.img 1-boot.img 2-system.img 3-config.img 4-blogo.img 5-slogo.img 6-env.img"
for F in $FILES; do
  echo "Copying $F"
  adb shell dd if=/dev/mtdblock${F:0:1} of=/mnt/extsd/backup/$F
  echo ""
done

[ -d backup ] && mv -T --backup=numbered backup backup-old && echo "Old backup directory found and renamed to backup-old"
adb pull /mnt/extsd/backup 2>&1>/dev/null
adb pull /overlay ./backup/mtdblock3-data 2>&1>/dev/null

echo "All mtd blocks downloaded"
echo ""

# try to get build, and netconfig and hardware information from device
rm -f hwinfo.txt hwinfo.temp 2>&1>/dev/null
adb pull /usr/share/app/sdv/build_info.lua 2>&1>/dev/null
adb pull /usr/share/app/sdv/device_info.lua 2>&1>/dev/null
adb pull /usr/share/app/sdv/net_config.lua 2>&1>/dev/null
echo "Build and hardware information" | iconv -t UTF-8 > hwinfo.temp
echo -e "\n" | iconv -t UTF-8 >> hwinfo.temp
iconv -t UTF-8 < device_info.lua >> hwinfo.temp
echo -e "\n" | iconv -t UTF-8 >> hwinfo.temp
iconv -t UTF-8 < build_info.lua >> hwinfo.temp
echo -e "\n" | iconv -t UTF-8 >> hwinfo.temp
iconv -f ISO-8859-1 -t UTF-8 < net_config.lua >> hwinfo.temp
# convert UNIX text to DOS/Windows text for better viewing in DOS/Win.
# if awk/gawk doesn't work, then use sed
awk 'sub("$", "\r")' hwinfo.temp > backup/hwinfo.txt
##sed 's/$'"/`echo \\\r`/" inputfile > outputfile
# remove temp files
rm -f build_info.lua device_info.lua net_config.lua hwinfo.temp 2>&1>/dev/null
echo "build and hardware information was pulled, and saved as 'hwinfo.txt'"
echo ""

cd backup
echo "Now creating full_img.fex ..."
cat 0-uboot.img 1-boot.img 2-system.img 3-config.img 4-blogo.img 5-slogo.img 6-env.img >full_img.fex
echo "Done creating full_img.fex file ..."
cd ..
# let the user choose to create/not create a compressed archive file
while true; do
    echo ""
    read -n1 -t 20 -p "Do you wish to create a 'backup.rar' file? Answer Y for yes or N for no." CHOICE
    case $CHOICE in
        [Yy] ) do_rar ; xdg-open backup.rar ; break;;
        [Nn] ) break;;
    esac
done
echo ""
echo "Firmware backup done. See new files in 'backup' folder, and 'backup.rar' file if any"
pause
exit 0
