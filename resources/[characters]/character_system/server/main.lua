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
    table.insert(characters[identifier], data)
    saveToDisk()
    TriggerClientEvent('character:sendList', src, characters[identifier])
    print(('[Character] Oyuncu %s yeni karakter oluşturdu'):format(identifier))
  else
    TriggerClientEvent('chat:addMessage', src, { args = {'CHAR', 'Karakter limiti dolu.'} })
  end
end)

-- Karakter seç
RegisterNetEvent('character:select')
AddEventHandler('character:select', function(index)
  local src = source
  local identifier = GetPlayerIdentifiers(src)[1]
  local list = characters[identifier] or {}
  local char = list[index]
  if char then
    TriggerClientEvent('character:load', src, char)
    print(('[Character] Oyuncu %s karakter %d seçti'):format(identifier, index))
  end
end)

-- Oyuncu ayrıldığında veri kaydet
AddEventHandler('playerDropped', function()
  saveToDisk()
end)

print('[Character System] Server yüklendi')
