-- İllegal Meslekler Server
print("^1[İllegal Meslekler]^7 Yüklendi")

-- Uyuşturucu Üretimi
RegisterNetEvent('illegal:produceCocaine')
AddEventHandler('illegal:produceCocaine', function()
    local src = source
    
    -- Random başarısızlık şansı (Polis tarafından yakalanma riski)
    if math.random(1, 100) <= 30 then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            args = {"POLİS", "Uyuşturucu operasyonunda yakalandınız!"}
        })
        print(("^1[İllegal]^7 Oyuncu %d uyuşturucuda yakalandı"):format(src))
        return
    end
    
    local amount = math.random(5000, 15000)
    TriggerEvent('money:add', amount, "UYUŞTURUCU")
    
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 255, 0},
        args = {"UYUŞTURUCU", "Ürün satıldı! +$" .. amount}
    })
    
    print(("^1[Uyuşturucu]^7 Oyuncu %d $%s kazandı"):format(src, amount))
end)

-- Soygun
RegisterNetEvent('illegal:robbery')
AddEventHandler('illegal:robbery', function()
    local src = source
    
    -- Yakalanma riski
    if math.random(1, 100) <= 40 then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            args = {"POLİS", "Soygun sırasında yakalandınız!"}
        })
        print(("^1[Soygun]^7 Oyuncu %d yakalandı"):format(src))
        return
    end
    
    local amount = math.random(3000, 10000)
    TriggerEvent('money:add', amount, "SOYGUN")
    
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 255, 0},
        args = {"SOYGUN", "Başarılı soygun! +$" .. amount}
    })
    
    print(("^1[Soygun]^7 Oyuncu %d $%s çaldı"):format(src, amount))
end)

-- Kaçak İn
RegisterNetEvent('illegal:mining')
AddEventHandler('illegal:mining', function()
    local src = source
    local ore = math.random(100, 500)
    
    TriggerEvent('inventory:addItem', "Altın Cevheri", ore)
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 255, 0},
        args = {"MADENCİLİK", "Çıkardı: " .. ore .. " gram altın"}
    })
    
    print(("^1[Madencilik]^7 Oyuncu %d %d gram çıkardı"):format(src, ore))
end)
