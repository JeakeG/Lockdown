local meta = FindMetaTable("Player")

function meta:AddToBalance(amount)
    local curBalance = self:GetBalance()
    print("Before: " .. self:GetBalance())
    self:SetBalance(curBalance + amount)
    print("After: " .. self:GetBalance())
end

function meta:RemoveFromBalance(amount)
    local curBalance = self:GetBalance()

    self:SetBalance(curBalance - amount)
end

function meta:SetBalance(amount)
    self:SetNWInt("playerMoney", amount)
end

function meta:SetLevel(level)
    self:SetNWInt("playerLvl", level)
end

function meta:AddExp(amount)
    local curExp = self:GetExp()

    self:SetExp(curExp + amount)
end

function meta:SetExp(amount)
    self:SetNWInt("playerMoney", amount)
end