#!/usr/bin/env bash
# Скачивает шрифты Google Fonts к себе, чтобы страницы не ходили на чужой домен.
# Нужен установленный npx (идёт с Node.js). Запускать из корня сайта.
set -euo pipefail
mkdir -p fonts
npx --yes google-font-installer download "Literata" -d fonts -w 400,600,700 || true
npx --yes google-font-installer download "Onest" -d fonts -w 300,400,500,600,700 || true
npx --yes google-font-installer download "JetBrains Mono" -d fonts -w 400,500,700 || true
echo
echo "Готово. Дальше:"
echo "  1) убедиться, что в fonts/ лежат .woff2"
echo "  2) в каждой странице заменить <link ... fonts.googleapis.com ...> на"
echo "     <link rel=\"stylesheet\" href=\"/fonts/fonts.css\">"
echo "  3) проверить, что шрифты грузятся с вашего домена (вкладка Network)"
