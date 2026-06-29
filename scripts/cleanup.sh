#!/bin/bash

set -e

# Рантайм-директории Neovim (плагины, состояние, кэш). Сам конфиг
# (~/.config/nvim) не трогаем — за него отвечает deploy.sh.
DIRS=(
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
)

show_help() {
    echo "Очистка рантайм-данных Neovim (плагины, состояние, кэш)"
    echo "Использование: $0 [опции]"
    echo "  -y, --yes     Не спрашивать подтверждение"
    echo "  -h, --help    Показать это сообщение"
}

YES=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes) YES=true; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Неизвестный параметр: $1"; show_help; exit 1 ;;
    esac
done

echo "Будут удалены:"
for d in "${DIRS[@]}"; do
    [ -d "$d" ] && echo "  $d"
done

if [ "$YES" != true ]; then
    read -r -p "Продолжить? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || { echo "Отменено"; exit 0; }
fi

for d in "${DIRS[@]}"; do
    if [ -d "$d" ]; then
        rm -rf "$d"
        echo "Удалено: $d"
    fi
done
echo "Готово. При следующем запуске Neovim переустановит плагины."
