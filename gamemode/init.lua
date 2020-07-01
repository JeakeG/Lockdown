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

//This function is run when the ply spawns on the server for the first time
function GM:PlayerInitialSpawn(ply)
    if (ply:GetPData("playerLvl") == nil) then
        ply:SetNWInt("playerLvl", 1)
    else
        ply:SetNWInt("playerLvl", tonumber(ply:GetPData("playerLvl")))
    end

    if (ply:GetPData("playerExp") == nil) then
        ply:SetNWInt("playerExp", 0)
    else
        ply:SetNWInt("playerExp", tonumber(ply:GetPData("playerExp")))
    end

    if (ply:GetPData("playerMoney") == nil) then
        ply:SetNWInt("playerMoney", 0)
    else
        ply:SetNWInt("playerMoney", tonumber(ply:GetPData("playerMoney")))
    end

    if (ply:GetPData("playerWeapon") != nil) then
        ply:SetNWString("playerWeapon", ply:GetPData("playerWeapon"))
    end
end

//This function is run when an npc is killed
function GM:OnNPCKilled(npc, attacker, inflictor)
    attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

    attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 75)
    checkForLevel(attacker)
end

//This function is run when a ply is killed
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

//This function checks to see if the ply should level up based on their experience
function checkForLevel(ply)
    local expToLevel = (ply:GetNWInt("playerLvl") * 100) * 2
    local curExp = ply:GetNWInt("playerExp")
    local curLvl = ply:GetNWInt("playerLvl")

    if(curExp >= expToLevel) then
        curExp = curExp - expToLevel
        ply:SetNWInt("playerExp", curExp)
        ply:SetNWInt("playerLvl", curLvl + 1)

        ply:PrintMessage(HUD_PRINTTALK, "Congratulations! You have reached level " .. (curLvl + 1) .. ".")
    end
end

//This function is run with "F4" is pressed
function GM:ShowSpare2(ply)
    ply:ConCommand("open_game_menu")
end

//This function is run when a ply disconnects from the server
function GM:PlayerDisconnected(ply)
    ply:SetPData("playerLvl", ply:GetNWInt("playerLvl"))
    ply:SetPData("playerExp", ply:GetNWInt("playerExp"))
    ply:SetPData("playerMoney", ply:GetNWInt("playerMoney"))
    ply:SetPData("playerWeapon", ply:GetNWString("playerWeapon"))
end

//This function is run when giving the ply their loadout when spawning
function GM:PlayerLoadout(ply)
    ply:Give("ld_tool")

    return true
end

local fallDamageMode = 1

//This function is run when a ply takes fall damage
function GM:GetFallDamage(ply, speed)
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
    for k, v in pairs(ply.GetAll()) do
        v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
        v:SetPData("playerExp", v:GetNWInt("playerExp"))
        v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
        v:SetPData("playerWeapon", v:GetNWString("playerWeapon"))
    end
end