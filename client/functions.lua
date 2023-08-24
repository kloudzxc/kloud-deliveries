local jobTarget
local jobZone
local Blip
inZone = false
isBusy = false
inJob = false
inCooldown = false
cooldownTime = 0
DeliveryPed = {}

if Delivery.Ped.Enabled then
    CreateThread(function()
        for k, v in pairs(Delivery.Locations) do
            local hash = GetHashKey(Delivery.Ped.Model)
            RequestModel(hash)
            while not HasModelLoaded(hash) do Wait(10) end
            DeliveryPed[k] = CreatePed(5, hash, vector3(v.PedLocation.x, v.PedLocation.y, v.PedLocation.z-1), v.PedLocation.w, false, false)
            FreezeEntityPosition(DeliveryPed[k], true)
            SetBlockingOfNonTemporaryEvents(DeliveryPed[k], true)
            SetEntityInvincible(DeliveryPed[k], true)
        end
    end)
end

RegisterPoints = function ()
    for k,v in pairs(Delivery.Locations) do
        if v.Type == "target" then
            AddTarget('kloud-deliveries', v.Location, 0.55, {
                name = 'kloud-deliveries',
                debugPoly = Delivery.Debug,
            }, {
                {
                    event = 'kloud-deliveries:client:checkdeliveries',
                    label = "Deliver Food",
                    name = "kloud-deliveries:checkdeliveries",
                    canInteract = function()
                        if inJob then return false end
                        return true
                    end,
                    icon = "fas fa-archive",
                    id = k,
                    item = Delivery.Item,
                    type = "delivery",
                    distance = 2.5,
                }
            }, 1)
            AddTarget('kloud-deliveries', v.Storage, 0.55, {
                name = 'kloud-deliveries',
                debugPoly = Delivery.Debug,
            }, {
                {
                    event = 'kloud-deliveries:client:jobmenu',
                    label = "Check Stash",
                    name = "kloud-deliveries:jobmenu",
                    icon = "fas fa-archive",
                    job = v.Job,
                    item = v.RequiredItem,
                    id = k,
                    type = "convert",
                    distance = 2.5,
                }
            }, 1)
        else
            lib.zones.box({coords = v.Location, size = v.Size, rotation = v.Rotation, debug = Delivery.Debug,
                onEnter = function ()
                    inZone = true
                    DrawText('[E] Start Delivery')
                end,
                onExit = function ()
                    inZone = false
                    HideText()
                end,
                inside = function ()
                    if IsControlJustPressed(0, 38) and not isBusy then
                        isBusy = true
                        HideText()
                        TriggerEvent("kloud-deliveries:client:checkdeliveries", {id = k, item = Delivery.Item, type = "delivery"})
                        return
                    end
    
                    if isBusy or not inZone then
                        HideText()
                    end
                end
            })

            lib.zones.box({coords = v.Storage, size = v.Size, rotation = v.Rotation, debug = Delivery.Debug,
                onEnter = function ()
                    inZone = true
                    DrawText('[E] Open Storage')
                end,
                onExit = function ()
                    inZone = false
                    HideText()
                end,
                inside = function ()
                    if IsControlJustPressed(0, 38) and not isBusy then
                        HideText()
                        TriggerEvent("kloud-deliveries:client:jobmenu", {id = k, job = v.Job, item = v.RequiredItem, type = "convert"})
                    end
    
                    if isBusy or not inZone then
                        HideText()
                    end
                end
            })
        end
    end
end

PickRandomDropOff = function ()
    local id = math.random(1, #Delivery.DropOffs)
    return Delivery.DropOffs[id].Location, id
end

SetJobWaypoint = function(location)
    local pedCoords = GetEntityCoords(cache.ped)
    Blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(Blip, Delivery.Blip.Sprite)
    SetBlipScale(Blip, Delivery.Blip.Scale)
    SetBlipColour(Blip, Delivery.Blip.Colour)
    SetBlipDisplay(Blip, 4)
    SetBlipFlashes(Blip, Delivery.Blip.Flashes)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Delivery.Blip.Name)
    EndTextCommandSetBlipName(Blip)

    ClearGpsMultiRoute()
    StartGpsMultiRoute(12, true, true)
    AddPointToGpsMultiRoute(location.x, location.y, location.z)
    SetGpsMultiRouteRender(true)
end

CreateInteraction = function (id)
    local data = Delivery.DropOffs[id]
    if data.Type == "target" then
        jobTarget = AddTarget('kloud-deliveries', data.Location, 0.55, {
            name = 'kloud-deliveries',
            debugPoly = Delivery.Debug,
        }, {
            {
                event = 'kloud-deliveries:client:deliver',
                label = "Deliver Food",
                name = "kloud-deliveries:deliver",
                icon = "fas fa-archive",
                distance = 2.5,
            },
        }, 1)
    else
        jobZone = lib.zones.box({coords = data.Location, size = data.Size, rotation = data.Rotation, debug = Delivery.Debug,
            onEnter = function ()
                inZone = true
                DrawText('[E] Deliver Food')
            end,
            onExit = function ()
                inZone = false
                HideText()
            end,
            inside = function ()
                if IsControlJustPressed(0, 38) and not isBusy then
                    HideText()
                    EndDelivery()
                end

                if isBusy or not inZone then
                    HideText()
                end
            end
        })
    end
end

Clear = function()
    isBusy = false

    if Blip then
        RemoveBlip(Blip)
    end
    ClearGpsMultiRoute()
    HideText()

    if jobZone then
        jobZone:remove()
    end

    if jobTarget then
        exports.ox_target:removeZone(jobTarget)
    end
end

StartDelivery = function ()
    local location, id = PickRandomDropOff()
    SetJobWaypoint(location)
    CreateInteraction(id)
    Notify("Check your GPS for the drop-off location", "success")
    inJob = true
end

EndDelivery = function ()
    local hasItem = lib.callback.await("kloud-deliveries:callback:checkdelivery", false)
    if not hasItem then return end
    isBusy = true
    exports["rpemotes"]:EmoteCommandStart('knock')
    local success = SkillCheck({"medium", "medium", "medium"})
    if not success then exports["rpemotes"]:EmoteCancel(true) DrawText('[E] Deliver Food') isBusy = false return end
    Clear()
    exports["rpemotes"]:EmoteCancel(true)
    Progress(1500, "Handing off food", "mp_common", "givetake1_b")
    TriggerServerEvent("kloud-deliveries:server:done")
    cooldownTime = Delivery.Cooldown
    Cooldown()
    inJob = false
end

Cooldown = function()
    while cooldownTime > 0 do
        if cooldownTime - 1 == 0 then cooldownTime = 0 break end
        cooldownTime = cooldownTime - 1
        Wait(1000)
    end
end

CreateThread(RegisterPoints)