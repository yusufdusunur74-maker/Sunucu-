-- Çekici Server
local OnDuty = {}

RegisterNetEvent('tow:startDuty')
AddEventHandler('tow:startDuty', function()
    local src = source
    OnDuty[src] = true
    TriggerEvent('job:setJob', 'cekici')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'ÇEKİCİ', 'Nöbete başladınız. Araç çekmek için yaklaşın'}
    })
    print(("^3[ÇEKİCİ]^7 Oyuncu %d nöbete başladı"):format(src))
end)

RegisterNetEvent('tow:endDuty')
AddEventHandler('tow:endDuty', function()
    local src = source
    OnDuty[src] = nil
    TriggerEvent('job:quitJob')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'ÇEKİCİ', 'Nöbetten ayrıldınız'}
    })
end)

RegisterNetEvent('tow:completeJob')
AddEventHandler('tow:completeJob', function(payment)
    local src = source
    
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'ÇEKİCİ', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    payment = tonumber(payment) or 400
    TriggerEvent('money:add', payment, 'tow')
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'ÇEKİCİ', '$' .. payment .. ' kazandınız'}
    })
    
    print(("^3[ÇEKİCİ]^7 %d oyuncu $%d kazandı"):format(src, payment))
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnDuty[src] = nil
end)

print("^3[ÇEKİCİ]^7 Sunucu başlatıldı")
