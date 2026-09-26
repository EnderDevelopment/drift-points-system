local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('driftPointSystem:getPoints', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchScalar('SELECT points FROM drift_points WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(points)
        if points then
            cb(points)
        else
            MySQL.Async.execute('INSERT INTO drift_points (identifier, points) VALUES (@identifier, 0)', {
                ['@identifier'] = xPlayer.identifier
            }, function()
                cb(0)
            end)
        end
    end)
end)

RegisterServerEvent('driftPointSystem:earnPoints')
AddEventHandler('driftPointSystem:earnPoints', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchScalar('SELECT points FROM drift_points WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(points)
        if points then
            local newPoints = points + Config.DriftPoint.Reward
            
            MySQL.Async.execute('UPDATE drift_points SET points = @points WHERE identifier = @identifier', {
                ['@points'] = newPoints,
                ['@identifier'] = xPlayer.identifier
            }, function()
                xPlayer.addAccountMoney('bank', Config.DriftPoint.Reward)
                TriggerClientEvent('esx:showNotification', source, 'You earned ~g~' .. Config.DriftPoint.Reward .. '~s~ points!')
            end)
        else
            MySQL.Async.execute('INSERT INTO drift_points (identifier, points) VALUES (@identifier, @points)', {
                ['@identifier'] = xPlayer.identifier,
                ['@points'] = Config.DriftPoint.Reward
            }, function()
                xPlayer.addAccountMoney('bank', Config.DriftPoint.Reward)
                TriggerClientEvent('esx:showNotification', source, 'You earned ~g~' .. Config.DriftPoint.Reward .. '~s~ points!')
            end)
        end
    end)
end)