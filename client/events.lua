RegisterNetEvent("kloud-deliveries:client:checkdeliveries", function(data)
    if cooldownTime > 0 then Notify("You're still in cooldown homie, wait for "..cooldownTime.." seconds", "error") isBusy = false return end

    if inJob then Notify("You already have a pending delivery", "error") isBusy = false return end
    
    local hasItem = lib.callback.await('kloud-deliveries:callback:checkitem', false, data)

    if not hasItem then Notify("There's no food ready for delivery", "error") isBusy = false return end


    if Delivery.Ped.Enabled then
        lib.requestAnimDict("mp_common")
        TaskPlayAnim(DeliveryPed[data.id], "mp_common", "givetake1_b", 3.0, 3.0, -1, 16, 0, false, false, false)
    end

    if Progress(2000, "Taking Order", "mp_common", "givetake1_a") then
        isBusy = false
        TriggerServerEvent('kloud-deliveries:server:start', data)
        return
    end
end)

RegisterNetEvent("kloud-deliveries:client:openstash", function(data)
    exports.ox_inventory:openInventory('stash', {id = "delivery_"..data.id})
end)

RegisterNetEvent("kloud-deliveries:client:addstock", function(data)
    local hasItem = lib.callback.await("kloud-deliveries:callback:checkitem", false, data)
    if not hasItem then Notify("You don't have the required item", "error") return end
    lib.requestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    TaskPlayAnim(cache.ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 3.0, 3.0, -1, 16, 0, false, false, false)
    
    local success = SkillCheck({"medium", "medium", "medium"})
    if not success then ClearPedTasks(cache.ped) return end
    ClearPedTasks(cache.ped)

    TriggerServerEvent("kloud-deliveries:server:convert", data)
end)

RegisterNetEvent("kloud-deliveries:client:start", function()
    StartDelivery()
end)

RegisterNetEvent("kloud-deliveries:client:deliver", function()
    EndDelivery()
end)

AddEventHandler("onResourceStop", function(resource)
    if GetCurrentResourceName() == resource then
        Clear()
    end
end)