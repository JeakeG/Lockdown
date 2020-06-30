GM.Name = "Lockdown"
GM.Author = "Jeake"
GM.Email = "N/A"
GM.Website = "N/A"

--DeriveGamemode("sandbox")

LOCKDOWN = {}

//This function is called to determine whether or not the tool gun can be used
function GM:CanTool(player, trace, mode)

    //This is a list of the current stools in this gamemode
    toolModes = {"remover"}

    //Loops through the modes to see if one of them is the current tool gun mode
    for k, v in pairs(toolModes) do
        if (v == mode) then return true end
    end

    //If the tool mode is not found in the toolModes list, then return false
    return false
end