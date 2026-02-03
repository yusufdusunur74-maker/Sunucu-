-- Garaj UI Handler
RegisterNuiCallback('garageUI', function(data, cb)
    if data.action == "test" then
        print("Garaj UI aktif")
    end
    cb('ok')
end)
