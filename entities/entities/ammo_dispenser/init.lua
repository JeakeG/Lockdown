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

    self:SetHealth(self.BaseHealth)
end

function ENT:SpawnFunction(player, tr, ClassName)
    if (!tr.Hit) then return end

    local entCount = player:GetNWInt(ClassName .. "count")

    if (entCount < self.Limit) then
        local spawnPos = player:GetShootPos() + player:GetForward() * 80

        self.Owner = player

        local ent = ents.Create(ClassName)
        ent:SetPos(spawnPos)
        ent:Spawn()
        ent:Activate()

        player:SetNWInt(ClassName .. "count", entCount + 1)

        return ent
    end

    return
end

function ENT:Use(activator, caller)
    local ammoType = activator:GetActiveWeapon():GetPrimaryAmmoType()

    activator:GiveAmmo(5, ammoType, false)
end

function ENT:Think()
    --Called every tick
end

function ENT:OnTakeDamage(damage)
    self:SetHealth(self:Health() - damage:GetDamage())

    if (self:Health() <= 0) then
        self:Remove()
    end
end

function ENT:OnRemove()
    local Owner = self.Owner
    local ClassName = self:GetClass()
    local entCount = Owner:GetNWInt(ClassName .. "count")

    Owner:SetNWInt(ClassName .. "count", entCount - 1)
end