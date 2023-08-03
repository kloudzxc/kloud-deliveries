if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

PlayerJob = {}
onDuty = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerJob = xPlayer
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	PlayerJob = {}
end)

RegisterNetEvent("esx:setJob", function(job)
    PlayerJob.job = job
end)

RegisterNetEvent("kloud-deliveries:client:jobmenu", function(data)
    if Delivery.Menu == "ox" then
        if PlayerJob.job.grade >= data.jobLevel then 
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
    end
end)