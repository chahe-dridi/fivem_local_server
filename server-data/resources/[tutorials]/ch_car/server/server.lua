-- Enhanced Car Menu Server Script
-- Handles player-to-player car spawning

print("^2[Car Menu Server] ^7Script loaded successfully!")

-- Handle car spawn request for other players
RegisterServerEvent('ch_car:spawnForPlayer')
AddEventHandler('ch_car:spawnForPlayer', function(targetPlayerId, model, style)
    local source = source
    local senderName = GetPlayerName(source)
    
    -- Validate the target player exists
    if GetPlayerName(targetPlayerId) then
        local targetName = GetPlayerName(targetPlayerId)
        
        print("^2[Car Menu Server] ^7" .. senderName .. " (" .. source .. ") spawning " .. model .. " for " .. targetName .. " (" .. targetPlayerId .. ")")
        
        -- Send spawn request to target player
        TriggerClientEvent('ch_car:receiveCarSpawn', targetPlayerId, model, style, senderName)
        
        -- Notify sender
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 255},
            multiline = true,
            args = {"Car Spawn", "✅ Spawned " .. model .. " for " .. targetName .. "!"}
        })
        
        -- Notify target
        TriggerClientEvent('chat:addMessage', targetPlayerId, {
            color = {255, 215, 0},
            multiline = true,
            args = {"Car Gift", "🎁 " .. senderName .. " spawned a " .. model .. " for you!"}
        })
    else
        -- Target player not found
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Car Spawn", "❌ Player ID " .. targetPlayerId .. " not found!"}
        })
    end
end)

-- Command to get player list (helpful for finding player IDs)
RegisterCommand("players", function(source, args, rawCommand)
    local playerList = {}
    local players = GetPlayers()
    
    for _, playerId in ipairs(players) do
        local playerName = GetPlayerName(playerId)
        table.insert(playerList, "ID: " .. playerId .. " - " .. playerName)
    end
    
    if #playerList > 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 255},
            multiline = true,
            args = {"Player List", "Online Players:"}
        })
        
        for _, playerInfo in ipairs(playerList) do
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 255, 255},
                multiline = true,
                args = {"", playerInfo}
            })
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 165, 0},
            multiline = true,
            args = {"Player List", "No players found!"}
        })
    end
end, false)

-- Resource start handler
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("^2[Car Menu Server] ^7Initialized successfully!")
        print("^2[Car Menu Server] ^7Players can now spawn cars for each other!")
    end
end)
