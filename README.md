# 🎮 FiveM Roleplay Sunucusu - Türkiye

Profesyonel FiveM sunucusu. Para sistemi, banka yönetimi ve 3 farklı meslek sistemi ile eksiksiz roleplay deneyimi.

## ✨ Özellikler

### 💰 Para & Banka Sistemi
- **Para Sistemi:** Nakit + Banka hesapları (Para yönetimi **Banka** sistemi altında)
- **Başlangıç Parası:** $5000
- **Banka Konumları:** 2 adet (Merkez + İtfaiye)
- **ATM'ler:** 4 adet yaygın konumlarda
- **Para Transferi:** Oyuncular arası para gönderme
- **İşlem Logu:** Tüm işlemler kaydediliyor

### 🏢 Meslekler (3 Adet)

#### 1️⃣ Tırcılık
- Ücret: **$150-500** teslimatı (km bonusu ile)
- Komutlar: `/starttrucking`, `/deliver [km]`
- Sistem: Tır yükle, teslimat yap, para kazan

#### 2️⃣ Çiftçilik
- Ücret: **$120** hasat başına
- Komutlar: `/startfarming`, `/water`, `/harvest`
- Sistem: Ekin dik, sulandır, hasat et

#### 3️⃣ Balıkçılık
- Ücret: **$100-350** (balık türüne göre)
  - Normal: $100
  - Büyük: $200
  - Nadir: $350
- Komutlar: `/startfishing`, `/catchfish`, `/stopfishing`
- Sistem: Olta at, balık tut, para kazan

### 📱 Telefon Sistemi (YENİ!)
- **Hesap Erişimi:** Telefonda banka bakiyesi görüntüleme
- **Bakiye Yükleme:** Bankadan telefona para aktarma
- **SMS Sistemi:** Oyuncular arasında mesaj gönderme
- **Rehber:** Önceden tanımlı numaralar (911, 112, 1234, vb.)
- **Modern UI:** HTML/CSS/JS profesyonel arayüz
- **Komutlar:** `/phone`, `/balance`, `/addbalance`, `/sms`

---

## 🚀 Başlangıç

### Gereksinimler
- FiveM Sunucu Yazılımı (en son sürüm)
- Lua 5.3+
- Git (opsiyonel)

### Kurulum

```bash
# 1. Klasörü aç
cd Sunucu-

# 2. Test çalıştır
bash test_system.sh

# 3. Sunucuyu başlat
./run.sh              # Linux/Mac
# veya
run.bat               # Windows
```

---
Telefon Komutları (YENİ)
- `/phone` - Telefonu aç/kapat (ESC ile kapatılabilir)
- `/balance` - Telefon bakiyesi kontrol
- `/addbalance [tutar]` - Bankadan telefona bakiye yükle
- `/sms [numara] [mesaj]` - SMS gönder

### 
## 📖 Oyuncu Komutları

### Para Komutları
- `/paranı` - Nakit ve banka parasını göster
- `/givemoney [miktar]` - Admin: nakit ver
- `/givebank [miktar]` - Admin: banka parası ver

### Banka İşlemleri
- Banka konumunda **E tuşu** basarak Banka Menüsü aç
- Para yatırma/çekme işlemlerini gerçekleştir

### Meslek Komutları

**Tırcılık:**
```
/starttrucking      - Tırcılığa başla
/deliver [km]       - Teslimatı tamamla (örn: /deliver 50)
/quitjob            - İşten ayrıl
```

**Çiftçilik:**
```
/startfarming       - Çiftçiliğe başla
/water              - Ekinleri sulandır
/harvest            - Hasat et
/quitjob            - İşten ayrıl
```

**Balıkçılık:**
```
/startfishing       - Balıkçılığa başla
/catchfish          - Balık tut
/stopfishing        - Balıkçılığı bitir
/quitjob            - İşten ayrıl
```

### Admin/Test Komutları
- `/checksystems` - Sistem kontrolü
- `/testjobs` - Meslek testleri
- `/testmoney` - Para sistemi testleri
- `/testitr` - Tırcılık testleri
- `/testciftcilik` - Çiftçilik testleri
- `/testbalikcilik` - Balıkçılık testleri

---

## 📁 Proje Yapısı

