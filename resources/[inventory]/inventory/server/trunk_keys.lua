-- Trunk key commands and ownership
-- Basit: `/givekey <plate> <playerId>` komutu ile araç sahibine trunk anahtarı verilir.

RegisterCommand('givekey', function(source, args, raw)
    local src = source
    if #args < 2 then
        TriggerClientEvent('chat:addMessage', src, { args = { 'Trunk', 'Kullanım: /givekey <plate> <playerId>' } })
        return
    end
    local plate = args[1]
    local target = tonumber(args[2])
    if not target then
        TriggerClientEvent('chat:addMessage', src, { args = { 'Trunk', 'Geçersiz player id' } })
        return
    end

    VehicleOwners[plate] = VehicleOwners[plate] or {}
    VehicleOwners[plate][tostring(target)] = true
    if saveTrunkOwners then saveTrunkOwners() end

    TriggerClientEvent('chat:addMessage', src, { args = { 'Trunk', ('%s plakalı araca %d id li oyuncuya anahtar verildi'):format(plate, target) } })
    TriggerClientEvent('chat:addMessage', target, { args = { 'Trunk', ('%s plakalı araca anahtar verildi'):format(plate) } })
end, false)

-- Yetki kontrolü helper
local function hasTrunkAccess(plate, playerId)
    if not VehicleOwners[plate] then return false end
    return VehicleOwners[plate][tostring(playerId)] == true
end

-- Trunk açma event'ine yetki kontrolü ekleyelim (varsa)
AddEventHandler('inventory:openTrunk', function(plate)
    local src = source
    if hasTrunkAccess(plate, src) then
        TrunkStorage[plate] = TrunkStorage[plate] or {items = {}}
        TriggerClientEvent('inventory:openTrunkUI', src, TrunkStorage[plate])
    else
        TriggerClientEvent('inventory:notify', src, 'Bu aracın bagajına erişiminiz yok.')
    end
end)
