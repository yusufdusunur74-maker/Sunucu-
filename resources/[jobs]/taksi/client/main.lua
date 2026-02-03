-- Taksi Client
local playerOnDuty = false
local taxiCar = nil

RegisterCommand('taksi', function()
    if playerOnDuty then
        TriggerServerEvent('taxi:endDuty')
        playerOnDuty = false
    else
        TriggerServerEvent('taxi:startDuty')
        playerOnDuty = true
    end
end, false)

RegisterCommand('taksiara', function()
    if not playerOnDuty then
        TriggerEvent('chat:addMessage', {
            args = {'TAKSİ', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- Taksi araç spawn (basit)
    local cfg = TaxiConfig or {}
    local spawn = cfg.spawn_points[1] or {x=903, y=-170, z=77.7, heading=180}
    
    RequestModel(GetHashKey("taxi"))
    while not HasModelLoaded(GetHashKey("taxi")) do
        Wait(10)
    end
    
    taxiCar = CreateVehicle(GetHashKey("taxi"), spawn.x, spawn.y, spawn.z, spawn.heading, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), taxiCar, -1)
    
    TriggerEvent('chat:addMessage', {
        args = {'TAKSİ', 'Taksi hazır. Yolcu ara!'}
    })
end, false)

RegisterCommand('ücretial', function(source, args, raw)
    if not playerOnDuty then
        TriggerEvent('chat:addMessage', {
            args = {'TAKSİ', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    local fare = tonumber(args[1]) or 50
    TriggerServerEvent('taxi:completeFare', fare)
end, false)

print("^6[TAKSİ]^7 Client yüklendi")
