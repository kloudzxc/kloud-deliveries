Delivery = {}
Delivery.Debug = false
Delivery.Decay = true
Delivery.Item = "delivery_food"

Delivery.MaxSlots = 15
Delivery.Reward = {min = 150, max = 200}
Delivery.Fee = 100
Delivery.Cooldown = 30

Delivery.JobReward = {
    Enabled = true,
    EmployeeReward = 50,
    Society = true,
    SocietyReward = 50
}

Delivery.Target = "ox"
Delivery.DrawText = "ox"
Delivery.Notify = "ox"
Delivery.SkillCheck = "ox"
Delivery.Menu = "ox"
Delivery.Type = "target"
Delivery.Progress = "bar"

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