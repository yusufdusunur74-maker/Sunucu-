-- Telefon Client
local phoneOpen = false
local playerPhone = nil

RegisterCommand('phone', function()
    if phoneOpen then
        ClosePhone()
    else
        OpenPhone()
    end
end)

function OpenPhone()
    phoneOpen = true
    TriggerServerEvent('phone:initialize')

    -- Para bilgilerini al (money sistemi doğrudan sunucuya istek atılıyor)
    TriggerServerEvent('money:getMoney')

    -- Biraz bekle ve UI aç
    Wait(100)
    SendNuiMessage(json.encode({type = "openPhone"}))
    SetNuiFocus(true, true)
end

function ClosePhone()
    phoneOpen = false
    SendNuiMessage(json.encode({type = "closePhone"}))
    SetNuiFocus(false, false)
end

-- Telefon Verileri Güncelle
RegisterNetEvent('phone:updatePhone')
AddEventHandler('phone:updatePhone', function(phoneData)
    playerPhone = phoneData
    SendNuiMessage(json.encode({
        type = "updatePhone",
        phoneNumber = phoneData.phoneNumber,
        bankAccount = phoneData.bankAccount,
        contacts = phoneData.contacts,
        messages = phoneData.messages,
        carrier = "TurkCell"
    }))
    
    print(("Telefon Numarası: %s | Hesap: %s"):format(phoneData.phoneNumber, phoneData.bankAccount))
end)

-- Kişiler Güncelle
RegisterNetEvent('phone:updateContacts')
AddEventHandler('phone:updateContacts', function(contacts)
    SendNuiMessage(json.encode({
        type = "updateContacts",
        contacts = contacts
    }))
end)

-- Mesajları Güncelle
RegisterNetEvent('phone:updateMessages')
AddEventHandler('phone:updateMessages', function(messages)
    SendNuiMessage(json.encode({ type = 'updateMessages', messages = messages }))
end)

RegisterNetEvent('phone:updateMoneyInfo')
AddEventHandler('phone:updateMoneyInfo', function(moneyInfo)
    SendNuiMessage(json.encode({
        type = "updateMoneyInfo",
        cash = moneyInfo.cash,
        bank = moneyInfo.bank,
        phoneBalance = moneyInfo.phoneBalance
    }))
    print(("^2[Telefon]^7 Hesap: $%d | Nakit: $%d | Telefon Bakiyesi: $%d"):format(moneyInfo.bank, moneyInfo.cash, moneyInfo.phoneBalance))
end)

-- money:updateMoney eventten gelen veriyi phone NUI'ye gönder
RegisterNetEvent('money:updateMoney')
AddEventHandler('money:updateMoney', function(cash, bank)
    SendNuiMessage(json.encode({ type = 'updateMoneyInfo', cash = cash, bank = bank, phoneBalance = (playerPhone and playerPhone.balance) or 0 }))
end)

-- Bildirim
RegisterNetEvent('phone:notification')
AddEventHandler('phone:notification', function(icon, message)
    SendNuiMessage(json.encode({
        type = "notification",
        icon = icon,
        message = message
    }))
    
    TriggerEvent('chat:addMessage', {
        color = {0, 150, 255},
        args = {"TELEFON", message}
    })
end)

RegisterNetEvent('phone:updateFeed')
AddEventHandler('phone:updateFeed', function(feed)
    SendNuiMessage(json.encode({ type = "updateFeed", feed = feed }))
end)

RegisterNetEvent('phone:receiveLocation')
AddEventHandler('phone:receiveLocation', function(info)
    SendNuiMessage(json.encode({ type = "receiveLocation", from = info.from, coords = info.coords }))
end)

RegisterNetEvent('marketplace:updateListings')
AddEventHandler('marketplace:updateListings', function(listings)
    SendNuiMessage(json.encode({ type = 'updateMarket', listings = listings }))
end)

RegisterNetEvent('bank:showTransactions')
AddEventHandler('bank:showTransactions', function(transactions)
    SendNuiMessage(json.encode({ type = 'updateTransactions', transactions = transactions }))
end)

RegisterNetEvent('bank:showBills')
AddEventHandler('bank:showBills', function(bills)
    SendNuiMessage(json.encode({ type = 'updateBills', bills = bills }))
end)

-- NUI Callback
RegisterNuiCallback('phoneAction', function(data, cb)
    if data.action == "close" then
        ClosePhone()
    elseif data.action == "sendSMS" then
        TriggerServerEvent('phone:sendSMS', data.number, data.message)
    elseif data.action == "addContact" then
        TriggerServerEvent('phone:addContact', data.name, data.number)
    elseif data.action == "getMessages" then
        TriggerServerEvent('phone:getMessages')
    elseif data.action == "checkBalance" then
        TriggerServerEvent('money:getMoney')
    elseif data.action == 'call' then
        TriggerServerEvent('phone:makeCall', data.number)
    elseif data.action == 'transferToIban' then
        TriggerServerEvent('bank:transferToIban', data.iban, data.amount)
    elseif data.action == 'postTweet' then
        TriggerServerEvent('phone:postTweet', data.content)
    elseif data.action == 'getFeed' then
        TriggerServerEvent('phone:getFeed')
    elseif data.action == 'shareLocation' then
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        TriggerServerEvent('phone:sendLocation', data.number, { x = x, y = y, z = z })
    elseif data.action == 'createListing' then
        TriggerServerEvent('marketplace:createListing', data.title, data.description, data.price)
    elseif data.action == 'getListings' then
        TriggerServerEvent('marketplace:getListings')
    elseif data.action == 'buyListing' then
        TriggerServerEvent('marketplace:buyListing', data.id)
    elseif data.action == 'removeListing' then
        TriggerServerEvent('marketplace:removeListing', data.id)
    elseif data.action == 'promoteListing' then
        TriggerServerEvent('marketplace:promoteListing', data.id, data.fee)
    elseif data.action == 'getTransactions' then
        TriggerServerEvent('bank:getTransactions')
    elseif data.action == 'getBills' then
        TriggerServerEvent('bank:getBills')
    elseif data.action == 'payBill' then
        TriggerServerEvent('bank:payBill', data.id)
    end
    cb('ok')
end)

-- ESC tuşu ile telefonu kapat

-- ESC tuşu ile telefonu kapat
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if phoneOpen and IsControlJustReleased(0, 322) then -- ESC
            ClosePhone()
        end
    end
end)

print("^2[Telefon Client]^7 Yüklendi")
