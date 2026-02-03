-- Para/Banka Server Script
local Players = {}

-- Oyuncu Verisi Başlatma
RegisterNetEvent('money:initialize')
AddEventHandler('money:initialize', function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    
    Players[src] = {
        id = src,
        identifier = identifier,
        cash = 5000,
        bank = 5000,
        timestamp = os.time()
    }
    
    TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
    TriggerEvent('money:log', src, "Sistem", "Oyuncu başlatıldı", Players[src].cash, Players[src].bank)
end)

-- Para İşlemler
RegisterNetEvent('money:add')
AddEventHandler('money:add', function(amount, source_type)
    local src = source
    if not Players[src] then return end
    
    amount = tonumber(amount) or 0
    if amount > 0 then
        Players[src].cash = Players[src].cash + amount
        TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
        TriggerEvent('money:log', src, source_type, "Para eklendi", amount, Players[src].cash)
    end
end)

-- Banka Para Ekleme
RegisterNetEvent('money:addBank')
AddEventHandler('money:addBank', function(amount)
    local src = source
    if not Players[src] then return end
    
    amount = tonumber(amount) or 0
    if amount > 0 and Players[src].cash >= amount then
        Players[src].cash = Players[src].cash - amount
        Players[src].bank = Players[src].bank + amount
        TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
        TriggerEvent('money:log', src, "BANKA", "Bankaya para yatırıldı", amount, Players[src].bank)
    end
end)

-- Banka Para Çekme
RegisterNetEvent('money:removeBank')
AddEventHandler('money:removeBank', function(amount)
    local src = source
    if not Players[src] then return end
    
    amount = tonumber(amount) or 0
    if amount > 0 and Players[src].bank >= amount then
        Players[src].bank = Players[src].bank - amount
        Players[src].cash = Players[src].cash + amount
        TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
        TriggerEvent('money:log', src, "BANKA", "Bankadan para çekildi", amount, Players[src].cash)
    end
end)

-- Para Transfer
RegisterNetEvent('money:transfer')
AddEventHandler('money:transfer', function(targetId, amount)
    local src = source
    if not Players[src] or not Players[targetId] then return end
    
    amount = tonumber(amount) or 0
    if amount > 0 and Players[src].cash >= amount then
        Players[src].cash = Players[src].cash - amount
        Players[targetId].cash = Players[targetId].cash + amount
        
        TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
        TriggerClientEvent('money:updateMoney', targetId, Players[targetId].cash, Players[targetId].bank)
        
        TriggerEvent('money:log', src, "TRANSFER", "Oyuncu ID: " .. targetId, amount, Players[src].cash)
        TriggerEvent('money:log', targetId, "TRANSFER", "Oyuncu ID: " .. src, amount, Players[targetId].cash)
    end
end)

-- Banka transferi (hesaplar arasi)
RegisterNetEvent('money:transferBank')
AddEventHandler('money:transferBank', function(targetId, amount)
    local src = source
    if not Players[src] or not Players[targetId] then return end

    amount = tonumber(amount) or 0
    if amount > 0 and Players[src].bank >= amount then
        Players[src].bank = Players[src].bank - amount
        Players[targetId].bank = Players[targetId].bank + amount

        TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
        TriggerClientEvent('money:updateMoney', targetId, Players[targetId].cash, Players[targetId].bank)

        TriggerEvent('money:log', src, "BANK_TRANSFER", "Oyuncu ID: " .. targetId, amount, Players[src].bank)
        TriggerEvent('money:log', targetId, "BANK_TRANSFER", "Oyuncu ID: " .. src, amount, Players[targetId].bank)
    end
end)

-- Banka Para Çıkarma (TELEFON İÇİN)
RegisterNetEvent('money:removeBank')
AddEventHandler('money:removeBank', function(amount, callback)
    local src = source
    if not Players[src] then return end
    
    amount = tonumber(amount) or 0
    if amount > 0 and Players[src].bank >= amount then
        Players[src].bank = Players[src].bank - amount
        TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
        TriggerEvent('money:log', src, "TELEFON", "Telefon bakiye yükledi", amount, Players[src].bank)
        
        if callback then
            callback(true)
        end
    else
        if callback then
            callback(false)
        end
    end
end)

-- Banka Paraları Sorgula
RegisterNetEvent('money:getMoney')
AddEventHandler('money:getMoney', function()
    local src = source
    if Players[src] then
        TriggerClientEvent('money:updateMoney', src, Players[src].cash, Players[src].bank)
    end
end)

-- Para Loğu
RegisterNetEvent('money:log')
AddEventHandler('money:log', function(src, source_type, action, amount, balance)
    print(("^2[Para Sistemi]^7 | Oyuncu: %s | Tip: %s | İşlem: %s | Tutar: $%s | Bakiye: $%s"):format(
        src, source_type, action, amount or 0, balance or 0
    ))
end)

-- Zorla banka kredisi (server tarafından başka modüller için)
RegisterNetEvent('money:forceAddBank')
AddEventHandler('money:forceAddBank', function(targetSrc, amount)
    if not targetSrc or not Players[targetSrc] then return end
    amount = tonumber(amount) or 0
    if amount <= 0 then return end
    Players[targetSrc].bank = Players[targetSrc].bank + amount
    TriggerClientEvent('money:updateMoney', targetSrc, Players[targetSrc].cash, Players[targetSrc].bank)
    TriggerEvent('money:log', targetSrc, 'BANK', 'Force add bank', amount, Players[targetSrc].bank)
end)

-- Zorla nakit kredisi
RegisterNetEvent('money:forceAddCash')
AddEventHandler('money:forceAddCash', function(targetSrc, amount)
    if not targetSrc or not Players[targetSrc] then return end
    amount = tonumber(amount) or 0
    if amount <= 0 then return end
    Players[targetSrc].cash = Players[targetSrc].cash + amount
    TriggerClientEvent('money:updateMoney', targetSrc, Players[targetSrc].cash, Players[targetSrc].bank)
    TriggerEvent('money:log', targetSrc, 'CASH', 'Force add cash', amount, Players[targetSrc].cash)
end)

-- Oyuncu Ayrılmıştır
AddEventHandler('playerDropped', function()
    local src = source
    if Players[src] then
        print(("^1[Para Sistemi]^7 | Oyuncu %s çıktı. Veriler kaydedildi."):format(src))
        Players[src] = nil
    end
end)
