@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion
title YT-to-VLC v1.0
set "version=v1.0"

:check-internet
cls
echo Verificando a conexão com a internet...
ping -n 1 youtube.com > NUL
if not "%errorlevel%"=="1" (
	goto check-sw-updates
)

:check-internet-failed
cls
echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.0 ::..
echo.
echo CONEXÃO COM A INTERNET INDISPONÍVEL
echo.
echo O YT-to-VLC precisa estar conectado a internet para procurar
echo por atualizações e funcionar de maneira geral. No entanto,
echo parece que sua internet não está funcionando. Por favor,
echo verifique e tente novamente.
echo.
echo Se você tem certeza que sua conexão com a internet está OK,
echo por favor reporte o problema pela seção Issues do
echo repositório.
echo.
echo O que você deseja fazer?
echo.
echo [1] Verificar a conexão com a internet novamente
echo [0] Sair
echo.
echo ============================================================
echo.

set /p choice=Escolha uma opção: 

if "%choice%"=="1" (
	goto check-internet
)
if "%choice%"=="0" (
	exit
)

echo.
echo Opção inválida. Digite a tecla desejada e pressione Enter.
pause > NUL
goto check-internet-failed

:check-sw-updates
echo Checando por atualizações do script...
for /f "delims=" %%a in ('powershell -command "Invoke-RestMethod -Uri 'https://api.github.com/repos/riomccloud/yt-to-vlc/releases/latest' | Select-Object -ExpandProperty tag_name"') do (
    set "latest-version=%%a"
)
if "%latest-version%"=="%version%" (
	goto check-yt-dlp-updates
) else (
	goto update-warning
)

:update-warning
cls
echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.0 ::..
echo.
echo NOVA VERSÃO ENCONTRADA
echo.
echo Há uma nova versão do YT-to-VLC disponível. Novas versões
echo costumam trazer melhorias e correções de bugs.
echo.
echo O que você deseja fazer?
echo.
echo [1] Baixar a versão mais recente
echo [2] Continuar sem atualizar
echo.
echo [0] Sair
echo.
echo ============================================================
echo.

set /p choice=Escolha uma opção: 

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
echo Opção inválida. Digite a tecla desejada e pressione Enter.
pause
goto update-warning

:check-yt-dlp-updates
cls
echo Checando por atualizações do yt-dlp...
if not exist "yt-dlp.exe" (
	powershell -command "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile 'yt-dlp.exe'" > NUL
)
yt-dlp.exe -U > NUL

if not exist "settings.txt" (
	echo res=1080> "settings.txt"
)

:check-vlc
if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    set "vlc=C:\Program Files\VideoLAN\VLC\vlc.exe"
	goto home
) else (
    if exist "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" (
        set "vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
		goto home
    ) else (
		if exist "vlc-path.txt" (
			for /f %%c in (vlc-path.txt) do set "vlc=%%c"
			goto home
		) else (
			goto vlc-not-found
		)
    )
)

:vlc-not-found
cls

echo ============================================================
echo.
echo ..:: YT-to-VLC v1.0 ::..
echo.
echo VLC NÃO ENCONTRADO
echo.
echo Não foi possível localizar o reprodutor de mídias VLC nos
echo caminhos padrões de instalação. Se você não possui o VLC
echo instalado, por favor baixe-o através do site videolan.org.
echo.
echo Se você instalou o reprodutor de mídias VLC em um diretório
echo diferente, digite o caminho completo para a pasta que contém
echo o executável do programa, seguindo o exemplo abaixo:
echo.
echo D:\pasta-do-vlc
echo.
echo * não use aspas *
echo.
echo [1] Verificar novamente
echo [0] Sair
echo.
echo ============================================================
echo.

set /p choice=Escolha uma opção: 

if "%choice%"=="1" (
    goto check-vlc
) else if "%choice%"=="0" (
    exit
) else (
	if exist "%choice%\vlc.exe" (
		set "vlc=%choice%\vlc.exe"
		echo %choice%\vlc.exe> vlc-path.txt
		goto home
	) else (
		echo.
		echo Caminho inválido^^! Verifique o diretório e tente novamente.
		pause > NUL
		goto vlc-not-found
	)
)

:home
cls

echo ============================================================
echo.
echo ..:: YT-to-VLC v1.0 ::..
echo.
echo Para reproduzir um vídeo, cole sua URL do YouTube abaixo.
echo.
echo [1] Configurações
echo [2] Sobre
echo [0] Sair
echo.
echo ============================================================
echo.

set /p choice=Escolha uma opção: 

if "%choice%"=="1" (
    goto settings
) else if "%choice%"=="2" (
	goto about
) else if "%choice%"=="0" (
    exit
) else (
	for /f %%a in ('yt-dlp.exe --get-url -f b --format-sort "res:!res!" "%choice%"') do (
		start "" "%vlc%" %%a
	)
	goto home
)

:settings
cls

echo ============================================================
echo.
echo ..:: YT-to-VLC v1.0 ::..
echo.
echo CONFIGURAÇÔES
echo.
echo Selecione a qualidade de vídeo desejada:
echo.
echo [1] 4320p (8k)
echo [2] 2160p (4k)
echo [3] 1440p (2k)
echo [4] 1080p (Full HD, padrão)
echo [5] 720p (HD)
echo [6] 480p (SD)
echo [7] 360p (SD)
echo.
echo [9] Voltar para o menu anterior
echo [0] Sair
echo.
echo ============================================================
echo.

set /p choice=Escolha uma opção: 

if "%choice%"=="1" (
	echo res=4320> "settings.txt"
)
if "%choice%"=="2" (
	echo res=2160> "settings.txt"
)
if "%choice%"=="3" (
	echo res=1440> "settings.txt"
)
if "%choice%"=="4" (
	echo res=1080> "settings.txt"
)
if "%choice%"=="5" (
	echo res=720> "settings.txt"
)
if "%choice%"=="6" (
	echo res=480> "settings.txt"
)
if "%choice%"=="7" (
	echo res=360> "settings.txt"
)
if "%choice%"=="9" (
	goto home
)
if "%choice%"=="0" (
	exit
)

echo.
echo Novo padrão de qualidade de vídeo definido^^! Voltando para o menu anterior...
timeout 3 > NUL
goto home

:about
cls

echo ============================================================
echo.
echo ..:: YT-TO-VLC v1.0 ::..
echo.
echo SOBRE
echo.
echo O YT-to-VLC é uma pequena ferramenta bash/batch que
echo automatiza o processo de reprodução de vídeos do YouTube e
echo outros sites no reprodutor de mídias VLC através do yt-dlp.
echo.
echo O YT-to-VLC é distribuído sobre a licença AGPL-3.0.
echo.
echo Feito por Rio McCloud, desde 2023.
echo Confira mais em https://github.com/riomccloud/yt-to-vlc
echo.
echo ============================================================
echo.
echo Pressione qualquer botão para voltar...
pause > NUL
goto home