-- Çekici Client
local playerOnDuty = false

RegisterCommand('cekici', function()
    if playerOnDuty then
        TriggerServerEvent('tow:endDuty')
        playerOnDuty = false
    else
        TriggerServerEvent('tow:startDuty')
        playerOnDuty = true
    end
end, false)

RegisterCommand('cekiara', function()
    if not playerOnDuty then
        TriggerEvent('chat:addMessage', {
            args = {'ÇEKİCİ', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- Çekici araç spawn
    local cfg = TowConfig or {}
    local depot = cfg.depots[1] or {x=473.5, y=-1065, z=29.4, heading=180}
    
    RequestModel(GetHashKey("towtruck"))
    while not HasModelLoaded(GetHashKey("towtruck")) do
        Wait(10)
    end
    
    local tow = CreateVehicle(GetHashKey("towtruck"), depot.x, depot.y, depot.z, depot.heading, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), tow, -1)
    
    TriggerEvent('chat:addMessage', {
        args = {'ÇEKİCİ', 'Çekici hazır!'}
    })
end, false)

RegisterCommand('cekiisi', function(source, args, raw)
    if not playerOnDuty then
        TriggerEvent('chat:addMessage', {
            args = {'ÇEKİCİ', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    local payment = tonumber(args[1]) or 400
    TriggerServerEvent('tow:completeJob', payment)
end, false)

print("^3[ÇEKİCİ]^7 Client yüklendi")
