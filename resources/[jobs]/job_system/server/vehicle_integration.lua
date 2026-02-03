-- Mesleklere Araç Entegrasyonu

-- Tırcılık Araç Verme
RegisterNetEvent('trucking:giveVehicle')
AddEventHandler('trucking:giveVehicle', function()
    local src = source
    TriggerClientEvent('garage:spawnVehicleClient', src, "pounder", "TRUCK01")
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 128, 0},
        args = {"TIRCİLIK", "Tır aldınız! /deliver [km] yazıp teslimat yapın"}
    })
end)

-- Çiftçilik Araç Verme
RegisterNetEvent('farming:giveVehicle')
AddEventHandler('farming:giveVehicle', function()
    local src = source
    TriggerClientEvent('garage:spawnVehicleClient', src, "dloader", "FARM01")
    TriggerClientEvent('chat:addMessage', src, {
        color = {34, 139, 34},
        args = {"ÇIFTÇİLİK", "Traktörü aldınız! /harvest yazıp hasat yapın"}
    })
end)

-- Balıkçılık Bot Verme
RegisterNetEvent('fishing:giveBoat')
AddEventHandler('fishing:giveBoat', function()
    local src = source
    -- GTA'da bot modeli yerine su taşıtı
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 128, 255},
        args = {"BALIKÇILIK", "Bot için sahile giderek /startfishing yazın"}
    })
end)

print("^2[Araç Entegrasyonu]^7 Yüklendi")
