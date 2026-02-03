-- Araç Galerisi Server Script
local PlayerVehicles = {}

-- Araç Satın Alma
RegisterNetEvent('garage:buyVehicle')
AddEventHandler('garage:buyVehicle', function(vehicleId)
    local src = source
    local vehicle = nil
    
    -- Araç kaydını bul
    for _, v in ipairs(GarageConfig.vehicles) do
        if v.id == vehicleId then
            vehicle = v
            break
        end
    end
    
    if not vehicle then return end
    
    -- Oyuncu parasını kontrol et
    if PlayerVehicles[src] == nil then
        PlayerVehicles[src] = {vehicles = {}}
    end
    
    -- Para kontrolü yapıl
    TriggerEvent('money:getMoney')
    Wait(100)
    
    print(("^2[Garaj]^7 | Oyuncu %d, %s aracını $%d fiyatına satın aldı"):format(
        src, vehicle.name, vehicle.price
    ))
    
    -- Araç veritabanına kaydet
    table.insert(PlayerVehicles[src].vehicles, {
        model = vehicle.model,
        name = vehicle.name,
        plate = "UNIV" .. math.random(1000, 9999)
    })
    
    TriggerClientEvent('garage:notification', src, "Başarılı", vehicle.name .. " satın aldınız! ($" .. vehicle.price .. ")")
    TriggerEvent('money:add', -vehicle.price, "GARAJ")
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
    if PlayerVehicles[src] == nil then
        PlayerVehicles[src] = {vehicles = {}}
    end
    TriggerClientEvent('garage:updateVehicleList', src, PlayerVehicles[src].vehicles)
end)

-- Oyuncu Çıktı
AddEventHandler('playerDropped', function()
    local src = source
    PlayerVehicles[src] = nil
end)
