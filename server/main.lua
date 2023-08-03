AddEventHandler("onResourceStart", function(resource)
    if GetCurrentResourceName() == resource then
        for k,v in pairs(Delivery.Locations) do
            RegisterStash("delivery_"..k, v.Job.."-"..k, Delivery.MaxSlots, 15000, false)
        end
    end
end)

lib.callback.register('kloud-deliveries:callback:checkitem', function(source, data)
    local src = source
    local itemName = data.item
    local itemStash
    if data.type == "delivery" then
        itemStash = GetInventoryItems("delivery_"..data.id)
    else
        itemStash = GetInventoryItems(src)
    end

    for _, data in pairs(itemStash) do
        if data.name == itemName then  
            if not data.metadata.durability and Delivery.Decay then return end

            if data.metadata.durability > 0 then
                return true
            end
        end
    end

    return false
    
end)

lib.callback.register('kloud-deliveries:callback:checkdelivery', function(source)
    local src = source
    local itemName = Delivery.Item
    local data = GetSlotWithItem(src, itemName, {}, false)

    if not data then SVNotify(src, "You don't have the food", "error") return false end

    if not data.metadata and Delivery.Decay then SVNotify(src, "An error occured", "error") return false end

    if data.metadata.durability > 0 then
        return true
    else
        SVNotify(src, "You can't deliver expired food!", "error")
        return false
    end
end)

RegisterNetEvent('kloud-deliveries:server:start', function(data)
    local src = source
    local Player = GetPlayer(src)
    local itemName = Delivery.Item
    local itemSlot = GetSlotWithItem("delivery_"..data.id, itemName, {}, false)

    if not RemoveMoney(src, "cash", Delivery.Fee, "Delivery Job Fee") then
        SVNotify(src, "You don't have enough money", "error")
        return
    end

    -- for some reason I can't get the SwapSlots function to work so I used this instead
    -- itemSlot gets all the necessary data then this check will remove the item
    if not RemoveItem("delivery_"..data.id, itemName, 1, itemSlot.metdata, itemSlot.slot) then return end
    -- then will add the item to player's inventory. this is basically swapping the items but not the short way
    if not AddItem(src, itemName, 1, itemSlot.metdata) then return end

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
    local itemName = data.item or Delivery.RequiredItem
    local Player = GetPlayer(src)
    local itemSlot = GetSlotWithItem(src, itemName, {}, false)

    if not CanCarryItem("delivery_"..data.id, itemName, 1, {}) then 
        SVNotify(src, "Not enough space left in the order storage", "error")
        return
    end

    if not RemoveItem(src, itemName, 1, itemSlot.metdata, itemSlot.slot) then return end

    if not AddItem("delivery_"..data.id, "delivery_food", 1, itemSlot.metdata) then return end

    if Delivery.JobReward.Enabled then
        if not AddMoney(src, "cash", Delivery.JobReward.EmployeeReward, "Add Stock Reward") then
            SVNotify(src, "An error occured", "error")
            return
        end
        if Delivery.JobReward.Society then
            print(data.job)
            exports['qb-management']:AddMoney(data.job, Delivery.JobReward.SocietyReward)
        end
    end
end)