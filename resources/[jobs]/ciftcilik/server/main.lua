-- Çiftçilik Server Script
RegisterNetEvent('ciftcilik:plantCrop')
AddEventHandler('ciftcilik:plantCrop', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {34, 139, 34},
        args = {"ÇIFTÇİ", "Ekin dikildi!"}
    })
    print(("^2[Çiftçilik]^7 | Oyuncu %d ekin dikti"):format(src))
end)

RegisterNetEvent('ciftcilik:harvestCrop')
AddEventHandler('ciftcilik:harvestCrop', function()
    local src = source
    local harvestPay = 120
    
    TriggerEvent('money:add', harvestPay, "CIFTCILIK")
    TriggerClientEvent('chat:addMessage', src, {
        color = {34, 139, 34},
        args = {"ÇIFTÇİ", "Hasat tamamlandı! +" .. harvestPay .. "$"}
    })
    print(("^2[Çiftçilik]^7 | Oyuncu %d $%s kazandı"):format(src, harvestPay))
end)

RegisterNetEvent('ciftcilik:water')
AddEventHandler('ciftcilik:water', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {34, 139, 34},
        args = {"ÇIFTÇİ", "Ekinler sulandı!"}
    })
    print(("^2[Çiftçilik]^7 | Oyuncu %d ekini suladı"):format(src))
end)
