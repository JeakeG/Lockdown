local menu
local ply

local function openF4Menu()
    ply = LocalPlayer()

    if (IsValid(menu)) then
        menu:Show()
    else
        menu = vgui.Create("F4Menu")

        local shopPanel = vgui.Create("ShopPanel", menu)

        menu:AddSheet("Shop", shopPanel)
    end
end
concommand.Add("open_game_menu", openF4Menu)

local PANEL = {}

function PANEL:Init()
    self:StretchToParent(100, 100, 100, 100)
    self:Center()
    self:MakePopup()
    self:SetupCloseButton(function()
        self:Close()
    end)
    self:ParentToHUD()
end

function PANEL:SetupCloseButton(func)
    self.CloseButton = self.tabScroller:Add("DButton")
    self.CloseButton:SetText("")
    self.CloseButton.DoClick = func
    self.CloseButton.Paint = function(panel, w, h)
    derma.SkinHook("Paint", "WindowCloseButton", panel, w, h)
    end
    self.CloseButton:Dock(RIGHT)
    self.CloseButton:DockMargin(0, 0, 0, 8)
    self.CloseButton:SetSize(32, 32)
end

function PANEL:Show()
    self:SetVisible(true)
end

function PANEL:Hide()
    self:SetVisible(false)
end

function PANEL:Close()
    self:Hide()
end
vgui.Register("F4Menu", PANEL, "DPropertySheet")

PANEL = {}

function PANEL:Init()
    local categoryList = vgui.Create("DCategoryList", self)
    categoryList:Dock(FILL)

    for categoryName, categoryTable in SortedPairs(LOCKDOWN.ShopItems) do
        local collapsibleCategory = vgui.Create("DCollapsibleCategory", categoryList)
        collapsibleCategory:SetLabel(categoryName)

        local iconLayout = vgui.Create("DIconLayout", collapsibleCategory)
        collapsibleCategory:SetContents(iconLayout)

        for itemName, itemTable in SortedPairsByMemberValue(categoryTable, "Price") do
            local model = itemTable.Model
            local price = itemTable.Price
            local levelReq = itemTable.LevelReq

            local icon = vgui.Create("SpawnIcon", iconLayout)
            icon:SetModel(model)
            icon:SetToolTip(
                itemName .. 
                "\nPrice: $" .. price .. 
                "\nLevel Req: " .. levelReq
                )
            icon.DoClick = function()
                RunConsoleCommand("buy_item", categoryName, itemName)
            end
        end
    end
end
vgui.Register("ShopPanel", PANEL, "DPanel")