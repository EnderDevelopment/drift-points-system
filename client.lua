local ESX = nil
local isDrifting = false
local lastDriftTime = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            local speed = GetEntitySpeed(vehicle) * 2.236936 -- Convert to mph
            local isInAir = IsEntityInAir(vehicle)
            
            if speed >= Config.DriftPoint.MinSpeed and speed <= Config.DriftPoint.MaxSpeed and not isInAir then
                if IsVehicleOnAllWheels(vehicle) and GetEntityRoll(vehicle) > 10.0 or GetEntityRoll(vehicle) < -10.0 then
                    if not isDrifting then
                        isDrifting = true
                        lastDriftTime = GetGameTimer()
                    else
                        if GetGameTimer() - lastDriftTime >= Config.DriftPoint.Cooldown then
                            TriggerServerEvent('driftPointSystem:earnPoints')
                            lastDriftTime = GetGameTimer()
                        end
                    end
                else
                    isDrifting = false
                end
            else
                isDrifting = false
            end
        else
            isDrifting = false
        end
    end
end)