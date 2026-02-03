-- Market Konfigürasyonu
MarketConfig = {
    -- Market Lokasyonları
    markets = {
        {
            name = "Merkez Market",
            x = 24.0,
            y = -883.0,
            z = 29.4,
            heading = 340.0,
            distance = 2.0
        },
        {
            name = "Kırsal Market",
            x = 1141.0,
            y = -783.0,
            z = 57.6,
            heading = 340.0,
            distance = 2.0
        }
    },
    
    -- Satılan Ürünler
    items = {
        {id = 1, name = "Su", price = 5, max = 50},
        {id = 2, name = "Sandviç", price = 15, max = 30},
        {id = 3, name = "Peynir", price = 20, max = 20},
        {id = 4, name = "Ekmek", price = 8, max = 40},
        {id = 5, name = "Elma", price = 10, max = 35},
        {id = 6, name = "Çikolata", price = 12, max = 25},
        {id = 7, name = "Tütün", price = 30, max = 15},
        {id = 8, name = "Soda", price = 7, max = 60},
    }
}

return MarketConfig
