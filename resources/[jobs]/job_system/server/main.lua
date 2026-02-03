-- Meslek Sistemi Server Script
local PlayerJobs = {}

-- Meslek Seç
RegisterNetEvent('job:setJob')
AddEventHandler('job:setJob', function(jobName)
    local src = source
    
    PlayerJobs[src] = {
        name = jobName,
        startTime = os.time(),
        earnings = 0
    }
    
    TriggerClientEvent('chat:addMessage', src, {
        color = {0, 255, 0},
        multiline = true,
        args = {"İŞ", "Meslek seçildi: " .. jobName}
    })
    
    print(("^2[Meslek Sistemi]^7 | Oyuncu %d meslek seçti: %s"):format(src, jobName))
end)

-- Meslek Kazancı
RegisterNetEvent('job:earn')
AddEventHandler('job:earn', function()
    local src = source
    
    if not PlayerJobs[src] then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"HATA", "Önce bir meslek seçin!"}
        })
        return
    end
    
    local jobName = PlayerJobs[src].name
    local earnings = 150
    
    if jobName == "ciftcilik" then
        earnings = 120
    elseif jobName == "balikcilik" then
        earnings = 140
    end
    
    TriggerEvent('money:add', earnings, jobName:upper())
    PlayerJobs[src].earnings = PlayerJobs[src].earnings + earnings
    
    print(("^2[%s]^7 | Oyuncu %d $%s kazandı"):format(jobName:upper(), src, earnings))
end)

-- Meslekten Ayrıl
RegisterNetEvent('job:quitJob')
AddEventHandler('job:quitJob', function()
    local src = source
    
    if PlayerJobs[src] then
        local earnings = PlayerJobs[src].earnings
        print(("^2[Meslek Sistemi]^7 | Oyuncu %d ayrıldı. Toplam kazanç: $%s"):format(src, earnings))
    end
    
    PlayerJobs[src] = nil
end)

-- Oyuncu Verisi Sorgu
RegisterNetEvent('job:getJobInfo')
AddEventHandler('job:getJobInfo', function()
    local src = source
    if PlayerJobs[src] then
        TriggerClientEvent('job:updateJobInfo', src, PlayerJobs[src])
    end
end)

-- Oyuncu Çıktı
AddEventHandler('playerDropped', function()
    local src = source
    PlayerJobs[src] = nil
end)
