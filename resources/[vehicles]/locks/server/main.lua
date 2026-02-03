-- Araç Kilit Server
local LockedVehicles = {}

RegisterNetEvent('locks:toggleLock')
AddEventHandler('locks:toggleLock', function(plate)
    local src = source
    
    if LockedVehicles[plate] then
        LockedVehicles[plate] = false
        TriggerClientEvent('chat:addMessage', src, {
            color = {0, 255, 0},
            args = {"ARAÇ", "Araç açıldı"}
        })
    else
        LockedVehicles[plate] = true
        TriggerClientEvent('chat:addMessage', src, {
            color = {0, 255, 0},
            args = {"ARAÇ", "Araç kilitlendi"}
        })
    end
    
    TriggerClientEvent('locks:updateLock', -1, plate, LockedVehicles[plate])
    print(("^2[Kilit]^7 Araç %s - %s"):format(plate, LockedVehicles[plate] and "Kilitli" or "Açık"))
end)

print("^2[Araç Kilit Sistemi]^7 Yüklendi")
