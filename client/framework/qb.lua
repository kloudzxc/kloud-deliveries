if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()
PlayerJob = {}
onDuty = false

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            onDuty = true
        end
    end)
end)

AddEventHandler("onResourceStart", function(resource)
    if GetCurrentResourceName() == resource then
        QBCore.Functions.GetPlayerData(function(PlayerData) 
            PlayerJob = PlayerData.job
        end)
    end
end)

RegisterNetEvent("kloud-deliveries:client:jobmenu", function(data)
    if Delivery.Menu == "ox" then
        if PlayerJob.grade.level >= data.jobLevel then 
            lib.registerContext({
                id = "delivery_"..data.id,
                title = "Delivery Menu",
                options = {
                    {
                        title = "Open Storage",
                        icon = "archive",
                        onSelect = function()
                            exports.ox_inventory:openInventory('stash', {id = "delivery_"..data.id})
                        end
                    },
                    {
                        title = "Add Stock",
                        icon = "bars",
                        onSelect = function()
                            TriggerEvent("kloud-deliveries:client:addstock", data)
                        end
                    },
                }
            })
        else
            lib.registerContext({
                id = "delivery_"..data.id,
                title = "Delivery Menu",
                options = {
                    {
                        title = "Add Stock",
                        icon = "bars",
                        onSelect = function()
                            TriggerEvent("kloud-deliveries:client:addstock", data)
                        end
                    },
                }
            })
        end

        lib.showContext("delivery_"..data.id)
    elseif Delivery.Menu == "qb" then
        exports['qb-menu']:openMenu({{
                header = 'Delivery Menu',
                isMenuHeader = true,
            },
            {
                header = 'Open Storage',
                icon = 'fas fa-archive',
                params = {
                    event = 'kloud-deliveries:client:openstash',
                    args = {
                        id = data.id
                    }
                }
            },
            {
                header = 'Add Stock',
                icon = 'fas fa-bars',
                params = {
                    event = 'kloud-deliveries:client:addstock',
                    args = {
                        id = data.id,
                        job = data.job,
                        item = data.item
                    }
                }
            }, 
        })
    end
end)