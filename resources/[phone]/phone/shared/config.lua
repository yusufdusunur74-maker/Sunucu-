-- Telefon Konfigürasyonu
PhoneConfig = {
    -- Telefon Görünümü
    carrier = "TurkCell",
    appName = "KPhone",
    
    -- Rehber Ön Tanımlıları
    contacts = {
        {name = "Polis", number = "911", type = "emergency"},
        {name = "Ambulans", number = "112", type = "emergency"},
        {name = "Itfaiye", number = "110", type = "emergency"},
        {name = "Banka Müşteri Hizmetleri", number = "1234", type = "service"},
        {name = "Market", number = "5678", type = "service"},
        {name = "Garaj", number = "9012", type = "service"},
    },
    
    -- Telefon Konumları (Düşen telefon gibi)
    pickupLocations = {
        {x = 425.0, y = -983.0, z = 29.4, heading = 340.0}
    }
}

return PhoneConfig
