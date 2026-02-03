-- Banka Client Script
local inBankMenu = false
local bankOpen = false

-- Banka Menüsü Aç
function OpenBankMenu()
    SendNuiMessage(json.encode({
        type = "open",
        amount = 0
    }))
    SetNuiFocus(true, true)
    bankOpen = true
end

-- Banka Menüsü Kapat
function CloseBankMenu()
    SendNuiMessage(json.encode({
        type = "close"
    }))
    SetNuiFocus(false, false)
    bankOpen = false
end

-- NUI Callback
RegisterNuiCallback('bankAction', function(data, cb)
    local action = data.action
    local amount = data.amount
    
    if action == "deposit" then
        TriggerServerEvent('bank:deposit', amount)
    elseif action == "withdraw" then
        TriggerServerEvent('bank:withdraw', amount)
    elseif action == "transfer" then
        TriggerServerEvent('bank:transferMoney', data.targetId, amount)
    elseif action == "close" then
        CloseBankMenu()
    end
    
    cb('ok')
end)

-- Banka Bildirim
RegisterNetEvent('bank:notification')
AddEventHandler('bank:notification', function(title, message)
    print(("^3[%s]^7 %s"):format(title, message))
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"BANKA", message}
    })
end)

RegisterNetEvent('bank:receiveIban')
AddEventHandler('bank:receiveIban', function(iban)
    TriggerEvent('chat:addMessage', { args = { 'BANKA', 'IBAN: ' .. tostring(iban) } })
end)

RegisterCommand('iban', function()
    TriggerServerEvent('bank:getIban')
end, false)

-- Banka Lokasyonlarında Kontrol
Citizen.CreateThread(function()
    local BankConfig = {
        locations = {
            {x = 151.0, y = -883.0, z = 24.4},
            {x = 228.14, y = -903.57, z = 24.39}
        }
    }
    
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isNearBank = false
        
        for _, location in ipairs(BankConfig.locations) do
            local distance = #(playerCoords - vector3(location.x, location.y, location.z))
            if distance < 5.0 then
                isNearBank = true
                if distance < 3.0 then
                    TriggerEvent('chat:addMessage', {
                        color = {0, 255, 0},
                        multiline = true,
                        args = {"BANKA", "Bankaya girmek için [E] tuşuna basın"}
                    })
                    
                    if IsControlJustReleased(0, 38) then -- E tuşu
                        OpenBankMenu()
                    end
                end
            end
        end
        
        if not isNearBank then
            Wait(500)
        end
    end
end)
