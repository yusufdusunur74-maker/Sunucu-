-- ATM UI Handler
RegisterNuiCallback('atmAction', function(data, cb)
    if data.action == "withdraw" then
        TriggerServerEvent('bank:withdraw', data.amount)
    elseif data.action == "deposit" then
        TriggerServerEvent('bank:deposit', data.amount)
    end
    cb('ok')
end)
