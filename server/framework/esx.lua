if GetResourceState("es_extended") ~= "started" then return end
print("Using ESX Framework")

ESX = exports["es_extended"]:getSharedObject()

AddMoney = function (src, type, amount)
    local Player = ESX.GetPlayerFromId(src)
    return Player.addAccountMoney(type, amount)
end

RemoveMoney = function (src, type, amount)
    local Player = ESX.GetPlayerFromId(src)
    return Player.removeAccountMoney(type, amount)
end

GetPlayer = function (src)
    return ESX.GetPlayerFromId(src)
end

AddJobMoney = function (job, amount)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
        account.addMoney(amount)
    end)
end