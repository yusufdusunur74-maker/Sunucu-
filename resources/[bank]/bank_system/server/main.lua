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

-- Persistence files
local transactionsFile = "resources/[bank]/bank_system/data/transactions.json"
local pendingFile = "resources/[bank]/bank_system/data/pending_transfers.json"
local billsFile = "resources/[bank]/bank_system/data/bills.json"
local PendingTransfers = {}
local Bills = {}

local function saveTransactions()
    local encoded = json and json.encode(BankTransactions) or '[]'
    local f = io.open(transactionsFile, 'w')
    if f then f:write(encoded); f:close(); end
end

local function loadTransactions()
    local f = io.open(transactionsFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then BankTransactions = decoded end
    else
        BankTransactions = {}
    end
end

local function savePending()
    local encoded = json and json.encode(PendingTransfers) or '[]'
    local f = io.open(pendingFile, 'w')
    if f then f:write(encoded); f:close(); end
end

local function loadPending()
    local f = io.open(pendingFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then PendingTransfers = decoded end
    else
        PendingTransfers = {}
    end
end

local function saveBills()
    local encoded = json and json.encode(Bills) or '[]'
    local f = io.open(billsFile, 'w')
    if f then f:write(encoded); f:close(); end
end

local function loadBills()
    local f = io.open(billsFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then Bills = decoded end
    else
        Bills = {}
    end
end

-- Load persisted data
loadTransactions()
loadPending()
loadBills()

local function getIdentifierFromSrc(src)
    local idents = GetPlayerIdentifiers(src)
    return idents and idents[1] or nil
end

local function deliverPendingForIdentifier(identifier, targetSrc)
    local delivered = false
    for i = #PendingTransfers, 1, -1 do
        local p = PendingTransfers[i]
        if p.toIdentifier == identifier then
            -- credit bank to targetSrc
            TriggerEvent('money:forceAddBank', targetSrc, p.amount)
            table.insert(BankTransactions, {
                type = 'transfer_iban_delivered',
                fromIban = p.fromIban,
                to = targetSrc,
                amount = p.amount,
                timestamp = os.time()
            })
            table.remove(PendingTransfers, i)
            delivered = true
        end
    end
    if delivered then
        savePending()
        saveTransactions()
        TriggerClientEvent('bank:notification', targetSrc, '✅', 'Bekleyen transferler hesabınıza eklendi.')
    end
end

-- Modify transferToIban: if target offline, queue pending
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

    -- find online player
    local targetPlayer = nil
    local targetIdentifier = nil
    for _, pid in ipairs(GetPlayers()) do
        local pidNum = tonumber(pid)
        if pidNum then
            local idents = GetPlayerIdentifiers(pidNum)
            if idents and idents[1] == targetIdStr then
                targetPlayer = pidNum
                targetIdentifier = idents[1]
                break
            end
        end
    end

    if not targetPlayer then
        -- queue pending transfer
        table.insert(PendingTransfers, {
            toIdentifier = targetIdStr,
            fromIdentifier = GetPlayerIdentifiers(src)[1],
            fromIban = Accounts[GetPlayerIdentifiers(src)[1]] and Accounts[GetPlayerIdentifiers(src)[1]].iban or 'UNKNOWN',
            amount = amount,
            timestamp = os.time()
        })
        savePending()
        table.insert(BankTransactions, {
            type = 'transfer_iban_queued',
            from = src,
            iban_to = iban,
            amount = amount,
            timestamp = os.time()
        })
        saveTransactions()
        TriggerClientEvent('bank:notification', src, '✅', 'Hedef çevrimdışı. Transfer kuyruğa alındı.')
        return
    end

    -- if target online, perform bank transfer (server-to-server)
    TriggerEvent('money:transferBank', targetPlayer, amount)

    table.insert(BankTransactions, {
        type = "transfer_iban",
        from = src,
        to = targetPlayer,
        iban_to = iban,
        amount = amount,
        timestamp = os.time()
    })
    saveTransactions()

    TriggerClientEvent('bank:notification', src, 'Başarılı', iban .. " IBAN'a $" .. amount .. " gönderildi")
    TriggerClientEvent('bank:notification', targetPlayer, 'Transfer Alındı', 'IBAN üzerinden $' .. amount .. ' aldınız')
end)

-- When account ensured, deliver pending for player
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

    -- deliver pending transfers (if any)
    deliverPendingForIdentifier(id, src)
end)

-- İşlem Geçmişi (şimdi filtreli)
RegisterNetEvent('bank:getTransactions')
AddEventHandler('bank:getTransactions', function()
    local src = source
    local ident = GetPlayerIdentifiers(src)[1]
    local iban = Accounts[ident] and Accounts[ident].iban
    local results = {}
    for _, t in ipairs(BankTransactions) do
        if t.player == src or t.from == src or t.to == src or t.iban_to == iban or t.fromIban == iban or (t.from and t.to and (t.from == src or t.to == src)) then
            table.insert(results, t)
        end
    end
    TriggerClientEvent('bank:showTransactions', src, results)
end)

-- Fatura sistemi
RegisterNetEvent('bank:createBill')
AddEventHandler('bank:createBill', function(targetIdentifier, amount, description)
    local src = source
    amount = tonumber(amount) or 0
    if not targetIdentifier or amount <= 0 then
        TriggerClientEvent('bank:notification', src, 'Hata', 'Geçersiz fatura')
        return
    end
    local bill = {
        id = #Bills + 1,
        issuer = GetPlayerIdentifiers(src)[1],
        target = targetIdentifier,
        amount = amount,
        description = tostring(description or ''),
        paid = false,
        createdAt = os.date('%d/%m %H:%M')
    }
    table.insert(Bills, bill)
    saveBills()
    TriggerClientEvent('bank:notification', src, '✅', 'Fatura oluşturuldu.')
    -- notify target if online
    for _, pid in ipairs(GetPlayers()) do
        local pidNum = tonumber(pid)
        if pidNum then
            local idents = GetPlayerIdentifiers(pidNum)
            if idents and idents[1] == targetIdentifier then
                TriggerClientEvent('bank:notification', pidNum, 'FATURA', 'Yeni fatura: $' .. amount)
            end
        end
    end
end)

RegisterNetEvent('bank:getBills')
AddEventHandler('bank:getBills', function()
    local src = source
    local ident = GetPlayerIdentifiers(src)[1]
    local myBills = {}
    for _, b in ipairs(Bills) do
        if b.target == ident then table.insert(myBills, b) end
    end
    TriggerClientEvent('bank:showBills', src, myBills)
end)

RegisterNetEvent('bank:payBill')
AddEventHandler('bank:payBill', function(billId)
    local src = source
    local id = tonumber(billId)
    if not id then return end
    for i, b in ipairs(Bills) do
        if b.id == id and not b.paid then
            -- try withdraw from payer's bank
            TriggerEvent('money:removeBank', b.amount, function(success)
                if not success then
                    TriggerClientEvent('bank:notification', src, 'Hata', 'Bakiye yetersiz')
                    return
                end
                b.paid = true
                b.paidAt = os.date('%d/%m %H:%M')
                saveBills()
                -- credit issuer if online
                for _, pid in ipairs(GetPlayers()) do
                    local pidNum = tonumber(pid)
                    if pidNum then
                        local idents = GetPlayerIdentifiers(pidNum)
                        if idents and idents[1] == b.issuer then
                            TriggerEvent('money:forceAddBank', pidNum, b.amount)
                            TriggerClientEvent('bank:notification', pidNum, '💰', 'Fatura ödendi: $' .. b.amount)
                            break
                        end
                    end
                end
                TriggerClientEvent('bank:notification', src, '✅', 'Fatura ödendi: $' .. b.amount)
            end)
            return
        end
    end
    TriggerClientEvent('bank:notification', src, 'Hata', 'Fatura bulunamadı veya zaten ödenmiş')
end)

-- Banka Para Sorgusu
RegisterNetEvent('bank:checkBalance')
AddEventHandler('bank:checkBalance', function()
    local src = source
    TriggerEvent('money:getMoney')
end)
