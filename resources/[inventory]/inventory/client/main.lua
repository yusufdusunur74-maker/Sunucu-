-- Envanter Client
local inventoryOpen = false

RegisterCommand('inventory', function()
    OpenInventory()
end)

function OpenInventory()
    inventoryOpen = true
    SendNuiMessage(json.encode({type = "openInventory"}))
    SetNuiFocus(true, true)
end

RegisterNetEvent('inventory:updateUI')
AddEventHandler('inventory:updateUI', function(inventoryData)
    SendNuiMessage(json.encode({
        type = "updateInventory",
        items = inventoryData.items,
        weight = inventoryData.weight,
        maxWeight = inventoryData.maxWeight
    }))
end)

RegisterNuiCallback('inventoryAction', function(data, cb)
    if data.action == "close" then
        inventoryOpen = false
        SetNuiFocus(false, false)
    elseif data.action == "useItem" then
        TriggerServerEvent('inventory:useItem', data.item)
    end
    cb('ok')
end)

window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && inventoryOpen) {
        inventoryOpen = false
        SetNuiFocus(false, false)
    }
})

-- Başlat
TriggerServerEvent('inventory:initialize')

print("^2[Envanter]^7 Client yüklendi")
