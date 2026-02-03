-- Envanter Server
local PlayerInventory = {}

-- Envanter Başlat
RegisterNetEvent('inventory:initialize')
AddEventHandler('inventory:initialize', function()
    local src = source
    
    if not PlayerInventory[src] then
        PlayerInventory[src] = {
            items = {},
            maxWeight = 50,
            weight = 0
        }
    end
    
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

-- Eşya Ekle
RegisterNetEvent('inventory:addItem')
AddEventHandler('inventory:addItem', function(itemName, count)
    local src = source
    
    if not PlayerInventory[src] then return end
    
    local item = {name = itemName, count = count, weight = count * 0.5}
    table.insert(PlayerInventory[src].items, item)
    PlayerInventory[src].weight = PlayerInventory[src].weight + item.weight
    
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
    print(("^2[Envanter]^7 Oyuncu %d, %dx %s aldı"):format(src, count, itemName))
end)

-- Eşya Kaldır
RegisterNetEvent('inventory:removeItem')
AddEventHandler('inventory:removeItem', function(itemName, count)
    local src = source
    
    if not PlayerInventory[src] then return end
    
    for i, item in ipairs(PlayerInventory[src].items) do
        if item.name == itemName and item.count >= count then
            item.count = item.count - count
            PlayerInventory[src].weight = PlayerInventory[src].weight - (count * 0.5)
            
            if item.count <= 0 then
                table.remove(PlayerInventory[src].items, i)
            end
            break
        end
    end
    
    TriggerClientEvent('inventory:updateUI', src, PlayerInventory[src])
end)

-- Oyuncu Ayrıldı
AddEventHandler('playerDropped', function()
    local src = source
    PlayerInventory[src] = nil
end)

print("^2[Envanter Sistemi]^7 Yüklendi")
