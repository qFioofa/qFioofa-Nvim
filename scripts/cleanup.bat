@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Рантайм-данные Neovim (плагины, состояние, кэш). Сам конфиг
REM (%LOCALAPPDATA%\nvim) не трогаем — за него отвечает deploy.bat.
set DATA_DIR=%LOCALAPPDATA%\nvim-data
set CACHE_DIR=%TEMP%\nvim-data

set YES=false

:parse
if "%~1"=="" goto after_parse
if "%1"=="-y" set YES=true& shift & goto parse
if "%1"=="--yes" set YES=true& shift & goto parse
if "%1"=="-h" goto show_help
if "%1"=="--help" goto show_help
echo Неизвестный параметр: %1
exit /b 1

:show_help
echo Очистка рантайм-данных Neovim (плагины, состояние, кэш)
echo Использование: %~nx0 [опции]
echo   -y, --yes     Не спрашивать подтверждение
echo   -h, --help    Показать это сообщение
exit /b 0

:after_parse

echo Будут удалены:
if exist "%DATA_DIR%" echo   %DATA_DIR%
if exist "%CACHE_DIR%" echo   %CACHE_DIR%

if not "!YES!"=="true" (
    set /p ans=Продолжить? [y/N]
    if /i not "!ans!"=="y" (echo Отменено & exit /b 0)
)

if exist "%DATA_DIR%" (rmdir /s /q "%DATA_DIR%" & echo Удалено: %DATA_DIR%)
if exist "%CACHE_DIR%" (rmdir /s /q "%CACHE_DIR%" & echo Удалено: %CACHE_DIR%)
echo Готово. При следующем запуске Neovim переустановит плагины.
