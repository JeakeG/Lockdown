
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "ghostentity.lua" )
AddCSLuaFile( "object.lua" )
AddCSLuaFile( "stool.lua" )
AddCSLuaFile( "cl_viewscreen.lua" )
AddCSLuaFile( "stool_cl.lua" )

include( "shared.lua" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

-- Should this weapon be dropped when its owner dies?
function SWEP:ShouldDropOnDie()
	return false
end