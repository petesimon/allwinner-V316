::SQUASHFS_UNMAKE.BAT script by BNDias.
::modified by petesimon of Goprawn forums to work with Allwinner V316 firmware.
::FULL_IMG.FEX size is 16777216 bytes, and 2-system.img is 11010048 bytes

cls
@echo off

:: Set source file (2-system.img, or rootfs.hex) and destination folder
set SOURCE=UNFEX\2-system.img
set DESTINATION=squashfs-root
echo SQUASHFS_UNMAKE.BAT script by BNDias for GoPrawn.com
echo modified by petesimon of Goprawn forums to work with Allwinner V316 firmware
echo.

if not exist "%~dp0squashfs_tools\unsquashfs.exe" goto UNSQUASHFSNOTFOUND
if not exist "%~dp0%SOURCE%" goto SOURCENOTFOUND

setlocal EnableDelayedExpansion
if exist "%~dp0%DESTINATION%" (
	if exist "%~dp0%DESTINATION%_bak"  rd /S /Q "%~dp0%DESTINATION%_bak"
    move "%~dp0%DESTINATION%" "%DESTINATION%_bak">nul
	echo Existing %DESTINATION% folder renamed to %DESTINATION%_bak
	echo.
)
endlocal

echo.
"%~dp0squashfs_tools/unsquashfs" -f -d "%~dp0%DESTINATION%" "%~dp0%SOURCE%"
echo.
echo.
echo.
echo Done. Check "%DESTINATION%" folder.
goto EXITBAT

:UNSQUASHFSNOTFOUND
echo.
echo SQUASHFS_TOOLS\UNSQUASHFS.EXE not found. Search Google/Yahoo and download 'unsquashfs.exe' for Windows.
if not exist "%~dp0squashfs_tools" mkdir "%~dp0squashfs_tools"
goto EXITBAT

:SOURCENOTFOUND
echo %SOURCE% file not found. Use 'unfex.bat' script first.
goto EXITBAT

:EXITBAT
echo.
echo Press any key to exit...
pause>nul
exit