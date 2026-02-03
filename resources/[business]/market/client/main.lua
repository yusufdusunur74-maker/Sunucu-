-- Market Client
RegisterCommand('market', function()
    OpenMarketMenu()
end)

function OpenMarketMenu()
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {"MARKET", "Mevcut ürünler:"}
    })
    
    for _, item in ipairs(MarketConfig.items) do
        print(("  %d. %s - $%d"):format(item.id, item.name, item.price))
    end
    
    print("Satın almak için: /buy [ürün_id] [miktar]")
end

RegisterCommand('buy', function(source, args)
    if args[1] and args[2] then
        local itemId = tonumber(args[1])
        local count = tonumber(args[2])
        TriggerServerEvent('market:buyItem', itemId, count)
    else
        print("Kullanım: /buy [ürün_id] [miktar]")
        print("Örn: /buy 1 5 (5 adet su satın al)")
    end
end)

-- Market Lokasyonlarında Kontrol
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for _, market in ipairs(MarketConfig.markets) do
            local distance = #(playerCoords - vector3(market.x, market.y, market.z))
            
            if distance < market.distance then
                if distance < 1.5 then
                    TriggerEvent('chat:addMessage', {
                        color = {0, 255, 0},
                        args = {"MARKET", "Alışveriş yapmak için [E] tuşuna basın"}
                    })
                    
                    if IsControlJustReleased(0, 38) then -- E tuşu
                        OpenMarketMenu()
                    end
                end
            end
        end
        
        Wait(500)
    end
end)

print("^2[Market]^7 Client yüklendi")
