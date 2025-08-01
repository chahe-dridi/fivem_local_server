-- Simple Weapon Menu for FiveM
-- Press F2 to open menu

print("^2[Weapon Menu] ^7Script loaded successfully!")

-- ================================
-- WEAPON DATABASE
-- ================================
local weaponCategories = {
    pistols = {
        "WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL",
        "WEAPON_STUNGUN", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL",
        "WEAPON_VINTAGEPISTOL", "WEAPON_FLAREGUN", "WEAPON_MARKSMANPISTOL", "WEAPON_REVOLVER"
    },
    
    smgs = {
        "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_SMG_MK2", "WEAPON_ASSAULTSMG",
        "WEAPON_COMBATPDW", "WEAPON_MACHINEPISTOL", "WEAPON_MINISMG"
    },
    
    rifles = {
        "WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE",
        "WEAPON_CARBINERIFLE_MK2", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE",
        "WEAPON_BULLPUPRIFLE", "WEAPON_COMPACTRIFLE"
    },
    
    shotguns = {
        "WEAPON_PUMPSHOTGUN", "WEAPON_PUMPSHOTGUN_MK2", "WEAPON_SAWNOFFSHOTGUN",
        "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_HEAVYSHOTGUN",
        "WEAPON_DBSHOTGUN", "WEAPON_AUTOSHOTGUN"
    },
    
    snipers = {
        "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_HEAVYSNIPER_MK2",
        "WEAPON_MARKSMANRIFLE", "WEAPON_MARKSMANRIFLE_MK2"
    },
    
    heavy = {
        "WEAPON_RPG", "WEAPON_GRENADELAUNCHER", "WEAPON_MINIGUN", 
        "WEAPON_FIREWORK", "WEAPON_HOMINGLAUNCHER", "WEAPON_COMPACTLAUNCHER"
    },
    
    melee = {
        "WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT",
        "WEAPON_GOLFCLUB", "WEAPON_CROWBAR", "WEAPON_DAGGER", "WEAPON_HATCHET",
        "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_BATTLEAXE"
    },
    
    throwables = {
        "WEAPON_GRENADE", "WEAPON_BZGAS", "WEAPON_MOLOTOV", "WEAPON_STICKYBOMB",
        "WEAPON_PROXMINE", "WEAPON_SMOKEGRENADE", "WEAPON_FLARE"
    }
}

-- ================================
-- VARIABLES
-- ================================
local isMenuOpen = false

-- ================================
-- UTILITY FUNCTIONS
-- ================================
local function isValidWeapon(weaponHash)
    return IsWeaponValid(weaponHash)
end

local function sendMessage(message)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {"[Weapon Menu]", message}
    })
end

-- ================================
-- NUI FUNCTIONS
-- ================================
local function openMenu()
    if isMenuOpen then 
        print("^3[Weapon Menu] ^7Menu already open!")
        return 
    end
    
    print("^2[Weapon Menu] ^7Opening menu...")
    isMenuOpen = true
    
    -- Set NUI focus
    SetNuiFocus(true, true)
    
    -- Send data to NUI
    SendNUIMessage({
        type = "openMenu",
        weaponData = weaponCategories
    })
    
    sendMessage("Menu opened! Use ESC to close.")
end

local function closeMenu()
    if not isMenuOpen then 
        print("^3[Weapon Menu] ^7Menu already closed!")
        return 
    end
    
    print("^2[Weapon Menu] ^7Closing menu...")
    isMenuOpen = false
    
    -- Remove NUI focus
    SetNuiFocus(false, false)
    
    -- Send close message to NUI
    SendNUIMessage({
        type = "closeMenu"
    })
    
    sendMessage("Menu closed.")
end

-- ================================
-- NUI CALLBACKS
-- ================================
RegisterNUICallback('spawnWeapon', function(data, cb)
    local weaponName = data.weapon
    local ammo = data.ammo or 250
    
    if not weaponName then
        cb({success = false, message = "No weapon specified"})
        return
    end
    
    local weaponHash = GetHashKey(weaponName)
    
    if not isValidWeapon(weaponHash) then
        cb({success = false, message = "Invalid weapon"})
        return
    end
    
    local playerPed = PlayerPedId()
    GiveWeaponToPed(playerPed, weaponHash, ammo, false, true)
    
    local displayName = weaponName:gsub("WEAPON_", ""):lower():gsub("_", " ")
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {"Weapon", "Spawned " .. displayName .. " with " .. ammo .. " ammo!"}
    })
    
    cb({success = true, message = "Weapon spawned successfully"})
end)

RegisterNUICallback('closeMenu', function(data, cb)
    closeMenu()
    cb({success = true})
end)

-- ================================
-- COMMANDS AND KEYBINDS
-- ================================
RegisterCommand("weaponmenu", function()
    if isMenuOpen then
        closeMenu()
    else
        openMenu()
    end
end, false)

-- F2 key mapping
RegisterKeyMapping('weaponmenu', 'Open Weapon Menu', 'keyboard', 'F2')

print("^2[Weapon Menu] ^7F2 key mapped to open menu")
print("^2[Weapon Menu] ^7Type /weaponmenu to test")

-- ================================
-- CLEANUP
-- ================================
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("^3[Weapon Menu] ^7Resource stopping, cleaning up...")
        if isMenuOpen then
            SetNuiFocus(false, false)
        end
    end
end)

-- Test command to check if everything is working
RegisterCommand("testweaponmenu", function()
    print("^2[Weapon Menu] ^7Test command executed!")
    sendMessage("Test command working! Press F2 or use /weaponmenu to open the menu.")
end, false)
