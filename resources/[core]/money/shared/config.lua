-- Para Sistemi Konfigürasyonu
MoneyConfig = {
    -- Başlangıç Parası
    startMoney = 5000,
    
    -- Para Limitleri
    maxCash = 999999999,
    maxBank = 999999999,
    
    -- Banka İşlemleri
    transferFee = 0, -- Transfer ücreti (%)
    
    -- Mesleklerin Ücretleri
    jobs = {
        tiryakicilik = {
            minWage = 100,
            maxWage = 500,
            payPerAction = 150
        },
        ciftcilik = {
            minWage = 80,
            maxWage = 400,
            payPerAction = 120
        },
        balikcilik = {
            minWage = 90,
            maxWage = 450,
            payPerAction = 140
        }
    }
}

-- Banka Sistemi Konfigürasyonu
BankConfig = {
    -- Banka Konumları
    locations = {
        {
            name = "Merkez Banka",
            x = 151.0,
            y = -883.0,
            z = 24.4,
            heading = 340.0
        },
        {
            name = "İtfaiye İstasyonu Banka",
            x = 228.14,
            y = -903.57,
            z = 24.39,
            heading = 340.0
        }
    },
    
    -- Para Transfers Ücreti
    transferFee = 0,
    
    -- Atm Konumları
    atms = {
        {x = 149.0, y = -890.0, z = 24.4},
        {x = 230.0, y = -900.0, z = 24.4},
        {x = 314.3, y = -279.0, z = 44.9},
        {x = 1165.0, y = -324.5, z = 69.2}
    }
}

return {
    MoneyConfig = MoneyConfig,
    BankConfig = BankConfig
}
