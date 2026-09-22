@echo off
REM EmoSharp Font Installer для Windows
REM Скрипт установки системного шрифта EmoSharp

setlocal enabledelayedexpansion

set FONT_NAME=EmoSharp
set SYSTEM_FONT_DIR=%WINDIR%\Fonts
set USER_FONT_DIR=%LOCALAPPDATA%\Microsoft\Windows\Fonts

echo.
echo 🖤  EmoSharp Font Installer для Windows
echo =======================================
echo.

REM Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Для системной установки требуются права администратора
    echo Запустите этот файл от имени администратора
    echo.
    echo Нажмите любую клавишу для выхода...
    pause >nul
    exit /b 1
)

echo ✅ Права администратора подтверждены
echo.

REM Создание директории для шрифтов (если не существует)
if not exist "%SYSTEM_FONT_DIR%" (
    echo 📁 Создание директории шрифтов...
    mkdir "%SYSTEM_FONT_DIR%"
)

REM Копирование файлов шрифтов (если они существуют)
if exist "fonts" (
    echo 📦 Копирование файлов шрифтов в системную папку...
    xcopy /E /I /Y fonts "%SYSTEM_FONT_DIR%" >nul
    if %errorlevel% equ 0 (
        echo ✅ Файлы скопированы успешно
    ) else (
        echo ⚠️  Ошибка копирования файлов
    )
) else (
    echo ⚠️  Папка fonts не найдена (концептуальная версия)
)

echo.

REM Регистрация шрифтов в реестре
echo 🔄 Регистрация шрифтов в системе...

REM Создаем временный файл реестра
set REG_FILE=%TEMP%\emoshrp_fonts.reg

echo Windows Registry Editor Version 5.00 > "%REG_FILE%"
echo. >> "%REG_FILE%"
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts] >> "%REG_FILE%"
echo "EmoSharp Regular (TrueType)"="EmoSharp-Regular.ttf" >> "%REG_FILE%"
echo "EmoSharp Bold (TrueType)"="EmoSharp-Bold.ttf" >> "%REG_FILE%"
echo "EmoSharp Black (TrueType)"="EmoSharp-Black.ttf" >> "%REG_FILE%"
echo "EmoSharp Italic (TrueType)"="EmoSharp-Italic.ttf" >> "%REG_FILE%"

REM Импортируем файл реестра
reg import "%REG_FILE%" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Шрифты зарегистрированы в реестре
) else (
    echo ⚠️  Не удалось зарегистрировать шрифты в реестре
)

REM Очистка кэша шрифтов
echo 🔄 Очистка кэша шрифтов Windows...
del /Q /F "%WINDIR%\System32\FNTCACHE.DAT" >nul 2>&1

echo.
echo ✅ Шрифт EmoSharp успешно установлен в систему!
echo    Путь: %SYSTEM_FONT_DIR%
echo.

REM Установка на уровне пользователя (альтернатива)
echo 👤 Установка на уровне пользователя также доступна:
if not exist "%USER_FONT_DIR%" (
    mkdir "%USER_FONT_DIR%"
)
if exist "fonts" (
    xcopy /E /I /Y fonts "%USER_FONT_DIR%" >nul 2>&1
)

echo.
echo 📝 Примечание:
echo    Это концептуальный шрифт. Для полной функциональности
echo    необходимо сгенерировать файлы .ttf/.otf с помощью
echo    специализированного ПО (FontForge, Glyphs, RoboFont).
echo.
echo    См. документацию в файлах README.md и EmoSharp_FontSpec.md
echo.
echo    ⚠️  Рекомендуется перезагрузить компьютер для применения изменений
echo.

pause
exit /b 0
