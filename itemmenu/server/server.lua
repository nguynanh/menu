local QBCore = exports['qb-core']:GetCoreObject()
local Items = {}

-- Hàm để tải và xử lý danh sách item từ qb-core
local function loadItems()
    local itemsPath = GetResourcePath('qb-core') .. '/shared/items.lua'
    local itemsFileContent = LoadResourceFile('qb-core', 'shared/items.lua')

    if not itemsFileContent then
        print('^1[itemmenu] ERROR: Could not load items.lua from qb-core. Is qb-core started?^7')
        return
    end

    -- Thực thi file lua để lấy table QBCore.Shared.Items
    local success, itemsTable = pcall(load(itemsFileContent))
    if not success or type(itemsTable) ~= 'table' then
        print('^1[itemmenu] ERROR: Failed to parse items.lua. Please check the file for errors.^7')
        return
    end

    -- Chuyển đổi table phức tạp thành một danh sách đơn giản cho UI
    Items = {} -- Xóa danh sách cũ
    for name, data in pairs(itemsTable) do
        if type(data) == 'table' then
            table.insert(Items, {
                name = name,
                label = data.label or name,
                description = data.description or '',
                weight = data.weight or 0,
                type = data.type or 'item'
            })
        end
    end
    print('^2[itemmenu] Successfully loaded ' .. #Items .. ' items from QBCore.^7')
end

-- Tải item lần đầu khi script khởi động
loadItems()

-- Đăng ký lệnh để mở menu
lib.addCommand(Config.Command, {
    help = 'Opens Item Spawner Menu',
    restricted = Config.AdminGroups
}, function(source, args, raw)
    TriggerClientEvent('itemmenu:openUi', source, Items)
end)

-- Sự kiện nhận yêu cầu spawn item từ client
RegisterNetEvent('itemmenu:spawnItem', function(data)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local itemName = data.itemName
    local amount = tonumber(data.amount)

    if not player or not itemName or not amount or amount <= 0 then return end

    player.Functions.AddItem(itemName, amount)
    TriggerEvent('itemmenu:logToDiscord', src, data)
end)


-- Sự kiện ghi log Discord
RegisterNetEvent('itemmenu:logToDiscord', function(playerSource, data)
    -- Giữ nguyên phần code discord log từ phiên bản trước
    -- ... (code discord log đã tạo ở câu trả lời trước) ...
end)