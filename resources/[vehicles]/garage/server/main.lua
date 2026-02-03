-- Garaj Server (Araç Depolama & Yönetim)
local Vehicles = {}  -- identifier -> { vehicles = { {plate, model, name, stored} }}
local vehiclesFile = "resources/[vehicles]/garage/data/vehicles.json"

local function saveVehicles()
    local encoded = json and json.encode(Vehicles) or '{}'
    local f = io.open(vehiclesFile, 'w')
    if f then f:write(encoded); f:close() end
end

-- Impound helper: mark vehicle as impounded
RegisterNetEvent('garage:impoundVehicle')
AddEventHandler('garage:impoundVehicle', function(plate, fine)
    -- Find owner and mark
    for identifier,data in pairs(Vehicles) do
        for i, v in ipairs(data.vehicles) do
            if v.plate == plate then
                v.impounded = true
                v.impoundFine = fine or 1000
                saveVehicles()
                print(("^3[GARAJ]^7 Araç %s (%s) impound edildi, ceza $%s"):format(v.name, plate, tostring(v.impoundFine)))
                return
            end
        end
    end
end)

local function loadVehicles()
    local f = io.open(vehiclesFile, 'r')
    if f then
        local content = f:read('*a'); f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then Vehicles = decoded end
    else Vehicles = {} end
end

loadVehicles()

-- Oyuncu garajını yükle/oluştur
RegisterNetEvent('garage:loadGarage')
AddEventHandler('garage:loadGarage', function()
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    
    Vehicles[id] = Vehicles[id] or { vehicles = {} }
    TriggerClientEvent('garage:showVehicles', src, Vehicles[id].vehicles)
    print(("^3[GARAJ]^7 Oyuncu %d garajını yükledi"):format(src))
end)

-- Araç sakla
RegisterNetEvent('garage:storeVehicle')
AddEventHandler('garage:storeVehicle', function(plate)
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    Vehicles[id] = Vehicles[id] or { vehicles = {} }

    local found = false
    for i, v in ipairs(Vehicles[id].vehicles) do
        if v.plate == plate then
            v.stored = true
            found = true
            break
        end
    end

    if not found then
        table.insert(Vehicles[id].vehicles, {plate = plate, model = "stored", stored = true})
    end

    saveVehicles()
    TriggerClientEvent('chat:addMessage', src, {
        args = {'GARAJ', '✅ Araç garajda saklandı'}
    })
    
    print(("^3[GARAJ]^7 Oyuncu %d araç (%s) sakladı"):format(src, plate))
end)

-- Araç çıkar
RegisterNetEvent('garage:spawnVehicle')
AddEventHandler('garage:spawnVehicle', function(plate, index)
    local src = source
    local id = GetPlayerIdentifiers(src)[1]
    Vehicles[id] = Vehicles[id] or { vehicles = {} }

    if index and Vehicles[id].vehicles[index] then
        local v = Vehicles[id].vehicles[index]
        v.stored = false
        local vehiclePlate = v.plate
        saveVehicles()
        TriggerClientEvent('garage:spawnCar', src, vehiclePlate, v.model)
        -- send fuel & damage state to client
        TriggerClientEvent('fuel:applyState', src, vehiclePlate, v.fuel, v.damage)
        TriggerClientEvent('chat:addMessage', src, {
            args = {'GARAJ', '✅ Araç çıkartıldı'}
        })
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    -- Veriler zaten saklanıyor; gerektiğinde ek işlemler yapılabilir
end)

print("^3[GARAJ]^7 Server başlatıldı")
