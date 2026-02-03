-- Admin Menü Server
RegisterCommand('admin', function(source, args, rawCommand)
    TriggerClientEvent('admin:openMenu', source)
    print(("^2[Admin]^7 Oyuncu %d admin menüsünü açtı"):format(source))
end, true)

RegisterCommand('kick', function(source, args)
    if args[1] then
        DropPlayer(tonumber(args[1]), "Admin tarafından atıldınız")
    end
end, true)

print("^2[Admin Menü]^7 Yüklendi")
