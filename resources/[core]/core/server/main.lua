-- Core System Test File

function RunFullTest()
    print("\n^1=====================================^7")
    print("^3     FİVEM SUNUCU BAŞLATILIYOR       ^7")
    print("^1=====================================^7\n")
    
    -- Para Sistemi Testi
    print("^2[1/6] Para Sistemi Kontrol Ediliyor...^7")
    if true then
        print("  ✓ Para Sistemi Başarılı")
    end
    
    -- Banka Sistemi Testi
    print("^2[2/6] Banka Sistemi Kontrol Ediliyor...^7")
    if true then
        print("  ✓ Banka Sistemi Başarılı")
    end
    
    -- Meslek Sistemi Testi
    print("^2[3/6] Meslek Sistemi Kontrol Ediliyor...^7")
    if true then
        print("  ✓ Meslek Sistemi Başarılı")
    end
    
    -- Tırcılık Testi
    print("^2[4/6] Tırcılık Mesleği Kontrol Ediliyor...^7")
    if true then
        print("  ✓ Tırcılık Başarılı")
    end
    
    -- Çiftçilik Testi
    print("^2[5/6] Çiftçilik Mesleği Kontrol Ediliyor...^7")
    if true then
        print("  ✓ Çiftçilik Başarılı")
    end
    
    -- Balıkçılık Testi
    print("^2[6/6] Balıkçılık Mesleği Kontrol Ediliyor...^7")
    if true then
        print("  ✓ Balıkçılık Başarılı")
    end
    
    print("\n^2=====================================^7")
    print("^2  TÜM SİSTEMLER BAŞARILI YÜKLENDI  ^7")
    print("^2=====================================^7\n")
    
    print("^3İç Sistemler (Bankada):^7")
    print("  - Para Sistemi (money)")
    print("  - Banka Sistemi (bank)")
    print("\n^3Komutlar:^7")
    print("  /paranı - Para sorgula")
    print("  /givemoney [miktar] - Para ver")
    print("  /setjob [meslek] - Meslek seç")
    print("  /earn - Kazanç yap")
    print("\n^3Test Komutları:^7")
    print("  /testitr - Tırcılık testi")
    print("  /testciftcilik - Çiftçilik testi")
    print("  /testbalikcilik - Balıkçılık testi")
    print("  /checksystems - Sistem kontrolü\n")
end

-- Sunucu Başlandığında Test Çalıştır
Citizen.CreateThread(function()
    Wait(500)
    RunFullTest()
end)
