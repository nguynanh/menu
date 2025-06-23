local QBCore = exports['qb-core']:GetCoreObject()

-- Open UI
RegisterNetEvent('itemmenu:openUi', function(items)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'setItems',
        items = items
    })
    SendNUIMessage({ action = "openUI" })
end)

-- Nhận yêu cầu spawn item từ NUI và gửi lên server
RegisterNUICallback('spawnItem', function(data, cb)
    if data.itemName and data.amount and tonumber(data.amount) > 0 then
        TriggerServerEvent('itemmenu:spawnItem', data)
        cb('ok')
    else
        cb('error: invalid data')
    end
end)

-- Close UI
RegisterNUICallback('closeUI', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)