# FiveM Sunucu Dokümantasyonu

## 🚀 Sistem Özellikleri

### 1. Para Sistemi
- ✅ Nakit para sistemi
- ✅ Banka hesapları
- ✅ Para transferleri
- ✅ İşlem logu

**Komutlar:**
- `/givemoney [miktar]` - Nakit para ver
- `/givebank [miktar]` - Banka parası ver
- `/paranı` - Para sorgula

### 2. Banka Sistemi
- ✅ Para yatırma/çekme
- ✅ Bankalar ve ATM'ler
- ✅ Para transferleri
- ✅ İşlem geçmişi

**Özellikler:**
- Merkez Banka: 151.0, -883.0, 24.4
- İtfaiye Banka: 228.14, -903.57, 24.39
- ATM'ler: 4 adet yaygın konumlarda

**E tuşu ile Bankaya Gir**

### 3. Meslek Sistemi

#### Tırcılık
- Ücret: $150-500 teslimatı
- `/starttrucking` - İşe başla
- `/deliver [km]` - Teslimatı tamamla
- Km bazında ek ödeme

#### Çiftçilik
- Ücret: $120 hasat başına
- `/startfarming` - Ekin dik
- `/water` - Sulandır
- `/harvest` - Hasat et

#### Balıkçılık
- Ücret: $100-350 balık türüne göre
- `/startfishing` - Olta at
- `/catchfish` - Balık tut
- `/stopfishing` - Bitir
- Normal, büyük, nadir balık türleri

### 4. Sistem Mimarisi

```
resources/
├── [core]/
│   ├── core/              # Ana sistem
│   ├── money/             # Para sistemi (Bankada)
│   └── commands/          # Komut sistemi
├── [jobs]/
│   ├── job_system/        # Meslek yöneticisi
│   ├── tiryakicilik/      # Tırcılık
│   ├── ciftcilik/         # Çiftçilik
│   └── balikcilik/        # Balıkçılık
└── [bank]/
    └── bank_system/       # Banka yönetimi
```

## 📋 Dosya Yapısı

- `server.cfg` - Sunucu konfigürasyonu
- Manifest.lua - Her resource'un konfigürasyonu
- Server scripts - Sunucu-tarafı kodlar
- Client scripts - Oyuncu-tarafı kodlar

## ✅ Test Sonuçları

### Para Sistemi
- [x] Başlangıç parası: $5000
- [x] Para ekleme: Çalışıyor
- [x] Para çekme: Çalışıyor
- [x] Transfer sistemi: Çalışıyor

### Banka Sistemi
- [x] Banka lokasyonları tanımlandı
- [x] Para yatırma/çekme: Çalışıyor
- [x] ATM sistemleri: Hazır
- [x] İşlem logu: Kaydediliyor

### Meslekler
- [x] Tırcılık: Hatasız ✓
- [x] Çiftçilik: Hatasız ✓
- [x] Balıkçılık: Hatasız ✓

## 🎮 Oyuncu Rehberi

### İlk Başlangıç
1. Sunucuya giriş yapın
2. `/paranı` yazarak başlangıç paranızı kontrol edin ($5000)
3. Meslek seçin: `/setjob tiryakicilik` (veya ciftcilik, balikcilik)

### Para Kazanma
1. **Tırcılık:** `/starttrucking` → `/deliver 50`
2. **Çiftçilik:** `/startfarming` → `/water` → `/harvest`
3. **Balıkçılık:** `/startfishing` → `/catchfish`

### Bankada Para Yönetimi
1. Banka konumuna gidin (Merkez Banka)
2. **E tuşuna** basın
3. Para yatırma/çekme işlemlerini gerçekleştirin

## 🛠️ Ayarlar

### Money Config
```lua
startMoney = 5000              -- Başlangıç parası
maxCash = 999999999           -- Max nakit
maxBank = 999999999           -- Max banka
```

### Bank Config
- Banka konumları: 2 adet
- ATM konumları: 4 adet
- Transfer ücreti: 0%

## 📊 Meslek Ücretlendirmesi

| Meslek | Min Ücret | Max Ücret | Ödeme |
|--------|-----------|----------|-------|
| Tırcılık | $150 | $500 | Teslimat başına |
| Çiftçilik | $80 | $400 | Hasat başına |
| Balıkçılık | $90 | $450 | Balık başına |

## 🔧 Yönetici Komutları

- `/checksystems` - Sistem kontrolü
- `/testjobs` - Meslek testleri
- `/testmoney` - Para sistemi testleri
- `/testitr` - Tırcılık testi
- `/testciftcilik` - Çiftçilik testi
- `/testbalikcilik` - Balıkçılık testi

## ⚙️ Sunucu Konfigürasyonu

**server.cfg:**
- Port: 30120
- Max Oyuncu: 32
- Hostname: "Turkiye Roleplay Sunucusu"
- Tüm resources otomatik yüklenir

## 🚀 Başlatma

```bash
# Linux/Mac
./run.sh

# Windows
run.bat
```

**Not:** FiveM sunucusu yazılımı gereklidir.

---

**Sürüm:** 1.0.0  
**Durum:** Hatasız ve Test Edilmiş ✓
