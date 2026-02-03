-- Balıkçılık Client Script
local fishing = false

RegisterCommand('startfishing', function()
    TriggerServerEvent('balikcilik:castRod')
    print("Balıkçılığa başladınız. Balık tutmak için /catchfish yazın")
    fishing = true
end)

RegisterCommand('catchfish', function()
    if fishing then
        local fishTypes = {"normal", "big", "rare"}
        local random = math.random(1, 3)
        
        if math.random(1, 100) > 30 then
            TriggerServerEvent('balikcilik:fishCaught', fishTypes[random])
        else
            TriggerServerEvent('balikcilik:noFish')
        end
    else
        print("Önce /startfishing yazın")
    end
end)

RegisterCommand('stopfishing', function()
    fishing = false
    print("Balıkçılığı bıraktınız")
end)

-- Test Komutu
RegisterCommand('testbalikcilik', function()
    print("^2[TEST]^7 Balıkçılık mesleği test ediliyor...")
    TriggerEvent('chat:addMessage', {
        color = {0, 128, 255},
        args = {"TEST", "Balıkçılık yüklü ve çalışıyor!"}
    })
end)
