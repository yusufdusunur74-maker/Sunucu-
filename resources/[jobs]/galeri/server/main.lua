-- Galeri Server
local SoldVehicles = {}

RegisterNetEvent('gallery:buyVehicle')
AddEventHandler('gallery:buyVehicle', function(vehicleModel, price)
    local src = source
    price = tonumber(price) or 0
    
    -- Para kontrol
    TriggerEvent('money:getMoney', function(moneyInfo)
        if (moneyInfo.cash + moneyInfo.bank) >= price then
            -- Para düş
            TriggerEvent('money:add', -price, 'gallery')
            
            -- Araç spawn
            TriggerClientEvent('gallery:spawnVehicle', src, vehicleModel)
            
            table.insert(SoldVehicles, {
                buyer = src,
                model = vehicleModel,
                price = price,
                timestamp = os.time()
            })
            
            TriggerClientEvent('chat:addMessage', src, {
                args = {'GALERİ', vehicleModel .. ' araçı satın alındı. $' .. price}
            })
            
            print(("^2[GALERİ]^7 Oyuncu %d %s araçı satın aldı ($%d)"):format(src, vehicleModel, price))
        else
            TriggerClientEvent('chat:addMessage', src, {
                args = {'GALERİ', 'Yeterli paranız yok!'}
            })
        end
    end)
end)

RegisterNetEvent('gallery:testDrive')
AddEventHandler('gallery:testDrive', function(vehicleModel)
    local src = source
    TriggerClientEvent('gallery:spawnTestVehicle', src, vehicleModel)
    
    TriggerClientEvent('chat:addMessage', src, {
        args = {'GALERİ', 'Test sürüşü başladı. 5 dakika sonra otomatik silinecek.'}
    })
end)

print("^2[GALERİ]^7 Sunucu başlatıldı")
