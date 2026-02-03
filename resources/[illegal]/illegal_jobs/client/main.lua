-- İllegal Meslekler Client
RegisterCommand('startcocaine', function()
    print("^1[UYUŞTURUCU]^7")
    print("Üretim başladı...")
    print("İşlemçı bitirmen ve polis gelmeleri riski var (30%)")
    
    TriggerServerEvent('illegal:produceCocaine')
end)

RegisterCommand('robbery', function()
    print("^1[SOYGUN]^7")
    print("Soygun başladı...")
    print("Yakalanma riski: 40%")
    
    TriggerServerEvent('illegal:robbery')
end)

RegisterCommand('mining', function()
    print("^1[MADENCILIK]^7")
    print("Altın çıkarmaya başladı...")
    
    TriggerServerEvent('illegal:mining')
end)

print("^1[İllegal Meslekler]^7 Client yüklendi")
print("Komutlar: /startcocaine, /robbery, /mining")
