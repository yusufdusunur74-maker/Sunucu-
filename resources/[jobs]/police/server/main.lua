-- Polis Server
local OnDuty = {}

RegisterNetEvent('police:startDuty')
AddEventHandler('police:startDuty', function()
    local src = source
    OnDuty[src] = true
    TriggerEvent('job:setJob', 'polis')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'POLİS', 'Nöbete başladınız. Araç almak için /arac yaz'}
    })
    print(("^1[POLİS]^7 Oyuncu %d nöbete başladı"):format(src))
end)

RegisterNetEvent('police:endDuty')
AddEventHandler('police:endDuty', function()
    local src = source
    OnDuty[src] = nil
    TriggerEvent('job:quitJob')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'POLİS', 'Nöbetten ayrıldınız'}
    })
end)

RegisterNetEvent('police:giveFine')
AddEventHandler('police:giveFine', function(targetId, amount, reason)
    local src = source
    targetId = tonumber(targetId)
    amount = tonumber(amount) or 0
    
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'POLİS', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- Para sistemi: ceza tutar
    TriggerEvent('money:add', amount, 'police_fine')
    TriggerClientEvent('chat:addMessage', targetId, {
        args = {'CEZA', 'Polis tarafından $' .. amount .. ' ceza kesildi: ' .. tostring(reason)}
    })
    
    print(("^1[POLİS]^7 %d oyuncu %d oyuncuya $%d ceza kesti"):format(src, targetId, amount))
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnDuty[src] = nil
end)

print("^1[POLİS]^7 Sunucu başlatıldı")
