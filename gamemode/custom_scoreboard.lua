--[[
    Last Modified By: Jeake
    Last Modified On: 6/30/20
]]--

local ScoreboardDerma = nil
local plyList = nil

function GM:ScoreboardShow()
    if (!IsValid(ScoreboardDerma)) then
        ScoreboardDerma = vgui.Create("DFrame")
        ScoreboardDerma:SetSize(750, 500)
        ScoreboardDerma:Center()
        ScoreboardDerma:SetTitle("Scoreboard")
        ScoreboardDerma:SetDraggable(false)
        ScoreboardDerma:ShowCloseButton(false)
        ScoreboardDerma.Paint = function()
            draw.RoundedBox(5, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(60, 60, 60, 255))
        end

        local plyScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
        plyScrollPanel:SetSize(ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall() - 20)
        plyScrollPanel:SetPos(0, 20)

        plyList = vgui.Create("DListLayout", plyScrollPanel)
        plyList:SetSize(plyScrollPanel:GetWide(), plyScrollPanel:GetTall())
        plyList:SetPos(0, 0)
    end

    if (IsValid(ScoreboardDerma)) then
        plyList:Clear()

        for k, v in pairs(player.GetAll()) do
            local plyPanel = vgui.Create("DPanel", plyList)
            plyPanel:SetSize(plyList:GetWide(), 50)
            plyPanel:SetPos(0, 0)
            plyPanel.Paint = function()
                draw.RoundedBox(0, 0, 0, plyPanel:GetWide(), plyPanel:GetTall(), Color(50, 50, 50, 255))
                draw.RoundedBox(0, 0, 49, plyPanel:GetWide(), 1, Color(255, 255, 255, 255))

                draw.SimpleText(v:GetName() .. " - Level: " .. v:GetNWInt("plyLvl"), "DermaDefaultBold", 20, 10,Color(255,255,255))
                draw.SimpleText("$ " .. v:GetNWInt("plyMoney"), "DermaDefaultBold", 20, 25, Color(255, 255, 255))
                draw.SimpleText("Kills: " .. v:Frags(), "DermaDefault", plyList:GetWide() - 20, 10, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
                draw.SimpleText("Deaths: " .. v:Deaths(), "DermaDefault", plyList:GetWide() - 20, 25, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            end
        end

        ScoreboardDerma:Show()
        ScoreboardDerma:MakePopup()
        ScoreboardDerma:SetKeyboardInputEnabled(false)
    end
end

function GM:ScoreboardHide()
    if (IsValid(ScoreboardDerma)) then
        ScoreboardDerma:Hide()
    end
end
