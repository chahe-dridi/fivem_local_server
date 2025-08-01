-- Enhanced Player Management Script for FiveM
-- Author: Enhanced version with comprehensive player utilities
-- Features: Spawning, Health, Movement, Character, and Utility commands

-- ================================
-- CONFIGURATION
-- ================================
local config = {
    defaultSpawnPos = vector3(686.245, 577.950, 130.461),
    defaultModel = 'a_m_m_skater_01',
    maxHealth = 200,
    maxArmor = 100,
    welcomeMessage = 'Welcome to the party!~',
    commandCooldown = 1000 -- 1 second
}

-- ================================
-- VARIABLES
-- ================================
local lastCommandTime = 0
local playerData = {
    lastPosition = nil,
    godMode = false,
    invisibility = false
}

-- ================================
-- UTILITY FUNCTIONS
-- ================================

-- Enhanced message function with colors
local function sendMessage(title, message, color)
    TriggerEvent('chat:addMessage', {
        color = color or {255, 255, 255},
        multiline = true,
        args = {title, message}
    })
end

-- Cooldown check
local function checkCooldown()
    local currentTime = GetGameTimer()
    if currentTime - lastCommandTime < config.commandCooldown then
        sendMessage("System", "Please wait before using another command!", {255, 165, 0})
        return false
    end
    lastCommandTime = currentTime
    return true
end

-- Get player status info
local function getPlayerStatus()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    local armor = GetPedArmour(playerPed)
    local coords = GetEntityCoords(playerPed)
    
    return {
        health = health,
        armor = armor,
        isDead = IsEntityDead(playerPed),
        coords = coords,
        heading = GetEntityHeading(playerPed)
    }
end

-- ================================
-- SPAWN SYSTEM
-- ================================

AddEventHandler('onClientGameTypeStart', function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        exports.spawnmanager:spawnPlayer({
            x = config.defaultSpawnPos.x,
            y = config.defaultSpawnPos.y,
            z = config.defaultSpawnPos.z,
            model = config.defaultModel
        }, function()
            sendMessage("Welcome", config.welcomeMessage, {0, 255, 0})
            sendMessage("Help", "Type /help for available commands", {255, 255, 0})
        end)
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

-- ================================
-- SPAWN COMMANDS
-- ================================

-- Basic spawn command
RegisterCommand('spawn', function(source, args, rawCommand)
    if not checkCooldown() then return end
    
    exports.spawnmanager:spawnPlayer({
        x = config.defaultSpawnPos.x,
        y = config.defaultSpawnPos.y,
        z = config.defaultSpawnPos.z,
        model = config.defaultModel
    }, function()
        sendMessage("Spawn", "You have been spawned!", {0, 255, 0})
    end)
end, false)

-- Spawn at custom coordinates
RegisterCommand('spawnat', function(source, args, rawCommand)
    if not checkCooldown() then return end
    
    if #args < 3 then
        sendMessage("Spawn", "Usage: /spawnat [x] [y] [z]", {255, 0, 0})
        return
    end
    
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if not x or not y or not z then
        sendMessage("Spawn", "Invalid coordinates!", {255, 0, 0})
        return
    end
    
    exports.spawnmanager:spawnPlayer({
        x = x, y = y, z = z,
        model = config.defaultModel
    }, function()
        sendMessage("Spawn", string.format("Spawned at %.1f, %.1f, %.1f", x, y, z), {0, 255, 0})
    end)
end, false)

-- Save current position as spawn
RegisterCommand('setspawn', function(source, args, rawCommand)
    local coords = GetEntityCoords(PlayerPedId())
    config.defaultSpawnPos = vector3(coords.x, coords.y, coords.z)
    sendMessage("Spawn", string.format("Spawn position set to %.1f, %.1f, %.1f", coords.x, coords.y, coords.z), {0, 255, 255})
end, false)

-- ================================
-- HEALTH & ARMOR COMMANDS
-- ================================

-- Revive command with enhancements
RegisterCommand('revive', function(source, args, rawCommand)
    if not checkCooldown() then return end
    
    local playerPed = PlayerPedId()
    if IsEntityDead(playerPed) then
        ResurrectPed(playerPed)
        SetEntityHealth(playerPed, config.maxHealth)
        SetPedArmour(playerPed, config.maxArmor)
        ClearPedTasksImmediately(playerPed)
        sendMessage("Revive", "You have been revived with full health and armor!", {0, 255, 0})
    else
        sendMessage("Revive", "You are not dead!", {255, 165, 0})
    end
end, false)

-- Enhanced heal command
RegisterCommand('heal', function(source, args, rawCommand)
    if not checkCooldown() then return end
    
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, config.maxHealth)
    SetPedArmour(playerPed, config.maxArmor)
    
    -- Clear any negative effects
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    
    sendMessage("Heal", "You have been fully healed and armored!", {0, 255, 0})
end, false)

-- Armor command
RegisterCommand('armor', function(source, args, rawCommand)
    if not checkCooldown() then return end
    
    local playerPed = PlayerPedId()
    SetPedArmour(playerPed, config.maxArmor)
    sendMessage("Armor", "Armor restored to maximum!", {0, 255, 255})
end, false)

-- Kill command with confirmation
RegisterCommand('kill', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 0)
    sendMessage("Kill", "You have committed suicide!", {255, 0, 0})
end, false)

-- ================================
-- MOVEMENT & TELEPORT COMMANDS
-- ================================

-- Go to coordinates
RegisterCommand('goto', function(source, args, rawCommand)
    if #args < 3 then
        sendMessage("Teleport", "Usage: /goto [x] [y] [z]", {255, 0, 0})
        return
    end
    
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if not x or not y or not z then
        sendMessage("Teleport", "Invalid coordinates!", {255, 0, 0})
        return
    end
    
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, x, y, z, false, false, false, true)
    sendMessage("Teleport", string.format("Teleported to %.1f, %.1f, %.1f", x, y, z), {0, 255, 255})
