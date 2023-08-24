if GetResourceState('ox_inventory') ~= 'started' then return end

Inventory = exports.ox_inventory

AddItem = function (inv, item, amount, type)
    return Inventory:AddItem(inv, item, amount)
end

RemoveItem = function (inv, item, amount, type)
    return Inventory:RemoveItem(inv, item, amount)
end

GetItemCount = function (inv, item, metadata, strict)
    return Inventory:GetItemCount(inv, item, metadata, strict)
end