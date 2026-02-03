-- Admin Menü Client
local adminMenuOpen = false

RegisterNetEvent('admin:openMenu')
AddEventHandler('admin:openMenu', function()
    adminMenuOpen = true
    OpenAdminMenu()
end)

function OpenAdminMenu()
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"ADMIN MENU", "Admin menüsü açıldı"}
    })
    
    print("^1╔════════════════════════════════════════╗^7")
    print("^1║          ADMIN MENÜ                    ║^7")
    print("^1╠════════════════════════════════════════╣^7")
    print("^2✓^7 Oyuncu Yönetimi")
    print("^2✓^7 Sunucu Yönetimi")
    print("^2✓^7 Araç Yönetimi")
    print("^2✓^7 İstatistikler")
    print("^1║                                        ║^7")
    print("^1║ Komutlar:                              ║^7")
    print("^3/givemoney [miktar]^7 - Para ver")
    print("^3/givecar [model]^7 - Araç ver")
    print("^3/kick [ID]^7 - Oyuncuyu at")
    print("^3/ban [ID]^7 - Oyuncuyu yasakla")
    print("^1╚════════════════════════════════════════╝^7")
end

-- Araç Verme Komutu
RegisterCommand('givecar', function(source, args)
    if args[1] then
        local model = args[1]
        TriggerServerEvent('admin:givecar', model)
    end
end)

RegisterNetEvent('admin:giveCarClient')
AddEventHandler('admin:giveCarClient', function(modelName)
    local model = GetHashKey(modelName)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = CreateVehicle(model, coords.x + 3, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {"ADMIN", "Araç aldınız: " .. modelName}
    })
    
    print(("Araç oluşturuldu: %s"):format(modelName))
end)
