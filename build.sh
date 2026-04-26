#!/bin/bash

# Скрипт для сборки приложения
APP_NAME="AltSwitcher"
BUILD_DIR="build"
APP_DIR="${BUILD_DIR}/${APP_NAME}.app"

echo "Очистка старой сборки..."
rm -rf "$BUILD_DIR"
mkdir -p "${APP_DIR}/Contents/MacOS"
mkdir -p "${APP_DIR}/Contents/Resources"

echo "Компиляция Swift кода..."
swiftc Sources/*.swift -o "${APP_DIR}/Contents/MacOS/${APP_NAME}" -framework AppKit -framework Carbon

if [ $? -ne 0 ]; then
    echo "Ошибка компиляции!"
    exit 1
fi

echo "Копирование Info.plist..."
cp Info.plist "${APP_DIR}/Contents/"

echo "Сборка успешна: ${APP_DIR}"
