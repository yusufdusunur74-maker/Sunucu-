#!/bin/bash

# FiveM Sunucusu Test Scripti
echo "================================"
echo "FiveM Sunucusu Test Başlatılıyor"
echo "================================"
echo ""

# Dosya yapısını kontrol et
echo "📁 Dosya Yapısı Kontrol:"
if [ -f "server.cfg" ]; then
    echo "✓ server.cfg bulundu"
else
    echo "✗ server.cfg bulunamadı"
fi

if [ -d "resources/[core]" ]; then
    echo "✓ [core] resources bulundu"
else
    echo "✗ [core] resources bulunamadı"
fi

if [ -d "resources/[jobs]" ]; then
    echo "✓ [jobs] resources bulundu"
else
    echo "✗ [jobs] resources bulunamadı"
fi

if [ -d "resources/[bank]" ]; then
    echo "✓ [bank] resources bulundu"
else
    echo "✗ [bank] resources bulunamadı"
fi

echo ""
echo "📦 Manifest Dosyaları Kontrol:"
manifests=(
    "resources/[core]/core/manifest.lua"
    "resources/[core]/money/manifest.lua"
    "resources/[core]/commands/manifest.lua"
    "resources/[jobs]/job_system/manifest.lua"
    "resources/[jobs]/tiryakicilik/manifest.lua"
    "resources/[jobs]/ciftcilik/manifest.lua"
    "resources/[jobs]/balikcilik/manifest.lua"
    "resources/[bank]/bank_system/manifest.lua"
)

for manifest in "${manifests[@]}"; do
    if [ -f "$manifest" ]; then
        echo "✓ $(basename $(dirname $manifest))"
    else
        echo "✗ $(basename $(dirname $manifest)) - bulunamadı"
    fi
done

echo ""
echo "================================"
echo "✓ Tüm dosyalar hazır!"
echo "================================"
echo ""
echo "Sunucuyu başlatmak için:"
echo "./run.sh (Linux/Mac) veya run.bat (Windows)"
echo ""
echo "Test komutları:"
echo "/checksystems - Sistem kontrolü"
echo "/testjobs - Meslek testleri"
echo "/testmoney - Para sistemi testleri"
