-- Çekici Client
RegisterCommand('cek', function(source, args)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        print('Araç içinde olun')
        return
    end
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('vehicle:impound', plate, tonumber(args[1]) or 1000)
end)

print('^2[ÇEKİCİ]^7 Client yüklendi')