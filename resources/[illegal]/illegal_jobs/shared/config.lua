-- İllegal Meslekler Konfigürasyonu
IllegalConfig = {
    drug_production = {
        time_seconds = 10,
        profit_per_unit = 500,
        police_risk = 30  -- % yakalanma şansı
    },
    
    robbery = {
        police_risk = 40,
        min_reward = 3000,
        max_reward = 10000
    },
    
    mining = {
        ore_min = 100,
        ore_max = 500,
        gold_price = 15  -- gram başına fiyat
    },
    
    weapons = {
        {name = "pistol", price = 5000, hash = "WEAPON_PISTOL"},
        {name = "smg", price = 8000, hash = "WEAPON_SMG"},
        {name = "rifle", price = 15000, hash = "WEAPON_ASSAULTRIFLE"}
    }
}

return IllegalConfig
