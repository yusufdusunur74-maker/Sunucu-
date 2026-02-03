-- Galeri Client
RegisterCommand('galeri', function()
    TriggerEvent('chat:addMessage', {
        args = {'GALERİ', 'Mevcut araçlar: /araçlar'}
    })
end, false)

RegisterCommand('araçlar', function()
    local cfg = GalleryConfig or {}
    TriggerEvent('chat:addMessage', {
        args = {'GALERİ', '--- Mevcut Araçlar ---'}
    })
    
    for i, v in ipairs(cfg.vehicles or {}) do
        TriggerEvent('chat:addMessage', {
            args = {'', v.name .. ' ($' .. v.price .. ') - /satinal ' .. i}
        })
    end
end, false)

RegisterCommand('satinal', function(source, args, raw)
    if not args[1] then
        TriggerEvent('chat:addMessage', {
            args = {'GALERİ', 'Kullanım: /satinal <numarası>'}
        })
        return
    end
    
    local idx = tonumber(args[1]) or 1
    local cfg = GalleryConfig or {}
    local veh = cfg.vehicles[idx]
    
    if veh then
        TriggerServerEvent('gallery:buyVehicle', veh.model, veh.price)
    else
        TriggerEvent('chat:addMessage', {
            args = {'GALERİ', 'Araç bulunamadı'}
        })
    end
end, false)

RegisterCommand('testsürüş', function(source, args, raw)
    if not args[1] then
        TriggerEvent('chat:addMessage', {
            args = {'GALERİ', 'Kullanım: /testsürüş <numarası>'}
        })
        return
    end
    
    local idx = tonumber(args[1]) or 1
    local cfg = GalleryConfig or {}
    local veh = cfg.vehicles[idx]
    
    if veh then
        TriggerServerEvent('gallery:testDrive', veh.model)
    end
end, false)

RegisterNetEvent('gallery:spawnVehicle')
AddEventHandler('gallery:spawnVehicle', function(model)
    local cfg = GalleryConfig or {}
    local loc = cfg.location or {x=561, y=-1217, z=26.4, heading=0}
    
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(10)
    end
    
    local veh = CreateVehicle(GetHashKey(model), loc.x, loc.y, loc.z, loc.heading, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
end)

RegisterNetEvent('gallery:spawnTestVehicle')
AddEventHandler('gallery:spawnTestVehicle', function(model)
    local cfg = GalleryConfig or {}
    local loc = cfg.location or {x=561, y=-1217, z=26.4, heading=0}
    
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(10)
    end
    
    local testVeh = CreateVehicle(GetHashKey(model), loc.x, loc.y, loc.z, loc.heading, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), testVeh, -1)
    
    -- 5 dakika sonra sil
    SetTimeout(300000, function()
        if testVeh and DoesEntityExist(testVeh) then
            DeleteEntity(testVeh)
            TriggerEvent('chat:addMessage', {
                args = {'GALERİ', 'Test sürüşü süresi bitti. Araç silindi.'}
            })
        end
    end)
end)

print("^2[GALERİ]^7 Client yüklendi")
