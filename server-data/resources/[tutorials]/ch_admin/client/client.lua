-- ch_admin/client/client.lua

local adminSkin = {
    model = "s_m_m_fibsec_01" -- Example admin skin (FIB Security)
}

local isAdmin = false
local isFlying = false
local flySpeed = 1.5

-- Load model utility
function loadModel(model)
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    return modelHash
end

-- Change to admin skin
function setAdminSkin()
    local playerPed = PlayerPedId()
    local modelHash = loadModel(adminSkin.model)
    SetPlayerModel(PlayerId(), modelHash)
    SetModelAsNoLongerNeeded(modelHash)
    isAdmin = true
    TriggerEvent('chat:addMessage', { args = { '^2[Admin]', 'Admin skin applied!' } })
end

-- Toggle fly mode
function toggleFly()
    isFlying = not isFlying
    local msg = isFlying and "Fly mode enabled!" or "Fly mode disabled!"
    TriggerEvent('chat:addMessage', { args = { '^2[Admin]', msg } })
end

-- Fly logic
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isFlying then
            local ped = PlayerPedId()
            SetEntityInvincible(ped, true)
            SetEntityVisible(ped, true)
            local coords = GetEntityCoords(ped)
            local forward, right, up = 0.0, 0.0, 0.0

            if IsControlPressed(0, 32) then -- W
                forward = 1.0
            end
            if IsControlPressed(0, 33) then -- S
                forward = -1.0
            end
            if IsControlPressed(0, 34) then -- A
                right = -1.0
            end
            if IsControlPressed(0, 35) then -- D
                right = 1.0
            end
            if IsControlPressed(0, 44) then -- Q
                up = 1.0
            end
            if IsControlPressed(0, 36) then -- LCTRL
                up = -1.0
            end

            local heading = GetEntityHeading(ped)
            local x = coords.x + (math.sin(math.rad(heading)) * forward * flySpeed)
            local y = coords.y + (math.cos(math.rad(heading)) * forward * flySpeed)
            x = x + (math.sin(math.rad(heading - 90)) * right * flySpeed)
            y = y + (math.cos(math.rad(heading - 90)) * right * flySpeed)
            local z = coords.z + (up * flySpeed)

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        else
            SetEntityInvincible(PlayerPedId(), false)
        end
    end
end)

-- Commands
RegisterCommand("adminskin", function()
    setAdminSkin()
end, false)

RegisterCommand("fly", function()
    if isAdmin then
        toggleFly()
    else
        TriggerEvent('chat:addMessage', { args = { '^1[Admin]', 'You must be an admin to use this!' } })
    end
end, false)