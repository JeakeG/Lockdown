local meta = FindMetaTable("Player")

function meta:GetBalance()
    return self:GetNWInt("playerMoney", 0)
end

function meta:GetLevel()
    return self:GetNWInt("playerLvl", 1)
end

function meta:GetExp()
    return self:GetNWInt("playerExp", 0)
end

function meta:CanAfford(cost)
    if (tonumber(self:GetBalance()) >= tonumber(cost)) then
        return true
    end

    return false
end