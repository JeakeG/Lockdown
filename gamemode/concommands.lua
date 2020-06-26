function handleLimitChange(ent, itemName, player)
    player:SetVar("amount_" .. itemName, player:GetVar("amount_" .. itemName, 0) + 1)

    ent:CallOnRemove("DecrementLimit", function()
        player:SetVar("amount_" .. itemName, player:GetVar("amount_" .. itemName) - 1)
    end)
end
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
        player:GiveAmmo(25, player:GetWeapon(classname):GetPrimaryAmmoType(), false)
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