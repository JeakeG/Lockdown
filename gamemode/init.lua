AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("custom_menu.lua")
AddCSLuaFile("custom_scoreboard.lua")

include("shared.lua")
include("concommands.lua")

local open = false

-- function GM:PlayerSpawn(player)
--     player:SetGravity(0.5)
--     player:SetRunSpeed(1500)
--     player:SetWalkSpeed(150)
--     player:SetupHands()
-- end

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

function GM:OnNPCKilled(npc, attacker, inflictor)
    attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

    attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 75)
    checkForLevel(attacker)
end

function GM:PlayerDeath(victim, inflictor, attacker)
    attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)

    attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 75)

    attacker:SetFrags(attacker:Frags() + 1)

    checkForLevel(attacker)
end

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

function GM:ShowSpare2(player)
    player:ConCommand("open_game_menu")
end

function GM:PlayerDisconnected(player)
    player:SetPData("playerLvl", player:GetNWInt("playerLvl"))
    player:SetPData("playerExp", player:GetNWInt("playerExp"))
    player:SetPData("playerMoney", player:GetNWInt("playerMoney"))
    player:SetPData("playerWeapon", player:GetNWString("playerWeapon"))
end

function GM:PlayerLoadout(player)
    player:Give("weapon_pistol")
    player:GiveAmmo(69, "Pistol", true)

    if (player:GetNWString("playerWeapon") != nil) then
        player:Give(player:GetNWString("playerWeapon"))
    end

    return true
end

function GM:ShutDown()
    for k, v in pairs(player.GetAll()) do
        v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
        v:SetPData("playerExp", v:GetNWInt("playerExp"))
        v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
        v:SetPData("playerWeapon", v:GetNWString("playerWeapon"))
    end
end