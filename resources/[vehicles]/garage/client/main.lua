-- Araç Galerisi Client Script
local garageOpen = false
local selectedVehicle = nil

-- Garaj Menüsü Aç
function OpenGarageMenu()
    garageOpen = true
    SendNuiMessage(json.encode({
        type = "openGarage",
        vehicles = GarageConfig.vehicles,
        categories = GarageConfig.categories
    }))
    SetNuiFocus(true, true)
end

-- Garaj Menüsü Kapat
function CloseGarageMenu()
    garageOpen = false
    SendNuiMessage(json.encode({type = "close"}))
    SetNuiFocus(false, false)
end

-- NUI Callback
RegisterNuiCallback('garageAction', function(data, cb)
    if data.action == "buyVehicle" then
        TriggerServerEvent('garage:buyVehicle', data.vehicleId)
    elseif data.action == "spawnVehicle" then
        TriggerServerEvent('garage:spawnVehicle', data.model, data.plate)
    elseif data.action == "close" then
        CloseGarageMenu()
    end
    cb('ok')
end)

-- Garaj Lokasyonlarında Kontrol
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for _, garage in ipairs(GarageConfig.garages) do
            local distance = #(playerCoords - vector3(garage.x, garage.y, garage.z))
            
            if distance < garage.distance then
                -- Garaj içindeyiz
                if distance < 2.0 then
                    TriggerEvent('chat:addMessage', {
                        color = {255, 200, 0},
                        args = {"GARAJ", "Garaj menüsü için [E] tuşuna basın"}
                    })
                    
                    if IsControlJustReleased(0, 38) then -- E tuşu
                        OpenGarageMenu()
                    end
                end
            end
        end
        
        if not garageOpen then
            Wait(500)
        end
    end
end)

-- Araç Bildirim
RegisterNetEvent('garage:notification')
AddEventHandler('garage:notification', function(title, message)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {title, message}
    })
end)

-- Araç Listesi Güncelle
RegisterNetEvent('garage:updateVehicleList')
AddEventHandler('garage:updateVehicleList', function(vehicles)
    SendNuiMessage(json.encode({
        type = "updateVehicleList",
        vehicles = vehicles
    }))
end)

-- Araç Spawn
RegisterNetEvent('garage:spawnVehicleClient')
AddEventHandler('garage:spawnVehicleClient', function(modelName, plate)
    local model = GetHashKey(modelName)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Oyuncunun önüne araç spawn et
    local vehicle = CreateVehicle(model, coords.x + 5, coords.y + 5, coords.z, 0.0, true, false)
    SmashVehicleWindow(vehicle, 0)
    SmashVehicleWindow(vehicle, 1)
    
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleDeformationFixed(vehicle)
    
    print(("Araç spawn edildi: %s"):format(modelName))
end)
