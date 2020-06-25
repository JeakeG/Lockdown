AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("testhud.lua")

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
    
end
