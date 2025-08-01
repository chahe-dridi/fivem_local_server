-- Enhanced Car Spawn Menu for FiveM
-- Press F3 to open car menu or use /carmenu command

print("^2[Car Menu] ^7Script loaded successfully!")

local spawnedVehicles = {} -- Track spawned vehicles for cleanup
local lastSpawnTime = 0
local spawnCooldown = 500 -- Reduced cooldown to 0.5 seconds
local menuOpen = false
local currentVehicle = 0
local vehicleInfoUpdateTimer = 0

-- ================================
-- MENU FUNCTIONS
-- ================================

-- Open the car menu
local function openMenu()
    if menuOpen then return end
    
    print("^2[Car Menu] ^7Opening car menu...")
    menuOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "showMenu"
    })
end

-- Close the car menu
local function closeMenu()
    if not menuOpen then return end
    
    print("^2[Car Menu] ^7Closing car menu...")
    menuOpen = false
    SetNuiFocus(false, false)
end

-- ================================
-- VEHICLE INFO FUNCTIONS
-- ================================

-- Get detailed vehicle information
local function getVehicleInfo()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        return {
            inVehicle = false,
            name = "No Vehicle",
            health = 0,
            engineHealth = 0,
            bodyHealth = 0,
            speed = 0,
            engineRunning = false,
            seat = -1
        }
    end
    
    local vehicleHash = GetEntityModel(vehicle)
    local vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)
    local health = GetEntityHealth(vehicle)
    local maxHealth = GetEntityMaxHealth(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)
    local bodyHealth = GetVehicleBodyHealth(vehicle)
    local speed = GetEntitySpeed(vehicle) * 2.237 -- Convert to MPH
    local engineRunning = GetIsVehicleEngineRunning(vehicle)
    
    -- Find player's seat
    local seat = -1
    for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        if GetPedInVehicleSeat(vehicle, i) == playerPed then
            seat = i
            break
        end
    end
    
    return {
        inVehicle = true,
        name = vehicleName,
        health = math.floor((health / maxHealth) * 1000),
        engineHealth = math.floor(engineHealth),
        bodyHealth = math.floor(bodyHealth),
        speed = math.floor(speed),
        engineRunning = engineRunning,
        seat = seat
    }
end

-- ================================
-- NUI CALLBACKS
-- ================================

-- Handle UI close
RegisterNUICallback("closeMenu", function(data, cb)
    closeMenu()
    cb("ok")
end)

-- Handle vehicle info request
RegisterNUICallback("getVehicleInfo", function(data, cb)
    local info = getVehicleInfo()
    SendNUIMessage({
        type = "updateVehicleInfo",
        info = info
    })
    cb("ok")
end)

-- Handle car spawning from menu
RegisterNUICallback("spawnCar", function(data, cb)
    local model = data.model
    local style = data.style
    local target = data.target or 'self'
    local targetPlayerId = data.targetPlayerId
    
    print("^2[Car Menu] ^7Spawning: " .. model .. " with style: " .. style .. " for target: " .. target)
    
    if target == 'self' then
        -- Spawn for current player
        spawnCarWithStyle(model, style, true) -- true = replace current vehicle
    elseif target == 'nearest' then
        -- Find nearest player and spawn for them
        local nearestPlayer = getNearestPlayer()
        if nearestPlayer and nearestPlayer ~= PlayerId() then
            TriggerServerEvent('ch_car:spawnForPlayer', GetPlayerServerId(nearestPlayer), model, style)
            sendMessage("Car Spawn", "Spawning " .. model .. " for nearest player!", {0, 255, 255})
        else
            sendMessage("Car Spawn", "No nearby players found!", {255, 165, 0})
        end
    elseif target == 'custom' and targetPlayerId then
        -- Spawn for specific player ID
        TriggerServerEvent('ch_car:spawnForPlayer', targetPlayerId, model, style)
        sendMessage("Car Spawn", "Spawning " .. model .. " for player " .. targetPlayerId .. "!", {0, 255, 255})
    end
    
    cb("ok")
end)

