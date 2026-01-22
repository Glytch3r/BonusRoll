--client/BonusRoll_Time.lua
BonusRoll = BonusRoll or {}


BonusRoll.durationTab = {
    [0] = 0,
    [1] = 60,
    [2] = 60,
    [3] = 1,
    [4] = 60,
    [5] = 60,
    [6] = 1,
    [7] = 1,
}
function BonusRoll.init()
    if SandboxVars.BonusRoll.loginResets then
        return BonusRoll.doReset()
    end
    local pl = getPlayer()
    local md = pl:getModData()
    md.BonusRoll = md.BonusRoll or {}
    md.BonusRoll.cooldown = md.BonusRoll.cooldown or 0
    md.BonusRoll.roll = md.BonusRoll.roll or 0
    md.BonusRoll.duration = md.BonusRoll.duration or 0
end
Events.OnCreatePlayer.Add(BonusRoll.init)

function BonusRoll.doReset()
    local pl = getPlayer()
    local md = pl:getModData()
    md.BonusRoll = {}
    md.BonusRoll.cooldown =  0
    md.BonusRoll.roll = 0
    md.BonusRoll.duration = 0
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

