#!/bin/bash

echo "🔍 Telefon Sistemi Test Kontrolü"
echo "================================"

# Manifest kontrolü
if [ -f "resources/[phone]/phone/manifest.lua" ]; then
    echo "✅ manifest.lua - MEVCUT"
else
    echo "❌ manifest.lua - EXİK"
fi

# Config kontrolü
if [ -f "resources/[phone]/phone/shared/config.lua" ]; then
    echo "✅ shared/config.lua - MEVCUT"
else
    echo "❌ shared/config.lua - EXİK"
fi

# Server main kontrolü
if [ -f "resources/[phone]/phone/server/main.lua" ]; then
    echo "✅ server/main.lua - MEVCUT"
else
    echo "❌ server/main.lua - EXİK"
fi

# Client main kontrolü
if [ -f "resources/[phone]/phone/client/main.lua" ]; then
    echo "✅ client/main.lua - MEVCUT"
else
    echo "❌ client/main.lua - EXİK"
fi

# HTML kontrolü
if [ -f "resources/[phone]/phone/html/index.html" ]; then
    echo "✅ html/index.html - MEVCUT"
else
    echo "❌ html/index.html - EXİK"
fi

# CSS kontrolü
if [ -f "resources/[phone]/phone/html/style.css" ]; then
    echo "✅ html/style.css - MEVCUT"
else
    echo "❌ html/style.css - EXİK"
fi

# JS kontrolü
if [ -f "resources/[phone]/phone/html/script.js" ]; then
    echo "✅ html/script.js - MEVCUT"
else
    echo "❌ html/script.js - EXİK"
fi

# Server.cfg kontrolü
if grep -q "ensure \[phone\]:phone" server.cfg; then
    echo "✅ server.cfg - Telefon kaynağı EKLENDI"
else
    echo "❌ server.cfg - Telefon kaynağı EXİK"
fi

# Para sistemi güncelleme kontrolü
if grep -q "money:removeBank" resources/[core]/money/server/main.lua; then
    echo "✅ Para Sistemi - removeBank Fonksiyonu MEVCUT"
else
    echo "❌ Para Sistemi - removeBank Fonksiyonu EXİK"
fi

echo ""
echo "📊 Telefon Sistemi Bileşenleri:"
find resources/[phone]/phone -type f | wc -l
echo "dosya bulundu"

echo ""
echo "✨ Telefon Sistemi Komutları:"
echo "  /phone                 - Telefon aç/kapat"
echo "  /balance               - Bakiye kontrol"
echo "  /addbalance [tutar]    - Bakiye yükle"
echo "  /sms [numara] [mesaj]  - SMS gönder"

