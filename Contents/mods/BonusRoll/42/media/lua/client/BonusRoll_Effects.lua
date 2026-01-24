--client/BonusRoll_Effects.lua
BonusRoll = BonusRoll or {}

function BonusRoll.getIsInPlay(roll)
    local md = getPlayer():getModData().BonusRoll
    if not md then return false end

    local target = tonumber(roll) or roll

    for fType, dice in pairs(md) do
        if dice and tonumber(dice.roll) and tonumber(dice.duration) and tonumber(dice.duration) > 0 then
            if tonumber(dice.roll) == target then
                return true
            end
        end
    end

    return false
end

function BonusRoll.getDiceEffect(fType)
    if not fType then return 0 end

    local md = getPlayer():getModData().BonusRoll
    if not md then return 0 end

    local dice = md[fType]
    if not dice then return 0 end
    return dice.roll or 0
end

function BonusRoll.speedEffectHandler(pl)
    if not pl then return end
    if pl:isAiming() then return end

    local applySlow = false
    local applyFast = false

    if BonusRoll.getIsInPlay(1) then applySlow = true end
    if BonusRoll.getIsInPlay(4) then applyFast = true end

    if not applySlow and not applyFast then return end
    if applySlow and applyFast then return end

    local dir = pl:getDir()
    local dx, dy = 0, 0
    local amt = 0

    if applyFast then
        amt = 0.08
    elseif applySlow then
        amt = 0.03
    end

    if dir == IsoDirections.N then dy = -amt
    elseif dir == IsoDirections.S then dy = amt
    elseif dir == IsoDirections.W then dx = -amt
    elseif dir == IsoDirections.E then dx = amt
    elseif dir == IsoDirections.NW then dx = -amt; dy = -amt
    elseif dir == IsoDirections.NE then dx = amt; dy = -amt
    elseif dir == IsoDirections.SW then dx = -amt; dy = amt
    elseif dir == IsoDirections.SE then dx = amt; dy = amt
    end

    local destX = pl:getX() + dx
    local destY = pl:getY() + dy

    pl:setX(destX)
    pl:setY(destY)
    if isClient() then
        pl:setLx(destX)
        pl:setLy(destY)
    end
end

Events.OnPlayerMove.Remove(BonusRoll.speedEffectHandler)
Events.OnPlayerMove.Add(BonusRoll.speedEffectHandler)

function BonusRoll.doHealthEffect(roll)
    local pl = getPlayer()

    if roll == 3 then
        pl:getBodyDamage():ReduceGeneralHealth(SandboxVars.BonusRoll.HealthDamage)
        return
    end

    if roll == 6 then
        pl:setGodMod(true)
        BonusRoll.pause(1, function()
            pl:setGodMod(false)
        end)
        return
    end
end

function BonusRoll.hitEffect(pl, targ, wpn, dmg)
    if pl == targ then return end
    if pl ~= getPlayer() then return end

    local effects = BonusRoll.getBonusEffects()

    if  BonusRoll.getIsInPlay(2) or  BonusRoll.getIsInPlay(5) then
        local bonusDmg = ZombRandFloat(0, SandboxVars.BonusRoll.DamageEffect)
        local bonusStr = "Damage "
        local newDmg = 0
        if instanceof(targ, "IsoZombie") then
            if BonusRoll.getIsInPlay(2) then
                newDmg = dmg - bonusDmg
                bonusStr = "Damage Penalty: -"..string.format("%.4f", bonusDmg)
                targ:setHeath(targ:getHeath()-newDmg)
            end

            if BonusRoll.getIsInPlay(5) then
                newDmg = dmg + bonusDmg
                bonusStr = "Damage Bonus: +"..string.format("%.4f", bonusDmg)
                targ:setHeath(targ:getHeath()+newDmg)
            end

            if SandboxVars.BonusRoll.showHitEffect then
                pl:addLineChatElement(tostring(bonusStr))
                if getCore():getDebug() then
                    print(bonusStr)
                end
            end
        end
    end
end

Events.OnWeaponHitCharacter.Remove(BonusRoll.hitEffect)
Events.OnWeaponHitCharacter.Add(BonusRoll.hitEffect)
