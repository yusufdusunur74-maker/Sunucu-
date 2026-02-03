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

-- Job pay config persistence
local paysFile = 'resources/[jobs]/job_system/data/job_pays.json'
local JobPays = {}

local function loadPays()
    local f = io.open(paysFile, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local ok, data = pcall(function() return json.decode(content) end)
        if ok and data then JobPays = data end
    else
        JobPays = {}
    end
end

local function savePays()
    local f = io.open(paysFile, 'w')
    if f then f:write(json.encode(JobPays)); f:close() end
end

loadPays()

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

    -- override from JobPays if exists
    if JobPays[jobName] then
        earnings = tonumber(JobPays[jobName]) or earnings
    else
        if jobName == "ciftcilik" then
            earnings = 120
        elseif jobName == "balikcilik" then
            earnings = 140
        end
    end
    
    TriggerEvent('money:add', earnings, jobName:upper())
    PlayerJobs[src].earnings = PlayerJobs[src].earnings + earnings
    
    print(("^2[%s]^7 | Oyuncu %d $%s kazandı"):format(jobName:upper(), src, earnings))
end)

-- Admin command to set job pay
RegisterCommand('setjobpay', function(source, args)
    local src = source
    -- admin check
    if src ~= 0 and not IsPlayerAceAllowed(src, 'admin') then return end
    if #args < 2 then
        if src ~= 0 then TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /setjobpay <job> <amount>'} }) end
        return
    end
    local job = tostring(args[1])
    local amount = tonumber(args[2]) or 0
    JobPays[job] = amount
    savePays()
    if src ~= 0 then TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('%s meslek kazancı $%s olarak ayarlandı'):format(job, amount)} }) end
end, true)

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
