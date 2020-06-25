AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("hud.lua")

include("shared.lua")

function GM:PlayerSpawn(player)
    player:SetGravity(0.5)
    player:SetMaxHealth(100)
    player:SetHealth(100)
    player:SetRunSpeed(1500)
    player:SetWalkSpeed(150)
    player:Give("weapon_physgun")
    player:SetupHands()
end

function GM:PlayerInitialSpawn(player)
    if (player:GetNWInt("playerLvl") <= 0) then
        player:SetNWInt("playerLvl", 1)
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
    end
end

util.AddNetworkString("FMenu")
function GM:ShowSpare2(player)
    net.Start("FMenu")
    net.Broadcast()
end

