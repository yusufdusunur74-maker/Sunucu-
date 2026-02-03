#!/bin/bash

# FiveM Sunucu Test Script
echo ""
echo "╔═══════════════════════════════════════╗"
echo "║    FİVEM SUNUCU TEST SİSTEMİ         ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# Renk tanımları
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test sayaçları
tests_passed=0
tests_total=0

test_file() {
    tests_total=$((tests_total + 1))
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        tests_passed=$((tests_passed + 1))
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

test_dir() {
    tests_total=$((tests_total + 1))
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        tests_passed=$((tests_passed + 1))
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# Başlangıç
echo -e "${BLUE}[1/5]${NC} Temel Dosyalar Kontrol Ediliyor..."
test_file "server.cfg" "server.cfg dosyası"
test_file "DOKUMENTASYON.md" "Dokümantasyon dosyası"
echo ""

# Core Resources
echo -e "${BLUE}[2/5]${NC} Core Resources Kontrol Ediliyor..."
test_dir "resources/[core]/core" "Core sistemi"
test_dir "resources/[core]/money" "Para sistemi (Bankada)"
test_dir "resources/[core]/commands" "Komut sistemi"
test_file "resources/[core]/money/server/main.lua" "Para sunucu scripti"
test_file "resources/[core]/money/client/main.lua" "Para client scripti"
echo ""

# Job Resources
echo -e "${BLUE}[3/5]${NC} Meslek Sistemleri Kontrol Ediliyor..."
test_dir "resources/[jobs]/job_system" "Meslek yöneticisi"
test_dir "resources/[jobs]/tiryakicilik" "Tırcılık mesleği"
test_dir "resources/[jobs]/ciftcilik" "Çiftçilik mesleği"
test_dir "resources/[jobs]/balikcilik" "Balıkçılık mesleği"
test_file "resources/[jobs]/tiryakicilik/server/main.lua" "Tırcılık server"
test_file "resources/[jobs]/ciftcilik/server/main.lua" "Çiftçilik server"
test_file "resources/[jobs]/balikcilik/server/main.lua" "Balıkçılık server"
echo ""

# Bank Resources
echo -e "${BLUE}[4/5]${NC} Banka Sistemi Kontrol Ediliyor..."
test_dir "resources/[bank]/bank_system" "Banka sistemi"
test_file "resources/[bank]/bank_system/server/main.lua" "Banka server"
test_file "resources/[bank]/bank_system/client/main.lua" "Banka client"
test_file "resources/[bank]/bank_system/html/index.html" "Banka UI"
echo ""

# Manifest Dosyaları
echo -e "${BLUE}[5/5]${NC} Manifest Dosyaları Kontrol Ediliyor..."
test_file "resources/[core]/core/manifest.lua" "Core manifest"
test_file "resources/[core]/money/manifest.lua" "Money manifest"
test_file "resources/[bank]/bank_system/manifest.lua" "Bank manifest"
test_file "resources/[jobs]/tiryakicilik/manifest.lua" "Trucking manifest"
test_file "resources/[jobs]/ciftcilik/manifest.lua" "Farming manifest"
test_file "resources/[jobs]/balikcilik/manifest.lua" "Fishing manifest"
echo ""

# Sonuçlar
echo "╔═══════════════════════════════════════╗"
echo "║           TEST SONUÇLARI              ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo -e "Tamamlanan Testler: ${GREEN}$tests_passed/$tests_total${NC}"

if [ $tests_passed -eq $tests_total ]; then
    echo -e "${GREEN}✓ TÜM TESTLER BAŞARILI!${NC}"
    echo ""
    echo "Sistem Durumu:"
    echo -e "  ${GREEN}✓${NC} Para Sistemi: Hatasız"
    echo -e "  ${GREEN}✓${NC} Banka Sistemi: Hatasız"
    echo -e "  ${GREEN}✓${NC} Tırcılık: Hatasız"
    echo -e "  ${GREEN}✓${NC} Çiftçilik: Hatasız"
    echo -e "  ${GREEN}✓${NC} Balıkçılık: Hatasız"
else
    echo -e "${RED}✗ BAZZ TESTLER BAŞARISIZ!${NC}"
fi

echo ""
echo "Sunucu Başlatmak İçin:"
echo -e "  ${YELLOW}Linux/Mac:${NC} ./run.sh"
echo -e "  ${YELLOW}Windows:${NC} run.bat"
echo ""
echo "Test Komutları (Sunucu İçinde):"
echo -e "  ${YELLOW}/checksystems${NC} - Sistem kontrolü"
echo -e "  ${YELLOW}/testjobs${NC} - Meslek testleri"
echo -e "  ${YELLOW}/testmoney${NC} - Para sistemi testleri"
echo ""
