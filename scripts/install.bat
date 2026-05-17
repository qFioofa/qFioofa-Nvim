
@echo off
setlocal enabledelayedexpansion

set REPO_URL=https://github.com/qFioofa/qFioofa-Nvim.git
set NVIM_CONFIG_DIR=%USERPROFILE%\AppData\Local\nvim
set BACKUP_DIR=%USERPROFILE%\AppData\Local\nvim.backup

set REMOVE=false
set BACKUP=false

:parse
if "%~1"=="" goto after_parse
if "%1"=="-r" set REMOVE=true& shift & goto parse
if "%1"=="--remove" set REMOVE=true& shift & goto parse
if "%1"=="-b" set BACKUP=true& shift & goto parse
if "%1"=="--backup" set BACKUP=true& shift & goto parse
if "%1"=="-h" goto show_help
if "%1"=="--help" goto show_help
echo Неизвестный параметр: %1
exit /b 1

:show_help
echo Установка конфигурации Neovim
echo Использование: %~nx0 [опции]
echo   -r, --remove    Удалить старый конфиг перед установкой
echo   -b, --backup    Создать бэкап старого конфига
echo   -h, --help      Показать это сообщение
exit /b 0

:after_parse

if exist "%NVIM_CONFIG_DIR%" (
    if "!REMOVE!"=="true" (
        rmdir /s /q "%NVIM_CONFIG_DIR%"
        echo Старый конфиг удален
    ) else if "!BACKUP!"=="true" (
        if exist "%BACKUP_DIR%" rmdir /s /q "%BACKUP_DIR%"
        move "%NVIM_CONFIG_DIR%" "%BACKUP_DIR%"
        echo Бэкап создан: %BACKUP_DIR%
    ) else (
        echo Обнаружена директория конфига. Используйте -r для удаления или -b для бэкапа.
        exit /b 1
    )
)

git clone %REPO_URL% "%NVIM_CONFIG_DIR%"
echo Установка завершена!
