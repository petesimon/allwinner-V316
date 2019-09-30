::UNFEX.BAT full_img.fex unpacking script by nutsey. Based on pack/unpack script by losber.
::Works with SFK tool https://sourceforge.net/projects/swissfileknife/ .
::Put full_img.fex file into folder containing this script if you want to extract files.
::Separate partition files will be extracted into UNFEX folder.
::modified by petesimon of Goprawn forums to work with Allwinner V316 firmware
::FULL_IMG.FEX size is 16777216 bytes, and 2-system.img is 11010048 bytes
::Check GoPrawn.com forums online for more details.

@echo off
cls
echo UNFEX.BAT full_img.fex unpacking script by nutsey for GoPrawn.com
echo modified by petesimon of Goprawn forums to work with Allwinner V316 firmware
echo.

IF NOT EXIST "%~dp0sfk.exe" (goto SFKNOTFOUND)

IF NOT EXIST "%~dp0full_img.fex" (
	echo File FULL_IMG.FEX not found.
	echo Press any key to exit...
	pause>nul
	exit /b
)

::set FILENAME=%~dp0full_img.fex
::set CORRECTSIZE=11010048

echo Now running Swiss File Knife, sfk.exe
echo.

IF NOT EXIST "%~dp0UNFEX" md "%~dp0UNFEX" >nul 2>&1
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0"        "1048576" "%~dp0UNFEX\0-uboot.img" "-yes"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x100000" "3145728" "%~dp0UNFEX\1-boot.img" "-yes"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x400000" "11010048" "%~dp0UNFEX\2-system.img" "-yes"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0xE80000" "524288" "%~dp0UNFEX\3-config.img" "-yes"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0xF00000" "131072" 	"%~dp0UNFEX\4-blogo.img" "-yes"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0xF20000" "393216" "%~dp0UNFEX\5-slogo.img" "-yes"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0xF80000" "524288" "%~dp0UNFEX\6-env.img" "-yes"
echo.
echo Done. Check UNFEX folder for extracted files.
echo Press any key to exit...
pause>nul
exit /b

:SFKNOTFOUND
echo SFK.EXE not found. Please download it from: https://sourceforge.net/projects/swissfileknife/
echo Press any key to exit...
pause>nul
exit /b