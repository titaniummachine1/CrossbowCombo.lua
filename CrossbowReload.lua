--[[
Crossbow autocombo script
author: titaniumachine1
]]

---@type boolean, lnxLib
local libLoaded, lnxLib = pcall(require, "lnxLib")
assert(libLoaded, "lnxLib not found, please install it!")
UnloadLib() --unloads all packages

local Math, Conversion = lnxLib.Utils.Math, lnxLib.Utils.Conversion
local WPlayer, WWeapon = lnxLib.TF2.WPlayer, lnxLib.TF2.WWeapon
local Helpers = lnxLib.TF2.Helpers
local Prediction = lnxLib.TF2.Prediction
local Fonts = lnxLib.UI.Fonts


local function CanShoot(pLocal)
    local pWeapon = pLocal:GetPropEntity("m_hActiveWeapon")
    if (not pWeapon) or (pWeapon:IsMeleeWeapon()) then return false end

    local nextPrimaryAttack = pWeapon:GetPropFloat("LocalActiveWeaponData", "m_flNextPrimaryAttack")
    local nextAttack = pLocal:GetPropFloat("bcc_localdata", "m_flNextAttack")
    if (not nextPrimaryAttack) or (not nextAttack) then return false end

    return (nextPrimaryAttack <= globals.CurTime()) and (nextAttack <= globals.CurTime())
end

local function OnCreateMove(pCmd)
    -- Get the local player entity
    local pLocal = entities.GetLocalPlayer()
    if not pLocal or not pLocal:IsAlive() then
        goto continue -- Return if the local player entity doesn't exist or is dead
    end

    -- Check if the local player is a spy
    local pLocalClass = pLocal:GetPropInt("m_iClass")
    if pLocalClass == nil or pLocalClass ~= 5 then
        goto continue -- Skip the rest of the code if not medic
    end

    -- Check if the local player is a Medic
    if pLocalClass == 5 then
        -- Get the local player's active weapon
        local pWeapon = pLocal:GetPropEntity("m_hActiveWeapon")
        if not pWeapon then
            goto continue -- Return if the local player doesn't have an active weapon
        end

        -- Get the weapon definition index
        local pWeaponDefIndex = pWeapon:GetPropInt("m_iItemDefinitionIndex")

        -- Check for the Crossbow, assuming its definition index is 305 (replace with the correct index)
        if pWeaponDefIndex == 305 then
            --print("Medic has the Crossbow equipped!")
            if CanShoot(pLocal) == true then
                client.Command("slot2", true)
            end
        end
    end

    ::continue::
end


--[[ Remove the menu when unloaded ]]--
local function OnUnload()                                -- Called when the script is unloaded
    MenuLib.RemoveMenu(menu)                             -- Remove the menu
    UnloadLib() --unloading lualib
    client.Command('play "ui/buttonclickrelease"', true) -- Play the "buttonclickrelease" sound
end

--[[ Unregister previous callbacks ]]--
callbacks.Unregister("CreateMove", "MCT_CreateMove")            -- Unregister the "CreateMove" callback
callbacks.Unregister("Unload", "MCT_Unload")                    -- Unregister the "Unload" callback
--[[ Register callbacks ]]--
callbacks.Register("CreateMove", "MCT_CreateMove", OnCreateMove)             -- Register the "CreateMove" callback
callbacks.Register("Unload", "MCT_Unload", OnUnload)                         -- Register the "Unload" callback
--[[ Play sound when loaded ]]--
client.Command('play "ui/buttonclick"', true) -- Play the "buttonclick" sound when the script is loaded