-- Karakter Client
local charOpen = false

-- Reusable appearance function (top-level)
local function applyAppearance(data)
  Citizen.CreateThread(function()
    local ped = PlayerPedId()

    -- Model değişikliği (opsiyonel)
    if data.model then
      local modelHash = GetHashKey(data.model)
      RequestModel(modelHash)
      local timeout = 2000
      while not HasModelLoaded(modelHash) and timeout > 0 do
        Wait(50)
        timeout = timeout - 50
      end
      if HasModelLoaded(modelHash) then
        SetPlayerModel(PlayerId(), modelHash)
        SetModelAsNoLongerNeeded(modelHash)
        ped = PlayerPedId()
      end
    end

    -- Face
    if data.face then
      local shapeFirstID = tonumber(data.face) or 0
      pcall(function()
        SetPedHeadBlendData(ped, shapeFirstID, shapeFirstID, 0, shapeFirstID, shapeFirstID, 0, 0.5, 0.5, 0.0, true)
      end)
    end

    -- Hair
    if data.hair then
      local hairId = tonumber(data.hair) or 0
      pcall(function()
        SetPedComponentVariation(ped, 2, hairId, 0, 0)
      end)
    end

    -- Weight (scale)
    if data.weight then
      local weight = tonumber(data.weight) or 70
      local scale = math.max(0.8, math.min(1.2, 1.0 + ((weight - 70) / 100)))
      pcall(function()
        SetPedScale(ped, scale)
      end)
    end

    -- Components
    if data.components and type(data.components) == 'table' then
      for compId, compData in pairs(data.components) do
        pcall(function()
          SetPedComponentVariation(ped, tonumber(compId), tonumber(compData.drawable) or 0, tonumber(compData.texture) or 0, 0)
        end)
      end
    end
  end)
end

RegisterCommand('chars', function()
  TriggerServerEvent('character:requestList')
end)

RegisterNetEvent('character:sendList')
AddEventHandler('character:sendList', function(list)
  SendNuiMessage(json.encode({type='openChars', list = list}))
  SetNuiFocus(true, true)
  charOpen = true
end)

RegisterNetEvent('character:load')
AddEventHandler('character:load', function(data)
  applyAppearance(data)
  SetNuiFocus(false, false)
  charOpen = false
  print('[Character] Karakter yüklendi ve görünüm uygulandı')
end)

-- NUI preview callback: sadece görünüm uygular, UI açık kalır
RegisterNUICallback('previewCharacter', function(data, cb)
  applyAppearance(data)
  cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
  TriggerServerEvent('character:create', data)
  cb('ok')
end)

RegisterNUICallback('selectCharacter', function(data, cb)
  TriggerServerEvent('character:select', tonumber(data.index))
  cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
  TriggerServerEvent('character:delete', tonumber(data.index))
  cb('ok')
end)

RegisterNUICallback('renameCharacter', function(data, cb)
  TriggerServerEvent('character:rename', tonumber(data.index), tostring(data.name))
  cb('ok')
end)

print('[Character] Client yüklendi')
