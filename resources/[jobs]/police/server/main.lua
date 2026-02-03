-- Polis Server
local OnDuty = {}

RegisterNetEvent('police:startDuty')
AddEventHandler('police:startDuty', function()
    local src = source
    OnDuty[src] = true
    TriggerEvent('job:setJob', 'polis')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'POLİS', 'Nöbete başladınız. Araç almak için /arac yaz'}
    })
    print(("^1[POLİS]^7 Oyuncu %d nöbete başladı"):format(src))
end)

RegisterNetEvent('police:endDuty')
AddEventHandler('police:endDuty', function()
    local src = source
    OnDuty[src] = nil
    TriggerEvent('job:quitJob')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'POLİS', 'Nöbetten ayrıldınız'}
    })
end)

RegisterNetEvent('police:giveFine')
AddEventHandler('police:giveFine', function(targetId, amount, reason)
    local src = source
    targetId = tonumber(targetId)
    amount = tonumber(amount) or 0
    
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'POLİS', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- Para sistemi: ceza tutar
    TriggerEvent('money:add', amount, 'police_fine')
    TriggerClientEvent('chat:addMessage', targetId, {
        args = {'CEZA', 'Polis tarafından $' .. amount .. ' ceza kesildi: ' .. tostring(reason)}
    })

    -- Add to criminal records
    local targetIdent = GetPlayerIdentifiers(targetId)[1]
    if targetIdent then
        local rec = { type = 'fine', amount = amount, reason = tostring(reason), issuer = GetPlayerIdentifiers(src)[1], timestamp = os.time() }
        Records[targetIdent] = Records[targetIdent] or {}
        table.insert(Records[targetIdent], rec)
        saveRecords()
    end
    
    print(("^1[POLİS]^7 %d oyuncu %d oyuncuya $%d ceza kesti"):format(src, targetId, amount))
end)

-- Records persistence and APIs
local recordsFile = 'resources/[jobs]/police/data/records.json'
local Records = {}

local function loadRecords()
    local f = io.open(recordsFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then Records = decoded end
    else
        Records = {}
    end
end

local function saveRecords()
    local encoded = json and json.encode(Records) or '{}'
    local f = io.open(recordsFile, 'w')
    if f then f:write(encoded); f:close(); end
end

loadRecords()

-- Scan fingerprint of a target player (requires active character info)
RegisterNetEvent('police:scanFingerprint')
AddEventHandler('police:scanFingerprint', function(targetId)
    local src = source
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, { args = {'POLİS', 'Nöbete başlamalısınız'} })
        return
    end
    targetId = tonumber(targetId)
    if not targetId then return end

    TriggerEvent('character:queryFingerprint', targetId, function(info)
        if info then
            -- Return scan result to police
            TriggerClientEvent('police:scanResult', src, { name = info.name, fingerprint = info.fingerprint, identifier = info.identifier })
        else
            TriggerClientEvent('police:scanResult', src, nil)
        end
    end)
end)

-- Find character by fingerprint
RegisterNetEvent('police:findByFingerprint')
AddEventHandler('police:findByFingerprint', function(fp)
    local src = source
    local found = nil
    -- brute-force search through characters file
    local path = ('resources/[characters]/character_system/data/characters.json')
    local f = io.open(path, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, data = pcall(function() return json.decode(content) end)
        if ok and data then
            for ident, list in pairs(data) do
                for _, ch in ipairs(list) do
                    if ch.fingerprint and tostring(ch.fingerprint) == tostring(fp) then
                        found = { identifier = ident, name = ch.name, fingerprint = ch.fingerprint }
                        break
                    end
                end
                if found then break end
            end
        end
    end
    TriggerClientEvent('police:findResult', src, found)
end)

-- Add arbitrary record to player (by player id)
RegisterNetEvent('police:addRecord')
AddEventHandler('police:addRecord', function(targetId, recType, note)
    local src = source
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, { args = {'POLİS', 'Nöbete başlamalısınız'} })
        return
    end
    targetId = tonumber(targetId)
    if not targetId then return end
    local ident = GetPlayerIdentifiers(targetId)[1]
    if not ident then return end
    Records[ident] = Records[ident] or {}
    table.insert(Records[ident], { type = tostring(recType or 'note'), note = tostring(note or ''), issuer = GetPlayerIdentifiers(src)[1], timestamp = os.time() })
    saveRecords()
    TriggerClientEvent('chat:addMessage', src, { args = {'POLİS', 'Kayıt eklendi.'} })
end)

RegisterNetEvent('police:getRecords')
AddEventHandler('police:getRecords', function(targetId)
    local src = source
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, { args = {'POLİS', 'Nöbete başlamalısınız'} })
        return
    end
    targetId = tonumber(targetId)
    if not targetId then return end
    local ident = GetPlayerIdentifiers(targetId)[1]
    if not ident then return end
    local recs = Records[ident] or {}
    TriggerClientEvent('police:showRecords', src, recs)
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnDuty[src] = nil
end)

print("^1[POLİS]^7 Sunucu başlatıldı")
