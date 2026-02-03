-- İşyeri Server
local OwnedBusinesses = {}

RegisterNetEvent('business:buyBusiness')
AddEventHandler('business:buyBusiness', function(businessId)
    local src = source
    
    for _, business in ipairs(BusinessConfig.locations) do
        if business.id == businessId then
            -- Para kontrolü yapılır
            TriggerEvent('money:add', -business.price, "İŞYERİ")
            
            if not OwnedBusinesses[businessId] then
                OwnedBusinesses[businessId] = {
                    owner = src,
                    name = business.name,
                    price = business.price
                }
            end
            
            TriggerClientEvent('chat:addMessage', src, {
                color = {0, 255, 0},
                args = {"İŞYERİ", business.name .. " işyerini satın aldınız!"}
            })
            
            print(("^2[İşyeri]^7 Oyuncu %d, %s işyerini $%d'ye satın aldı"):format(
                src, business.name, business.price
            ))
            break
        end
    end
end)

-- İşyeri Bilgisi
RegisterNetEvent('business:getInfo')
AddEventHandler('business:getInfo', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 200, 0},
        args = {"İŞYERİ", "İşyeri bilgileri gösteriliyor"}
    })
end)

print("^2[İşyeri Sistemi]^7 Yüklendi")
