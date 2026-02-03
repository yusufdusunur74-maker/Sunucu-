-- Banka Server Script
local BankTransactions = {}

-- Para Yatırma
RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    amount = tonumber(amount) or 0
    
    if amount > 0 then
        TriggerEvent('money:addBank', amount)
        
        table.insert(BankTransactions, {
            type = "deposit",
            player = src,
            amount = amount,
            timestamp = os.time()
        })
        
        TriggerClientEvent('bank:notification', src, "Başarılı", "Bankaya $" .. amount .. " yatırıldı")
        print(("^2[Banka]^7 | Oyuncu %d %s$ yatırdı"):format(src, amount))
    end
end)

-- Para Çekme
RegisterNetEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    amount = tonumber(amount) or 0
    
    if amount > 0 then
        TriggerEvent('money:removeBank', amount)
        
        table.insert(BankTransactions, {
            type = "withdraw",
            player = src,
            amount = amount,
            timestamp = os.time()
        })
        
        TriggerClientEvent('bank:notification', src, "Başarılı", "Bankadan $" .. amount .. " çekildi")
        print(("^2[Banka]^7 | Oyuncu %d %s$ çekti"):format(src, amount))
    end
end)

-- Para Transfer
RegisterNetEvent('bank:transferMoney')
AddEventHandler('bank:transferMoney', function(targetId, amount)
    local src = source
    amount = tonumber(amount) or 0
    targetId = tonumber(targetId) or 0
    
    if amount > 0 and targetId > 0 then
        TriggerEvent('money:transfer', targetId, amount)
        
        table.insert(BankTransactions, {
            type = "transfer",
            from = src,
            to = targetId,
            amount = amount,
            timestamp = os.time()
        })
        
        TriggerClientEvent('bank:notification', src, "Başarılı", targetId .. " numaralı oyuncuya $" .. amount .. " transfer edildi")
        TriggerClientEvent('bank:notification', targetId, "Transfer Alındı", "Oyuncu ID " .. src .. "'den $" .. amount .. " aldınız")
        print(("^2[Banka]^7 | Oyuncu %d -> %d : $%s transfer"):format(src, targetId, amount))
    end
end)

-- İşlem Geçmişi
RegisterNetEvent('bank:getTransactions')
AddEventHandler('bank:getTransactions', function()
    local src = source
    TriggerClientEvent('bank:showTransactions', src, BankTransactions)
end)

-- Banka Para Sorgusu
RegisterNetEvent('bank:checkBalance')
AddEventHandler('bank:checkBalance', function()
    local src = source
    TriggerEvent('money:getMoney')
end)
