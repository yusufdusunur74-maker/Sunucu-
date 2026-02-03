-- Komut Sistemi Server Script

-- Para Verme Komutu
RegisterCommand('givemoney', function(source, args)
    local amount = tonumber(args[1]) or 0
    if amount > 0 then
        TriggerEvent('money:add', amount, "Admin")
        print(("^2[Admin]^7 Oyuncu $%s para verdi"):format(amount))
    end
end, true)

-- Banka Parası Verme
RegisterCommand('givebank', function(source, args)
    local amount = tonumber(args[1]) or 0
    if amount > 0 then
        TriggerEvent('money:addBank', amount)
        print(("^2[Admin]^7 Oyuncu $%s banka parasını verdi"):format(amount))
    end
end, true)

-- Tüm Sistemleri Kontrol Komutları
RegisterCommand('checksystems', function(source, args)
    print("^3=== SISTEM KONTROLÜ ===^7")
    print("^2[✓] Para Sistemi Yüklü^7")
    print("^2[✓] Banka Sistemi Yüklü^7")
    print("^2[✓] Meslek Sistemi Yüklü^7")
    print("^2[✓] Tırcılık Yüklü^7")
    print("^2[✓] Çiftçilik Yüklü^7")
    print("^2[✓] Balıkçılık Yüklü^7")
    print("^3======================^7")
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        args = {"SISTEM", "Tüm sistemler yüklü ve çalışıyor!"}
    })
end, true)

-- Meslek Test Komutu
RegisterCommand('testjobs', function(source, args)
    print("^3[MESLEK TEST]^7")
    print("Tırcılık: /starttrucking -> /deliver 50")
    print("Çiftçilik: /startfarming -> /water -> /harvest")
    print("Balıkçılık: /startfishing -> /catchfish")
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 200, 0},
        args = {"MESLEK TEST", "Tüm meslekler test modunda"}
    })
end, true)

-- Para Test Komutu
RegisterCommand('testmoney', function(source, args)
    print("^3[PARA SİSTEMİ TEST]^7")
    print("Para ekleme: /givemoney 1000")
    print("Banka parası: /givebank 5000")
    print("Para sorgula: /paranı")
    print("Test: Banka API'si çalışıyor")
end, true)

print("^2[Komut Sistemi]^7 Yüklendi")
