-- Banka Server Script
local BankTransactions = {}
local Accounts = {}
local accountsFile = "resources/[bank]/bank_system/data/accounts.json"

local function saveAccounts()
    local encoded = json and json.encode(Accounts) or '{}'
    local f = io.open(accountsFile, 'w')
    if f then f:write(encoded); f:close(); end
end

local function loadAccounts()
    local f = io.open(accountsFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then Accounts = decoded end
    else
        Accounts = {}
    end
end

local function generateIban()
    math.randomseed(os.time() + GetGameTimer())
    local s = 'TR'
    for i=1,16 do s = s .. tostring(math.random(0,9)) end
    return s
end

loadAccounts()

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

-- IBAN / Hesap işlemleri
RegisterNetEvent('bank:ensureAccount')
AddEventHandler('bank:ensureAccount', function()
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    if not id then return end

    -- eğer zaten hesap yoksa oluştur
    if not Accounts[id] then
        local iban = generateIban()
        Accounts[id] = { iban = iban }
        Accounts[iban] = id
        saveAccounts()
    end
    local iban = Accounts[id] and Accounts[id].iban or nil
    TriggerClientEvent('bank:receiveIban', src, iban)
end)

RegisterNetEvent('bank:getIban')
AddEventHandler('bank:getIban', function()
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    if Accounts[id] and Accounts[id].iban then
        TriggerClientEvent('bank:receiveIban', src, Accounts[id].iban)
    else
        TriggerEvent('bank:ensureAccount')
    end
end)

RegisterNetEvent('bank:transferToIban')
AddEventHandler('bank:transferToIban', function(iban, amount)
    local src = source
    amount = tonumber(amount) or 0
    if not iban or amount <= 0 then
        TriggerClientEvent('bank:notification', src, 'Hata', 'Geçersiz IBAN veya tutar')
        return
    end

    loadAccounts()
    local targetIdStr = Accounts[iban]
    if not targetIdStr then
        TriggerClientEvent('bank:notification', src, 'Hata', 'IBAN bulunamadı')
        return
    end

    -- hedef oyuncu çevrimiçi mi kontrol et
    local targetPlayer = nil
    for _, pid in ipairs(GetPlayers()) do
        local pidNum = tonumber(pid)
        if pidNum then
            local idents = GetPlayerIdentifiers(pidNum)
            if idents and idents[1] == targetIdStr then
                targetPlayer = pidNum
                break
            end
        end
    end

    if not targetPlayer then
        TriggerClientEvent('bank:notification', src, 'Hata', 'Hedef kullanıcı çevrimdışı. Şu an desteklenmiyor.')
        return
    end

    -- para transferi (banka): gönderenin banka bakiyesinden düş ve hedefin banka bakiyesine ekle
    TriggerEvent('money:transferBank', targetPlayer, amount)

    table.insert(BankTransactions, {
        type = "transfer_iban",
        from = src,
        to = targetPlayer,
        iban_to = iban,
        amount = amount,
        timestamp = os.time()
    })

    TriggerClientEvent('bank:notification', src, 'Başarılı', iban .. " IBAN'a $" .. amount .. " gönderildi")
    TriggerClientEvent('bank:notification', targetPlayer, 'Transfer Alındı', 'IBAN üzerinden $' .. amount .. ' aldınız')
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
