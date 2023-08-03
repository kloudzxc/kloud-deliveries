Started = function (name)
    local started = false
    if GetResourceState(name) == 'started' then
        started = true
    else
        started = false
    end
   return started
end

Notify = function (msg, type)
    if Delivery.Notify == "ox" then
        if not Started('ox_lib') then print("You need ox_lib running for the notifications to work") return end 
        if type == "error" then
            lib.notify({
                id = 'error_moneyDelivery',
                title = 'Error',
                description = msg,
                icon = 'ban',
                iconColor = '#C53030'
            })
        elseif type == "success" then
            lib.notify({
                id = 'success_moneyDelivery',
                title = 'Success',
                description = msg,
                icon = 'check',
                iconColor = '#30c56a'
            })
        end
    elseif Delivery.Notify == "qb" then
        TriggerEvent('QBCore:Notify', msg, type)
    elseif Delivery.Notify == "esx" then
        TriggerEvent('esx:showNotification', msg, type)
    end
end

SVNotify = function (source, msg, type)
    if Delivery.Notify == "ox" then
        if type == "error" then
            TriggerClientEvent('ox_lib:notify', source, {
                id = 'error_moneyDelivery',
                title = 'Error',
                description = msg,
                icon = 'ban',
                iconColor = '#C53030'
            })
        elseif type == "success" then
            TriggerClientEvent('ox_lib:notify', source, {
                id = 'success_moneyDelivery',
                title = 'Success',
                description = msg,
                icon = 'check',
                iconColor = '#30c56a'
            })
        end
    elseif Delivery.Notify == "qb" then
        TriggerClientEvent('QBCore:Notify', source, msg, type)
    elseif Delivery.Notify == "esx" then
        TriggerClientEvent('esx:showNotification', source, msg, type)
    end
end

DrawText = function (msg)
    if Delivery.DrawText == 'ox' then
        lib.showTextUI(msg)
    elseif Delivery.DrawText == 'qb' then
        exports['qb-core']:DrawText(msg, Delivery.QBDrawAlignment)
    end
end

HideText = function ()
    if Delivery.DrawText == 'ox' then
        lib.hideTextUI()
    elseif Delivery.DrawText == 'qb' then
        exports['qb-core']:HideText()
    end
end

AddTarget = function (name, coords, radius, infos, options, distance)
    if Delivery.Target == 'qb' then
        Target = exports['qb-target']
        Target:AddCircleZone(name, coords, radius, infos, {
            options = options,
            distance = distance or 1.5
        })
    elseif Delivery.Target == 'ox' then
        Target = exports.ox_target
        Target:addSphereZone({
            coords = coords,
            radius = radius,
            debug = Delivery.Debug,
            drawSprite = true,
            options = options
        })
    end
end

SkillCheck = function (diff)
    if Delivery.SkillCheck == "ox" then
        return lib.skillCheck(diff, {'w', 'a', 's', 'd'})
    end
end

Progress = function (duration, label, dict, clip)
    if Delivery.Progress == "circle" then
        return lib.progressCircle({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
                mouse = false
            },
            anim = {
                dict = dict,
                clip = clip
            },
    
        })
    elseif Delivery.Progress == "bar" then
        return lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
                mouse = false
            },
            anim = {
                dict = dict,
                clip = clip
            }
        })
    end
end

AddBoxZone = function(coords, size, rotation, onEnter, onExit, inside)
    lib.zones.box({
        coords = coords,
        size = size,
        rotation = rotation,
        debug = Delivery.Debug,
        onEnter = onEnter,
        onExit = onExit,
        inside = inside
    })
end