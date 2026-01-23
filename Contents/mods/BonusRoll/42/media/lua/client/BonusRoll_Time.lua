--client/BonusRoll_Time.lua
BonusRoll = BonusRoll or {}

-- client/BonusRoll_Time.lua
BonusRoll = BonusRoll or {}

function BonusRoll.init()
    local pl = getPlayer()
    if not pl then return end
    local md = pl:getModData()
    md.BonusRoll = md.BonusRoll or {}
    md.BonusRoll.cooldown = md.BonusRoll.cooldown or 0
    md.BonusRoll.roll = md.BonusRoll.roll or 0
    md.BonusRoll.duration = md.BonusRoll.duration or 0
    md.BonusRoll.dice = md.BonusRoll.dice or {}

    for fType, _ in pairs(BonusRoll.diceInitTab) do
        md.BonusRoll.dice[fType] = md.BonusRoll.dice[fType] or {
            roll = 0,
            duration = 0,
            active = false
        }
    end

    if SandboxVars.BonusRoll.loginResets then
        return BonusRoll.doReset()
    end
end
Events.OnCreatePlayer.Add(BonusRoll.init)
function BonusRoll.doReset()
    local pl = getPlayer()
    if not pl then return end
    local md = pl:getModData()
    md.BonusRoll = {}
    md.BonusRoll.cooldown = 0
    md.BonusRoll.roll = 0
    md.BonusRoll.duration = 0
    md.BonusRoll.activeDice = nil
    md.BonusRoll.dice = {}

    for fType, _ in pairs(BonusRoll.diceInitTab) do
        md.BonusRoll.dice[fType] = {
            roll = 0,
            duration = 0,
            active = false
        }
    end

    BonusRoll.delRadiusMarker()
end

function BonusRoll.getRemaining()
    local pl = getPlayer()
    if not pl then return 0 end
    local md = pl:getModData()
    local activeDice = md.BonusRoll.activeDice
    if not activeDice then return 0 end
    local diceData = md.BonusRoll.dice[activeDice]
    return diceData and diceData.duration or 0
end

function BonusRoll.getCooldown()
    local pl = getPlayer()
    if not pl then return 0 end
    local md = pl:getModData()
    return md.BonusRoll.cooldown or 0
end

function BonusRoll.cooldownHandler()
    local pl = getPlayer()
    local md = pl:getModData().BonusRoll
    md.cooldown = math.max(0, md.cooldown - 1)
    if getCore():getDebug() then
        local msg = 'BonusRoll Cooldown: '..tostring(md.cooldown)
        pl:addLineChatElement(msg)
        print(msg)
    end
end
Events.EveryHours.Add(BonusRoll.cooldownHandler)

function BonusRoll.durationHandler()
    if getGameTime():getTrueMultiplier() > 1 then return end
    local pl = getPlayer()
    local md = pl:getModData().BonusRoll
    if md.duration > 0 then
        md.duration = math.max(0, md.duration - 1)
    elseif md.duration <= 0 then
        md.roll = 0
        md.activeDice = nil
    end

    for fType, diceData in pairs(md.dice or {}) do
        if diceData.duration > 0 then
            diceData.duration = math.max(0, diceData.duration - 1)
        elseif diceData.duration <= 0 then
            diceData.roll = 0
            diceData.active = false
        end
    end
end
Events.EveryOneMinute.Add(BonusRoll.durationHandler)

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

function BonusRoll.getDuration(roll)
    return tonumber(BonusRoll.durationTab[roll]) or 0
end

function BonusRoll.isAnyDicePlaying()
    local pl = getPlayer()
    local md = pl:getModData().BonusRoll
    for fType, diceData in pairs(md.dice or {}) do
        if diceData.duration and diceData.duration > 0 then
            return true
        end
    end
    return false
end

function BonusRoll.doReset()
    local pl = getPlayer()
    local md = pl:getModData()
    md.BonusRoll = {}
    md.BonusRoll.cooldown =  0
    md.BonusRoll.roll = 0
    md.BonusRoll.duration = 0
    BonusRoll.delRadiusMarker()
end
function BonusRoll.getRemaining()
    local pl = getPlayer() 
    local md = pl:getModData()
    return md.BonusRoll.duration
end


function BonusRoll.getCooldown()
    local pl = getPlayer() 
    local md = pl:getModData()
    return md.BonusRoll.cooldown
end


function BonusRoll.cooldownHandler()
    local pl = getPlayer() 
    local md = pl:getModData().BonusRoll
    md.cooldown = math.max(0, md.cooldown - 1)
  --[[   if md.cooldown <= 0 then 
        BonusRoll.doReset()
    end ]]
    if getCore():getDebug() then      
        local msg = 'BonusRoll Cooldown: '..tostring(md.cooldown)
        pl:addLineChatElement(msg)
        print(msg)
    end
end
Events.EveryHours.Add(BonusRoll.cooldownHandler)

function BonusRoll.durationHandler()
    -- UIManager.getSpeedControls():getCurrentGameSpeed() 
    if getGameTime():getTrueMultiplier() > 1 then return end
    local md = getPlayer():getModData().BonusRoll
    if md.duration > 0 then
        md.duration = math.max(0, md.duration - 1)
    elseif md.duration <= 0 then
        md.roll = 0
    end
end
Events.EveryOneMinute.Add(BonusRoll.durationHandler)

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

function BonusRoll.getDuration(roll)
    return tonumber(BonusRoll.durationTab[roll]) or 0
end

