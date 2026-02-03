-- İllegal Meslekler Client

RegisterCommand('startcocaine', function()
    TriggerEvent('chat:addMessage', {
        args = {'⚠️ UYUŞTURUCU', 'Üretim başladı... Yakalanma riski: 30%'}
    })
    TriggerServerEvent('illegal:produceCocaine')
end, false)

RegisterCommand('robbery', function()
    TriggerEvent('chat:addMessage', {
        args = {'⚠️ SOYGUN', 'Soygun başladı... Yakalanma riski: 40%'}
    })
    TriggerServerEvent('illegal:robbery')
end, false)

RegisterCommand('silah', function(source, args, raw)
    local cfg = IllegalConfig or {}
    if not args[1] then
        TriggerEvent('chat:addMessage', {
            args = {'⚠️ SİLAH', '--- Silahlar --- /silah <numarası>'}
        })
        for i, w in ipairs(cfg.weapons or {}) do
            TriggerEvent('chat:addMessage', {
                args = {'', i .. '. ' .. w.name .. ' ($' .. w.price .. ')'}
            })
        end
        return
    end
    
    TriggerServerEvent('illegal:buyWeapon', tonumber(args[1]) or 1)
end, false)

RegisterNetEvent('illegal:receiveWeapon')
AddEventHandler('illegal:receiveWeapon', function(weapon)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey(weapon.hash), 120, false, true)
end)

print("^1[İLLEGAL]^7 Client yüklendi")
