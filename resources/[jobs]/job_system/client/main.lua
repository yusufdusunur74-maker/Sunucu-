-- Meslek Sistemi Client Script
local currentJob = nil
local jobActive = false

-- Meslek Menüsü Aç
function OpenJobMenu()
    print("^3[MESLEK MENÜSÜ]^7")
    print("1. Tırcılık ($150)")
    print("2. Çiftçilik ($120)")
    print("3. Balıkçılık ($140)")
    print("Seçmek için /setjob <iş_adı> komutunu kullanın")
end

-- Meslek Komutu
RegisterCommand('setjob', function(source, args)
    local jobName = args[1]
    
    if not jobName then
        print("Kullanım: /setjob <tiryakicilik|ciftcilik|balikcilik>")
        return
    end
    
    TriggerServerEvent('job:setJob', jobName)
    currentJob = jobName
    jobActive = true
end)

-- Meslek Kazan
RegisterCommand('earn', function(source, args)
    if currentJob then
        TriggerServerEvent('job:earn')
    else
        print("Önce bir meslek seçin! /setjob <meslek>")
    end
end)

-- Meslekten Ayrıl
RegisterCommand('quitjob', function(source, args)
    if currentJob then
        TriggerServerEvent('job:quitJob')
        currentJob = nil
        jobActive = false
        print("Meslekten ayrıldınız")
    end
end)

-- Meslek Bilgisi Güncelle
RegisterNetEvent('job:updateJobInfo')
AddEventHandler('job:updateJobInfo', function(jobInfo)
    print(("Meslek: %s | Kazanç: $%s"):format(jobInfo.name, jobInfo.earnings))
end)

-- Başlangıç
Citizen.CreateThread(function()
    Wait(1000)
    print("^2[Meslek Sistemi]^7 Yüklendi. /setjob <meslek> komutunu kullanın")
    OpenJobMenu()
end)
