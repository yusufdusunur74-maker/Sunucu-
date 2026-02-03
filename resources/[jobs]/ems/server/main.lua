-- EMS Server
local OnDuty = {}

RegisterNetEvent('ems:startDuty')
AddEventHandler('ems:startDuty', function()
    local src = source
    OnDuty[src] = true
    TriggerEvent('job:setJob', 'ems')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'EMS', 'Nöbete başladınız. Ambulans almak için /ambulans yaz'}
    })
    print(("^5[EMS]^7 Oyuncu %d nöbete başladı"):format(src))
end)

RegisterNetEvent('ems:endDuty')
AddEventHandler('ems:endDuty', function()
    local src = source
    OnDuty[src] = nil
    TriggerEvent('job:quitJob')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'EMS', 'Nöbetten ayrıldınız'}
    })
end)

RegisterNetEvent('ems:revivePlayer')
AddEventHandler('ems:revivePlayer', function(targetId)
    local src = source
    targetId = tonumber(targetId)
    
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'EMS', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- Oyuncu dirilt (respawn)
    TriggerClientEvent('ems:respawnPlayer', targetId)
    
    -- EMS kazanç
    TriggerEvent('money:add', 250, 'ems')
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'EMS', '$250 kazandınız'}
    })
    
    print(("^5[EMS]^7 %d oyuncu %d oyuncuyu dirilttti"):format(src, targetId))
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnDuty[src] = nil
end)

print("^5[EMS]^7 Sunucu başlatıldı")