-- Handle vehicle control actions
RegisterNUICallback("vehicleAction", function(data, cb)
    local action = data.action
    local actionData = data.data
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        sendMessage("Vehicle Control", "You're not in a vehicle!", {255, 165, 0})
        cb("ok")
        return
    end
    
    if action == "fix" then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, false)
        SetVehicleDirtLevel(vehicle, 0.0)
        sendMessage("Vehicle Control", "Vehicle repaired!", {0, 255, 0})
        
    elseif action == "clean" then
        SetVehicleDirtLevel(vehicle, 0.0)
        sendMessage("Vehicle Control", "Vehicle cleaned!", {0, 255, 0})
        
    elseif action == "engine" then
        local engineOn = GetIsVehicleEngineRunning(vehicle)
        SetVehicleEngineOn(vehicle, not engineOn, true, true)
        sendMessage("Vehicle Control", engineOn and "Engine stopped!" or "Engine started!", {0, 255, 255})
        
    elseif action == "lock" then
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        if lockStatus == 1 then -- Unlocked
            SetVehicleDoorsLocked(vehicle, 2) -- Lock
            sendMessage("Vehicle Control", "Vehicle locked!", {255, 255, 0})
        else
            SetVehicleDoorsLocked(vehicle, 1) -- Unlock
            sendMessage("Vehicle Control", "Vehicle unlocked!", {0, 255, 0})
        end
        
    elseif action == "delete" then
        DeleteVehicle(vehicle)
        sendMessage("Vehicle Control", "Vehicle deleted!", {255, 0, 0})
        -- Remove from tracking list
        for i = #spawnedVehicles, 1, -1 do
            if spawnedVehicles[i] == vehicle then
                table.remove(spawnedVehicles, i)
                break
            end
        end
        
    elseif action == "changeSeat" then
        local targetSeat = actionData or 0
        TaskWarpPedIntoVehicle(playerPed, vehicle, targetSeat)
        local seatName = targetSeat == -1 and "driver" or "passenger " .. (targetSeat + 1)
        sendMessage("Vehicle Control", "Moved to " .. seatName .. " seat!", {0, 255, 255})
    end
    
    cb("ok")
end)

-- ================================
-- UTILITY FUNCTIONS
-- ================================

-- Utility function to send colored messages
local function sendMessage(title, message, color)
    TriggerEvent("chat:addMessage", {
        color = color or {255, 255, 255},
        multiline = true,
        args = {title, message}
    })
end

-- Function to clean up old vehicles
local function cleanupOldVehicles()
    local playerPed = PlayerPedId()
    for i = #spawnedVehicles, 1, -1 do
        local vehicle = spawnedVehicles[i]
        if DoesEntityExist(vehicle) then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if driver == 0 or driver ~= playerPed then -- No driver or player not in vehicle
                DeleteVehicle(vehicle)
                table.remove(spawnedVehicles, i)
            end
        else
            table.remove(spawnedVehicles, i)
        end
    end
end

-- Function to get safe spawn position
local function getSafeSpawnPosition(playerPed)
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Try to find a clear area in front of the player
    local forwardVector = GetEntityForwardVector(playerPed)
    local spawnPos = vector3(
        pos.x + forwardVector.x * 3.0,
        pos.y + forwardVector.y * 3.0,
        pos.z
    )
    
    -- Check if the area is clear
    local groundZ = 0.0
    local foundGround, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z + 10.0, false)
    
    if foundGround then
        spawnPos = vector3(spawnPos.x, spawnPos.y, groundZ + 1.0)
    end
    
    return spawnPos, heading
end

-- Function to find nearest player
local function getNearestPlayer()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer = nil
    local closestDistance = 50.0 -- Maximum distance to search
    
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            if targetPed and targetPed ~= 0 then
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(playerCoords - targetCoords)
                
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- ================================
-- CAR SPAWNING LOGIC
-- ================================

