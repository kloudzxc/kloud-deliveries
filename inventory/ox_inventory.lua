if GetResourceState('ox_inventory') ~= 'started' then return end

Inventory = exports.ox_inventory

AddItem = function (inv, item, amount)
    return Inventory:AddItem(inv, item, amount)
end

RemoveItem = function (inv, item, amount)
    return Inventory:RemoveItem(inv, item, amount)
end

GetItemCount = function (inv, item, metadata, strict)
    return Inventory:GetItemCount(inv, item, metadata, strict)
end

GetInventoryItems = function (inv)
    return Inventory:GetInventoryItems(inv)
end

CanCarryItem = function (inv, itemName, amount, metadata)
    return Inventory:CanCarryItem(inv, itemName, amount, metadata)
end

GetSlotWithItem = function(inv, itemName, metadata, strict)
    return Inventory:GetSlotWithItem(inv, itemName, metadata, strict)
end

RegisterStash = function(id, label, slots, weight, owner)
    Inventory:RegisterStash(id, label, slots, weight, owner)
end