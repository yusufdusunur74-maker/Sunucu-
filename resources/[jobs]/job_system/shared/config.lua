-- Meslek Sistemi Konfigürasyonu
JobConfig = {
    -- Başlangıç Konumu
    spawnPoint = {
        x = 152.0,
        y = -888.0,
        z = 24.4,
        heading = 340.0
    },
    
    -- Meslekler
    jobs = {
        tiryakicilik = {
            label = "Tırcılık",
            description = "Tırcılık yaparak para kazan",
            pay = 150,
            color = {r = 255, g = 128, b = 0}
        },
        ciftcilik = {
            label = "Çiftçilik",
            description = "Çiftçilik yaparak para kazan",
            pay = 120,
            color = {r = 34, g = 139, b = 34}
        },
        balikcilik = {
            label = "Balıkçılık",
            description = "Balıkçılık yaparak para kazan",
            pay = 140,
            color = {r = 0, g = 128, b = 255}
        }
    }
}
