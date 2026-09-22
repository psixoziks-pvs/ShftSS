#!/bin/bash

# EmoSharp Font Installer для Linux/macOS
# Скрипт установки системного шрифта EmoSharp

set -e

FONT_NAME="EmoSharp"
FONT_DIR="/usr/share/fonts/truetype/emoshrp"
MAC_FONT_DIR="/Library/Fonts"
USER_FONT_DIR="$HOME/.local/share/fonts"

echo "🖤  EmoSharp Font Installer"
echo "=========================="
echo ""

# Определение операционной системы
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    echo "❌ Неподдерживаемая операционная система: $OSTYPE"
    exit 1
fi

echo "Обнаружена ОС: $OS"
echo ""

# Проверка прав администратора
if [[ "$EUID" -ne 0 ]] && [[ "$OS" == "Linux" ]]; then
    echo "⚠️  Для системной установки требуются права root"
    echo "Запустите скрипт с sudo: sudo ./install.sh"
    exit 1
fi

# Создание директории для шрифтов
if [[ "$OS" == "Linux" ]]; then
    echo "📁 Создание директории: $FONT_DIR"
    mkdir -p "$FONT_DIR"
    
    # Копирование файлов шрифтов (если они существуют)
    if [ -d "fonts" ]; then
        echo "📦 Копирование файлов шрифтов..."
        cp -r fonts/* "$FONT_DIR/" 2>/dev/null || echo "⚠️  Файлы шрифтов не найдены (концептуальная версия)"
    fi
    
    # Обновление кэша шрифтов
    echo "🔄 Обновление кэша шрифтов..."
    fc-cache -fv
    
    echo ""
    echo "✅ Шрифт EmoSharp успешно установлен в систему!"
    echo "   Путь: $FONT_DIR"
    
elif [[ "$OS" == "macOS" ]]; then
    echo "📁 Создание директории: $MAC_FONT_DIR"
    mkdir -p "$MAC_FONT_DIR"
    
    # Копирование файлов шрифтов (если они существуют)
    if [ -d "fonts" ]; then
        echo "📦 Копирование файлов шрифтов..."
        cp -r fonts/* "$MAC_FONT_DIR/" 2>/dev/null || echo "⚠️  Файлы шрифтов не найдены (концептуальная версия)"
    fi
    
    # Обновление кэша шрифтов
    echo "🔄 Обновление кэша шрифтов..."
    atsutil databases -remove
    
    echo ""
    echo "✅ Шрифт EmoSharp успешно установлен в систему!"
    echo "   Путь: $MAC_FONT_DIR"
fi

# Установка на уровне пользователя (альтернатива)
echo ""
echo "👤 Также доступна установка на уровне пользователя:"
mkdir -p "$USER_FONT_DIR"
if [ -d "fonts" ]; then
    cp -r fonts/* "$USER_FONT_DIR/" 2>/dev/null || true
fi
fc-cache -fv 2>/dev/null || true

echo ""
echo "📝 Примечание:"
echo "   Это концептуальный шрифт. Для полной функциональности"
echo "   необходимо сгенерировать файлы .ttf/.otf с помощью"
echo "   специализированного ПО (FontForge, Glyphs, RoboFont)."
echo ""
echo "   См. документацию в файлах README.md и EmoSharp_FontSpec.md"
echo ""

exit 0
