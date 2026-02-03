-- Araç Kilit Client
local function GetClosestPlayer()
    local players = GetActivePlayers()
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    local closestPlayer = nil
    local closestDistance = 9999
    for _, pid in ipairs(players) do
        local targetPed = GetPlayerPed(pid)
        if targetPed ~= ped then
            local tCoords = GetEntityCoords(targetPed)
            local dist = #(pCoords - tCoords)
            if dist < closestDistance then
                closestDistance = dist
                closestPlayer = pid
            end
        end
    end
    return closestPlayer, closestDistance
end

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

-- Give key to closest player (or use arg server id/plate)
RegisterCommand('givekey', function(source, args)
    local ped = PlayerPedId()
    local plate = args[1]
    if not plate then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then plate = GetVehicleNumberPlateText(vehicle) end
    end
    if not plate then print("Plaka belirtin veya araç içinde olun") return end

    local closest, dist = GetClosestPlayer()
    if not closest or dist > 5.0 then print("Yakın oyuncu bulunamadı") return end

    TriggerServerEvent('vehicle:giveKeyToPlayer', plate, closest)
end)

-- Remove key from closest player
RegisterCommand('removekey', function(source, args)
    local ped = PlayerPedId()
    local plate = args[1]
    if not plate then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then plate = GetVehicleNumberPlateText(vehicle) end
    end
    if not plate then print("Plaka belirtin veya araç içinde olun") return end

    local closest, dist = GetClosestPlayer()
    if not closest or dist > 5.0 then print("Yakın oyuncu bulunamadı") return end

    TriggerServerEvent('vehicle:removeKeyFromPlayer', plate, closest)
end)

-- Query keys for a plate
RegisterCommand('keys', function(source, args)
    local ped = PlayerPedId()
    local plate = args[1]
    if not plate then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then plate = GetVehicleNumberPlateText(vehicle) end
    end
    if not plate then print("Plaka belirtin veya araç içinde olun") return end
    TriggerServerEvent('vehicle:getKeyInfo', plate)
end)

RegisterNetEvent('vehicle:keysInfo')
AddEventHandler('vehicle:keysInfo', function(plate, info)
    print(("Anahtar Bilgisi - %s"):format(plate))
    print(("Sahip: %s"):format(info.owner or "Yok"))
    if info.shared and #info.shared > 0 then
        for i, id in ipairs(info.shared) do
            print(("Paylaşılan: %s"):format(id))
        end
    else
        print("Paylaşılan anahtar yok")
    end
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
