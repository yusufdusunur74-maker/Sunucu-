-- Polis Konfigürasyonu
PoliceConfig = {
    stations = {
        {
            name = "Merkez Karakol",
            x = 441.53,
            y = -981.67,
            z = 25.7,
            heading = 270.0
        }
    },
    
    duty_locations = {
        {
            x = 451.0,
            y = -981.0,
            z = 25.7,
            description = "Nöbet Başla"
        }
    },
    
    vehicle_spawn = {
        x = 464.0,
        y = -1017.0,
        z = 25.4,
        heading = 90.0,
        model = "police"
    },
    
    uniform_model = "a_m_m_business_1",
    
    fine_types = {
        speeding = 500,
        reckless = 1000,
        stolen = 2500
    }
}

return PoliceConfig