end, false)

-- Save and load positions
RegisterCommand('savepos', function(source, args, rawCommand)
    local coords = GetEntityCoords(PlayerPedId())
    playerData.lastPosition = coords
    sendMessage("Position", string.format("Position saved: %.1f, %.1f, %.1f", coords.x, coords.y, coords.z), {255, 255, 0})
end, false)

RegisterCommand('loadpos', function(source, args, rawCommand)
    if not playerData.lastPosition then
        sendMessage("Position", "No saved position found! Use /savepos first.", {255, 0, 0})
        return
    end
    
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, playerData.lastPosition.x, playerData.lastPosition.y, playerData.lastPosition.z, false, false, false, true)
    sendMessage("Position", "Teleported to saved position!", {0, 255, 255})
end, false)

-- ================================
-- CHARACTER COMMANDS
-- ================================

-- Change player model
RegisterCommand('skin', function(source, args, rawCommand)
    if #args < 1 then
        sendMessage("Skin", "Usage: /skin [model_name]", {255, 0, 0})
        sendMessage("Examples", "a_m_m_skater_01, a_f_y_hippie_01, s_m_y_cop_01", {255, 255, 0})
        return
    end
    
    local model = args[1]
    local modelHash = GetHashKey(model)
    
    if not IsModelInCdimage(modelHash) or not IsModelValid(modelHash) then
        sendMessage("Skin", "Invalid model name!", {255, 0, 0})
        return
    end
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(500)
    end
    
    SetPlayerModel(PlayerId(), modelHash)
    SetModelAsNoLongerNeeded(modelHash)
    sendMessage("Skin", "Model changed to: " .. model, {0, 255, 0})
end, false)

-- ================================
-- SPECIAL ABILITIES
-- ================================

-- God mode toggle
RegisterCommand('god', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    playerData.godMode = not playerData.godMode
    
    SetEntityInvincible(playerPed, playerData.godMode)
    
    if playerData.godMode then
        sendMessage("God Mode", "God mode enabled!", {255, 215, 0})
    else
        sendMessage("God Mode", "God mode disabled!", {255, 255, 255})
    end
end, false)

-- Invisibility toggle
RegisterCommand('invis', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    playerData.invisibility = not playerData.invisibility
    
    SetEntityVisible(playerPed, not playerData.invisibility, 0)
    
    if playerData.invisibility then
        sendMessage("Invisibility", "You are now invisible!", {128, 0, 128})
    else
        sendMessage("Invisibility", "You are now visible!", {255, 255, 255})
    end
end, false)

-- ================================
-- UTILITY COMMANDS
-- ================================

-- Get current coordinates
RegisterCommand('coords', function(source, args, rawCommand)
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    sendMessage("Coordinates", string.format("X: %.3f, Y: %.3f, Z: %.3f", coords.x, coords.y, coords.z), {255, 255, 0})
    sendMessage("Heading", string.format("Heading: %.3f", heading), {255, 255, 0})
end, false)

-- Player status
RegisterCommand('status', function(source, args, rawCommand)
    local status = getPlayerStatus()
    sendMessage("Player Status", "Current player information:", {0, 255, 255})
    sendMessage("Health", string.format("Health: %d/%d", status.health, config.maxHealth), {255, 255, 255})
    sendMessage("Armor", string.format("Armor: %d/%d", status.armor, config.maxArmor), {255, 255, 255})
    sendMessage("Status", string.format("Dead: %s | God: %s | Invisible: %s", 
        status.isDead and "Yes" or "No",
        playerData.godMode and "Yes" or "No",
        playerData.invisibility and "Yes" or "No"), {255, 255, 255})
end, false)

-- Resource restart
RegisterCommand('refreshauto', function(source, args, rawCommand)
    local resourceName = GetCurrentResourceName()
    TriggerServerEvent('restartResource', resourceName)
    sendMessage("System", "Resource restart requested!", {255, 165, 0})
end, false)

-- ================================
-- HELP SYSTEM
-- ================================

RegisterCommand('help', function(source, args, rawCommand)
    sendMessage("=== PLAYER COMMANDS ===", "Available commands:", {0, 255, 255})
    sendMessage("Spawn", "/spawn, /spawnat [x y z], /setspawn", {255, 255, 255})
    sendMessage("Health", "/heal, /revive, /armor, /kill", {255, 255, 255})
    sendMessage("Movement", "/goto [x y z], /savepos, /loadpos", {255, 255, 255})
    sendMessage("Character", "/skin [model], /god, /invis", {255, 255, 255})
    sendMessage("Utility", "/coords, /status, /refreshauto", {255, 255, 255})
    sendMessage("Info", "Use individual commands for more details!", {255, 255, 0})
end, false)

-- Command list
RegisterCommand('commands', function(source, args, rawCommand)
    sendMessage("Command List", "All available commands:", {0, 255, 255})
    local commands = {
        "spawn", "spawnat", "setspawn", "heal", "revive", "armor", "kill",
        "goto", "savepos", "loadpos", "skin", "god", "invis", "coords", 
        "status", "refreshauto", "help", "commands"
    }
    
    local commandStr = ""
    for i, cmd in ipairs(commands) do
        commandStr = commandStr .. "/" .. cmd
        if i < #commands then commandStr = commandStr .. ", " end
        if i % 6 == 0 then
            sendMessage("Commands", commandStr, {255, 255, 255})
            commandStr = ""
        end
    end
    if commandStr ~= "" then
        sendMessage("Commands", commandStr, {255, 255, 255})
    end
end, false)