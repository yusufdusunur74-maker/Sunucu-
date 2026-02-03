-- Admin Menü Server
RegisterCommand('admin', function(source, args, rawCommand)
    TriggerClientEvent('admin:openMenu', source)
    print(("^2[Admin]^7 Oyuncu %d admin menüsünü açtı"):format(source))
end, true)

local json = json

-- Helpers
local function isAdmin(src)
    if src == 0 then return true end
    return IsPlayerAceAllowed(src, 'admin')
end

-- Data files
local dataPath = 'resources/[admin]/admin_menu/data'
local housesFile = dataPath .. '/houses.json'
local salariesFile = dataPath .. '/salaries.json'
local unionsFile = dataPath .. '/unions.json'

local Houses = {}
local Salaries = {}
local Unions = {}

local function loadJSON(path)
    local f = io.open(path, 'r')
    if not f then return nil end
    local content = f:read('*a')
    f:close()
    local ok, data = pcall(function() return json.decode(content) end)
    if ok and data then return data end
    return nil
end

local function saveJSON(path, tbl)
    local f = io.open(path, 'w')
    if not f then return false end
    f:write(json.encode(tbl))
    f:close()
    return true
end

-- load persisted
local function loadAll()
    Houses = loadJSON(housesFile) or {}
    Salaries = loadJSON(salariesFile) or {}
    Unions = loadJSON(unionsFile) or {}
end

local function saveAll()
    saveJSON(housesFile, Houses)
    saveJSON(salariesFile, Salaries)
    saveJSON(unionsFile, Unions)
end

loadAll()

-- Give house command
RegisterCommand('givehouse', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 2 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /givehouse <playerId> <houseId>'} })
        return
    end
    local target = tonumber(args[1])
    local houseId = tostring(args[2])
    if not target then return end
    local ident = GetPlayerIdentifiers(target)[1]
    if not ident then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Geçersiz hedef oyuncu.'} })
        return
    end
    Houses[houseId] = ident
    saveJSON(housesFile, Houses)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('%s id li eve sahiplik verildi: Oyuncu %d'):format(houseId, target)} })
    TriggerClientEvent('chat:addMessage', target, { args = {'ADMIN', ('%s id li ev size verildi.'):format(houseId)} })
end, true)

RegisterCommand('removehouse', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /removehouse <houseId>'} })
        return
    end
    local houseId = tostring(args[1])
    Houses[houseId] = nil
    saveJSON(housesFile, Houses)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('%s id li evin sahipliği kaldırıldı.'):format(houseId)} })
end, true)

RegisterCommand('houseinfo', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /houseinfo <houseId>'} })
        return
    end
    local houseId = tostring(args[1])
    local ident = Houses[houseId]
    if not ident then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Bu evin sahibi yok.'} })
        return
    end
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('%s id li ev sahibi: %s'):format(houseId, ident)} })
end, true)

-- Salary management
RegisterCommand('setsalary', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 2 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /setsalary <playerId> <amount>'} })
        return
    end
    local target = tonumber(args[1])
    local amount = tonumber(args[2]) or 0
    if not target then return end
    local ident = GetPlayerIdentifiers(target)[1]
    Salaries[ident] = amount
    saveJSON(salariesFile, Salaries)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('Oyuncu %d maaşı $%s olarak ayarlandı'):format(target, amount)} })
end, true)

RegisterCommand('getsalary', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /getsalary <playerId>'} })
        return
    end
    local target = tonumber(args[1])
    if not target then return end
    local ident = GetPlayerIdentifiers(target)[1]
    local amt = Salaries[ident] or 0
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('Oyuncu %d maaşı: $%s'):format(target, amt)} })
end, true)

-- Unions (birlik) management
RegisterCommand('createunion', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /createunion <name>'} })
        return
    end
    local name = tostring(args[1])
    if Unions[name] then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Aynı isimde birlik zaten var.'} })
        return
    end
    Unions[name] = { members = {}, leader = nil, funds = 0 }
    saveJSON(unionsFile, Unions)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('Birlik oluşturuldu: %s'):format(name)} })
end, true)

RegisterCommand('deleteunion', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /deleteunion <name>'} })
        return
    end
    local name = tostring(args[1])
    Unions[name] = nil
    saveJSON(unionsFile, Unions)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('Birlik silindi: %s'):format(name)} })
end, true)

RegisterCommand('unionadd', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 2 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /unionadd <name> <playerId>'} })
        return
    end
    local name = tostring(args[1])
    local target = tonumber(args[2])
    if not Unions[name] then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Birlik bulunamadı.'} })
        return
    end
    local ident = GetPlayerIdentifiers(target)[1]
    table.insert(Unions[name].members, ident)
    saveJSON(unionsFile, Unions)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('Oyuncu %d birlik %s üyeliğine eklendi'):format(target, name)} })
end, true)

RegisterCommand('unionremove', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 2 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /unionremove <name> <playerId>'} })
        return
    end
    local name = tostring(args[1])
    local target = tonumber(args[2])
    if not Unions[name] then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Birlik bulunamadı.'} })
        return
    end
    local ident = GetPlayerIdentifiers(target)[1]
    for i, v in ipairs(Unions[name].members) do
        if v == ident then
            table.remove(Unions[name].members, i)
            break
        end
    end
    saveJSON(unionsFile, Unions)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('Oyuncu %d birlik %s üyeliğinden çıkarıldı'):format(target, name)} })
end, true)

RegisterCommand('unioninfo', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /unioninfo <name>'} })
        return
    end
    local name = tostring(args[1])
    local u = Unions[name]
    if not u then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Birlik bulunamadı.'} })
        return
    end
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('Birlik: %s | Lider: %s | Üyeler: %d | Bakiye: $%s'):format(name, tostring(u.leader or 'Yok'), #u.members, tostring(u.funds or 0))} })
end, true)

RegisterCommand('setunionincome', function(source, args)
    local src = source
    if not isAdmin(src) then return end
    if #args < 2 then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Kullanım: /setunionincome <name> <amount>'} })
        return
    end
    local name = tostring(args[1])
    local amount = tonumber(args[2]) or 0
    if not Unions[name] then
        TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', 'Birlik bulunamadı.'} })
        return
    end
    Unions[name].funds = amount
    saveJSON(unionsFile, Unions)
    TriggerClientEvent('chat:addMessage', src, { args = {'ADMIN', ('%s birlik geliri $%s olarak ayarlandı'):format(name, amount)} })
end, true)

print("^2[Admin Menü]^7 Yüklendi")
