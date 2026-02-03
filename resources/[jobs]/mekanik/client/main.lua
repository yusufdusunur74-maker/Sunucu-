-- Mekanik Client
local playerOnDuty = false

RegisterCommand('mekanik', function()
    if playerOnDuty then
        TriggerServerEvent('mechanic:endDuty')
        playerOnDuty = false
    else
        TriggerServerEvent('mechanic:startDuty')
        playerOnDuty = true
    end
end, false)

RegisterCommand('tamir', function(source, args, raw)
    if not playerOnDuty then
        TriggerEvent('chat:addMessage', {
            args = {'MEKANİK', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- Oyuncu bulunduğu araçı tamir et
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        TriggerServerEvent('mechanic:repairVehicle', veh)
    else
        TriggerEvent('chat:addMessage', {
            args = {'MEKANİK', 'Araç içinde olmalısınız'}
        })
    end
end, false)

RegisterNetEvent('mechanic:performRepair')
AddEventHandler('mechanic:performRepair', function(vehicle)
    -- Araçı onar
    SmashVehicleWindow(vehicle, 0)
    SmashVehicleWindow(vehicle, 1)
    SmashVehicleWindow(vehicle, 2)
    SmashVehicleWindow(vehicle, 3)
    
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    
    TriggerEvent('chat:addMessage', {
        args = {'MEKANİK', 'Araç tamir edildi!'}
    })
end)

print("^3[MEKANİK]^7 Client yüklendi")
