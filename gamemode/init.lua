--[[
    Last Modified By: Jeake
    Last Modified On: 6/29/20
]]--

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("custom_menu.lua")
AddCSLuaFile("custom_scoreboard.lua")
AddCSLuaFile("player/sh_player.lua")
AddCSLuaFile("shop/sh_shop.lua")

include("shared.lua")
include("concommands.lua")
include("player/sh_player.lua")
include("player/sv_player.lua")
include("shop/sh_shop.lua")

//This function is run when the player spawns on the server for the first time
function GM:PlayerInitialSpawn(player)
    if (player:GetPData("playerLvl") == nil) then
        player:SetNWInt("playerLvl", 1)
    else
        player:SetNWInt("playerLvl", tonumber(player:GetPData("playerLvl")))
    end

    if (player:GetPData("playerExp") == nil) then
        player:SetNWInt("playerExp", 0)
    else
        player:SetNWInt("playerExp", tonumber(player:GetPData("playerExp")))
    end

    if (player:GetPData("playerMoney") == nil) then
        player:SetNWInt("playerMoney", 0)
    else
        player:SetNWInt("playerMoney", tonumber(player:GetPData("playerMoney")))
    end

    if (player:GetPData("playerWeapon") != nil) then
        player:SetNWString("playerWeapon", player:GetPData("playerWeapon"))
    end
end

//This function is run when an npc is killed
function GM:OnNPCKilled(npc, attacker, inflictor)
    attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

    attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 75)
    checkForLevel(attacker)
end

//This function is run when a player is killed
function GM:PlayerDeath(victim, inflictor, attacker)
    if(IsValid(attacker) and attacker:IsPlayer()) then
        if (victim == attacker) then
            victim:SetFrags(victim:Frags() + 1)
        else
            attacker:AddToBalance(100)
            attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 75)

            checkForLevel(attacker)
        end
    end
end

//This function checks to see if the player should level up based on their experience
function checkForLevel(player)
    local expToLevel = (player:GetNWInt("playerLvl") * 100) * 2
    local curExp = player:GetNWInt("playerExp")
    local curLvl = player:GetNWInt("playerLvl")

    if(curExp >= expToLevel) then
        curExp = curExp - expToLevel
        player:SetNWInt("playerExp", curExp)
        player:SetNWInt("playerLvl", curLvl + 1)

        player:PrintMessage(HUD_PRINTTALK, "Congratulations! You have reached level " .. (curLvl + 1) .. ".")
    end
end

//This function is run with "F4" is pressed
function GM:ShowSpare2(player)
    player:ConCommand("open_game_menu")
end

//This function is run when a player disconnects from the server
function GM:PlayerDisconnected(player)
    player:SetPData("playerLvl", player:GetNWInt("playerLvl"))
    player:SetPData("playerExp", player:GetNWInt("playerExp"))
    player:SetPData("playerMoney", player:GetNWInt("playerMoney"))
    player:SetPData("playerWeapon", player:GetNWString("playerWeapon"))
end

//This function is run when giving the player their loadout when spawning
function GM:PlayerLoadout(player)
    player:Give("ld_tool")

    return true
end

local fallDamageMode = 1

//This function is run when a player takes fall damage
function GM:GetFallDamage(player, speed)
    if (fallDamageMode == 0) then
        //This is for "realistic" fall damage
        return (speed / 8)
    elseif (fallDamageMode == 1) then
        //This is for "Counter Strike: Source" fall damage
        return math.max(0, math.ceil(0.2418 * speed - 141.75))
    else
        //Returns 10 if the given fall damage mode is invalid
        return 10
    end
end

//This function is run when the server is shutting down
function GM:ShutDown()
    for k, v in pairs(player.GetAll()) do
        v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
        v:SetPData("playerExp", v:GetNWInt("playerExp"))
        v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
        v:SetPData("playerWeapon", v:GetNWString("playerWeapon"))
    end
end