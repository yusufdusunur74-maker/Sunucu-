-- Garaj Client (Araç Depolama & Yönetim)
local GarageConfig = {}
local playerVehicles = {}
local garageOpen = false

-- Config al
TriggerEvent('garage:getConfig', function(cfg)
    GarageConfig = cfg
end)

-- Garaj açma komutu
RegisterCommand('garaj', function(source, args, rawCommand)
    TriggerServerEvent('garage:loadGarage')
    garageOpen = true
    OpenGarageMenu()
end)

-- Garaj Menüsü Aç
function OpenGarageMenu()
    garageOpen = true
    SendNuiMessage(json.encode({
        type = "openGarage",
        vehicles = playerVehicles,
        garages = GarageConfig.garages
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
    if data.action == "spawnVehicle" then
        TriggerServerEvent('garage:spawnVehicle', data.plate, data.index)
    elseif data.action == "storeVehicle" then
        TriggerServerEvent('garage:storeVehicle', data.plate)
    elseif data.action == "close" then
        CloseGarageMenu()
    end
    cb('ok')
end)

-- Araçları göster
RegisterNetEvent('garage:showVehicles')
AddEventHandler('garage:showVehicles', function(vehicles)
    playerVehicles = vehicles
    print("^3[GARAJ]^7 Oyuncu araçları yüklendi: " .. json.encode(vehicles))
end)

-- Garaj Lokasyonlarında Kontrol
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        if GarageConfig and GarageConfig.garages then
            for _, garage in ipairs(GarageConfig.garages) do
                local distance = #(playerCoords - vector3(garage.x, garage.y, garage.z))
                
                if distance < 50.0 then
                    if distance < 2.0 then
                        TriggerEvent('chat:addMessage', {
                            color = {255, 200, 0},
                            args = {"GARAJ", "Garaj menüsü için /garaj komutunu kullanın"}
                        })
                    end
                end
            end
        end
        
        if not garageOpen then
            Wait(500)
        end
    end
end)

-- Araç Spawn
RegisterNetEvent('garage:spawnCar')
AddEventHandler('garage:spawnCar', function(plate, modelName)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local modelName = modelName or "adder"  -- Varsayılan
    
    local model = GetHashKey(modelName)
    RequestModel(model)
    
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    local vehicle = CreateVehicle(model, coords.x + 5, coords.y, coords.z, 0.0, true, false)
    SetVehicleNumberPlateText(vehicle, plate)
    SmashVehicleWindow(vehicle, 0)
    SmashVehicleWindow(vehicle, 1)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleDeformationFixed(vehicle)
    
    print(("^3[GARAJ]^7 Araç spawn edildi: %s (%s)"):format(modelName, plate))
end)

print("^3[GARAJ]^7 Client başlatıldı - Komut: /garaj")
end)
