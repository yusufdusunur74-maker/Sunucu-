-- Tırcılık Client Script
local workingTruck = nil
local deliveryActive = false

RegisterCommand('starttrucking', function()
    TriggerServerEvent('tiryakicilik:startWork')
    print("Tırcılığa başladınız. Şimdi bir tır bulun!")
    deliveryActive = true
end)

RegisterCommand('deliver', function(source, args)
    if deliveryActive then
        local distance = tonumber(args[1]) or 50
        TriggerServerEvent('tiryakicilik:deliver', distance)
    else
        print("Önce /starttrucking yazın")
    end
end)

-- Test Komutu
RegisterCommand('testitr', function()
    print("^2[TEST]^7 Tırcılık mesleği test ediliyor...")
    TriggerEvent('chat:addMessage', {
        color = {255, 128, 0},
        args = {"TEST", "Tırcılık yüklü ve çalışıyor!"}
    })
end)
