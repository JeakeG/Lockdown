function buyEntity(player, cmd, args)
    if (args[1] != nil) then
        local ent = ents.Create(args[1])
        local tr = player:GetEyeTrace()

        if (IsValid(ent)) then
            local ClassName = ent:GetClass()

            if (!tr.Hit) then return end

            local entCount = player:GetNWInt(ClassName .. "count")

            if(!ent.Limit or entCount < ent.Limit) then
                if (player:CanAfford(ent.Cost)) then
                    local spawnPos = player:GetShootPos() + player:GetForward() * 80

                    ent.Owner = player

                    ent:SetPos(spawnPos)
                    ent:Spawn()
                    ent:Activate()

                    player:SetNWInt(ClassName .. "count", entCount + 1)
                    player:RemoveFromBalance(ent.Cost)

                    return ent
                else
                    player:PrintMessage(HUD_PRINTTALK, "You do not have enough money to purchase this.")
                end
            else
                player:PrintMessage(HUD_PRINTTALK, "Maximum amount of this entity has been reached. MAX = " .. ent.Limit)
            end
            return
        end
    end
end
concommand.Add("buy_entity", buyEntity)

function buyGun(player, cmd, args)
    local weaponPrices = {}
    weaponPrices[1] = {"weapon_smg1", 100, 5}

    for k, v in pairs(weaponPrices) do
        if (args[1] == v[1]) then
            local playerLvl = player:GetLevel()
            local gunCost = v[2]
            local levelReq = v[3]

            if (playerLvl >= levelReq) then
                if (player:CanAfford(gunCost)) then
                    player:RemoveFromBalance(gunCost)
                    player:SetNWString("playerWeapon", args[1])
                    player:Give(args[1])
                    player:GiveAmmo(20, player:GetWeapon(args[1]):GetPrimaryAmmoType(), false)
                else
                    player:PrintMessage(HUD_PRINTTALK, "You do not have enough money to purchase this.")
                end
            else
                player:PrintMessage(HUD_PRINTTALK, "Level " .. levelReq .. " is required to purchase this.")
            end
            return
        end
    end
end
concommand.Add("buy_gun", buyGun)