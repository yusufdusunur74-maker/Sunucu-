-- İşyeri Client
RegisterCommand('businesses', function()
    print("^3╔════════════════════════════════════════╗^7")
    print("^3║        AYDA ÇIKARI İŞYERLERİ          ║^7")
    print("^3╠════════════════════════════════════════╣^7")
    
    for _, business in ipairs(BusinessConfig.locations) do
        print(("^2%d. %s^7 - $%d"):format(business.id, business.name, business.price))
    end
    
    print("^3╚════════════════════════════════════════╝^7")
    print("Satın almak için: /buybusiness [id]")
end)

RegisterCommand('buybusiness', function(source, args)
    if args[1] then
        TriggerServerEvent('business:buyBusiness', tonumber(args[1]))
    else
        print("Kullanım: /buybusiness [id]")
    end
end)

-- İşyeri Lokasyonlarında Kontrol
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for _, business in ipairs(BusinessConfig.locations) do
            local distance = #(playerCoords - vector3(business.x, business.y, business.z))
            
            if distance < 3.0 then
                if distance < 1.5 then
                    TriggerEvent('chat:addMessage', {
                        color = {255, 200, 0},
                        args = {"İŞYERİ", business.name .. " - $" .. business.price}
                    })
                    
                    if IsControlJustReleased(0, 38) then -- E tuşu
                        TriggerServerEvent('business:getInfo')
                    end
                end
            end
        end
        
        Wait(500)
    end
end)

print("^2[İşyeri]^7 Client yüklendi")
