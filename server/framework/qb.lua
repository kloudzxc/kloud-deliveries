if GetResourceState("qb-core") ~= "started" then return end
print("Using QBCore Framework")

QBCore = exports['qb-core']:GetCoreObject()

GetPlayer = function (src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player
end

RemoveMoney = function (src, type, amount, reason)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.Functions.RemoveMoney(type, amount, reason)
end

AddMoney = function (src, type, amount, reason)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.Functions.AddMoney(type, amount, reason)
end

AddJobMoney = function(job, amount)
    exports['qb-management']:AddMoney(job, amount)
end