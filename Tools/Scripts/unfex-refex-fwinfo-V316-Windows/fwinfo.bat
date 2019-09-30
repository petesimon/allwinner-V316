::FWINFO.BAT script for gathering Allwinner V316 (not V3) firmware details by nutsey for GoPrawn.com
::modified by petesimon of Goprawn forums to work with V316 firmware
::FULL_IMG.FEX size is 16777216 bytes, and 2-system.img is 11010048 bytes
::info is stored in LUA scripts in the [squashfs]\usr\share\app\sdv directory, extracted from 2-system.img
cls
@echo off
setlocal
set SFK=%~dp0sfk.exe
set SOURCEDIR=%~dp0squashfs-root\usr\share\app\sdv
set IMAGESDIR=%~dp0squashfs-root\usr\share\minigui\res\images
echo.

echo Allwinner V3 firmware information script by nutsey v0.2.
echo modified by petesimon of Goprawn forums to work with Allwinner V316 firmware
echo.

if not exist %IMAGESDIR% (GOTO LOGONOTFOUND)
if not exist UNFEX\5-slogo.img (GOTO LOGONOTFOUND)
if not exist %SOURCEDIR% (GOTO SOURCEDIRNOTFOUND)

if not exist \FWINFO (md FWINFO >nul 2>&1)
if exist fwinfo.tmp (del fwinfo.tmp >nul 2>&1)
echo FWINFO > fwinfo.tmp

echo Now running Swiss File Knife, sfk.exe ...
echo please wait ...
echo.
echo Manufacturer: >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\net_config.lua -firsthit -text "/manufacturer=\q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo Build by: >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\build_info.lua -firsthit -text "/build_by_who = \q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo Product type: >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\net_config.lua -firsthit -text "/producttype=\q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo Firmware time: >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\build_info.lua -firsthit -text "/build_time = \q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo Updated date: >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\net_config.lua -firsthit -text "/updated=\q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo Linux kernel version: >> fwinfo.tmp
dir /b %~dp0squashfs-root\lib\modules >> fwinfo.tmp

echo Software version: >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\net_config.lua -firsthit -text "/softwareversion=\q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo LCD resolution: >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\device_info.lua -firsthit -text "/width = [digits]/[part2]/" -astext -quiet -yes >> fwinfo.tmp
echo     x >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\device_info.lua -firsthit -text "/height = [digits]/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo LCD model:  >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\net_config.lua -firsthit -text "/lcd=\q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

echo Sensor model:  >> fwinfo.tmp
%SFK% extract %SOURCEDIR%\net_config.lua -firsthit -text "/sensor=\q*\q/[part2]/" -astext -quiet -yes >> fwinfo.tmp

:: -- next command is a work in progress --
::echo Sensor modules (drivers): >> fwinfo.tmp
::%SFK% extract squashfs-root\build.prop -text "/ro.build.version.incremental=*.*.*.*/[part6]/" -astext >> fwinfo.tmp

::remove double-quotes fwinfo.tmp file
::%SFK% replace fwinfo.tmp *\"** -yes -quiet

::process fwinfo.tmp and save it as fwinfo.txt
%SFK% partcopy fwinfo.tmp -fromto 0 -2 FWINFO\fwinfo.txt -yes -quiet

del fwinfo.tmp >nul 2>&1
echo.
more FWINFO\fwinfo.txt
copy /B %IMAGESDIR%\shutdown.bmp FWINFO\off-logo.bmp >nul 2>&1
::5-slogo was shutdown logo in V3(s), but in V316, this 5-slogo file is the boot logo
copy /B UNFEX\5-slogo.img FWINFO\on-logo.bmp >nul 2>&1
echo.

echo Done. Check FWINFO folder for ON-LOGO.BMP, OFF-LOGO.BMP and FWINFO.TXT files.
echo Press any key to exit...
pause>nul
exit /b

:LOGONOTFOUND
echo 5-slogo.img (power ON logo) or shutdown.bmp (power OFF logo) not found in source folders!
echo Run 'unfex.bat' and then run 'squashfs_unmake.bat' scripts first.
echo Press any key to exit...
pause>nul
exit /b

:SOURCEDIRNOTFOUND
echo "Can't get any information ..."
echo "Source folders not found. Run 'unfex.bat and then run 'squashfs_unmake.bat' scripts first."
echo "Press any key to exit..."
pause>nul
exit /b