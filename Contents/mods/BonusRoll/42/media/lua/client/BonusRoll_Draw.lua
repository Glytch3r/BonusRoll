--client/BonusRoll_Draw.lua
BonusRoll = BonusRoll or {}

BonusRoll.drawImageActive = false
BonusRoll.drawImageTex = nil

BonusRoll.ImgTab = {
    [0] = "",
    [1] = "You-Rolled-Reduced-Speed.png",
    [2] = "You-Rolled-Reduced-Damage.png",
    [3] = "You-Rolled-Health-Damage.png",
    [4] = "You-Rolled-Increased-Speed.png",
    [5] = "You-Rolled-Increased-Damage.png",
    [6] = "You-Rolled-Full-Heal.png",
}
function BonusRoll.getEffectImg(roll)
    local img = BonusRoll.ImgTab[roll]
    if not img or img == "" then return nil end
    return "media/ui/BonusRoll/" .. tostring(img)
end

function BonusRoll.doShowImage(roll)
    local dir = BonusRoll.getEffectImg(roll)
    if not dir then return end
    BonusRoll.setDrawImage(dir, true)
    BonusRoll.pause(3, function()
        BonusRoll.setDrawImage(nil, false)
    end)
end

function BonusRoll.setDrawImage(dir, active)
    if active and dir then
        BonusRoll.drawImageTex = getTexture(dir)
        BonusRoll.drawImageActive = BonusRoll.drawImageTex ~= nil
    else
        BonusRoll.drawImageActive = false
        BonusRoll.drawImageTex = nil
    end
end

function BonusRoll.drawHandler()
    if not BonusRoll.drawImageActive then return end
    local tex = BonusRoll.drawImageTex
    if not tex then return end

    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local tw = tex:getWidth()
    local th = tex:getHeight()

    tex:render((sw - tw) / 2, (sh - th) / 2, tw, th, 1, 1, 1, 1)
end
Events.OnPostUIDraw.Add(BonusRoll.drawHandler)
