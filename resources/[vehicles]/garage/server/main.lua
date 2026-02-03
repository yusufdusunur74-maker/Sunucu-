-- Garaj Server (Araç Depolama & Yönetim)
local PlayerGarages = {}  -- {playerId -> {vehicles list}}

-- Oyuncu garajını yükle/oluştur
RegisterNetEvent('garage:loadGarage')
AddEventHandler('garage:loadGarage', function()
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    
    if not PlayerGarages[id] then
        PlayerGarages[id] = {
            vehicles = {}
        }
    end
    
    TriggerClientEvent('garage:showVehicles', src, PlayerGarages[id].vehicles)
    print(("^3[GARAJ]^7 Oyuncu %d garajını yükledi"):format(src))
end)

-- Araç sakla
RegisterNetEvent('garage:storeVehicle')
AddEventHandler('garage:storeVehicle', function(plate)
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    
    if not PlayerGarages[id] then return end
    
    table.insert(PlayerGarages[id].vehicles, {plate = plate, model = "stored"})
    TriggerClientEvent('chat:addMessage', src, {
        args = {'GARAJ', '✅ Araç garajda saklandı'}
    })
    
    print(("^3[GARAJ]^7 Oyuncu %d araç (%s) sakladı"):format(src, plate))
end)

-- Araç çıkar
RegisterNetEvent('garage:spawnVehicle')
AddEventHandler('garage:spawnVehicle', function(plate, index)
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    
    if not PlayerGarages[id] or not PlayerGarages[id].vehicles[index] then return end
    
    -- Araç çıkar
    table.remove(PlayerGarages[id].vehicles, index)
    TriggerClientEvent('garage:spawnCar', src, plate)
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'GARAJ', '✅ Araç çıkartıldı'}
    })
end)

AddEventHandler('playerDropped', function()
    local src = source
    -- Veriler JSON'a kaydedilecek (ileri geliştirme)
end)

print("^3[GARAJ]^7 Server başlatıldı")
