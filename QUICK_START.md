# ⚡ Hızlı Başlama Kılavuzu

## 🎮 İlk 5 Dakika

### 1. Sunucuyu Başlat
```bash
# Linux/Mac
./run.sh

# Windows  
run.bat
```

### 2. Oyuncu Olarak Bağlan
- GTA V'i aç
- FiveM'i seç
- Sunucuyu bul veya direkt bağlan: `localhost:30120`

### 3. Komutları Test Et

```bash
# Paranızı kontrol edin
/paranı

# Başlangıç Parası: $5000 (Nakit) + $5000 (Banka)
```

---

## 👤 Oyuncu Rehberi - 10 Dakika

### Meslek Seç (5 seçenek)

**1. Tırcılık (Kargo Görevleri)**
```
/starttrucking
/deliver 50          ← 50km teslimat, $250 para kazan!
```
⏱️ **Süre:** 5-10 dakika | 💰 **Kazanç:** $150-500

**2. Çiftçilik (Tarım)**
```
/startfarming        ← Başla
/water               ← Sulandır
/harvest             ← Hasat et, $120 kazan!
```
⏱️ **Süre:** 3-5 dakika | 💰 **Kazanç:** $120

**3. Balıkçılık (Balık Tutuş)**
```
/startfishing        ← Olta at
/catchfish           ← Balık tut!
```
⏱️ **Süre:** 2-5 dakika | 💰 **Kazanç:** $100-350

### Banka İşlemleri (2 dakika)

Banka konumuna git ve **E tuşu** basarak:
- 💵 Para yatır
- 💸 Para çek
- 🔄 Transfer yap

---

## ✅ Sistem Kontrolleri

Sistem düzgün çalışıyor mu check et:

```bash
# Tüm sistemleri kontrol et
/checksystems

# Meslek testleri
/testjobs

# Para sistemi testleri  
/testmoney

# Bireysel testler
/testitr          ← Tırcılık
/testciftcilik    ← Çiftçilik
/testbalikcilik   ← Balıkçılık
```

---

## 📊 Para Yönetimi Şeması

```
Banka Sistemi (MERKEZ KONTROL)
│
├─ Nakit Para (Cebinde taşı)
│  │
│  ├─ Mesleklerle kazan
│  ├─ Diğer oyuncularla transfer
│  └─ Harcamalar
│
└─ Banka Hesabı (Güvenli)
   │
   ├─ Para yatır (/E düğmesi)
   ├─ Para çek (/E düğmesi)
   └─ Bankalara gir (151, -883) veya (228, -903)
```

---

## 🎯 Hızlı Tespit

| Komut | Yanıt | Durum |
|-------|-------|-------|
| `/paranı` | Nakit + Banka göstersin | ✅ OK |
| `/givemoney 1000` | Para eklensin | ✅ OK |
| `/setjob tiryakicilik` | Meslek seçilsin | ✅ OK |
| `/checksystems` | Tüm sistemler OK | ✅ OK |

---

## 🐛 Sorun Giderme

**Sorun:** Komutlar çalışmıyor
```
→ Kontrol et: /checksystems yazıp çalışıyor mı?
→ Sunucuyu yeniden başlatmayı dene: run.sh / run.bat
```

**Sorun:** Para gözükmüyor
```
→ /paranı yazarak kontrol et
→ Banka menüsüne git (E tuşu)
```

**Sorun:** Meslek seçilmiyor
```
→ /setjob tiryakicilik yazıp tekrar dene
→ Doğru yazıldığını kontrol et (Türkçe karakterler yok!)
```

---

## 📚 Detaylı Bilgi

Daha fazla bilgi için bkz:
- [README.md](README.md) - Ana dokümantasyon
- [DOKUMENTASYON.md](DOKUMENTASYON.md) - Detaylı ayarlar
- [TEST_RAPORU.md](TEST_RAPORU.md) - Test sonuçları

---

## 🎉 5 Dakikalık Başarılı Test Senaryosu

```
1️⃣ Sunucuya bağlan
2️⃣ /paranı yazarak $10000 bak
3️⃣ /setjob balikcilik yap
4️⃣ /startfishing yaz
5️⃣ /catchfish ile 3 balık tut
6️⃣ Bankaya git (E tuşu basıp 2000 yatır)
7️⃣ /paranı yazarak kontrol et
8️⃣ /phone yazarak telefonu aç
9️⃣ 💰 Hesap sekmesinde BANKA BAKİYESİ'ni gör

✅ BAŞARILI! Tüm sistemler çalışıyor!
```

---

## 📱 Telefon Sistemi (YENİ!)

Artık oyuncular telefonlarında **hesap bakiyesi** görebilir!

### Hızlı Test
```
/phone                    ← Telefon aç
→ 💰 Hesap sekmesine git
→ "HESAP BAKİYESİ (BANKA)" gör
→ "Bakiye Yükle" ile para aktar
```

### Telefon Özellikleri
✨ **Hesap Erişimi** - Banka bakiyenizi telefondan görün  
✨ **Bakiye Yükleme** - Bankadan telefona para aktarın  
✨ **SMS Sistemi** - Oyuncularla mesaj yaşayın  
✨ **Rehber** - Önceden tanımlı numaralar (911, 112, 1234, vb.)  
✨ **Mobil Arayüz** - Modern ve kullanıcı dostu UI  

Detaylı bilgi için: **TELEFON_KILAVUZU.md**

---

**⏱️ Tahmini Süre:** 5-10 dakika  
**📈 Zorluk:** Çok Kolay  
**✨ Sonuç:** Tam Fonksiyonel Sunucu
