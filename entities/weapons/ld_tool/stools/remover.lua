--[[
	Last Modified By: Jeake
	Last Modified On: 6/29/20

	6/29/20 - copied almost all of this from the base remover tool in the sandbox gamemode changed very few things that were giving me errors
]]--

TOOL.Category       = "Lockdown"
TOOL.Name           = "Remover"
TOOL.Command        = nil
TOOL.ConfigName     = ""

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

local function DoRemoveEntity( ent )

	if ( !IsValid( ent ) || ent:IsPlayer() ) then return false end

	-- Nothing for the client to do here
	if ( CLIENT ) then return true end

	-- Remove it properly in 1 second
	timer.Simple( 1, function() if ( IsValid( ent ) ) then ent:Remove() end end )

	-- Make it non solid
	ent:SetNotSolid( true )
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetNoDraw( true )

	-- Send Effect
	local ed = EffectData()
		ed:SetOrigin( ent:GetPos() )
		ed:SetEntity( ent )
	util.Effect( "entity_remove", ed, true, true )

	return true

end

--
-- Remove a single entity
--
function TOOL:LeftClick( trace )

	if ( DoRemoveEntity( trace.Entity ) ) then

		if ( !CLIENT ) then
			self:GetOwner():SendLua( "achievements.Remover()" )
		end

		return true

	end

	return false

end

--
-- Reload removes all constraints on the targetted entity
--
function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveAll( trace.Entity )

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.remover.desc" } )

end
