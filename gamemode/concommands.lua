--[[
    Last Modified By: Jeake
    Last Modified On: 6/30/20

]]--

local function buyItem(ply, _, args)
    local categoryName = args[1]
    local itemName = args[2]

    local itemTable = LOCKDOWN.ShopItems[categoryName][itemName]

    local isGun = itemTable.IsGun or false
    local price = itemTable.Price
    local levelReq = itemTable.LevelReq
    local limit = itemTable.Limit
    local model = itemTable.Model
    local className = itemTable.ClassName

    if !ply:CanAfford(price) then
        ply:ChatPrint("You cannot afford this item!")
        return 
    end

    if ply:GetLevel() < levelReq then
        ply:ChatPrint("You are not high enough level to purchase this item!")
        return
    end

    if isGun then
        ply:Give(className)
        ply:GiveAmmo(25, ply:GetWeapon(tostring(className)):GetPrimaryAmmoType(), false)
    else
        if limit then
            local plyCurentSpawnAmount = ply:GetVar("amount_" .. itemName, 0)
            
            if plyCurentSpawnAmount >= limit then
                ply:ChatPrint("The spawn limit for this item has been reached!")
            end
        end

        local tr = {}
        tr.start = ply:EyePos()
        tr.endpos = tr.start + ply:GetAimVector() * 85
        tr.filter = ply

        tr = util.TraceLine(tr)

        local SpawnPos = tr.HitPos + Vector(0, 0, 40)
        local SpawnAng = ply:EyeAngles()
        SpawnAng.pitch = 0
        SpawnAng.yaw = SpawnAng.yaw + 180

        local ent = ents.Create(className)
        ent.Owner = ply
        ent:SetModel(model)
        ent:SetPos(SpawnPos)
        ent:SetAngles(SpawnAng)
        ent:Spawn()
        ent:Activate()

    end

    ply:RemoveFromBalance(price)
end
concommand.Add("buy_item", buyItem)

//Console Command to add money to a ply's account
function AddplyMoney (ply, command, args)
    if (ply:IsAdmin()) then
        if(tonumber(args[1]) != nil) then
            ply:AddToBalance(args[1])
        else
        print("not a number")
        end
    else
        print("you are not an admin")
    end
end
concommand.Add("add_money", AddplyMoney)

//Console Command to set money in a ply's account
function SetplyMoney (ply, command, args)
    if (ply:IsAdmin()) then
        if(tonumber(args[1]) != nil) then
            ply:SetBalance(args[1])
        else
            print("not a number")
        end
    else
        print("you are not an admin")
    end
end
concommand.Add("set_money", SetplyMoney)

//Function to get a ply from a ply id
function GetplyByID(steamID)
    //Returns if the client calls the command
    if CLIENT then return nil end

    //Loops through all plys in server
    for k, v in pairs(ply.GetAll()) do
        //Returns a ply is the steamID of the ply matches the given ID
        if (v:SteamID() == steamID) then
            return v
        end
    end

    //If no ply is found, returns nil
    return nil
end

//Test function
local function TestConCommandFunc(ply, command, args)
    print(player.GetAll())
    -- for i, v in ipairs(ply.GetAll()) do
    --     print(v:Nick())
    -- end
end
concommand.Add("ld_test", TestConCommandFunc)