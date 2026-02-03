RegisterNetEvent('inventory:show')
AddEventHandler('inventory:show', function(inv)
  if not inv then
    TriggerEvent('chat:addMessage', { args = { 'Inventory', 'Envanter boş.' } })
    return
  end
  TriggerEvent('chat:addMessage', { args = { 'Inventory', '--- Envanter ---' } })
  for k,v in pairs(inv) do
    TriggerEvent('chat:addMessage', { args = { 'Inventory', k .. ': ' .. tostring(v) } })
  end
end)

RegisterCommand('inv', function()
  TriggerServerEvent('inventory:request')
end, false)
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
    elseif data.action == 'dropItem' then
        TriggerServerEvent('inventory:removeItem', data.itemName, data.count or 1)
    elseif data.action == 'trunkWithdraw' then
        TriggerServerEvent('inventory:trunkWithdraw', data.plate, data.itemName, data.count or 1)
    elseif data.action == 'stashWithdraw' then
        TriggerServerEvent('inventory:stashWithdraw', data.stashId, data.itemName, data.count or 1)
    end
    cb('ok')
end)

-- UI'yi sunucudan açma (trunk/stash)
RegisterNetEvent('inventory:openTrunkUI')
AddEventHandler('inventory:openTrunkUI', function(trunkData)
    SendNuiMessage(json.encode({type = 'openTrunkUI', data = trunkData}))
    SetNuiFocus(true, true)
    inventoryOpen = true
end)

RegisterNetEvent('inventory:openStashUI')
AddEventHandler('inventory:openStashUI', function(stashData)
    SendNuiMessage(json.encode({type = 'openStashUI', data = stashData}))
    SetNuiFocus(true, true)
    inventoryOpen = true
end)

-- Başlat
TriggerServerEvent('inventory:initialize')

print("^2[Envanter]^7 Client yüklendi")

RegisterNetEvent('inventory:notify')
AddEventHandler('inventory:notify', function(msg)
    TriggerEvent('chat:addMessage', { args = { 'Envanter', msg } })
    SendNuiMessage(json.encode({ type = 'notification', message = msg }))
end)
