--client/BonusRoll_AoE.lua
BonusRoll = BonusRoll or {}

BonusRoll.AoETicks = 0

function BonusRoll.delRadiusMarker()
    if BonusRoll.RadiusMarker then
        BonusRoll.RadiusMarker:remove()
        BonusRoll.RadiusMarker = nil
    end
end

function BonusRoll.addRadiusMarker(pl, csq)
    pl = pl or getPlayer()
    if not pl or pl:isDead() then return end
    csq = csq or pl:getCurrentSquare()
    if not csq then return end

    local r = 1
    if SandboxVars.BonusRoll.RadiateAoEMarker then
        r = ZombRand(0, 101) / 100
    end

    BonusRoll.delRadiusMarker()
    BonusRoll.RadiusMarker = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", csq, r, r, r, true, r + 3)
end

function BonusRoll.doAoEAttact(pl)
    BonusRoll.AoETicks = BonusRoll.AoETicks + 1
    if BonusRoll.AoETicks % 3 ~= 0 then return end

    if BonusRoll.getIsInPlay(9) then 
        local csq = pl:getCurrentSquare()
        BonusRoll.addRadiusMarker(pl, csq)
    elseif BonusRoll.getIsInPlay(10) then
        addSound(pl, pl:getX(), pl:getY(), pl:getZ(), 30, 30)
    end
end
Events.OnPlayerUpdate.Remove(BonusRoll.doAoEAttact)
Events.OnPlayerUpdate.Add(BonusRoll.doAoEAttact)


function BonusRoll.doAoEDamageZed(zed)
    local pl = getPlayer()
    if not pl or not zed or zed:isDead() then return end

    local hasAoE = BonusRoll.getIsInPlay(9)
    if not hasAoE then return end

    local rad = SandboxVars.BonusRoll.zedAoEDist
    local dps = SandboxVars.BonusRoll.zedAoEDPS

    local psq = pl:getSquare()
    local zsq = zed:getSquare()
    if not psq or not zsq then return end
    if psq:getZ() ~= zsq:getZ() then return end

    local dx = zsq:getX() - psq:getX()
    local dy = zsq:getY() - psq:getY()
    if (dx * dx + dy * dy) <= (rad * rad) then
        zed:setHealth(zed:getHealth() - dps)
    end
end
Events.OnZombieUpdate.Remove(BonusRoll.doAoEDamageZed)
Events.OnZombieUpdate.Add(BonusRoll.doAoEDamageZed)
