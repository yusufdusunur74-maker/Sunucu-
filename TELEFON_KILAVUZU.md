# Telefon Sistemi Kullanıcı Kılavuzu

## Telefon Sistemi Nedir?
Telefon sistemi sayesinde oyuncular:
- **Hesaplarına erişebilir** - Banka bakiyesi görebilir
- **Bakiye yükleyebilir** - Bankasından telefon bakiyesine para aktarabilir
- **SMS gönderbilir** - Diğer oyunculara mesaj atabilir
- **Rehber yönetebilir** - Önceden tanımlı ve kişi rehberi

## Telefon Komutları

### Temel Komutlar
| Komut | Açıklama |
|-------|----------|
| `/phone` | Telefonu aç/kapat (ESC tuşu ile de kapatabilirsiniz) |
| `/balance` | Telefon bakiyenizi kontrol edin |
| `/addbalance [tutar]` | Bankadan telefona bakiye yükle (Ör: /addbalance 100) |
| `/sms [numara] [mesaj]` | SMS gönder (Ör: /sms 555-1234 Merhaba) |

## Telefon Açılışında Neler Görürsünüz?

### Ana Menü
```
👥 Rehber       - Önceden tanımlı ve kişi numaraları
💬 Mesajlar     - Aldığınız SMS'ler
💰 Hesap        - BANKA BAKİYESİ + Telefon Bakiyesi
☎️ Aramalar     - Arama geçmişi
```

### HESAP Sekmesi (ÖNEMLİ)
Telefonu açtığınızda **Hesap** sekmesinde görecekleriniz:

✅ **Telefon Numarası** - Oyuncular size bu numaraya SMS gönderecek  
✅ **Telefon Bakiyesi** - Telefon hizmetleri için bakiye ($)  
✅ **HESAP BAKİYESİ** - **BANKA HESABINIZ** (Buradan bakiye yüklersiniz)  
✅ **NAKİT** - Elinizdeki para  
✅ **Bakiye Yükle Butonu** - Bankadan telefona para aktar

## Nasıl Çalışır?

### 1. Telefon Satın Alma
```
/phone
→ Eğer telefonunuz yoksa: "Telefonunuz yok! /buyphone yazarak satın alın"
→ /buyphone komutu ile telefon satın al
```

### 2. Hesabınızdan Bakiye Yükleme (HESABIMA YUKLE)
```
Telefon Menü → 💰 Hesap sekmesine git
↓
"HESAP BAKİYESİ (BANKA)" kısmını gör
↓
"Bakiye Yükle" butonuna tıkla
↓
Para miktarını gir
↓
✅ Bankandan çekilerek telefona aktarılır
```

**Önemli:** Telefon bakiyesi her SMS göndermek veya hizmet kullanmak için kullanılır.

### 3. SMS Gönderme
```
Telefon Menü → 💬 Mesajlar sekmesine git
↓
Alıcı telefon numarasını gir (Ör: 555-1234)
↓
Mesajınızı yaz
↓
"Gönder" butonuna tıkla
↓
✅ Alıcı SMS'i anında alır
```

### 4. Rehber Kullanma
```
Telefon Menü → 👥 Rehber sekmesine git
↓
Önceden tanımlı numara (911, 112, 1234, vb.)
↓
Numaraya tıkla → Arama başlar
```

## SMS Maliyetleri

| İşlem | Maliyet |
|-------|---------|
| SMS Gönderme | $1 |
| Telefon Çağrısı | $2 |
| Para Transferi | $5 |

## Telefon Önceden Tanımlı Numaraları

| Numara | Hizmet | Tür |
|--------|--------|-----|
| 911 | Polis | Acil |
| 112 | Ambulans | Acil |
| 110 | İtfaiye | Acil |
| 1234 | Banka Müşteri Hizmetleri | Hizmet |
| 5678 | Market | Hizmet |
| 9012 | Garaj | Hizmet |

## Sorun Giderme

**Soru: Telefon açılmıyor**
Cevap: 
1. `/buyphone` ile telefon satın aldığınızdan emin olun
2. Bankada yeterli para ($500) olması gerekir
3. `/phone` komutu ile tekrar deneyin

**Soru: SMS gönderemiyor**
Cevap:
1. Telefon bakiyeniz kontrol edin (/balance)
2. Yeterli bakiye yoksa `/addbalance 100` yazın
3. Alıcının telefon numarasını doğru yazdığınızdan emin olun

**Soru: Hesap bakiyesi görmüyor**
Cevap:
1. Telefon Menü → Hesap sekmesine git
2. Sayfayı yenile (Telefonu kapat ve tekrar aç)
3. Sunucu bağlantısını kontrol et

**Soru: Hesaptan bakiye yüklenemiyor**
Cevap:
1. Banka bakiyesinin yeterli olduğundan emin ol
2. Tutar 0'dan büyük olmalı
3. `/balance` ile telefon bakiyesini kontrol et

## İpuçları

💡 **SMS gönder** - Yöneticilere veya arkadaşlarına hızlıca mesaj at  
💡 **Bakiye kontrol** - Harcanmış paramı takip et  
💡 **Acil numaralar** - 911, 112, 110 acil durumlarda hızlı yardım  
💡 **Rehber** - Numaraları kaydet ve hızlı erişim sağla  

---

**Telefon Sistemi v1.0.0** - Aktif ve Etkinleştirildi ✅
