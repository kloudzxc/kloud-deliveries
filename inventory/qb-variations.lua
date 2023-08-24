local qbVariations = {"qb-inventory", "ps-inventory", "lj-inventory"}
local Inventory = exports["qb-inventory"]
local foundInv = nil

for i = 1, #qbVariations do
    if GetResourceState(qbVariations[i]) ~= "started" then
        if i == #qbVariations then
            if not foundInv then
                return
            end
        end
    else
        foundInv = qbVariations[i]
        Inventory = exports[qbVariations[i]]
    end
end


AddItem = function(inv, item, amount, metadata)
    if Inventory:AddItem(inv, item, amount, false, metadata) then
        for i = 1, amount do
            TriggerClientEvent('inventory:client:ItemBox', inv, QBCore.Shared.Items[item], 'add')
        end
        return true
    end
    return false
end

RemoveItem = function(inv, item, amount, metadata, slot)
    if Inventory:RemoveItem(inv, item, amount, slot) then
        for i = 1, amount do
            TriggerClientEvent('inventory:client:ItemBox', inv, QBCore.Shared.Items[item], 'remove')
        end
        return true
    end
    return false
end

GetItemCount = function(inv, item)
    if #Inventory:GetItemsByName(inv, item) >= 1 then return true end
    return false
end

