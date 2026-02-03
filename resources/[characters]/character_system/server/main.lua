-- Karakter sistemi - server
local json = json
local characters = {}

-- Dosya tabanlı saklama yolu
local savePath = ('resources/[characters]/character_system/' .. (CharacterConfig and CharacterConfig.saveFile or 'data/characters.json'))

local function saveToDisk()
  local f, err = io.open(savePath, "w+")
  if not f then
    print(('^1[Character]^7 Kaydetme hatası: %s'):format(tostring(err)))
    return false
  end
  local ok, content = pcall(function() return json.encode(characters) end)
  if not ok then
    f:close()
    print('^1[Character]^7 Json encode hatası')
    return false
  end
  f:write(content)
  f:close()
  return true
end

local function loadFromDisk()
  local f = io.open(savePath, "r")
  if not f then
    characters = {}
    return
  end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(function() return json.decode(content) end)
  if ok and type(data) == 'table' then
    characters = data
  else
    characters = {}
  end
end

-- Başlangıçta yükle
loadFromDisk()

-- Oyuncu bağlanınca karakter listesini gönder (identifier bazlı)
RegisterNetEvent('character:requestList')
AddEventHandler('character:requestList', function()
  local src = source
  local identifier = GetPlayerIdentifiers(src)[1]
  characters[identifier] = characters[identifier] or {}
  TriggerClientEvent('character:sendList', src, characters[identifier])
end)

-- Yeni karakter oluştur (identifier bazlı)
RegisterNetEvent('character:create')
AddEventHandler('character:create', function(data)
  local src = source
  local identifier = GetPlayerIdentifiers(src)[1]
  characters[identifier] = characters[identifier] or {}
  if #characters[identifier] < (CharacterConfig and CharacterConfig.maxCharacters or 4) then
    -- ensure fingerprint exists
    data.fingerprint = data.fingerprint or tostring(math.random(100000,999999))
    table.insert(characters[identifier], data)
    saveToDisk()
    TriggerClientEvent('character:sendList', src, characters[identifier])
    print(('[Character] Oyuncu %s yeni karakter oluşturdu'):format(identifier))
  else
    TriggerClientEvent('chat:addMessage', src, { args = {'CHAR', 'Karakter limiti dolu.'} })
  end
end)

-- Active characters map (source -> active character info)
local PlayersActive = {}

-- Karakter seç
RegisterNetEvent('character:select')
AddEventHandler('character:select', function(index)
  local src = source
  local identifier = GetPlayerIdentifiers(src)[1]
  local list = characters[identifier] or {}
  local char = list[index]
  if char then
    -- set active on server side
    PlayersActive[src] = {
      identifier = identifier,
      index = index,
      name = char.name or 'unknown',
      fingerprint = char.fingerprint
    }

    TriggerClientEvent('character:load', src, char)
    print(('[Character] Oyuncu %s karakter %d seçti'):format(identifier, index))
  end
end)

-- Allow server queries for active character
RegisterNetEvent('character:getActive')
AddEventHandler('character:getActive', function()
  local src = source
  TriggerClientEvent('character:activeInfo', src, PlayersActive[src])
end)

-- Query fingerprint info for a target player src (callback style)
RegisterNetEvent('character:queryFingerprint')
AddEventHandler('character:queryFingerprint', function(targetSrc, cb)
  local info = nil
  if targetSrc and PlayersActive[targetSrc] then
    info = {
      name = PlayersActive[targetSrc].name,
      fingerprint = PlayersActive[targetSrc].fingerprint,
      identifier = PlayersActive[targetSrc].identifier
    }
  end
  if cb then cb(info) end
end)

-- Cleanup on drop
AddEventHandler('playerDropped', function()
  local src = source
  PlayersActive[src] = nil
end)

-- Karakter sil
RegisterNetEvent('character:delete')
AddEventHandler('character:delete', function(index)
  local src = source
  local identifier = GetPlayerIdentifiers(src)[1]
  local list = characters[identifier] or {}
  index = tonumber(index)
  if index and list[index] then
    table.remove(list, index)
    characters[identifier] = list
    saveToDisk()
    TriggerClientEvent('character:sendList', src, list)
    print(('[Character] Oyuncu %s karakter %d sildi'):format(identifier, index))
  end
end)

-- Karakter yeniden adlandır
RegisterNetEvent('character:rename')
AddEventHandler('character:rename', function(index, newName)
  local src = source
  local identifier = GetPlayerIdentifiers(src)[1]
  local list = characters[identifier] or {}
  index = tonumber(index)
  if index and list[index] and newName and type(newName) == 'string' then
    list[index].name = tostring(newName)
    characters[identifier] = list
    saveToDisk()
    TriggerClientEvent('character:sendList', src, list)
    print(('[Character] Oyuncu %s karakter %d adını %s yaptı'):format(identifier, index, newName))
  end
end)

-- Oyuncu ayrıldığında veri kaydet
AddEventHandler('playerDropped', function()
  saveToDisk()
end)

print('[Character System] Server yüklendi')
