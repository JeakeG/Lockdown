--[[
	Last Modified By: Jeake
	Last Modified On: 7/1/20
]]--

local gmod_drawhelp = CreateClientConVar( "gmod_drawhelp", "1", true, false, "Should the tool HUD be displayed when the tool gun is active?" )
local gmod_toolmode = CreateClientConVar( "gmod_toolmode", "rope", true, true )
CreateClientConVar( "gmod_drawtooleffects", "1", true, false, "Should tools draw certain UI elements or effects? ( Will not work for all tools )" )

cvars.AddChangeCallback( "gmod_toolmode", function( name, old, new )
	if ( old == new ) then return end
	spawnmenu.ActivateTool( new, true )
end, "gmod_toolmode_panel" )

include( "shared.lua" )
include( "cl_viewscreen.lua" )

SWEP.Slot			= 5
SWEP.SlotPos		= 6
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false

local shouldDrawHUD = false

--------------I dont really know what these do-------------
function SWEP:SetStage( ... )
	if ( !self:GetToolObject() ) then return end
	return self:GetToolObject():SetStage( ... )
end

function SWEP:GetStage( ... )
	if ( !self:GetToolObject() ) then return end
	return self:GetToolObject():GetStage( ... )
end

function SWEP:ClearObjects( ... )
	if ( !self:GetToolObject() ) then return end
	self:GetToolObject():ClearObjects( ... )
end

function SWEP:StartGhostEntities( ... )
	if ( !self:GetToolObject() ) then return end
	self:GetToolObject():StartGhostEntities( ... )
end

function SWEP:FreezeMovement()
	local mode = self:GetMode()
	if ( !self:GetToolObject() ) then return false end
	return self:GetToolObject():FreezeMovement()
end
-----------------------------------------------------------

//Hooks that are called when keys are pressed and released, will be used to determine when tool hud should show
local function KeyPress (ply, key)
	if (!IsValid(ply)) then return end

	if (key == IN_ATTACK2) then
		shouldDrawHUD = true
	end
end
hook.Add("KeyPress", "keypress_show_tool_menu", KeyPress)

local function KeyRelease (ply, key)
	if (!IsValid(ply)) then return end

	if (key == IN_ATTACK2) then
		shouldDrawHUD = false
	end
end
hook.Add("KeyRelease", "keyrelease_show_tool_menu", KeyRelease)

//This will draw the radial menu to choose a tool when right click is held down
ply = LocalPlayer()
function SWEP:DrawHUD()
	if(shouldDrawHUD) then
		surface.SetDrawColor(15, 15, 15, 225)
		DrawCircle(ScrW() / 2, ScrH() / 2, 125, 60, 1000)
		--TestCircle(ScrW() / 2, ScrH() / 2, 250, 150, 256)
		gui.EnableScreenClicker(true)
	else
		gui.EnableScreenClicker(false)
	end
end

//Function used to draw the tool menu circle background on screen
function DrawCircle( x, y, oRad, iRad, seg )
	
	local halfSeg = seg / 4
	for i = 0, halfSeg - 1 do
		local cir = {}
		local ang = math.rad( ( i / (halfSeg) ) * -360 )
		local nextAng = math.rad( ( (i + 1) / (halfSeg) ) * -360 )
		table.insert( cir, { x = x + math.sin(ang) * oRad, y = y + math.cos(ang) * oRad} )
		table.insert( cir, { x = x + math.sin(nextAng) * oRad, y = y + math.cos(nextAng) * oRad} )
		table.insert( cir, { x = x + math.sin(nextAng) * iRad, y = y + math.cos(nextAng) * iRad} )
		table.insert( cir, { x = x + math.sin(ang) * iRad, y = y + math.cos(ang) * iRad} )
		surface.DrawPoly(cir)
	end
end