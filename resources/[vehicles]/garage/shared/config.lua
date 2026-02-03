-- Araç Galerisi Konfigürasyonu
GarageConfig = {
    -- Araç Galerilerinin Konumları
    garages = {
        {
            name = "Merkez Garaj",
            x = 221.0,
            y = -937.0,
            z = 24.0,
            heading = 340.0,
            distance = 3.0
        },
        {
            name = "Kırsal Garaj",
            x = 439.0,
            y = 6526.0,
            z = 29.4,
            heading = 340.0,
            distance = 3.0
        },
        {
            name = "Lüks Garaj",
            x = 312.0,
            y = -281.0,
            z = 44.9,
            heading = 340.0,
            distance = 3.0
        }
    },

    -- Satılık Araçlar
    vehicles = {
        -- Standart Araçlar
        {id = 1, model = "blista", name = "Blista", price = 5000, type = "standart"},
        {id = 2, model = "dilettante", name = "Dilettante", price = 8000, type = "standart"},
        {id = 3, model = "issi2", name = "Issi", price = 6000, type = "standart"},
        
        -- Spor Araçları
        {id = 4, model = "banshee2", name = "Banshee", price = 95000, type = "spor"},
        {id = 5, model = "cheetah", name = "Cheetah", price = 120000, type = "spor"},
        {id = 6, model = "t20", name = "T20", price = 250000, type = "spor"},
        
        -- Lüks Araçlar
        {id = 7, model = "oracle", name = "Oracle", price = 150000, type = "lux"},
        {id = 8, model = "rebla", name = "Rebla", price = 180000, type = "lux"},
        {id = 9, model = "schafter5", name = "Schafter", price = 175000, type = "lux"},
        
        -- SUV'lar
        {id = 10, model = "granger", name = "Granger", price = 50000, type = "suv"},
        {id = 11, model = "contender", name = "Contender", price = 80000, type = "suv"},
        {id = 12, model = "kamacho", name = "Kamacho", price = 90000, type = "suv"},
        
        -- Motorcycle'lar
        {id = 13, model = "bagger", name = "Bagger", price = 30000, type = "motor"},
        {id = 14, model = "hakuchou", name = "Hakuchou", price = 45000, type = "motor"},
        {id = 15, model = "shotaro", name = "Shotaro", price = 85000, type = "motor"},
        
        -- Kamyonlar
        {id = 16, model = "pounder", name = "Pounder", price = 40000, type = "kamyon"},
        {id = 17, model = "mule", name = "Mule", price = 25000, type = "kamyon"},
        
        -- Ekonomi Araçları (Kırsal)
        {id = 18, model = "dloader", name = "Dloader", price = 20000, type = "kiral"},
        {id = 19, model = "baller", name = "Baller", price = 60000, type = "kiral"},
    },

    -- Araç Kategorileri
    categories = {
        {name = "Tüm Araçlar", filter = "all"},
        {name = "Standart", filter = "standart"},
        {name = "Spor", filter = "spor"},
        {name = "Lüks", filter = "lux"},
        {name = "SUV", filter = "suv"},
        {name = "Motorsiklet", filter = "motor"},
        {name = "Kamyon", filter = "kamyon"},
        {name = "Kırsal", filter = "kiral"}
    }
}

return GarageConfig
