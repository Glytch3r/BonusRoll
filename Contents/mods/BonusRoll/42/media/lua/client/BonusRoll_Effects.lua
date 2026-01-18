--client/BonusRoll_Effects.lua
BonusRoll = BonusRoll or {}

function BonusRoll.speedEffectHandler(pl)
    if not pl then return end
    local md = pl:getModData().BonusRoll
    if pl:isAiming() then return end
    if not md or md.roll == 0 then return end
    local roll = md.roll
    if roll ~= 1 and roll ~= 4 then return end

    local dir = pl:getDir()
    local dx, dy = 0, 0
    local amt = roll == 4 and 0.08 or -0.06

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

function BonusRoll.clearEffect()
    local md = getPlayer():getModData()
    md.BonusRoll.roll = 0    
end

function BonusRoll.doHealthEffect(roll)
    local pl = getPlayer()

    if roll == 3 then
        pl:getBodyDamage():ReduceGeneralHealth(SandboxVars.BonusRoll.HealthDamage)
        return
    end

    if roll == 6 then
        pl:setGodMod(true)
        pl:setGodMod(false)
        return
    end
end

function BonusRoll.getBonusEffect()
    local pl = getPlayer()
    local md = pl:getModData()
    return md.BonusRoll.roll
end

function BonusRoll.hitEffect(pl, targ, wpn, dmg)
    if pl == targ then return end
    if pl == getPlayer() then
        local effect =  BonusRoll.getBonusEffect()
        if effect == 2 or effect == 5 then
            local bonusDmg = SandboxVars.BonusRoll.DamageEffect
            if instanceof(targ, "IsoZombie")  then
                local hp = targ:getHealth()
                if effect == 2 then
                    targ:setHealth(hp+bonusDmg) 
                elseif effect == 5 then
                    targ:setHealth(hp-bonusDmg) 
                end
            end
        end
       
    end
end
Events.OnWeaponHitCharacter.Remove(BonusRoll.hitEffect)
Events.OnWeaponHitCharacter.Add(BonusRoll.hitEffect)
