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

RegisterCommand('scanfinger', function(source, args, raw)
    if #args < 1 then
        TriggerEvent('chat:addMessage', { args = {'POLİS', 'Kullanım: /scanfinger <playerId>'} })
        return
    end
    local targetId = tonumber(args[1])
    TriggerServerEvent('police:scanFingerprint', targetId)
end, false)

RegisterCommand('findfinger', function(source, args, raw)
    if #args < 1 then
        TriggerEvent('chat:addMessage', { args = {'POLİS', 'Kullanım: /findfinger <fingerprint>'} })
        return
    end
    TriggerServerEvent('police:findByFingerprint', tostring(args[1]))
end, false)

RegisterCommand('records', function(source, args, raw)
    if #args < 1 then
        TriggerEvent('chat:addMessage', { args = {'POLİS', 'Kullanım: /records <playerId>'} })
        return
    end
    local targetId = tonumber(args[1])
    TriggerServerEvent('police:getRecords', targetId)
end, false)

RegisterCommand('recadd', function(source, args, raw)
    if #args < 2 then
        TriggerEvent('chat:addMessage', { args = {'POLİS', 'Kullanım: /recadd <playerId> <type> [note]'} })
        return
    end
    local targetId = tonumber(args[1])
    local rtype = tostring(args[2])
    table.remove(args,1); table.remove(args,1)
    local note = table.concat(args, ' ')
    TriggerServerEvent('police:addRecord', targetId, rtype, note)
end, false)

RegisterNetEvent('police:scanResult')
AddEventHandler('police:scanResult', function(info)
    if not info then
        TriggerEvent('chat:addMessage', { args = {'POLİS', 'Parmak izi bulunamadı veya hedef karakter seçili değil.'} })
        return
    end
    TriggerEvent('chat:addMessage', { args = {'POLİS', ('Scan Result - İsim: %s | FP: %s'):format(info.name or 'unknown', info.fingerprint or 'N/A')} })
end)

RegisterNetEvent('police:findResult')
AddEventHandler('police:findResult', function(info)
    if not info then
        TriggerEvent('chat:addMessage', { args = {'POLİS', 'Parmak izi kayıtlı değil.'} })
        return
    end
    TriggerEvent('chat:addMessage', { args = {'POLİS', ('Bulundu - İsim: %s | ID: %s | FP: %s'):format(info.name, info.identifier, info.fingerprint)} })
end)

RegisterNetEvent('police:showRecords')
AddEventHandler('police:showRecords', function(records)
    if not records or #records == 0 then
        TriggerEvent('chat:addMessage', { args = {'POLİS', 'Kayıt bulunamadı.'} })
        return
    end
    TriggerEvent('chat:addMessage', { args = {'POLİS', '--- Sabıka Kayıtları ---'} })
    for _, r in ipairs(records) do
        TriggerEvent('chat:addMessage', { args = {'POLİS', ('%s | %s | %s'):format(r.type or 'unknown', r.note or (r.reason or ''), os.date('%d/%m %H:%M', r.timestamp or os.time()))} })
    end
end)

print("^1[POLİS]^7 Client yüklendi")
