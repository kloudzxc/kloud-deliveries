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