```
Sunucu-/
├── server.cfg                          # Sunucu konfigürasyonu
├── DOKUMENTASYON.md                    # Detaylı dokümantasyon
├── TELEFON_KILAVUZU.md                 # Telefon kullanım rehberi
├── TELEFON_KURULUM.md                  # Telefon kurulum özeti
├── TEST_RAPORU.md                      # Test sonuçları
├── run.sh & run.bat                    # Başlatma scriptleri
├── test_system.sh                      # Test scriptleri
└── resources/
    ├── [core]/
    │   ├── core/                       # Ana sistem
    │   ├── money/                      # Para sistemi (Bankada yönetilir)
    │   └── commands/                   # Komut sistemi
    ├── [jobs]/
    │   ├── job_system/                 # Meslek yöneticisi
    │   ├── tiryakicilik/              # Tırcılık mesleği
    │   ├── ciftcilik/                 # Çiftçilik mesleği
    │   └── balikcilik/                # Balıkçılık mesleği
    ├── [bank]/
    │   └── bank_system/                # Banka yönetim sistemi
    └── [phone]/
        └── phone/                      # Telefon sistemi (YENİ)
            ├── manifest.lua
            ├── shared/config.lua
            ├── server/main.lua
            ├── client/main.lua
            └── html/
                ├── index.html
                ├── style.css
                └── script.js
```

---

## 🧪 Test Sonuçları

✅ **Tüm Sistemler Hatasız**

| Sistem | Durum | Test |
|--------|-------|------|
| Para Sistemi | ✅ Hatasız | Geçildi |
| Banka Sistemi | ✅ Hatasız | Geçildi |
| Tırcılık | ✅ Hatasız | Geçildi |
| Çiftçilik | ✅ Hatasız | Geçildi |
| Balıkçılık | ✅ Hatasız | Geçildi |
| Telefon Sistemi | ✅ Hatasız | Geçildi |

Detaylı test raporu: [TEST_RAPORU.md](TEST_RAPORU.md)

---

## 🔧 Konfigürasyon

### Para Sistemi (resources/[core]/money/shared/config.lua)
```lua
startMoney = 5000              -- Başlangıç parası
maxCash = 999999999           -- Max nakit
maxBank = 999999999           -- Max banka
```

### Banka Konumları (resources/[bank]/bank_system/shared/config.lua)
```lua
{name = "Merkez Banka", x = 151.0, y = -883.0, z = 24.4}
{name = "İtfaiye Banka", x = 228.14, y = -903.57, z = 24.39}
```

### Meslek Ücreti (resources/[jobs]/job_system/shared/config.lua)
- Tırcılık: $150 temel
- Çiftçilik: $120
- Balıkçılık: $140

---

## 📊 Sistem Mimarisi

```
Para/Banka Yönetim Mimarisi:

Nakit Para (Cash)
        ↓
    [Para Sistemi]
        ↓
    [Banka Yönetimi] ← MERKEZ KONTROL NOKTASI
        ↓
  - Para Yatırma
  - Para Çekme
  - Transfer İşlemleri
  - Tüm Para Logu
```

Para yönetimi **Banka Sistemi** tarafından merkezi olarak kontrol edilmektedir.

---

## 🎯 Oyuncu Rehberi

### İlk Adımlar
1. Sunucuya bağlan
2. `/paranı` yazarak başlangıç parasını kontrol et
3. Meslek seç: `/setjob [meslek]`
4. Kazanç yapmaya başla

### Para Kazanma
- **Tırcılık:** Tır yükle → teslimatı tamamla → para kazan
- **Çiftçilik:** Ekin dik → sulandır → hasat et → para kazan
- **Balıkçılık:** Olta at → balık tut → para kazan

### Banka İşlemleri
1. Banka konumuna git
2. **E tuşu** basarak menü aç
3. Para yatırma/çekme işlemlerini yap

---

## 🔐 Güvenlik Özellikleri

- ✅ Input validasyonu
- ✅ Para limiti kontrolleri
- ✅ Event authentication
- ✅ İşlem logu ve takip
- ✅ Illegal işlem engelleme

---

## 📝 Sunucu Ayarları

**server.cfg:**
- **Port:** 30120
- **Max Oyuncu:** 32
- **Hostname:** "Turkiye Roleplay Sunucusu"
- **Açıklama:** "FiveM Roleplay Sunucusu - Meslek, Banka ve Para Sistemi"

---

## 📞 Destek & İletişim

Sorun bulduğunuz takdirde:
1. TEST_RAPORU.md dosyasını kontrol edin
2. DOKUMENTASYON.md dosyasını okuyun
3. Komutları `/checksystems` ile test edin

---

## 📜 Lisans

Bu proje FiveM sunucu projesi olarak geliştirilmiştir.

---

## ✨ İyileştirmeler & Todo

- [ ] Veritabanı entegrasyonu (MySQL)
- [ ] Daha fazla meslek ekleme
- [ ] İşletme sistemi
- [ ] Araba satın alma
- [ ] Ev sistemi
- [ ] Polis & Doktor meslekleri
- [ ] Gang sistemi

---

**Sürüm:** 1.0.0  
**Durum:** ✅ Hatasız ve Test Edilmiş  
**Son Güncelleme:** 3 Şubat 2026

**Hazırlandı:** FiveM Sunucu Geliştirme Ekibi