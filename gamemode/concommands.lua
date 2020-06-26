function buyEntity(player, cmd, args)
    if (args[1] != nil) then
        local ent = ents.Create(args[1])
        local tr = player:GetEyeTrace()
        local balance = player:GetNWInt("playerMoney")

        if (ent:IsValid()) then
            local ClassName = ent:GetClass()

            if (!tr.Hit) then return end

            local entCount = player:GetNWInt(ClassName .. "count")

            if (entCount < ent.Limit && balance >= ent.Cost) then
                local spawnPos = player:GetShootPos() + player:GetForward() * 80

                ent.Owner = player

                ent:SetPos(spawnPos)
                ent:Spawn()
                ent:Activate()

                player:SetNWInt(ClassName .. "count", entCount + 1)
                player:SetNWInt("playerMoney", balance - ent.Cost)

                return ent
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
            local balance = player:GetNWInt("playerMoney")
            local playerLvl = player:GetNWInt("playerLvl")
            local gunCost = v[2]
            local levelReq = v[3]

            if (balance >= gunCost && playerLvl >= levelReq) then
                player:SetNWInt("playerMoney", balance - gunCost)
                player:Give(args[1])
                player:GiveAmmo(20, player:GetWeapon(args[1]):GetPrimaryAmmoType(), false)
            end
            return
        end
    end
end
concommand.Add("buy_gun", buyGun)