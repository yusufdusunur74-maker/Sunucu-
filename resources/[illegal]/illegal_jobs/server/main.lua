-- İllegal Meslekler Server
local cfg = IllegalConfig or {}

-- Uyuşturucu Üretimi
RegisterNetEvent('illegal:produceCocaine')
AddEventHandler('illegal:produceCocaine', function()
    local src = source
    local drugCfg = cfg.drug_production or {police_risk = 30, profit_per_unit = 500}
    
    if math.random(1, 100) <= drugCfg.police_risk then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'POLİS', '⚠️ Uyuşturucu operasyonunda yakalandınız!'}
        })
        print(("^1[İLLEGAL]^7 Oyuncu %d uyuşturucuda yakalandı"):format(src))
        return
    end
    
    local amount = drugCfg.profit_per_unit * math.random(5, 10)
    TriggerEvent('money:add', amount, 'UYUŞTURUCU')
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'UYUŞTURUCU', '✅ Ürün satıldı! +$' .. amount}
    })
    
    print(("^1[UYUŞTURUCU]^7 Oyuncu %d $%s kazandı"):format(src, amount))
end)

-- Soygun
RegisterNetEvent('illegal:robbery')
AddEventHandler('illegal:robbery', function()
    local src = source
    local robberyCfg = cfg.robbery or {police_risk = 40, min_reward = 3000, max_reward = 10000}
    
    if math.random(1, 100) <= robberyCfg.police_risk then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'POLİS', '⚠️ Soygun sırasında yakalandınız!'}
        })
        print(("^1[SOYGUN]^7 Oyuncu %d yakalandı"):format(src))
        return
    end
    
    local amount = math.random(robberyCfg.min_reward, robberyCfg.max_reward)
    TriggerEvent('money:add', amount, 'SOYGUN')
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'SOYGUN', '✅ Başarılı soygun! +$' .. amount}
    })
    
    print(("^1[SOYGUN]^7 Oyuncu %d $%s çaldı"):format(src, amount))
end)

-- Silah Satışı
RegisterNetEvent('illegal:buyWeapon')
AddEventHandler('illegal:buyWeapon', function(weaponIndex)
    local src = source
    weaponIndex = tonumber(weaponIndex) or 1
    local weapon = (cfg.weapons or {})[weaponIndex]
    
    if not weapon then return end
    
    TriggerClientEvent('illegal:receiveWeapon', src, weapon)
    TriggerClientEvent('chat:addMessage', src, {
        args = {'⚠️ SİLAH', weapon.name .. ' silahı alındı ($' .. weapon.price .. ')'}
    })
    
    print(("^1[UYUŞTURUCU]^7 Oyuncu %d %s satın aldı"):format(src, weapon.name))
end)

print("^1[İLLEGAL]^7 Sunucu başlatıldı")
