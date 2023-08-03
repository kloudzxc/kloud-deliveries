Delivery = {}
Delivery.Debug = false
Delivery.Decay = true -- if you are using metadata durability
Delivery.Item = "delivery_food" -- this'll be the item inside the storages

Delivery.MaxSlots = 15 -- max slots is also equal to max item per storage since stack is disabled
Delivery.Reward = {min = 150, max = 200}
Delivery.Fee = 100 -- deposit fee
Delivery.Cooldown = 30 -- cooldown / in seconds

Delivery.JobReward = {
    Enabled = true, -- reward employee?
    EmployeeReward = 50, -- how much then?
    Society = true, -- also reward the society?
    SocietyReward = 50 -- how much?
}


Delivery.Target = "ox" -- qb, ox 
Delivery.DrawText = "ox" -- qb, ox
Delivery.Notify = "ox" -- qb, ox
Delivery.SkillCheck = "ox" -- wip
Delivery.Menu = "ox" -- qb, ox
Delivery.Type = "target" -- zone, target
Delivery.Progress = "bar" -- circle, bar

Delivery.QBDrawAlignment = 'top' --  'left', 'top', 'right' -- / For QB DrawText

Delivery.Blip = {
    Scale = 0.9,
    Colour = 5,
    Sprite = 280,
    Flashes = true,
    Name = "Delivery Drop-Off"
}

Delivery.Ped = {
    Enabled = true,
    Model = "u_m_y_burgerdrug_01",

}

Delivery.Locations = {
    [1] = {
        Type = "zone",
        Job = "burgershot",
        RequiredItem = "burger",
        StorageLevel = 2,
        PedLocation = vec4(-1198.5, -891.76, 13.89, 341.39),
        Location = vec4(-1197.55, -891.54, 13.89, 163.94),
        Storage = vec4(-1197.96, -893.21, 13.89, 341.26),
        Size = vec3(0.75,0.75,2),
        Rotation = 160,
    }
}

Delivery.DropOffs = {
    [1] = {
        Type = "zone",
        Location = vec4(-949.34, 196.74, 67.39, 345.78),
        Size = vec3(1,1,2),
        Rotation = 0,
    },

    [2] = {
        Type = "zone",
        Location = vec4(-1037.97, 222.17, 64.38, 269.91),
        Size = vec3(1,1,2),
        Rotation = 0,
    },

    [3] = {
        Type = "zone",
        Location = vec4(-1465.15, -34.5, 55.05, 127.36),
        Size = vec3(1,1,2),
        Rotation = 0,
    },
}