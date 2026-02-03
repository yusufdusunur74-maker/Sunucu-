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

-- Carry / stretcher system (simplified)
RegisterNetEvent('ems:carry')
AddEventHandler('ems:carry', function(targetId)
    local src = source
    targetId = tonumber(targetId)
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, { args = {'EMS', 'Nöbete başlamalısınız'} })
        return
    end
    if not targetId then return end
    TriggerClientEvent('ems:beCarried', targetId, src)
    TriggerClientEvent('ems:carryStarted', src, targetId)
    TriggerClientEvent('chat:addMessage', src, { args = {'EMS', 'Hasta sedyeye alındı.'} })
end)

RegisterNetEvent('ems:drop')
AddEventHandler('ems:drop', function(targetId)
    local src = source
    targetId = tonumber(targetId)
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, { args = {'EMS', 'Nöbete başlamalısınız'} })
        return
    end
    TriggerClientEvent('ems:stopCarry', targetId)
    TriggerClientEvent('ems:carryStopped', src, targetId)
    TriggerClientEvent('chat:addMessage', src, { args = {'EMS', 'Sedye bırakıldı.'} })
end)

-- Treatment and billing
RegisterNetEvent('ems:treat')
AddEventHandler('ems:treat', function(targetId, amount)
    local src = source
    targetId = tonumber(targetId)
    amount = tonumber(amount) or 100
    if not OnDuty[src] then
        TriggerClientEvent('chat:addMessage', src, { args = {'EMS', 'Nöbete başlamalısınız'} })
        return
    end
    if not targetId then return end

    -- charge target's bank
    TriggerEvent('money:removeBank', amount, function(success)
        if success then
            -- pay EMS
            TriggerEvent('money:forceAddBank', src, amount)
            TriggerClientEvent('ems:receiveTreatment', targetId, amount)
            TriggerClientEvent('chat:addMessage', src, { args = {'EMS', ('Tedavi uygulandı. $%d alındı.'):format(amount)} })
        else
            TriggerClientEvent('chat:addMessage', src, { args = {'EMS', 'Hastanın bakiyesi yetersiz.'} })
        end
    end)
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnDuty[src] = nil
end)

print("^5[EMS]^7 Sunucu başlatıldı")
