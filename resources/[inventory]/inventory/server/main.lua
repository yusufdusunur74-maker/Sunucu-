-- Envanter Server
local PlayerInventory = {}

-- Stash ve Trunk verisi
local Stashes = {}
local TrunkStorage = {}
local trunkDataFile = "resources/[inventory]/inventory/data/trunks.json"

-- Araç sahipliği (plate -> owner identifier)
local VehicleOwners = {}
local trunkOwnersFile = "resources/[inventory]/inventory/data/trunk_owners.json"

local function saveTrunkData()
    local encoded = json and json.encode(TrunkStorage) or '{}'
    local f = io.open(trunkDataFile, 'w')
    if f then
        f:write(encoded)
        f:close()
    end
end

local function loadTrunkData()
    local f = io.open(trunkDataFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then TrunkStorage = decoded end
    else
        TrunkStorage = {}
    end
end

local function saveTrunkOwners()
    local encoded = json and json.encode(VehicleOwners) or '{}'
    local f = io.open(trunkOwnersFile, 'w')
    if f then
        f:write(encoded)
        f:close()
    end
end

local function loadTrunkOwners()
    local f = io.open(trunkOwnersFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then VehicleOwners = decoded end
    else
        VehicleOwners = {}
    end
end

-- yükleme
loadTrunkData()
loadTrunkOwners()
-- Envanter Başlat
RegisterNetEvent('inventory:initialize')
AddEventHandler('inventory:initialize', function()
    local src = source
    
    local cfg = Config or { MaxWeight = 50, Items = {} }

    if not PlayerInventory[src] then
        PlayerInventory[src] = {
            items = {},
            maxWeight = cfg.MaxWeight or 50,
            weight = 0
        }
    end

    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

-- Eşya Ekle
RegisterNetEvent('inventory:addItem')
AddEventHandler('inventory:addItem', function(itemName, count)
    local src = source
    
    if not PlayerInventory[src] then return end
    local unitWeight = (Config and Config.Items and Config.Items[itemName] and Config.Items[itemName].weight) or 0.5
    local totalWeight = unitWeight * count

    if PlayerInventory[src].weight + totalWeight > PlayerInventory[src].maxWeight then
        TriggerClientEvent('inventory:notify', src, 'Envanter dolu. Daha fazla eşya eklenemez.')
        return
    end

    local item = {name = itemName, count = count, weight = unitWeight}
    table.insert(PlayerInventory[src].items, item)
    PlayerInventory[src].weight = PlayerInventory[src].weight + totalWeight

    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
    print(("^2[Envanter]^7 Oyuncu %d, %dx %s aldı"):format(src, count, itemName))
end)

-- Eşya Kaldır
RegisterNetEvent('inventory:removeItem')
AddEventHandler('inventory:removeItem', function(itemName, count)
    local src = source
    
    if not PlayerInventory[src] then return end
    
    for i, item in ipairs(PlayerInventory[src].items) do
        if item.name == itemName and item.count >= count then
            item.count = item.count - count
            local unitW = item.weight or ((Config and Config.Items and Config.Items[itemName] and Config.Items[itemName].weight) or 0.5)
            PlayerInventory[src].weight = PlayerInventory[src].weight - (count * unitW)

            if item.count <= 0 then
                table.remove(PlayerInventory[src].items, i)
            end
            break
        end
    end
    
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

-- Basit kullanma handler'ı
RegisterNetEvent('inventory:useItem')
AddEventHandler('inventory:useItem', function(item)
    local src = source
    if not PlayerInventory[src] then return end
    for i, it in ipairs(PlayerInventory[src].items) do
        if it.name == item.name and it.count >= 1 then
            it.count = it.count - 1
            local unitW = it.weight or ((Config and Config.Items and Config.Items[item.name] and Config.Items[item.name].weight) or 0.5)
            PlayerInventory[src].weight = PlayerInventory[src].weight - unitW
            if it.count <= 0 then table.remove(PlayerInventory[src].items, i) end
            TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
            print(("[Envanter] Oyuncu %d kullandı: %s"):format(src, item.name))
            break
        end
    end
end)

-- Silah / Mermi desteği (basit)
RegisterNetEvent('inventory:addWeapon')
AddEventHandler('inventory:addWeapon', function(weaponName, ammo)
    local src = source
    if not PlayerInventory[src] then return end
    PlayerInventory[src].weapons = PlayerInventory[src].weapons or {}
    PlayerInventory[src].weapons[weaponName] = (PlayerInventory[src].weapons[weaponName] or 0) + (ammo or 0)
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

RegisterNetEvent('inventory:removeWeapon')
AddEventHandler('inventory:removeWeapon', function(weaponName)
    local src = source
    if not PlayerInventory[src] then return end
    if PlayerInventory[src].weapons then
        PlayerInventory[src].weapons[weaponName] = nil
    end
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

RegisterNetEvent('inventory:addAmmo')
AddEventHandler('inventory:addAmmo', function(weaponName, amount)
    local src = source
    if not PlayerInventory[src] then return end
    PlayerInventory[src].weapons = PlayerInventory[src].weapons or {}
    PlayerInventory[src].weapons[weaponName] = (PlayerInventory[src].weapons[weaponName] or 0) + (amount or 0)
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

RegisterNetEvent('inventory:removeAmmo')
AddEventHandler('inventory:removeAmmo', function(weaponName, amount)
    local src = source
    if not PlayerInventory[src] then return end
    if PlayerInventory[src].weapons and PlayerInventory[src].weapons[weaponName] then
        PlayerInventory[src].weapons[weaponName] = math.max(0, PlayerInventory[src].weapons[weaponName] - (amount or 0))
    end
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

-- Stash (sunucu taraflı basit depolar)
RegisterNetEvent('inventory:openStash')
AddEventHandler('inventory:openStash', function(stashId)
    local src = source
    Stashes[stashId] = Stashes[stashId] or {items = {}}
    TriggerClientEvent('inventory:openStashUI', src, Stashes[stashId])
end)

RegisterNetEvent('inventory:stashDeposit')
AddEventHandler('inventory:stashDeposit', function(stashId, itemName, count)
    local src = source
    if not PlayerInventory[src] then return end
    -- Basit: oyuncudan item çıkar ve stash'e ekle
    for i, item in ipairs(PlayerInventory[src].items) do
        if item.name == itemName and item.count >= count then
            item.count = item.count - count
            local unitW = item.weight or ((Config and Config.Items and Config.Items[itemName] and Config.Items[itemName].weight) or 0.5)
            if item.count <= 0 then table.remove(PlayerInventory[src].items, i) end
            Stashes[stashId] = Stashes[stashId] or {items = {}}
            table.insert(Stashes[stashId].items, {name = itemName, count = count, weight = unitW})
            PlayerInventory[src].weight = PlayerInventory[src].weight - (count * unitW)
            break
        end
    end
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

RegisterNetEvent('inventory:stashWithdraw')
AddEventHandler('inventory:stashWithdraw', function(stashId, itemName, count)
    local src = source
    Stashes[stashId] = Stashes[stashId] or {items = {}}
    for i, item in ipairs(Stashes[stashId].items) do
        if item.name == itemName and item.count >= count then
            local unitW = item.weight or ((Config and Config.Items and Config.Items[itemName] and Config.Items[itemName].weight) or 0.5)
            local totalW = unitW * count
            if PlayerInventory[src].weight + totalW > PlayerInventory[src].maxWeight then
                TriggerClientEvent('inventory:notify', src, 'Envanter dolu. Eşya alınamadı.')
                return
            end

            item.count = item.count - count
            if item.count <= 0 then table.remove(Stashes[stashId].items, i) end
            -- oyuncuya ekle
            table.insert(PlayerInventory[src].items, {name = itemName, count = count, weight = unitW})
            PlayerInventory[src].weight = PlayerInventory[src].weight + totalW
            break
        end
    end
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
    TriggerClientEvent('inventory:refreshStashUI', src, Stashes[stashId])
end)

-- Trunk (araç bagajı) basit implementasyon
RegisterNetEvent('inventory:openTrunk')
AddEventHandler('inventory:openTrunk', function(plate)
    local src = source
    loadTrunkData()
    TrunkStorage[plate] = TrunkStorage[plate] or {items = {}}
    TriggerClientEvent('inventory:openTrunkUI', src, TrunkStorage[plate])
end)

RegisterNetEvent('inventory:trunkDeposit')
AddEventHandler('inventory:trunkDeposit', function(plate, itemName, count)
    local src = source
    if not PlayerInventory[src] then return end
    for i, item in ipairs(PlayerInventory[src].items) do
        if item.name == itemName and item.count >= count then
            local unitW = item.weight or ((Config and Config.Items and Config.Items[itemName] and Config.Items[itemName].weight) or 0.5)
            item.count = item.count - count
            if item.count <= 0 then table.remove(PlayerInventory[src].items, i) end
            TrunkStorage[plate] = TrunkStorage[plate] or {items = {}}
            table.insert(TrunkStorage[plate].items, {name = itemName, count = count, weight = unitW})
            PlayerInventory[src].weight = PlayerInventory[src].weight - (count * unitW)
            saveTrunkData()
            break
        end
    end
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

RegisterNetEvent('inventory:trunkWithdraw')
AddEventHandler('inventory:trunkWithdraw', function(plate, itemName, count)
    local src = source
    TrunkStorage[plate] = TrunkStorage[plate] or {items = {}}
    for i, item in ipairs(TrunkStorage[plate].items) do
        if item.name == itemName and item.count >= count then
            local unitW = item.weight or ((Config and Config.Items and Config.Items[itemName] and Config.Items[itemName].weight) or 0.5)
            local totalW = unitW * count
            if PlayerInventory[src].weight + totalW > PlayerInventory[src].maxWeight then
                TriggerClientEvent('inventory:notify', src, 'Envanter dolu. Eşya alınamadı.')
                return
            end

            item.count = item.count - count
            if item.count <= 0 then table.remove(TrunkStorage[plate].items, i) end
            table.insert(PlayerInventory[src].items, {name = itemName, count = count, weight = unitW})
            PlayerInventory[src].weight = PlayerInventory[src].weight + totalW
            saveTrunkData()
            break
        end
    end
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)
-- Oyuncu Ayrıldı
AddEventHandler('playerDropped', function()
    local src = source
    PlayerInventory[src] = nil
end)

print("^2[Envanter Sistemi]^7 Yüklendi")
