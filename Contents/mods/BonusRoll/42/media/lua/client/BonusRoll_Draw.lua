--client/BonusRoll_Draw.lua
BonusRoll = BonusRoll or {}

BonusRoll.drawPanel = nil
BonusRoll.drawImagePath = nil

BonusRoll.ImgTab = {
    [0] = "",
    [1] = "You-Rolled-Reduced-Speed.png",
    [2] = "You-Rolled-Reduced-Damage.png",
    [3] = "You-Rolled-Health-Damage.png",
    [4] = "You-Rolled-Increased-Speed.png",
    [5] = "You-Rolled-Increased-Damage.png",
    [6] = "You-Rolled-Full-Heal.png",
    [7] = "You-Rolled-Spawn-Weapon.png",
}

function BonusRoll.getEffectImg(roll)
    local img = BonusRoll.ImgTab[roll] or "Rolled.png"
    if not img or img == "" then return nil end
    return "media/ui/BonusRoll/" .. img
end

function BonusRoll.setDrawImage(dir, active)
    if not active then
        if BonusRoll.drawPanel then
            BonusRoll.drawPanel:removeFromUIManager()
            BonusRoll.drawPanel = nil
        end
        BonusRoll.drawImagePath = nil
        return
    end

    if BonusRoll.drawPanel then return end
    if not dir then return end

    BonusRoll.drawImagePath = dir

    local tex = getTexture(dir)
    if not tex then return end

    local w = tex:getWidth()
    local h = tex:getHeight()

    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()

    local x = (sw - w) / 2
    local y = (sh - h) / 2

    BonusRoll.drawPanel = ISPanel:new(x, y, w, h)
    BonusRoll.drawPanel:initialise()
    BonusRoll.drawPanel:noBackground()
    --BonusRoll.drawPanel:setConsumeMouseEvents(false)
    BonusRoll.drawPanel:setCapture(false)
    BonusRoll.drawPanel:setAlwaysOnTop(true)
    BonusRoll.drawPanel:addToUIManager()

    BonusRoll.drawPanel.render = function(self)
        self:drawTextureScaled(
            getTexture(BonusRoll.drawImagePath),
            0, 0, w, h,
            1, 1, 1, 1
        )
    end
end

function BonusRoll.doShowImage(roll)
    local dir = BonusRoll.getEffectImg(roll)
    if not dir then return end
    BonusRoll.setDrawImage(dir, true)
    BonusRoll.pause(3, function()
        BonusRoll.setDrawImage(nil, false)
    end)
end

