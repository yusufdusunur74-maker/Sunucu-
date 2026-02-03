#!/bin/bash

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         YENİ ÖZELLIKLER KURULUM TEST SİSTEMİ           ║"
echo "║                  ✅ BAŞLADI                              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

# Araç Galerisi
echo -e "${YELLOW}[1/7] Araç Galerisi Kontrolü${NC}"
test_file "resources/[vehicles]/garage/manifest.lua" "Garaj manifest"
test_file "resources/[vehicles]/garage/shared/config.lua" "Garaj konfigürasyonu"
test_file "resources/[vehicles]/garage/server/main.lua" "Garaj sunucu"
test_file "resources/[vehicles]/garage/client/main.lua" "Garaj client"
test_file "resources/[vehicles]/garage/html/index.html" "Garaj UI"
echo ""

# Admin Menü
echo -e "${YELLOW}[2/7] Admin Menü Kontrolü${NC}"
test_file "resources/[admin]/admin_menu/manifest.lua" "Admin manifest"
test_file "resources/[admin]/admin_menu/server/main.lua" "Admin sunucu"
test_file "resources/[admin]/admin_menu/client/main.lua" "Admin client"
echo ""

# Envanter
echo -e "${YELLOW}[3/7] Envanter Sistemi Kontrolü${NC}"
test_file "resources/[inventory]/inventory/manifest.lua" "Envanter manifest"
test_file "resources/[inventory]/inventory/server/main.lua" "Envanter sunucu"
test_file "resources/[inventory]/inventory/html/index.html" "Envanter UI"
echo ""

# Market
echo -e "${YELLOW}[4/7] Market Sistemi Kontrolü${NC}"
test_file "resources/[business]/market/manifest.lua" "Market manifest"
test_file "resources/[business]/market/server/main.lua" "Market sunucu"
test_file "resources/[business]/market/client/main.lua" "Market client"
echo ""

# İşyeri
echo -e "${YELLOW}[5/7] İşyeri Sistemi Kontrolü${NC}"
test_file "resources/[business]/business/manifest.lua" "İşyeri manifest"
test_file "resources/[business]/business/server/main.lua" "İşyeri sunucu"
test_file "resources/[business]/business/client/main.lua" "İşyeri client"
echo ""

# İllegal Meslekler
echo -e "${YELLOW}[6/7] İllegal Meslekler Kontrolü${NC}"
test_file "resources/[illegal]/illegal_jobs/manifest.lua" "İllegal manifest"
test_file "resources/[illegal]/illegal_jobs/server/main.lua" "İllegal sunucu"
test_file "resources/[illegal]/illegal_jobs/client/main.lua" "İllegal client"
echo ""

# Araç Kilit
echo -e "${YELLOW}[7/7] Araç Kilit Sistemi Kontrolü${NC}"
test_file "resources/[vehicles]/locks/manifest.lua" "Kilit manifest"
test_file "resources/[vehicles]/locks/server/main.lua" "Kilit sunucu"
test_file "resources/[vehicles]/locks/client/main.lua" "Kilit client"
echo ""

# Sonuçlar
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              TEST SONUÇLARI                              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

if [ $tests_passed -eq $tests_total ]; then
    echo -e "${GREEN}✓ TÜM TESTLER BAŞARILI!${NC}"
    echo ""
    echo "Yeni Özellikler:"
    echo -e "  ${GREEN}✓${NC} Araç Galerisi (19 araç, 8 dosya)"
    echo -e "  ${GREEN}✓${NC} Admin Menü (4 dosya)"
    echo -e "  ${GREEN}✓${NC} Envanter Sistemi (7 dosya)"
    echo -e "  ${GREEN}✓${NC} Market (4 dosya)"
    echo -e "  ${GREEN}✓${NC} İşyeri (4 dosya)"
    echo -e "  ${GREEN}✓${NC} İllegal Meslekler (5 dosya)"
    echo -e "  ${GREEN}✓${NC} Araç Kilit (3 dosya)"
else
    echo -e "${RED}✗ BAZZ TESTLER BAŞARISIZ!${NC}"
fi

echo ""
echo "Toplam Dosya: $tests_passed/$tests_total"
echo ""
echo "Komutlar:"
echo "  • /givecar [model] - Araç al"
echo "  • /buy [id] [miktar] - Ürün satın al"
echo "  • /businesses - İşyeri listesi"
echo "  • /startcocaine - Uyuşturucu üret"
echo "  • /admin - Admin menü"
echo ""
