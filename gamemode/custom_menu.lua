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

    if (net.ReadBit() == 0) then 
        Menu:Hide()
        gui.EnableScreenClicker(false)
    else
        Menu:Show()
        gui.EnableScreenClicker(true)
    end
end)