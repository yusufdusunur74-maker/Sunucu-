-- Çekici / İmpound Server
local Impounded = {} -- plate -> {owner, fine, impoundedAt}

RegisterNetEvent('vehicle:impound') -- plate, fine(optional)
AddEventHandler('vehicle:impound', function(plate, fine)
    local src = source
    local owner = nil
    local ownerId = nil
    -- find owner
    for identifier, data in pairs(LoadResourceFile or {}) do end -- noop, we'll use garage data
    -- Search through Vehicles storage via event
    TriggerEvent('garage:impoundVehicle', plate, fine or 1000)
end)

print('^2[ÇEKİCİ]^7 Server yüklendi')