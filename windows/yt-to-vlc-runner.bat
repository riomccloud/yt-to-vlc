@echo off
chcp 65001>nul
setlocal enabledelayedexpansion
title YT-to-VLC Runner v1.1
set "version=v1.1"

if not exist "%userprofile%\yttovlc-scriptdir.txt" (
	cls
	echo ============================================================
	echo.
	echo ..:: YT-TO-VLC RUNNER v1.1 ::..
	echo.
	echo INSTALLATION DIRECTORY NOT FOUND
	echo.
	echo To be able to use YT-to-VLC runner, you need to run the main
	echo script at least one time to create its config files.
	echo.
	echo Do that and try again.
	echo.
	echo ============================================================
	echo.
	echo Press any key to exit...
	pause >nul
	exit
)
for /f "usebackq delims=" %%a in ("%userprofile%\yttovlc-scriptdir.txt") do set "scriptdir=%%a"

:check-sw-updates
echo Checking for script updates
for /f "delims=" %%a in ('powershell -command "Invoke-RestMethod -Uri 'https://api.github.com/repos/riomccloud/yt-to-vlc/releases/latest' | Select-Object -ExpandProperty tag_name"') do (
    set "latest-version=%%a"
)
if "%latest-version%"=="%version%" (
	goto check-yt-dlp-updates
)

:update-warning
cls
echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.1 ::..
echo.
echo NEW VERSION FOUND
echo.
echo There's a new YT-to-VLC version available. New versions
echo usually bring improvements and bug fixes.
echo.
echo What do you want to do?
echo.
echo [1] Download latest release
echo [2] Continue without updating it
echo.
echo [0] Exit
echo.
echo ============================================================
echo.

set /p choice=Choose an option: 

if "%choice%"=="1" (
	start https://github.com/riomccloud/yt-to-vlc/releases/latest
)
if "%choice%"=="2" (
	goto check-yt-dlp-updates
)
if "%choice%"=="0" (
	exit
)

echo.
echo Invalid option. Type the desired key and press Enter.
pause
goto update-warning

:check-yt-dlp-updates
cls
echo Checking for yt-dlp updates...
if not exist "yt-dlp.exe" (
	powershell -command "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile 'yt-dlp.exe'" > NUL
)
yt-dlp.exe -U > NUL

:check-vlc
if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    set "vlc=C:\Program Files\VideoLAN\VLC\vlc.exe"
	goto scriptfiles
) else (
    if exist "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" (
        set "vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
		goto scriptfiles
    ) else (
		if exist "vlc-path.txt" (
			for /f %%b in (vlc-path.txt) do set "vlc=%%b"
			goto scriptfiles
		) else (
			goto vlc-not-found
		)
    )
)

:vlc-not-found
cls

echo ============================================================
echo.
echo ..:: YT-TO-VLC RUNNER v1.1 ::..
echo.
echo VLC NOT FOUND
echo.
echo Unable to locate VLC media player in the default
echo installation paths. If you don't have VLC installed, please
echo download it at videolan.org.
echo.
echo If you installed VLC media player in a different path, type
echo the full path to the folder that contains the program's
echo executable, following the example below:
echo.
echo D:\vlc-folder
echo.
echo * do not use quotes *
echo.
echo [1] Verify again
echo [0] Exit
echo.
echo ============================================================
echo.

set /p choice=Choose an option: 

if "%choice%"=="1" (
    goto check-vlc
) else if "%choice%"=="0" (
    exit
) else (
	if exist "%choice%\vlc.exe" (
		set "vlc=%choice%\vlc.exe"
		echo %choice%\vlc.exe> vlc-path.txt
		goto scriptfiles
	) else (
		echo.
		echo Invalid path^^! Check the directory and try again.
		pause > NUL
		goto vlc-not-found
	)
)

:scriptfiles
cd /d "%scriptdir%"
if not exist "settings.txt" (
	echo res=1080> "settings.txt"
)
for /f "tokens=2 delims==" %%d in (settings.txt) do (
    set "res=%%d"
)

cls
echo ============================================================
echo.
echo ..:: YT-TO-VLC RUNNER v1.1 ::..
echo.
echo The video will play in a few seconds.
echo Please wait.
echo.
echo ============================================================

set "url=%1"
set "finalurl=!url:yttovlc://=!"

for /f %%e in ('yt-dlp.exe --print url -f "(bv[height<=%res%]+ba/b)b" "%finalurl%"') do (
	start "" "%vlc%" %%e
)

