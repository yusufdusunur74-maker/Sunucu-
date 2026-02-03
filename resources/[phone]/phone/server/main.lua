-- Telefon Server
local PlayerPhones = {}
local Messages = {}

-- Oyuncu Telefonunu Başlat
RegisterNetEvent('phone:initialize')
AddEventHandler('phone:initialize', function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    
    if not PlayerPhones[src] then
        PlayerPhones[src] = {
            phoneNumber = "555-" .. math.random(1000, 9999),
            owner = identifier,
            contacts = PhoneConfig.contacts,
            messages = {},
            balance = 0,
            bankAccount = math.random(100000, 999999)
        }
    end
    
    TriggerClientEvent('phone:updatePhone', src, PlayerPhones[src])
    print(("^2[Telefon]^7 Oyuncu %d'ye telefon verildi: %s"):format(src, PlayerPhones[src].phoneNumber))
end)

-- Hesap Bakiyesi Güncelle
RegisterNetEvent('phone:updateBalance')
AddEventHandler('phone:updateBalance', function()
    local src = source
    if PlayerPhones[src] then
        -- Para sisteminden bakiye al
        TriggerEvent('money:getMoney')
        Wait(100)
    end
end)

-- Kişi Ekle
RegisterNetEvent('phone:addContact')
AddEventHandler('phone:addContact', function(name, number)
    local src = source
    if not PlayerPhones[src] then return end
    
    table.insert(PlayerPhones[src].contacts, {
        name = name,
        number = number,
        type = "custom"
    })
    
    TriggerClientEvent('phone:updateContacts', src, PlayerPhones[src].contacts)
    print(("^2[Telefon]^7 Oyuncu %d, %s (%s) kişisini ekledi"):format(src, name, number))
end)

-- SMS Gönder
RegisterNetEvent('phone:sendSMS')
AddEventHandler('phone:sendSMS', function(targetNumber, message)
    local src = source
    
    if not PlayerPhones[src] then return end
    
    local senderNumber = PlayerPhones[src].phoneNumber
    
    -- Alıcıyı bul
    for targetSrc, phoneData in pairs(PlayerPhones) do
        if phoneData.phoneNumber == targetNumber then
            table.insert(phoneData.messages, {
                from = senderNumber,
                sender = "Bilinmeyen",
                message = message,
                timestamp = os.date("%H:%M")
            })
            
            TriggerClientEvent('phone:notification', targetSrc, "📱", senderNumber .. " adresinden mesaj")
            break
        end
    end
    
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 150, 255},
        args = {"SMS", message .. " (" .. targetNumber .. ")"}
    })
    
    print(("^2[SMS]^7 %s -> %s: %s"):format(senderNumber, targetNumber, message))
end)


-- Arama başlatma (basit notify)
RegisterNetEvent('phone:makeCall')
AddEventHandler('phone:makeCall', function(targetNumber)
    local src = source
    if not PlayerPhones[src] then return end
    local senderNumber = PlayerPhones[src].phoneNumber

    for targetSrc, phoneData in pairs(PlayerPhones) do
        if phoneData.phoneNumber == targetNumber then
            -- Bildirim at
            TriggerClientEvent('phone:notification', targetSrc, '📞', senderNumber .. ' sizi arıyor')
            TriggerClientEvent('phone:notification', src, '📞', 'Arama başlatıldı: ' .. targetNumber)
            print(('^2[Telefon]^7 %s arıyor %s'):format(senderNumber, targetNumber))
            return
        end
    end

    -- bulunamadı
    TriggerClientEvent('phone:notification', src, '📞', 'Aranan numara çevrimdışı veya bulunamadı')
end)

-- Mesajları Getir
RegisterNetEvent('phone:getMessages')
AddEventHandler('phone:getMessages', function()
    local src = source
    if PlayerPhones[src] then
        TriggerClientEvent('phone:updateMessages', src, PlayerPhones[src].messages)
    end
end)

-- Para ve Hesap Bilgisi Al (HESABIMA YUKLE)
RegisterNetEvent('phone:getMoneyInfo')
AddEventHandler('phone:getMoneyInfo', function()
    local src = source
    
    -- Money sisteminden veri al
    TriggerEvent('money:getMoney', src, function(moneyInfo)
        if PlayerPhones[src] then
            TriggerClientEvent('phone:updateMoneyInfo', src, {
                cash = moneyInfo.cash or 0,
                bank = moneyInfo.bank or 0,
                phoneBalance = PlayerPhones[src].balance or 0
            })
        end
    end)
end)

-- Bakiye Yükle (HESABIMDAN)
RegisterNetEvent('phone:addBalance')
AddEventHandler('phone:addBalance', function(amount)
    local src = source
    if not PlayerPhones[src] then return end
    
    -- Bankadan çek
    TriggerEvent('money:removeBank', amount, function(success)
        if success then
            PlayerPhones[src].balance = PlayerPhones[src].balance + amount
            TriggerClientEvent('chat:addMessage', src, {
                color = {0, 255, 0},
                args = {"TELEFON", "Bakiye yüklendi: +$" .. amount}
            })
        else
            TriggerClientEvent('chat:addMessage', src, {
                color = {255, 0, 0},
                args = {"TELEFON", "Bakiye yetersiz!"}
            })
        end
    end)
end)

-- Oyuncu Ayrıldı
AddEventHandler('playerDropped', function()
    local src = source
    PlayerPhones[src] = nil
end)

print("^2[Telefon Sistemi]^7 Sunucu başlatıldı")
