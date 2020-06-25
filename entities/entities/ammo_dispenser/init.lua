AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever_cart.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if (IsValid(phys)) then
        phys:Wake()
    end
end

function ENT:SpawnFunction(player, tr, ClassName)
    if (!tr.Hit) then return end

    local spawnPos = player:GetShootPos() + player:GetForward() * 80

    local ent = ents.Create(ClassName)
    ent:SetPos(spawnPos)
    ent:Spawn()
    ent:Activate()

    return ent
end

function ENT:Use(activator, caller)
    local ammoType = activator:GetActiveWeapon():GetPrimaryAmmoType()

    activator:GiveAmmo(5, ammoType, false)
end

function ENT:Think()
    --Called every tick
end