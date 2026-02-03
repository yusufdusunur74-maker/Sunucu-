-- EMS Client
local playerOnDuty = false

RegisterCommand('ems', function()
    if playerOnDuty then
        TriggerServerEvent('ems:endDuty')
        playerOnDuty = false
    else
        TriggerServerEvent('ems:startDuty')
        playerOnDuty = true
    end
end, false)

RegisterCommand('ambulans', function()
    if not playerOnDuty then
        TriggerEvent('chat:addMessage', {
            args = {'EMS', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- ambulans spawn (basit)
    local cfg = EMSConfig or {}
    local vehCfg = cfg.vehicle_spawn or {x=311, y=-360, z=44.9, heading=70, model="ambulance"}
    
    RequestModel(GetHashKey(vehCfg.model))
    while not HasModelLoaded(GetHashKey(vehCfg.model)) do
        Wait(10)
    end
    
    local veh = CreateVehicle(GetHashKey(vehCfg.model), vehCfg.x, vehCfg.y, vehCfg.z, vehCfg.heading, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    
    TriggerEvent('chat:addMessage', {
        args = {'EMS', 'Ambulans hazır. İlaçlama zamanı!'}
    })
end, false)

RegisterCommand('revive', function(source, args, raw)
    if #args < 1 then
        TriggerEvent('chat:addMessage', {
            args = {'EMS', 'Kullanım: /revive <playerId>'}
        })
        return
    end
    
    local targetId = tonumber(args[1])
    TriggerServerEvent('ems:revivePlayer', targetId)
end, false)

-- carry / drop / treat commands
RegisterCommand('carry', function(source, args)
    if #args < 1 then
        TriggerEvent('chat:addMessage', { args = {'EMS', 'Kullanım: /carry <playerId>'} })
        return
    end
    TriggerServerEvent('ems:carry', tonumber(args[1]))
end, false)

RegisterCommand('drop', function(source, args)
    if #args < 1 then
        TriggerEvent('chat:addMessage', { args = {'EMS', 'Kullanım: /drop <playerId>'} })
        return
    end
    TriggerServerEvent('ems:drop', tonumber(args[1]))
end, false)

RegisterCommand('treat', function(source, args)
    if #args < 2 then
        TriggerEvent('chat:addMessage', { args = {'EMS', 'Kullanım: /treat <playerId> <amount>'} })
        return
    end
    TriggerServerEvent('ems:treat', tonumber(args[1]), tonumber(args[2]))
end, false)

RegisterNetEvent('ems:respawnPlayer')
AddEventHandler('ems:respawnPlayer', function()
    -- hastane konumlarından birinde spawn ol
    local hospitals = (EMSConfig and EMSConfig.hospitals) or {}
    local hospital = hospitals[1] or {respawn = {x=295.6, y=-349.6, z=45}}
    
    local ped = PlayerPedId()
    SetEntityCoords(ped, hospital.respawn.x, hospital.respawn.y, hospital.respawn.z, false, false, false, false)
    
    TriggerEvent('chat:addMessage', {
        args = {'EMS', 'Hastanede uyandınız. Sağlıkla kalınız!'}
    })
end)

-- carry handlers
RegisterNetEvent('ems:beCarried')
AddEventHandler('ems:beCarried', function(carrierSrc)
    TriggerEvent('chat:addMessage', { args = {'EMS', 'EMS sizi sedyeye aldı. Taşınıyorsunuz...'} })
    -- basit: freeze while being carried
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
end)

RegisterNetEvent('ems:stopCarry')
AddEventHandler('ems:stopCarry', function()
    TriggerEvent('chat:addMessage', { args = {'EMS', 'Sedyeden indirildiniz.'} })
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
end)

RegisterNetEvent('ems:carryStarted')
AddEventHandler('ems:carryStarted', function(targetId)
    TriggerEvent('chat:addMessage', { args = {'EMS', ('Sedyede oyuncu %s ile taşımaya başladınız.'):format(tostring(targetId))} })
end)

RegisterNetEvent('ems:carryStopped')
AddEventHandler('ems:carryStopped', function(targetId)
    TriggerEvent('chat:addMessage', { args = {'EMS', ('Sedyeyi bıraktınız: %s'):format(tostring(targetId))} })
end)

RegisterNetEvent('ems:receiveTreatment')
AddEventHandler('ems:receiveTreatment', function(amount)
    TriggerEvent('chat:addMessage', { args = {'EMS', ('Tedavi uygulandı. $%s ödendi ve sağlık geri verildi.'):format(tostring(amount))} })
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
end)

print("^5[EMS]^7 Client yüklendi")
