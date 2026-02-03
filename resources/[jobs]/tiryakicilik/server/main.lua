-- Tırcılık Server Script
RegisterNetEvent('tiryakicilik:startWork')
AddEventHandler('tiryakicilik:startWork', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 128, 0},
        args = {"TIR ŞOFÖRÜ", "Tır yüküyle başladınız!"}
    })
    print(("^3[Tırcılık]^7 | Oyuncu %d tırcılık işine başladı"):format(src))
end)

RegisterNetEvent('tiryakicilik:deliver')
AddEventHandler('tiryakicilik:deliver', function(distance)
    local src = source
    local basePay = 150
    local distanceBonus = math.floor(distance / 10)
    local totalPay = basePay + distanceBonus
    
    TriggerEvent('money:add', totalPay, "TIRYAKICILIK")
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 128, 0},
        args = {"TIR ŞOFÖRÜ", "Teslimat başarılı! +" .. totalPay .. "$"}
    })
    print(("^3[Tırcılık]^7 | Oyuncu %d $%s kazandı (km: %d)"):format(src, totalPay, distance))
end)

RegisterNetEvent('tiryakicilik:crash')
AddEventHandler('tiryakicilik:crash', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 0, 0},
        args = {"TIR ŞOFÖRÜ", "Tırı kırdınız! İşe baştan başlayın"}
    })
    print(("^1[Tırcılık]^7 | Oyuncu %d kaza yaptı"):format(src))
end)