-- Main car spawn function (can be called from menu or command)
function spawnCarWithStyle(vehicleName, customization, replaceVehicle)
    local currentTime = GetGameTimer()
    
    -- Check cooldown
    if currentTime - lastSpawnTime < spawnCooldown then
        sendMessage("Car Spawn", "Please wait before spawning another vehicle!", {255, 165, 0})
        return
    end
    
    -- Convert to lowercase and handle hash
    vehicleName = string.lower(vehicleName)
    
    -- Validate vehicle model
    local vehicleHash = GetHashKey(vehicleName)
    if not IsModelInCdimage(vehicleHash) or not IsModelAVehicle(vehicleHash) then
        sendMessage("Car Spawn", "Error: Invalid vehicle name '" .. vehicleName .. "'!", {255, 0, 0})
        return false
    end
    
    local playerPed = PlayerPedId()
    local oldVehicle = GetVehiclePedIsIn(playerPed, false)
    
    -- If replacing and player is in a vehicle, delete it first
    if replaceVehicle and oldVehicle ~= 0 then
        DeleteVehicle(oldVehicle)
        -- Remove from tracking list
        for i = #spawnedVehicles, 1, -1 do
            if spawnedVehicles[i] == oldVehicle then
                table.remove(spawnedVehicles, i)
                break
            end
        end
        sendMessage("Car Spawn", "Replaced previous vehicle!", {255, 255, 0})
    else
        -- Clean up old vehicles first
        cleanupOldVehicles()
    end
    
    -- Request model with timeout
    RequestModel(vehicleHash)
    local timeout = 0
    while not HasModelLoaded(vehicleHash) and timeout < 100 do
        Wait(100)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(vehicleHash) then
        sendMessage("Car Spawn", "Error: Failed to load vehicle model!", {255, 0, 0})
        return false
    end
    
    local spawnPos, heading = getSafeSpawnPosition(playerPed)
    
    -- Create vehicle
    local vehicle = CreateVehicle(vehicleHash, spawnPos.x, spawnPos.y, spawnPos.z, heading, true, false)
    
    if not DoesEntityExist(vehicle) then
        sendMessage("Car Spawn", "Error: Failed to spawn vehicle!", {255, 0, 0})
        SetModelAsNoLongerNeeded(vehicleHash)
        return false
    end
    
    -- Vehicle customization based on parameter
    if customization == "tuned" then
        -- Max out all modifications
        SetVehicleModKit(vehicle, 0)
        for i = 0, 49 do
            local maxMod = GetNumVehicleMods(vehicle, i) - 1
            if maxMod > 0 then
                SetVehicleMod(vehicle, i, maxMod, false)
            end
        end
        SetVehicleWindowTint(vehicle, 1)
        SetVehicleColours(vehicle, 0, 0) -- Black
        sendMessage("Car Spawn", "Spawned fully tuned " .. vehicleName .. "!", {0, 255, 255})
    elseif customization == "dirty" then
        SetVehicleDirtLevel(vehicle, 15.0)
        SetVehicleColours(vehicle, 106, 106) -- Rusty brown
        sendMessage("Car Spawn", "Spawned dirty " .. vehicleName .. "!", {139, 69, 19})
    elseif customization == "clean" then
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleColours(vehicle, 111, 111) -- Pearl white
        sendMessage("Car Spawn", "Spawned clean " .. vehicleName .. "!", {255, 255, 255})
    elseif customization == "race" then
        -- Racing modifications
        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 0, GetNumVehicleMods(vehicle, 0) - 1, false) -- Spoiler
        SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false) -- Engine
        SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false) -- Brakes
        SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false) -- Transmission
        SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 1, false) -- Suspension
        SetVehicleColours(vehicle, 27, 27) -- Red
        SetVehicleNumberPlateText(vehicle, "RACE")
        sendMessage("Car Spawn", "Spawned race-tuned " .. vehicleName .. "!", {255, 0, 0})
    elseif customization == "luxury" then
        -- Luxury modifications
        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 1, GetNumVehicleMods(vehicle, 1) - 1, false) -- Front bumper
        SetVehicleMod(vehicle, 2, GetNumVehicleMods(vehicle, 2) - 1, false) -- Rear bumper
        SetVehicleWindowTint(vehicle, 2) -- Light smoke
        SetVehicleColours(vehicle, 0, 0) -- Black
        SetVehicleExtraColours(vehicle, 111, 111) -- Pearl white secondary
        SetVehicleNumberPlateText(vehicle, "LUXURY")
        sendMessage("Car Spawn", "Spawned luxury " .. vehicleName .. "!", {255, 215, 0})
    else
        sendMessage("Car Spawn", "Spawned " .. vehicleName .. " successfully!", {0, 255, 0})
    end
    
    -- Set vehicle properties
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    
    -- Add to tracking list
    table.insert(spawnedVehicles, vehicle)
    
    -- Put player in vehicle
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    
    -- Clean up model
    SetModelAsNoLongerNeeded(vehicleHash)
    lastSpawnTime = currentTime
    
    return true
end

-- ================================
-- KEY BINDINGS AND COMMANDS
-- ================================

