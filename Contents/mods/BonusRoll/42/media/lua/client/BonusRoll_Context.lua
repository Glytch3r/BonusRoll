--client/BonusRoll_Draw.lua
BonusRoll = BonusRoll or {}

function BonusRoll.getEffectString(roll)
    return BonusRoll.EffectsStringTab[roll] or ""
end

function BonusRoll.rollUnique(md)
    local faceCount = BonusRoll.faceCount
    local roll = ZombRand(1, faceCount + 1)

    while BonusRoll.getIsInPlay(roll)  do
        roll = ZombRand(1, faceCount + 1)
    end

    return roll
end

function BonusRoll.doDiceRoll(item)
    local pl = getPlayer()
    if not pl or not item then return 0 end

    local fType = item:getFullType()
    local md = pl:getModData().BonusRoll
    if not md then return 0 end

    local dice = md[fType]
    if not dice or dice.cooldown > 0 then return 0 end

    local roll = BonusRoll.rollUnique(md)
    if not roll then return 0 end

    dice.roll = roll
    dice.duration = BonusRoll.getDuration(roll)
    dice.cooldown = SandboxVars.BonusRoll.hrsCooldown

    pl:playEmote("BonusRoll")
    pl:playSoundLocal("BonusRoll")

    BonusRoll.pause(2, function()
        BonusRoll.doShowImage(roll)
    end)

    if roll == 3 or roll == 6 then
        BonusRoll.doHealthEffect(roll)
    elseif roll == 7 then
        BonusRoll.doSpawnWeaponEffect()
    elseif roll == 8 then
        BonusRoll.pause(2, function()
            local bd = pl:getBodyDamage()
            if not bd then return roll end

            local parts = bd:getBodyParts()
            if not parts then return roll end

            local part = parts:get(ZombRand(1, parts:size() + 1))
            if part then 
                part:setFractureTime(21)
            end
        end)
    end

    return roll
end


function BonusRoll.isCanRoll(fType)
    local md = getPlayer():getModData().BonusRoll
    if not md then return false end
    local dice = md[fType]
    if not dice then return false end
    return dice.cooldown <= 0
end

function BonusRoll.isDice(fType)
    return BonusRoll.diceTab and BonusRoll.diceTab[fType]
end

function BonusRoll.invContext(plNum, context, items)
    local pl = getSpecificPlayer(plNum)
    if not pl then return end

    local md = pl:getModData().BonusRoll
    if not md then return end

    context:removeOptionByName(Translator.getRecipeName("RollOneDice"))
    --context:removeOptionByName('Roll One Dice')
    local item = nil
    for i, diceItem in ipairs(items) do
        if type(diceItem) == "table" then
            item = diceItem.items[1]
        elseif instanceof(diceItem, "InventoryItem") then
            item = diceItem
        end
    end
    if not item then return end

    local fType = item:getFullType()
    if not BonusRoll.isDice(fType) then return end

    local dice = md[fType]
    if not dice then
        dice = { cooldown = 0, roll = 0, duration = 0 }
        md[fType] = dice
    end

    local canRoll = dice.cooldown <= 0
    local roll = dice.roll
    local dur = dice.duration
    local cd = dice.cooldown

    local title = "Roll The Dice"
    if roll > 0 and dice.duration > 0 then
        local effectStr = BonusRoll.getEffectString(roll)
        if effectStr ~= "" then
            title = "Roll The Dice: " .. effectStr
        end
    elseif not canRoll then
        title = "Roll The Dice (Cooldown: " .. tostring(cd) .. "Hours)"
    end

    local opt = context:addOptionOnTop(title,  item, function() BonusRoll.doDiceRoll(item) end)

    opt.iconTexture = getTexture("media/textures/Item_"..tostring(item:getType())..".png")
    opt.notAvailable = not canRoll

    local tip = ISInventoryPaneContextMenu.addToolTip()
    if canRoll then
        tip.description = "Roll the Dice to get Random Bonus or Penalty"
    else
        local desc = "Cooldown: " .. tostring(cd) .. " Hours"
        if dur > 0 then
            desc = desc .. "\nDuration: " .. tostring(dur)  .. " Minutes"
        end
        tip.description = desc
    end
    opt.toolTip = tip
end

Events.OnFillInventoryObjectContextMenu.Remove(BonusRoll.invContext)
Events.OnFillInventoryObjectContextMenu.Add(BonusRoll.invContext)
