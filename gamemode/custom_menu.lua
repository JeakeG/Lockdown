local Menu

net.Receive("FMenu", function()
if (Menu == nil) then
        Menu = vgui.Create("DFrame")
        Menu:SetSize(750, 500)
        Menu:Center()
        Menu:SetTitle("Lockdown Menu")
        Menu:SetDraggable(false)
        Menu:ShowCloseButton(false)
        Menu:SetDeleteOnClose(false)
        Menu.Paint = function()
            surface.SetDrawColor(60, 60, 60, 255)
            surface.DrawRect(0, 0, Menu:GetWide(), Menu:GetTall())

            surface.SetDrawColor(40, 40, 40, 255)
            surface.DrawRect(0, 24, Menu:GetWide(), 1)
        end
    end

    addButtons(Menu)

    if (net.ReadBit() == 0) then 
        Menu:Hide()
        gui.EnableScreenClicker(false)
    else
        Menu:Show()
        gui.EnableScreenClicker(true)
    end
end)

function addButtons(Menu) 
    local playerButton = vgui.Create("DButton")
    playerButton:SetParent(Menu)
    playerButton:SetText("")
    playerButton:SetSize(100, 50)
    playerButton:SetPos(0, 25)
    playerButton.Paint = function()
        surface.SetDrawColor(50, 50, 50, 255)
        surface.DrawRect(0, 0, playerButton:GetWide(), playerButton:GetTall())

        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawRect(0, 49, playerButton:GetWide(), 1)
        surface.DrawRect(99, 0, 1, playerButton:GetTall())

        draw.DrawText("Player", "DermaDefaultBold", playerButton:GetWide() / 2, 17, Color(255, 255, 255, 255), 1)
    end
    playerButton.DoClick = function(playerButton)
        local playerPanel = Menu:Add("Player Panel")

        playerPanel.Paint = function()
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(0, 0, playerPanel:GetWide(), playerPanel:GetTall())
            surface.SetTextColor(255, 255, 255, 255)

            --Player Name
            surface.CreateFont("HeaderFont", {font="Default", size=30, weight=5000})
            surface.SetFont("HeaderFont")
            surface.SetTextPos(5, 0)
            surface.DrawText(LocalPlayer():GetName())

            --Player Exp and Level
            local expToLevel = (LocalPlayer():GetNWInt("playerLvl") * 100) * 2
            surface.SetFont("Default")
            surface.SetTextPos(8, 35)
            surface.DrawText("Level: " .. LocalPlayer():GetNWInt("playerLvl"))
            surface.DrawText("\tExp: " .. LocalPlayer():GetNWInt("playerExp") .. "/" .. expToLevel)

            --Player Balance
            surface.SetTextPos(8, 55)
            surface.DrawText("Balance: $" .. LocalPlayer():GetNWInt("playerMoney"))
        end
    end

    local shopButton = vgui.Create("DButton")
    shopButton:SetParent(Menu)
    shopButton:SetText("")
    shopButton:SetSize(100, 50)
    shopButton:SetPos(0, 75)
    shopButton.Paint = function()
        surface.SetDrawColor(50, 50, 50, 255)
        surface.DrawRect(0, 0, shopButton:GetWide(), shopButton:GetTall())

        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawRect(0, 49, shopButton:GetWide(), 1)
        surface.DrawRect(99, 0, 1, shopButton:GetTall())

        draw.DrawText("Shop", "DermaDefaultBold", shopButton:GetWide() / 2, 17, Color(255, 255, 255, 255), 1)
    end
    shopButton.DoClick = function(shopButton)
        local shopPanel = Menu:Add("Shop Panel")

        local entityCategory = vgui.Create("DCollapsibleCategory", shopPanel)
        entityCategory:SetPos(0, 0)
        entityCategory:SetSize(shopPanel:GetWide(), 100)
        entityCategory:SetLabel("Entities")

        local weaponCategory = vgui.Create("DCollapsibleCategory", shopPanel)
        weaponCategory:SetPos(0, 100)
        weaponCategory:SetSize(shopPanel:GetWide(), 100)
        weaponCategory:SetLabel("Weapons")

        local entityList = vgui.Create("DIconLayout", entityCategory)
        entityList:SetPos(0,20)
        entityList:SetSize(entityCategory:GetWide(), entityCategory:GetTall())
        entityList:SetSpaceY(5)
        entityList:SetSpaceX(5)

        local weaponList = vgui.Create("DIconLayout", weaponCategory)
        weaponList:SetPos(0,20)
        weaponList:SetSize(weaponCategory:GetWide(), weaponCategory:GetTall())
        weaponList:SetSpaceY(5)
        weaponList:SetSpaceX(5)
        
        local entsArr = {}
        entsArr[1] = scripted_ents.Get("ammo_dispenser")

        for k, v in pairs(entsArr) do
            local icon = vgui.Create("SpawnIcon", entityList)
            icon:SetModel(v["Model"])
            icon:SetToolTip(v["PrintName"] .. "\nCost: " .. "$" .. v["Cost"])
            entityList:Add(icon)
            icon.DoClick = function(icon)
                LocalPlayer():ConCommand("buy_entity " .. v["ClassName"])
            end
        end

        local weaponsArr = {}
        weaponsArr[1] = {"models/weapons/w_pist_deagle.mdl", "arccw_welrod", "Default Pistol", 125}

        for k, v in pairs(weaponsArr) do
            local icon = vgui.Create("SpawnIcon", weaponList)
            icon:SetModel(v[1])
            icon:SetToolTip(v[3] .. "\nCost: " .. "$" .. v[4])
            weaponList:Add(icon)
            icon.DoClick = function(icon)
                LocalPlayer():ConCommand("buy_gun " .. v[2] .. " " .. v[4])
            end
        end
    end
end

--Player Panel

PANEL = {}

function PANEL:Init()
    self:SetSize(650, 475)
    self:SetPos(100, 25)
end

function PANEL:Paint(width, height)
    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 255))
end

vgui.Register("Player Panel", PANEL, "Panel")

--End Player Panel

--Shop Panel

PANEL = {}

function PANEL:Init()
    self:SetSize(650, 475)
    self:SetPos(100, 25)
end

function PANEL:Paint(width, height)
    draw.RoundedBox(0, 0, 0, width, height, Color(255, 255, 255, 255))
end

vgui.Register("Shop Panel", PANEL, "Panel")

--End Shop Panel