-- Car menu command
RegisterCommand("carmenu", function()
    openMenu()
end, false)

-- Key mapping for F3
if RegisterKeyMapping then
    RegisterKeyMapping('carmenu', 'Open Car Menu', 'keyboard', 'F3')
end

-- ESC key handling
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen then
            -- Disable game controls while menu is open
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 25, true) -- Aim
            
            -- Check for ESC key
            if IsControlJustPressed(0, 322) then -- ESC key
                closeMenu()
            end
        end
    end
end)

-- Test command for debugging
RegisterCommand("testcarmenu", function()
    if GetCurrentResourceName() == "ch_car" then
        sendMessage("Car Menu", "Car menu test - Press F3 or use /carmenu", {0, 255, 255})
        openMenu()
    end
end, false)

-- ================================
-- LEGACY COMMANDS (still available)
-- ================================

-- Legacy car spawn command (still works)
RegisterCommand("car", function(source, args, rawCommand)
    local vehicleName = args[1] or "adder"
    local customization = args[2] or "default"
    spawnCarWithStyle(vehicleName, customization, false)
end, false)

-- Delete current vehicle command
RegisterCommand("cardv", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        sendMessage("Delete Vehicle", "You're not in a vehicle!", {255, 165, 0})
        return
    end
    
    DeleteVehicle(vehicle)
    sendMessage("Delete Vehicle", "Vehicle deleted!", {0, 255, 0})
    
    -- Remove from tracking list
    for i = #spawnedVehicles, 1, -1 do
        if spawnedVehicles[i] == vehicle then
            table.remove(spawnedVehicles, i)
            break
        end
    end
end, false)

-- Fix current vehicle command
RegisterCommand("carfix", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        sendMessage("Fix Vehicle", "You're not in a vehicle!", {255, 165, 0})
        return
    end
    
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    sendMessage("Fix Vehicle", "Vehicle repaired!", {0, 255, 0})
end, false)

-- Cleanup all spawned vehicles command
RegisterCommand("carcleanup", function(source, args, rawCommand)
    local count = 0
    for i = #spawnedVehicles, 1, -1 do
        local vehicle = spawnedVehicles[i]
        if DoesEntityExist(vehicle) then
            DeleteVehicle(vehicle)
            count = count + 1
        end
        table.remove(spawnedVehicles, i)
    end
    
    sendMessage("Cleanup", "Cleaned up " .. count .. " vehicles!", {0, 255, 0})
end, false)

-- Car list command (show some popular vehicles)
RegisterCommand("carlist", function(source, args, rawCommand)
    sendMessage("Car Menu Info", "Press F3 or use /carmenu to open the car spawn menu!", {0, 255, 255})
    sendMessage("Legacy Commands", "/car [name] [style] - Direct spawn", {255, 255, 0})
    sendMessage("Legacy Commands", "/cardv, /carfix, /carcleanup - Utilities", {255, 255, 0})
end, false)

-- Help command
RegisterCommand("carhelp", function(source, args, rawCommand)
    sendMessage("Car Menu Help", "🚗 Car Spawn System", {0, 255, 255})
    sendMessage("Main Menu", "F3 or /carmenu - Open car spawn menu", {255, 255, 255})
    sendMessage("Quick Commands", "/car [name] [style] - Direct spawn", {255, 255, 255})
    sendMessage("Utilities", "/cardv, /carfix, /carcleanup", {255, 255, 255})
    sendMessage("Styles", "default, tuned, clean, dirty", {255, 255, 0})
end, false)

-- ================================
-- INITIALIZATION
-- ================================

-- Resource start handler
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("^2[Car Menu] ^7Initialized! Press F3 to open menu")
        Wait(1000)
        sendMessage("Car Menu", "🚗 Enhanced Car Menu loaded! Press F3 or use /carmenu", {0, 255, 255})
    end
end)

-- Handle spawn request from server (for receiving cars from other players)
RegisterNetEvent('ch_car:receiveCarSpawn')
AddEventHandler('ch_car:receiveCarSpawn', function(model, style, senderName)
    print("^2[Car Menu] ^7Received car spawn request: " .. model .. " from " .. senderName)
    spawnCarWithStyle(model, style, true)
    sendMessage("Car Spawn", "🎁 " .. senderName .. " spawned a " .. model .. " for you!", {255, 215, 0})
end)