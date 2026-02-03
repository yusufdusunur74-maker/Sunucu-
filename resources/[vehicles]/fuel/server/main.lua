-- Yakıt Sunucu
local stationsFile = "resources/[vehicles]/fuel/data/stations.json"
local Stations = {}

local VehiclesRef = nil -- We'll use garage vehicles JSON via events

local function loadStations()
    local f = io.open(stationsFile, 'r')
    if f then
        local content = f:read('*a'); f:close()
        local ok, decoded = pcall(function() return json.decode(content) end)
        if ok and decoded then Stations = decoded end
    else Stations = {} end
end

loadStations()

RegisterNetEvent('fuel:setFuel') -- plate, fuel
AddEventHandler('fuel:setFuel', function(plate, fuel)
    local src = source
    -- Modify garage vehicles data file
    TriggerEvent('garage:updateVehicleFuel', plate, fuel)
end)

RegisterNetEvent('fuel:refill') -- plate
AddEventHandler('fuel:refill', function(plate)
    local src = source
    local price = 200 -- sabit ücret PoC
    -- charge player
    TriggerEvent('money:add', -price, "BENZINLIK")
    TriggerEvent('garage:updateVehicleFuel', plate, 100)
    TriggerClientEvent('chat:addMessage', src, { color={0,255,0}, args={"YAKIT","Araç yakıtı dolduruldu ($"..price..")"}})
end)

RegisterNetEvent('fuel:getStations')
AddEventHandler('fuel:getStations', function()
    local src = source
    TriggerClientEvent('fuel:stationsList', src, Stations)
end)

print("^2[YAKIT]^7 Server yüklendi")