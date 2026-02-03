-- Para Sistemi Client Script
local playerCash = 0
local playerBank = 0

RegisterNetEvent('money:updateMoney')
AddEventHandler('money:updateMoney', function(cash, bank)
    playerCash = cash
    playerBank = bank
    print(("Nakit: $%s | Banka: $%s"):format(playerCash, playerBank))
end)

-- Para İşlemleri Komutları
TriggerServerEvent('money:initialize')

-- Nakit Verme Komutu (Admin)
RegisterCommand('givecash', function(source, args)
    if args[1] and args[2] then
        TriggerServerEvent('money:add', tonumber(args[2]), "Admin Komutu")
    end
end)

-- Banka Parası Verme Komutu (Admin)
RegisterCommand('givebank', function(source, args)
    if args[1] and args[2] then
        TriggerServerEvent('money:addBank', tonumber(args[2]))
    end
end)

-- Para Sorgula
RegisterCommand('paranı', function(source, args)
    print(("Nakit: $%s | Banka: $%s"):format(playerCash, playerBank))
end)
