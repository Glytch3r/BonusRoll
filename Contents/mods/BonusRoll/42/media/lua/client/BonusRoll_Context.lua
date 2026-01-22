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
    [7] = "Spawn Weapon",
}
BonusRoll.diceTab = {
    ["Base.Dice"]=true,
    ["Base.Dice_6"]=true,

}
function BonusRoll.getEffectString()
    local roll = BonusRoll.getBonusEffect()    
    return BonusRoll.EffectsStringTab[roll] or ""
end



function BonusRoll.doDiceRoll()
    local faceCount = 7 --just change this
    local pl = getPlayer() 
    local roll = ZombRand(1, faceCount+1)
    local md = pl:getModData().BonusRoll

    md.cooldown = SandboxVars.BonusRoll.hrsCooldown
    md.roll = roll
    md.duration = BonusRoll.getDuration(roll)
    pl:playEmote('BonusRoll')
    pl:playSoundLocal("BonusRoll")

    BonusRoll.pause(2, function() 
        BonusRoll.doShowImage(roll)
    end)
    
    if getCore():getDebug() then print(roll) end

    if roll == 3 or roll == 6  then
        BonusRoll.doHealthEffect(roll)
    elseif roll == 7  then
        BonusRoll.doSpawnWeaponEffect()
    end

    return roll
end

function BonusRoll.isCanRoll()
    local md = getPlayer():getModData().BonusRoll
    if md.roll > 0 then return false end
    return md.cooldown <= 0
end

function BonusRoll.isDice(item)
    return item and item.getFullType and BonusRoll.diceTab[item:getFullType()]
end

function BonusRoll.invContext(plNum, context, items)
    for _, entry in ipairs(items) do
        local item = type(entry) == "table" and entry.items[1] or entry
        if BonusRoll.isDice(item) then
            local isCanRoll = BonusRoll.isCanRoll()
            local effectStr = BonusRoll.getEffectString()
            local cd = BonusRoll.getCooldown()
            local dur = BonusRoll.getRemaining()

            local title = "Bonus Roll"
            if not isCanRoll and dur > 0 and effectStr ~= "" then
                title = "Bonus Roll: "..tostring(effectStr)
            end

            local opt = context:addOptionOnTop(title, item, BonusRoll.doDiceRoll)
            opt.iconTexture = getTexture("media/ui/BonusRoll/dice.png")
            opt.notAvailable = not isCanRoll

            local tip = ISInventoryPaneContextMenu.addToolTip()

            if isCanRoll then
                tip.description = "Roll the Dice to get Bonus or Penalty"
            else
                local desc = ""

                if cd > 0 then
                    desc = "Cooldown: " .. tostring(cd).." Hours"
                end

                if dur > 0 then
                    if desc ~= "" then desc = desc .. "\n" end
                    desc = desc .. "Duration: " .. tostring(dur)
                end

                if desc == "" then
                    desc = "Roll the Dice to get Bonus or Penalty"
                end

                tip.description = desc
            end

            opt.toolTip = tip
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Remove(BonusRoll.invContext)
Events.OnFillInventoryObjectContextMenu.Add(BonusRoll.invContext)
