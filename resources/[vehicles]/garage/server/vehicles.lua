-- Araç Galerisi Server Script
local Vehicles = {}
local vehiclesFile = "resources/[vehicles]/garage/data/vehicles.json"

local function saveVehicles()
    local encoded = json and json.encode(Vehicles) or '{}'
    local f = io.open(vehiclesFile, 'w')
    if f then f:write(encoded); f:close() end
end

local function loadVehicles()
    local f = io.open(vehiclesFile, 'r')
    if f then
        local content = f:read('*a'); f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then Vehicles = decoded end
    else Vehicles = {} end
end

loadVehicles()

-- Araç Satın Alma
RegisterNetEvent('garage:buyVehicle')
AddEventHandler('garage:buyVehicle', function(vehicleId)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local vehicle = nil
    
    -- Araç kaydını bul
    for _, v in ipairs(GarageConfig.vehicles) do
        if v.id == vehicleId then
            vehicle = v
            break
        end
    end
    
    if not vehicle then return end
    
    -- Para kontrolü yapıl
    TriggerEvent('money:getMoney')
    Wait(100)

    Vehicles[identifier] = Vehicles[identifier] or { vehicles = {} }
    local plate = "UNIV" .. math.random(1000,9999)
    table.insert(Vehicles[identifier].vehicles, { model = vehicle.model, name = vehicle.name, plate = plate, stored = false })
    saveVehicles()

    -- kayıt et, kilit sistemi bilsin
    TriggerEvent('vehicle:registerOwnership', plate)

    TriggerClientEvent('garage:notification', src, "Başarılı", vehicle.name .. " satın aldınız! ($" .. vehicle.price .. ")")
    TriggerEvent('money:add', -vehicle.price, "GARAJ")

    print(("^2[Garaj]^7 | Oyuncu %d, %s aracını $%d fiyatına satın aldı (plate: %s)"):format(src, vehicle.name, vehicle.price, plate))
end)

-- Araç Getir
RegisterNetEvent('garage:spawnVehicle')
AddEventHandler('garage:spawnVehicle', function(vehicleModel, plate)
    local src = source
    TriggerClientEvent('garage:spawnVehicleClient', src, vehicleModel, plate)
    print(("^2[Garaj]^7 | Oyuncu %d, %s aracını çağırdı"):format(src, vehicleModel))
end)

-- Araç Listesi
RegisterNetEvent('garage:getVehicles')
AddEventHandler('garage:getVehicles', function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    Vehicles[identifier] = Vehicles[identifier] or { vehicles = {} }
    TriggerClientEvent('garage:updateVehicleList', src, Vehicles[identifier].vehicles)
end)
