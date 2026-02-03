-- Araç Kilit Server
local LockedVehicles = {}
local Keys = {} -- plate -> { owner = identifier, shared = { [identifier]=true } }
local keysFile = "resources/[vehicles]/locks/data/keys.json"

local function saveKeys()
    local encoded = json and json.encode(Keys) or '{}'
    local f = io.open(keysFile, 'w')
    if f then f:write(encoded); f:close() end
end

local function loadKeys()
    local f = io.open(keysFile, 'r')
    if f then
        local content = f:read('*a'); f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then Keys = decoded end
    else Keys = {} end
end

loadKeys()

local function hasKey(identifier, plate)
    if not Keys[plate] then return false end
    if Keys[plate].owner == identifier then return true end
    if Keys[plate].shared and Keys[plate].shared[identifier] then return true end
    return false
end

RegisterNetEvent('vehicle:giveKey')
AddEventHandler('vehicle:giveKey', function(plate, targetIdentifier)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    if not Keys[plate] then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Bu plakaya ait anahtar kaydı yok"}})
        return
    end
    if Keys[plate].owner ~= identifier then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Sadece araç sahibi anahtar verebilir"}})
        return
    end
    Keys[plate].shared = Keys[plate].shared or {}
    Keys[plate].shared[targetIdentifier] = true
    saveKeys()
    TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"KILIT","Anahtar verildi"}})
end)

RegisterNetEvent('vehicle:removeKey')
AddEventHandler('vehicle:removeKey', function(plate, targetIdentifier)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    if not Keys[plate] then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Bu plakaya ait anahtar kaydı yok"}})
        return
    end
    if Keys[plate].owner ~= identifier then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Sadece araç sahibi anahtar kaldırabilir"}})
        return
    end
    if Keys[plate].shared then Keys[plate].shared[targetIdentifier] = nil end
    saveKeys()
    TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"KILIT","Anahtar kaldırıldı"}})
end)

RegisterNetEvent('locks:toggleLock')
AddEventHandler('locks:toggleLock', function(plate)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    if not hasKey(identifier, plate) then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Bu aracı kilitleme/açma yetkiniz yok"}})
        return
    end
    LockedVehicles[plate] = not LockedVehicles[plate]
    if LockedVehicles[plate] then
        TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"ARAÇ","Araç kilitlendi"}})
    else
        TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"ARAÇ","Araç açıldı"}})
    end
    TriggerClientEvent('locks:updateLock', -1, plate, LockedVehicles[plate])
    print(("^2[Kilit]^7 Araç %s - %s"):format(plate, LockedVehicles[plate] and "Kilitli" or "Açık"))
end)

RegisterNetEvent('vehicle:registerOwnership')
AddEventHandler('vehicle:registerOwnership', function(plate)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    Keys[plate] = Keys[plate] or { owner = identifier, shared = {} }
    saveKeys()
    TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"KILIT","Araç sahibi kaydedildi"}})
    print(("^2[Kilit]^7 %s aracı sahibi %s olarak kaydedildi"):format(plate, identifier))
end)

-- Give key using target server id (convenience wrapper)
RegisterNetEvent('vehicle:giveKeyToPlayer')
AddEventHandler('vehicle:giveKeyToPlayer', function(plate, targetServerId)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local target = tonumber(targetServerId)
    if not target then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Hedef oyuncu ID geçerli değil"}})
        return
    end
    local ids = GetPlayerIdentifiers(target)
    if not ids or not ids[1] then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Hedef oyuncu bulunamadı"}})
        return
    end
    local targetIdentifier = ids[1]

    if not Keys[plate] then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Bu plakaya ait anahtar kaydı yok"}})
        return
    end
    if Keys[plate].owner ~= identifier then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Sadece araç sahibi anahtar verebilir"}})
        return
    end

    Keys[plate].shared = Keys[plate].shared or {}
    Keys[plate].shared[targetIdentifier] = true
    saveKeys()

    TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"KILIT","Anahtar verildi"}})
    TriggerClientEvent('chat:addMessage', target, { color={0,255,0}, args={"KILIT","Bir araç için anahtar aldınız: " .. plate}})
end)

-- Remove key using target server id
RegisterNetEvent('vehicle:removeKeyFromPlayer')
AddEventHandler('vehicle:removeKeyFromPlayer', function(plate, targetServerId)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local target = tonumber(targetServerId)
    if not target then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Hedef oyuncu ID geçerli değil"}})
        return
    end
    local ids = GetPlayerIdentifiers(target)
    if not ids or not ids[1] then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Hedef oyuncu bulunamadı"}})
        return
    end
    local targetIdentifier = ids[1]

    if not Keys[plate] then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Bu plakaya ait anahtar kaydı yok"}})
        return
    end
    if Keys[plate].owner ~= identifier then
        TriggerClientEvent('chat:addMessage', src, { color={255,0,0}, args={"KILIT","Sadece araç sahibi anahtar kaldırabilir"}})
        return
    end

    if Keys[plate].shared then Keys[plate].shared[targetIdentifier] = nil end
    saveKeys()

    TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"KILIT","Anahtar kaldırıldı"}})
    TriggerClientEvent('chat:addMessage', target, { color={255,0,0}, args={"KILIT","Bir araç için anahtarınız alındı: " .. plate}})
end)

-- Get key info (owner + shared identifiers) - returned to requester
RegisterNetEvent('vehicle:getKeyInfo')
AddEventHandler('vehicle:getKeyInfo', function(plate)
    local src = source
    local info = { owner = nil, shared = {} }
    if Keys[plate] then
        info.owner = Keys[plate].owner
        if Keys[plate].shared then
            for k,_ in pairs(Keys[plate].shared) do table.insert(info.shared, k) end
        end
    end
    TriggerClientEvent('vehicle:keysInfo', src, plate, info)
end)

print("^2[Araç Kilit Sistemi]^7 Yüklendi")
