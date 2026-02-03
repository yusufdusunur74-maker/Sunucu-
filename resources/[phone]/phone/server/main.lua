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

-- Tweets feed
local Tweets = {}

RegisterNetEvent('phone:postTweet')
AddEventHandler('phone:postTweet', function(content)
    local src = source
    if not PlayerPhones[src] then return end
    local sender = PlayerPhones[src].phoneNumber
    local tweet = {
        id = #Tweets + 1,
        from = sender,
        content = content,
        timestamp = os.date("%d/%m %H:%M")
    }
    table.insert(Tweets, 1, tweet) -- newest first
    -- Broadcast updated feed to all players
    for targetSrc, _ in pairs(PlayerPhones) do
        TriggerClientEvent('phone:updateFeed', targetSrc, Tweets)
    end
    print(("^2[Tweet]^7 %s: %s"):format(sender, content))
end)

RegisterNetEvent('phone:getFeed')
AddEventHandler('phone:getFeed', function()
    local src = source
    if PlayerPhones[src] then
        TriggerClientEvent('phone:updateFeed', src, Tweets)
    end
end)

RegisterNetEvent('phone:sendLocation')
AddEventHandler('phone:sendLocation', function(targetNumber, coords)
    local src = source
    if not PlayerPhones[src] then return end
    local sender = PlayerPhones[src].phoneNumber
    for targetSrc, phoneData in pairs(PlayerPhones) do
        if phoneData.phoneNumber == targetNumber then
            TriggerClientEvent('phone:receiveLocation', targetSrc, { from = sender, coords = coords })
            TriggerClientEvent('phone:notification', src, "📍", "Konum gönderildi: " .. targetNumber)
            print(("^2[Konum]^7 %s -> %s: %s,%s,%s"):format(sender, targetNumber, coords.x, coords.y, coords.z))
            return
        end
    end
    TriggerClientEvent('phone:notification', src, "📍", "Hedef numara bulunamadı.")
end)

-- Sahibinden (Marketplace)
local Marketplace = {}
local NextListingId = 1

RegisterNetEvent('marketplace:createListing')
AddEventHandler('marketplace:createListing', function(title, description, price)
    local src = source
    if not PlayerPhones[src] then return end
    price = tonumber(price) or 0
    if price <= 0 then
        TriggerClientEvent('phone:notification', src, '❌', 'Geçersiz fiyat.')
        return
    end

    local listing = {
        id = NextListingId,
        owner = src,
        ownerNumber = PlayerPhones[src].phoneNumber,
        title = tostring(title),
        description = tostring(description or ''),
        price = price,
        createdAt = os.date('%d/%m %H:%M'),
        promoted = false
    }
    NextListingId = NextListingId + 1
    table.insert(Marketplace, 1, listing)

    -- Update all players' market UI
    for targetSrc, _ in pairs(PlayerPhones) do
        TriggerClientEvent('marketplace:updateListings', targetSrc, Marketplace)
    end

    TriggerClientEvent('phone:notification', src, '✅', 'İlan oluşturuldu.')
    print(('^2[Market]^7 İlan %d oluşturuldu: %s ($%d)'):format(listing.id, listing.title, listing.price))
end)

RegisterNetEvent('marketplace:getListings')
AddEventHandler('marketplace:getListings', function()
    local src = source
    if PlayerPhones[src] then
        TriggerClientEvent('marketplace:updateListings', src, Marketplace)
    end
end)

RegisterNetEvent('marketplace:buyListing')
AddEventHandler('marketplace:buyListing', function(listingId)
    local src = source
    if not PlayerPhones[src] then return end
    local id = tonumber(listingId)
    if not id then return end

    for i, l in ipairs(Marketplace) do
        if l.id == id then
            if l.owner == src then
                TriggerClientEvent('phone:notification', src, '⚠️', 'Kendi ilanınızı satın alamazsınız.')
                return
            end
            -- transfer cash
            TriggerEvent('money:transfer', l.owner, l.price)
            -- remove listing
            table.remove(Marketplace, i)
            TriggerClientEvent('phone:notification', src, '✅', 'Satın alındı: ' .. l.title)
            TriggerClientEvent('phone:notification', l.owner, '💰', 'İlanınız satıldı: ' .. l.title .. ' - $' .. l.price)

            for targetSrc, _ in pairs(PlayerPhones) do
                TriggerClientEvent('marketplace:updateListings', targetSrc, Marketplace)
            end
            print(('^2[Market]^7 İlan %d satıldı, alıcı: %s, satıcı: %s'):format(id, src, l.owner))
            return
        end
    end
    TriggerClientEvent('phone:notification', src, '❌', 'İlan bulunamadı veya satılmış.')
end)

RegisterNetEvent('marketplace:removeListing')
AddEventHandler('marketplace:removeListing', function(listingId)
    local src = source
    local id = tonumber(listingId)
    if not id then return end
    for i, l in ipairs(Marketplace) do
        if l.id == id then
            if l.owner ~= src then
                TriggerClientEvent('phone:notification', src, '❌', 'Bu ilanı kaldıramazsınız.')
                return
            end
            table.remove(Marketplace, i)
            for targetSrc, _ in pairs(PlayerPhones) do
                TriggerClientEvent('marketplace:updateListings', targetSrc, Marketplace)
            end
            TriggerClientEvent('phone:notification', src, '✅', 'İlan kaldırıldı.')
            return
        end
    end
end)

-- İlan tanıtımı (reklam verme) - ücret karşılığı tüm oyunculara bildirim
RegisterNetEvent('marketplace:promoteListing')
AddEventHandler('marketplace:promoteListing', function(listingId, fee)
    local src = source
    local id = tonumber(listingId)
    fee = tonumber(fee) or 0
    if not id or fee <= 0 then return end

    -- try charge bank (phone/telecom style) with callback
    TriggerEvent('money:removeBank', fee, function(success)
        if not success then
            TriggerClientEvent('phone:notification', src, '❌', 'Reklam ücreti ödenemedi.')
            return
        end
        for _, l in ipairs(Marketplace) do
            if l.id == id and l.owner == src then
                l.promoted = true
                -- broadcast ad notification
                for targetSrc, _ in pairs(PlayerPhones) do
                    TriggerClientEvent('phone:notification', targetSrc, '📢', ('Reklam: %s - $%d'):format(l.title, l.price))
                end
                TriggerClientEvent('phone:notification', src, '✅', 'İlan tanıtıldı.')
                return
            end
        end
        TriggerClientEvent('phone:notification', src, '❌', 'İlan bulunamadı.')
    end)
end)

-- Oyuncu Ayrıldı
AddEventHandler('playerDropped', function()
    local src = source
    PlayerPhones[src] = nil
end)

print("^2[Telefon Sistemi]^7 Sunucu başlatıldı")
