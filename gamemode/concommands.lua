--[[
    Last Modified By: Jeake
    Last Modified On: 6/30/20

]]--

local function buyItem(player, _, args)
    local categoryName = args[1]
    local itemName = args[2]

    local itemTable = LOCKDOWN.ShopItems[categoryName][itemName]

    local isGun = itemTable.IsGun or false
    local price = itemTable.Price
    local levelReq = itemTable.LevelReq
    local limit = itemTable.Limit
    local model = itemTable.Model
    local className = itemTable.ClassName

    if !player:CanAfford(price) then
        player:ChatPrint("You cannot afford this item!")
        return 
    end

    if player:GetLevel() < levelReq then
        player:ChatPrint("You are not high enough level to purchase this item!")
        return
    end

    if isGun then
        player:Give(className)
        player:GiveAmmo(25, player:GetWeapon(tostring(className)):GetPrimaryAmmoType(), false)
    else
        if limit then
            local playerCurentSpawnAmount = player:GetVar("amount_" .. itemName, 0)
            
            if playerCurentSpawnAmount >= limit then
                player:ChatPrint("The spawn limit for this item has been reached!")
            end
        end

        local tr = {}
        tr.start = player:EyePos()
        tr.endpos = tr.start + player:GetAimVector() * 85
        tr.filter = player

        tr = util.TraceLine(tr)

        local SpawnPos = tr.HitPos + Vector(0, 0, 40)
        local SpawnAng = player:EyeAngles()
        SpawnAng.pitch = 0
        SpawnAng.yaw = SpawnAng.yaw + 180

        local ent = ents.Create(className)
        ent.Owner = player
        ent:SetModel(model)
        ent:SetPos(SpawnPos)
        ent:SetAngles(SpawnAng)
        ent:Spawn()
        ent:Activate()

        if limit then
            handleLimitChange(ent, itemName, player)
        end
    end

    player:RemoveFromBalance(price)
end
concommand.Add("buy_item", buyItem)

//Console Command to add money to a player's account
function AddPlayerMoney (player, command, args)
    if (player:IsAdmin()) then
        if(tonumber(args[1]) != nil) then
            player:AddToBalance(args[1])
        else
        print("not a number")
        end
    else
        print("you are not an admin")
    end
end
concommand.Add("add_money", AddPlayerMoney)

//Console Command to set money in a player's account
function SetPlayerMoney (player, command, args)
    if (player:IsAdmin()) then
        if(tonumber(args[1]) != nil) then
            player:SetBalance(args[1])
        else
            print("not a number")
        end
    else
        print("you are not an admin")
    end
end
concommand.Add("set_money", SetPlayerMoney)

//Function to get a player from a player id
function GetPlayerByID(steamID)
    //Returns if the client calls the command
    if CLIENT then return nil end

    //Loops through all players in server
    for k, v in pairs(player.GetAll()) do
        //Returns a player is the steamID of the player matches the given ID
        if (v:SteamID() == steamID) then
            return v
        end
    end

    //If no player is found, returns nil
    return nil
end

//Test function
local function TestConCommandFunc(player, command, args)
    local playerSteamID = player:SteamID()

    local playerByID = GetPlayerByID(playerSteamID)

    local playerNameByID = playerByID:GetName()

    print(playerNameByID)
end
concommand.Add("ld_test", TestConCommandFunc)