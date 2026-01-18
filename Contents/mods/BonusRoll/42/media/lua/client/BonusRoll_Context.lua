--client/BonusRoll_Context.lua
BonusRoll = BonusRoll or {}
BonusRoll.EffectsStringTab = {
    [0] = "",
    [1] = "Reduced Movement Speed",
    [2] = "Reduced Attack Damage",
    [3] = "Health Damage",
    [4] = "Increased Movement Speed",
    [5] = "Increased Attack Damage",
    [6] = "Full Heal",
}
function BonusRoll.getEffectString()
    local roll = BonusRoll.getBonusEffect()    
    return BonusRoll.EffectsStringTab[roll]
end



function BonusRoll.doDiceRoll()
    local pl = getPlayer() 
    local roll = ZombRand(1, 7)
    local md = pl:getModData().BonusRoll

    md.cooldown = SandboxVars.BonusRoll.hrsCooldown
    md.roll = roll
    md.duration = BonusRoll.getDuration(roll)

    --BonusRoll.applyEffect(roll)
    --BonusRoll.doShowImage(roll)
    if getCore():getDebug() then print(roll) end
    

    if roll == 3 or roll == 6  then
        BonusRoll.doHealthEffect(roll)
    end
    pl:playSoundLocal("BonusRoll")
    return roll
end

function BonusRoll.isCanRoll()
    local md = getPlayer():getModData().BonusRoll
    if md.roll > 0 then return false end
    return md.cooldown <= 0
end

function BonusRoll.isDice(item)
    return item and item.getFullType and item:getFullType() == "Base.Dice"
end

function BonusRoll.invContext(plNum, context, items)
    for _, entry in ipairs(items) do
        local item = type(entry) == "table" and entry.items[1] or entry
        if BonusRoll.isDice(item) then
            local title = "Bonus Roll"
            local isCanRoll = BonusRoll.isCanRoll()
            if not isCanRoll then
                local cd = BonusRoll.getCooldown()
                if cd > 0 then
                    title = tostring(title)..': Cooldown '..tostring(cd)
                end
            else
                local dur = BonusRoll.getDuration()
                if dur > 0 then
                    title = tostring(title)..': Duration '..tostring(dur)
                end
            end
            local opt = context:addOption(tostring(title), item, BonusRoll.doDiceRoll)
            opt.iconTexture = getTexture("media/ui/BonusRoll/dice.png")
            local tip = ISInventoryPaneContextMenu.addToolTip()
            tip.description = "Roll the Dice to get Bonus or Penalty"
 
            opt.notAvailable = not isCanRoll
            local txt = BonusRoll.getEffectString()
            if not isCanRoll and txt ~= "" then
                tip.description = tostring(txt)
            end
            opt.toolTip = tip
        end
    end
end
Events.OnFillInventoryObjectContextMenu.Remove(BonusRoll.invContext)
Events.OnFillInventoryObjectContextMenu.Add(BonusRoll.invContext)
