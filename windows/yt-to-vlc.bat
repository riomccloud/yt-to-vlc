@echo off
setlocal enabledelayedexpansion
title YT-to-VLC v1.1
set "version=v1.1"

:check-internet
cls
echo Checking internet connection...
ping -n 1 youtube.com > NUL
if not "%errorlevel%"=="1" (
	goto check-sw-updates
)

:check-internet-failed
cls
echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.1 ::..
echo.
echo INTERNET CONNECTION UNAVAILABLE
echo.
echo YT-to-VLC needs an internet connection to check for updates
echo and work in general. However, it seems that your internet
echo isn't working. Please check it and try again.
echo.
echo If you are sure that your network is fine, please report the
echo problem through the Issues section of the repository.
echo.
echo What do you want to do?
echo.
echo [1] Check for internet connection again
echo [0] Exit
echo.
echo ============================================================
echo.

set /p choice=Choose an option: 

if "%choice%"=="1" (
	goto check-internet
)
if "%choice%"=="0" (
	exit
)

echo.
echo Invalid option. Type the desired key and press Enter.
pause > NUL
goto check-internet-failed

:check-sw-updates
echo Checking for script updates...
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
			for /f %%c in (vlc-path.txt) do set "vlc=%%c"
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
echo ..:: YT-TO-VLC v1.1 ::..
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
if not exist "settings.txt" (
	echo res=1080> "settings.txt"
)
for /f "tokens=2 delims==" %%b in (settings.txt) do (
    set "res=%%b"
)
set "scriptdir=%CD%"
echo %scriptdir% >"%userprofile%\yttovlc-scriptdir.txt"

:home
cls

echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.1 ::..
echo.
echo To play a video, paste its YouTube URL below.
echo.
echo [1] Settings
echo [2] About
echo [0] Exit
echo.
echo ============================================================
echo.

set /p choice=Choose an option: 

if "%choice%"=="1" (
    goto settings
) else if "%choice%"=="2" (
	goto about
) else if "%choice%"=="0" (
    exit
) else (
	for /f %%a in ('yt-dlp.exe --print url -f "(bv[height<=!res!]+ba/b)b" "%choice%"') do (
		start "" "%vlc%" %%a
	)
	pause
	goto home
)

:settings
cls

echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.1 ::..
echo.
echo SETTINGS
echo.
echo Select the desired video quality:
echo.
echo [1] 4320p (8k)
echo [2] 2160p (4k)
echo [3] 1440p (2k)
echo [4] 1080p (Full HD, default)
echo [5] 720p (HD)
echo [6] 480p (SD)
echo [7] 360p (SD)
echo.
echo [9] Return to the previous menu
echo [0] Exit
echo.
echo ============================================================
echo.

set /p choice=Choose an option: 

if "%choice%"=="1" (
	echo res=4320> "settings.txt"
	set "res=4320"
)
if "%choice%"=="2" (
	echo res=2160> "settings.txt"
	set "res=2160"
)
if "%choice%"=="3" (
	echo res=1440> "settings.txt"
	set "res=1440"
)
if "%choice%"=="4" (
	echo res=1080> "settings.txt"
	set "res=1080"
)
if "%choice%"=="5" (
	echo res=720> "settings.txt"
	set "res=720"
)
if "%choice%"=="6" (
	echo res=480> "settings.txt"
	set "res=480"
)
if "%choice%"=="7" (
	echo res=360> "settings.txt"
	set "res=360"
)
if "%choice%"=="9" (
	goto home
)
if "%choice%"=="0" (
	exit
)

echo.
echo New video quality set^^! Returning to the previous menu...
timeout 3 > NUL
goto home

:about
cls

echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.1 ::..
echo.
echo ABOUT
echo.
echo YT-to-VLC is a small bash/batch tool that automates the
echo process of playing videos from YouTube and other sites in
echo VLC media player through yt-dlp.
echo.
echo YT-to-VLC is licensed under AGPL-3.0 license.
echo.
echo Made by Rio McCloud, since 2023.
echo Check it out at https://github.com/riomccloud/yt-to-vlc
echo.
echo ============================================================
echo.
echo Press any key to go back...
pause > NUL
goto home
