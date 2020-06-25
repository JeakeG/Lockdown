AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("custom_menu.lua")

include("shared.lua")

local open = false

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
    if (player:GetPData("playerLvl") == nil) then
        player:SetNWInt("playerLvl", 1)
    else
        player:SetNWInt("playerLvl", player:GetPData("playerLvl"))
    end

    if (player:GetPData("playerExp") == nil) then
        player:SetNWInt("playerExp", 0)
    else
        player:SetNWInt("playerExp", player:GetPData("playerExp"))
    end

    if (player:GetPData("playerMoney") == nil) then
        player:SetNWInt("playerMoney", 0)
    else
        player:SetNWInt("playerMoney", player:GetPData("playerMoney"))
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
    if (open == false) then
        open = true
    else
        open = false
    end
    net.Start("FMenu")
        net.WriteBit(open)
    net.Broadcast()
end

function GM:PlayerDisconnected(player)
    player:SetPData("playerLvl", player:GetNWInt("playerLvl"))
    player:SetPData("playerExp", player:GetNWInt("playerExp"))
    player:SetPData("playerMoney", player:GetNWInt("playerMoney"))
end

function GM:ShutDown()
    for k, v in pairs(player.GetAll()) do
        v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
        v:SetPData("playerExp", v:GetNWInt("playerExp"))
        v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
    end
end