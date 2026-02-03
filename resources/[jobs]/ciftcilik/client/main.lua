-- Çiftçilik Client Script
local farming = false

RegisterCommand('startfarming', function()
    TriggerServerEvent('ciftcilik:plantCrop')
    print("Çiftçiliğe başladınız")
    farming = true
end)

RegisterCommand('water', function()
    if farming then
        TriggerServerEvent('ciftcilik:water')
    else
        print("Önce /startfarming yazın")
    end
end)

RegisterCommand('harvest', function()
    if farming then
        TriggerServerEvent('ciftcilik:harvestCrop')
        farming = false
    else
        print("Önce /startfarming yazın")
    end
end)

-- Test Komutu
RegisterCommand('testciftcilik', function()
    print("^2[TEST]^7 Çiftçilik mesleği test ediliyor...")
    TriggerEvent('chat:addMessage', {
        color = {34, 139, 34},
        args = {"TEST", "Çiftçilik yüklü ve çalışıyor!"}
    })
end)
