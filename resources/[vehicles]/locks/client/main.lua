-- Araç Kilit Client
RegisterCommand('lock', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('locks:toggleLock', plate)
    else
        print("Araç içinde değilsiniz")
    end
end)

RegisterNetEvent('locks:updateLock')
AddEventHandler('locks:updateLock', function(plate, isLocked)
    print(("Araç %s - %s"):format(plate, isLocked and "Kilitli" or "Açık"))
end)

-- Araç Binme Animasyonu
RegisterCommand('enter', function()
    local ped = PlayerPedId()
    
    -- Araç binme animasyonu
    if GetVehiclePedIsIn(ped, false) == 0 then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_MOBILE_FILM_SHOCKING", 0, true)
        Wait(500)
        ClearPedTasks(ped)
        print("Araçtan çıkıldı")
    end
end)

print("^2[Araç Kilit]^7 Client yüklendi")
