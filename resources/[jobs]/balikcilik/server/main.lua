-- Balıkçılık Server Script
RegisterNetEvent('balikcilik:castRod')
AddEventHandler('balikcilik:castRod', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 128, 255},
        args = {"BALIKÇI", "Olta atıldı! Balık tutmayı bekleyin..."}
    })
    print(("^5[Balıkçılık]^7 | Oyuncu %d olta attı"):format(src))
end)

RegisterNetEvent('balikcilik:fishCaught')
AddEventHandler('balikcilik:fishCaught', function(fishType)
    local src = source
    local fishPay = {
        normal = 100,
        big = 200,
        rare = 350
    }
    
    local pay = fishPay[fishType] or 140
    TriggerEvent('money:add', pay, "BALIKCILIK")
    
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 128, 255},
        args = {"BALIKÇI", "Balık tutuldu! +" .. pay .. "$"}
    })
    print(("^5[Balıkçılık]^7 | Oyuncu %d (%s) $%s kazandı"):format(src, fishType, pay))
end)

RegisterNetEvent('balikcilik:noFish')
AddEventHandler('balikcilik:noFish', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 128, 255},
        args = {"BALIKÇI", "Balık tutamamadınız! Yeniden deneyin"}
    })
    print(("^5[Balıkçılık]^7 | Oyuncu %d balık tutamamadı"):format(src))
end)
