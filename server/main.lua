MySQL.ready(function()
    local response = MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `kloud_deliveries` (
            `job` varchar(50) NOT NULL,
            `stock` int DEFAULT '0',
            PRIMARY KEY (`job`)
        )]])
    if response then
        for _, v in pairs(Delivery.Locations) do
            MySQL.prepare('INSERT INTO kloud_deliveries (job) VALUES (?) ON DUPLICATE KEY UPDATE job=job', { v.Job }, function()
                print("Inserted/found ".. v.Job .." job in the database.")
            end)
        end
    end
end)

lib.callback.register('kloud-deliveries:callback:checkitem', function(source, data)
    local loc = Delivery.Locations[data.id]
    local currentStock = MySQL.scalar.await('SELECT `stock` FROM `kloud_deliveries` WHERE `job` = ? LIMIT 1', { loc.Job })

    return currentStock >= 1
end)

lib.callback.register('kloud-deliveries:callback:checkdelivery', function(source)
    local src = source
    local data = GetItemCount(src, Delivery.Item) >= 1

    if not data then SVNotify(src, "You don't have the food", "error") return false end

    return true
end)

RegisterNetEvent('kloud-deliveries:server:start', function(data)
    local src = source
    local itemName = Delivery.Item
    local loc = Delivery.Locations[data.id]

    if not RemoveMoney(src, "cash", Delivery.Fee, "Delivery Job Fee") then
        SVNotify(src, "You don't have enough money", "error")
        return
    end

    local newStock = nil
    local currentStock = MySQL.scalar.await('SELECT `stock` FROM `kloud_deliveries` WHERE `job` = ? LIMIT 1', { loc.Job })

    if currentStock == 0 then return false end

    newStock = currentStock - 1

    if newStock == nil then return false end

    if not AddItem(src, itemName, 1) then return end
    MySQL.Async.execute('UPDATE kloud_deliveries SET stock = ? WHERE `job` = ?', {newStock, loc.Job})

    TriggerClientEvent('kloud-deliveries:client:start', src)
end)

RegisterNetEvent('kloud-deliveries:server:done', function()
    local src = source
    local Player = GetPlayer(src)
    local itemName = Delivery.Item
    local reward = math.random(Delivery.Reward.min, Delivery.Reward.max)

    if not RemoveItem(src, itemName, 1) then return end

    if not AddMoney(src, "cash", reward, "Delivery Job Reward") then
        SVNotify(src, "An error occured", "error")
        return
    end
end)

RegisterNetEvent('kloud-deliveries:server:convert', function(data)
    local src = source
    local loc = Delivery.Locations[data.id]
    local itemName = data.item or Delivery.RequiredItem
    local newStock = nil
    local currentStock = MySQL.scalar.await('SELECT `stock` FROM `kloud_deliveries` WHERE `job` = ? LIMIT 1', { loc.Job })

    if currentStock >= loc.MaxStock then
        SVNotify(src, "Not enough space left in the order storage", "error")
        return
    end

    if not RemoveItem(src, itemName, 1) then return end

    newStock = currentStock + 1

    if newStock == nil then return end

    MySQL.Async.execute('UPDATE kloud_deliveries SET stock = ? WHERE `job` = ?', {newStock, loc.Job})

    if Delivery.JobReward.Enabled then
        if not AddMoney(src, "cash", Delivery.JobReward.EmployeeReward, "Add Stock Reward") then
            SVNotify(src, "An error occured", "error")
            return
        end
        if Delivery.JobReward.Society then
            AddJobMoney(data.job, Delivery.JobReward.SocietyReward)
        end
    end
end)