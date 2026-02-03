-- Market Server
RegisterNetEvent('market:buyItem')
AddEventHandler('market:buyItem', function(itemId, count)
    local src = source
    
    for _, item in ipairs(MarketConfig.items) do
        if item.id == itemId then
            local totalPrice = item.price * count
            
            -- Para kontrolü yapılır
            TriggerEvent('money:add', -totalPrice, "MARKET")
            TriggerEvent('inventory:addItem', item.name, count)
            
            TriggerClientEvent('chat:addMessage', src, {
                color = {0, 255, 0},
                args = {"MARKET", "Satın aldınız: " .. count .. "x " .. item.name .. " ($" .. totalPrice .. ")"}
            })
            
            print(("^2[Market]^7 Oyuncu %d, %dx %s satın aldı"):format(src, count, item.name))
            break
        end
    end
end)

print("^2[Market Sistemi]^7 Yüklendi")
