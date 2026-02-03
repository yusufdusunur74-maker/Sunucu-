-- Mekanik Server
local OnDuty = {}

RegisterNetEvent('mechanic:startDuty')
AddEventHandler('mechanic:startDuty', function()
    local src = source
    OnDuty[src] = true
    TriggerEvent('job:setJob', 'mekanik')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'MEKANİK', 'Nöbete başladınız. /tamir <id> komutu ile araç tamirleyin'}
    })
    print(("^3[MEKANİK]^7 Oyuncu %d nöbete başladı"):format(src))
end)

RegisterNetEvent('mechanic:endDuty')
AddEventHandler('mechanic:endDuty', function()
    local src = source
    OnDuty[src] = nil
    TriggerEvent('job:quitJob')
    TriggerClientEvent('chat:addMessage', src, {
        args = {'MEKANİK', 'Nöbetten ayrıldınız'}
    })
end)

RegisterNetEvent('mechanic:repairVehicle')
AddEventHandler('mechanic:repairVehicle', function(targetVehicle)
    local src = source
    
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'MEKANİK', 'Nöbete başlamalısınız'}
        })
        return
    end
    
    -- Araç tamir edildi
    TriggerClientEvent('mechanic:performRepair', targetVehicle)
    
    -- Mekanik ödeme
    TriggerEvent('money:add', 350, 'mechanic')
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'MEKANİK', '$350 kazandınız'}
    })
    
    print(("^3[MEKANİK]^7 %d oyuncu bir araç tamir etti"):format(src))
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnDuty[src] = nil
end)

print("^3[MEKANİK]^7 Sunucu başlatıldı")
