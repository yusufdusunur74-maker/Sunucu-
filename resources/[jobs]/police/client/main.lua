-- Polis Client
local playerOnDuty = false
local policeCarModel = nil

RegisterCommand('nobet', function()
    if playerOnDuty then
        TriggerServerEvent('police:endDuty')
        playerOnDuty = false
    else
        TriggerServerEvent('police:startDuty')
        playerOnDuty = true
    end
end, false)

RegisterCommand('arac', function()
    if not playerOnDuty then
        TriggerEvent('chat:addMessage', {
            args = {'POLİS', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- araç spawn (basit)
    local cfg = PoliceConfig or {}
    local vehCfg = cfg.vehicle_spawn or {x=464, y=-1017, z=25.4, heading=90, model="police"}
    
    RequestModel(GetHashKey(vehCfg.model))
    while not HasModelLoaded(GetHashKey(vehCfg.model)) do
        Wait(10)
    end
    
    local veh = CreateVehicle(GetHashKey(vehCfg.model), vehCfg.x, vehCfg.y, vehCfg.z, vehCfg.heading, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    
    TriggerEvent('chat:addMessage', {
        args = {'POLİS', 'Araç hazır. Başarılı kalmalar!'}
    })
end, false)

RegisterCommand('ceza', function(source, args, raw)
    if #args < 2 then
        TriggerEvent('chat:addMessage', {
            args = {'POLİS', 'Kullanım: /ceza <playerId> <miktar>'}
        })
        return
    end
    
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2]) or 500
    
    TriggerServerEvent('police:giveFine', targetId, amount, 'Polis Cezası')
end, false)

print("^1[POLİS]^7 Client yüklendi")
