-- Yakıt Client
local FuelLevels = {} -- plate -> fuel
local FuelConfig = { consumptionPerSecond = 0.02 } -- % per second at running

RegisterNetEvent('fuel:applyState')
AddEventHandler('fuel:applyState', function(plate, fuel, damage)
    FuelLevels[plate] = fuel or 100
    print(("[YAKIT] %s için yakıt: %s"):format(plate, tostring(FuelLevels[plate])))
end)

-- Araç içindeyken yakıt tüketimi
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            local plate = GetVehicleNumberPlateText(veh)
            local running = GetIsVehicleEngineRunning(veh)
            if running then
                FuelLevels[plate] = (FuelLevels[plate] or 100) - FuelConfig.consumptionPerSecond
                if FuelLevels[plate] < 0 then FuelLevels[plate] = 0 end
                if FuelLevels[plate] <= 0 then
                    -- stop engine
                    SetVehicleEngineOn(veh, false, true, true)
                    TriggerEvent('chat:addMessage', { color={255, 0, 0}, args={"YAKIT","Araç yakıtı bitti!"}})
                end
                -- senkronize her 10 saniyede bir
                if math.random(1,10) == 1 then
                    TriggerServerEvent('fuel:setFuel', plate, math.floor(FuelLevels[plate]))
                end
            end
        else
            Wait(2000)
        end
    end
end)

RegisterCommand('doldur', function(source, args)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then print('Araç içinde olun veya plaka belirtin: /doldur PLATE') return end
    local plate = GetVehicleNumberPlateText(veh)
    TriggerServerEvent('fuel:refill', plate)
end)

RegisterCommand('yakitdurum', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then print('Araç içinde olun veya plaka belirtin: /yakitdurum PLATE') return end
    local plate = GetVehicleNumberPlateText(veh)
    print(("[%s] Yakıt: %s"):format(plate, tostring(FuelLevels[plate] or 100)))
end)

RegisterNetEvent('fuel:stationsList')
AddEventHandler('fuel:stationsList', function(stations)
    print('Yakıt istasyonları:')
    for i, s in ipairs(stations) do
        print(('- %s @ %.1f, %.1f, %.1f'):format(s.name, s.x, s.y, s.z))
    end
end)

print('^2[YAKIT]^7 Client yüklendi')