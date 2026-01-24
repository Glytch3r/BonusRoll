----------------------------------------------------------------
-----  ▄▄▄   ▄    ▄   ▄  ▄▄▄▄▄   ▄▄▄   ▄   ▄   ▄▄▄    ▄▄▄  -----
----- █   ▀  █    █▄▄▄█    █    █   ▀  █▄▄▄█  ▀  ▄█  █ ▄▄▀ -----
----- █  ▀█  █      █      █    █   ▄  █   █  ▄   █  █   █ -----
-----  ▀▀▀▀  ▀▀▀▀   ▀      ▀     ▀▀▀   ▀   ▀   ▀▀▀   ▀   ▀ -----
----------------------------------------------------------------
--                                                            --
--   Project Zomboid Modding Commissions                      --
--   https://steamcommunity.com/id/glytch3r/myworkshopfiles   --
--                                                            --
--   ▫ Discord  ꞉   glytch3r                                  --
--   ▫ Support  ꞉   https://ko-fi.com/glytch3r                --
--   ▫ Youtube  ꞉   https://www.youtube.com/@glytch3r         --
--   ▫ Github   ꞉   https://github.com/Glytch3r               --
--                                                            --
----------------------------------------------------------------
----- ▄   ▄   ▄▄▄   ▄   ▄   ▄▄▄     ▄      ▄   ▄▄▄▄  ▄▄▄▄  -----
----- █   █  █   ▀  █   █  ▀   █    █      █      █  █▄  █ -----
----- ▄▀▀ █  █▀  ▄  █▀▀▀█  ▄   █    █    █▀▀▀█    █  ▄   █ -----
-----  ▀▀▀    ▀▀▀   ▀   ▀   ▀▀▀   ▀▀▀▀▀  ▀   ▀    ▀   ▀▀▀  -----
----------------------------------------------------------------
--client/BonusRoll_Time.lua
BonusRoll = BonusRoll or {}

BonusRoll.diceTab = {
    ["Base.Dice"]=true,
    ["Base.Dice_Bone"]=true,
    ["Base.Dice_Wood"]=true,
    ["Base.Dice_00"]=true,
    ["Base.Dice_10"]=true,
    ["Base.Dice_12"]=true,
    ["Base.Dice_20"]=true,
    ["Base.Dice_4"]=true,
    ["Base.Dice_6"]=true,
    ["Base.Dice_8"]=true,
}

BonusRoll.durationTab = BonusRoll.durationTab or {}

function BonusRoll.init()
    local pl = getPlayer()
    if not pl then return end
    local md = pl:getModData()
    md.BonusRoll = md.BonusRoll or {}
    for fType, _ in pairs(BonusRoll.diceTab) do
        md.BonusRoll[fType] = md.BonusRoll[fType] or {
            cooldown = 0,
            roll = 0,
            duration = 0
        }
    end
    if SandboxVars.BonusRoll.loginResets then
        BonusRoll.doReset()
    end
end
Events.OnCreatePlayer.Add(BonusRoll.init)

function BonusRoll.doReset()
    local pl = getPlayer()
    if not pl then return end
    local md = pl:getModData()
    md.BonusRoll = {}
    for fType, _ in pairs(BonusRoll.diceTab) do
        md.BonusRoll[fType] = {
            cooldown = 0,
            roll = 0,
            duration = 0
        }
    end
    BonusRoll.delRadiusMarker()
end

function BonusRoll.getRemaining(fType)
    local pl = getPlayer()
    if not pl or not fType then return 0 end
    local dice = pl:getModData().BonusRoll[fType]
    return dice and dice.duration or 0
end

function BonusRoll.getCooldown(fType)
    local pl = getPlayer()
    if not pl or not fType then return 0 end
    local dice = pl:getModData().BonusRoll[fType]
    return dice and dice.cooldown or 0
end

function BonusRoll.cooldownHandler()
    local pl = getPlayer()
    if not pl then return end
    local md = pl:getModData()
    if not md.BonusRoll then return end
    
    for _, dice in pairs(md.BonusRoll) do
        if dice.cooldown and dice.cooldown > 0 then
            dice.cooldown = math.max(0, dice.cooldown - 1)
        end
    end
end
Events.EveryHours.Add(BonusRoll.cooldownHandler)

function BonusRoll.durationHandler()
    if getGameTime():getTrueMultiplier() > 1 then return end
    local pl = getPlayer()
    if not pl then return end
    local md = pl:getModData()
    if not md.BonusRoll then return end
    
    for _, dice in pairs(md.BonusRoll) do
        if dice.duration and dice.duration > 0 then
            dice.duration = math.max(0, dice.duration - 1)
            if dice.duration == 0 then
                dice.roll = 0
            end
        end
    end
end
Events.EveryOneMinute.Add(BonusRoll.durationHandler)

function BonusRoll.getDuration(roll)
    return tonumber(BonusRoll.durationTab[roll]) or 0
end

function BonusRoll.pause(seconds, callback)
    local start = getTimestampMs()
    local dur = seconds * 1000
    local function tick()
        if getTimestampMs() - start >= dur then
            Events.OnTick.Remove(tick)
            if callback then callback() end
        end
    end
    Events.OnTick.Add(tick)
end