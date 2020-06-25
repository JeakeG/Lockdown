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

function GM:OnNPCKilled(npc, attacker, inflictor)
    --Add money
    --Add exp and check for level up

inflictor:SetArmor(inflictor:Armor() + 1) 
end

function GM:PlayerDeath(victim, inflictor, attacker)
    --Add money
    --Add exp and check for level up
end

