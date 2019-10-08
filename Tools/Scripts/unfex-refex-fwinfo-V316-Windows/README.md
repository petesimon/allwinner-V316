# UNFEX, REFEX, FWINFO for Allwinner V316

README for for UNFEX REFEX FWINFO scripts to use in Windows.
Scripts were modified to work with Allwinner V316 firmware.
FULL_IMG.FEX size is 16777216 bytes, and 2-system.img is 11010048 bytes.

Instructions:

Put FULL_IMG.FEX from your firmware backup into the main script folder.
Run UNFEX.BAT to separate FULL_IMG.FEX into partitions.
Run SQUASHFS_UNMAKE.BAT to unpack UNFEX\2-system.img file.
Run FWINFO.BAT to get details about your Allwinner V316 firmware. 

FWINFO.TXT file, boot and shutdown logo files will be copied to FWINFO folder.

Look in the FWINFO folder for new files. Open 'fwinfo.txt' file.

Check https://www.GoPrawn.com action cam discussion forum 
and the Facebook users groups http://fb.com/groups/allwinner4kcamerasusergroup
for more details.
