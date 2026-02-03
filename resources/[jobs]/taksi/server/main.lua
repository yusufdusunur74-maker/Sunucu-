-- Taksi Server
local OnDuty = {}
local Fares = {}

RegisterNetEvent('taxi:startDuty')
AddEventHandler('taxi:startDuty', function()
    local src = source
    OnDuty[src] = true
    TriggerEvent('job:setJob', 'taksi')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'TAKSİ', 'Nöbete başladınız. Yolcu bekliyorum...'}
    })
    print(("^6[TAKSİ]^7 Oyuncu %d nöbete başladı"):format(src))
end)

RegisterNetEvent('taxi:endDuty')
AddEventHandler('taxi:endDuty', function()
    local src = source
    OnDuty[src] = nil
    TriggerEvent('job:quitJob')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'TAKSİ', 'Nöbetten ayrıldınız'}
    })
end)

RegisterNetEvent('taxi:completeFare')
AddEventHandler('taxi:completeFare', function(fare)
    local src = source
    
    if not OnDuty[src] then return end
    
    fare = tonumber(fare) or 50
    TriggerEvent('money:add', fare, 'taxi')
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'TAKSİ', '$' .. fare .. ' kazandınız'}
    })
    
    print(("^6[TAKSİ]^7 %d oyuncu $%d yolcu ücreti aldı"):format(src, fare))
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnDuty[src] = nil
end)

print("^6[TAKSİ]^7 Sunucu başlatıldı")
