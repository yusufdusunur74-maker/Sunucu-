#!/bin/bash

# FiveM Sunucu Başlatma Scripti (Linux/Mac)

echo ""
echo "╔═══════════════════════════════════════╗"
echo "║  FİVEM SUNUCU BAŞLATILIYOR...         ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# Sunucu yazılımının bulunup bulunmadığını kontrol et
if [ ! -f "txAdmin" ] && [ ! -f "FXServer" ]; then
    echo "❌ FiveM sunucu yazılımı bulunamadı!"
    echo ""
    echo "Lütfen şunları yapın:"
    echo "1. FiveM sunucu yazılımını indirin"
    echo "2. Bu klasöre çıkartın"
    echo "3. Tekrar /run.sh komutunu çalıştırın"
    echo ""
    exit 1
fi

echo "✓ Sistem bilgisi yükleniyor..."
echo "  - Port: 30120"
echo "  - Max Oyuncu: 32"
echo "  - Sunucu Adı: Turkiye Roleplay Sunucusu"
echo ""

echo "✓ Kaynaklar yükleniyor..."
echo "  - [core] resources"
echo "  - [jobs] resources"
echo "  - [bank] resources"
echo ""

echo "✓ Sistemler başlatılıyor..."
echo "  - Para Sistemi"
echo "  - Banka Sistemi"
echo "  - Meslek Sistemi"
echo "  - Tırcılık"
echo "  - Çiftçilik"
echo "  - Balıkçılık"
echo ""

echo "╔═══════════════════════════════════════╗"
echo "║  SUNUCU BAŞLATILIYOR...               ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# Sunucu başlatma
if [ -f "FXServer" ]; then
    ./FXServer +exec server.cfg
elif [ -f "txAdmin" ]; then
    ./txAdmin
else
    echo "Sunucu yazılımı başlatılamadı!"
    exit 1
fi
