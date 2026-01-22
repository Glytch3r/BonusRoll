BonusRoll = BonusRoll or {}

function BonusRoll.isFirearm(fType)
    if not fType then return false end
    local scr = getScriptManager():FindItem(fType)
    return scr and scr:isRanged() or false
end

BonusRoll.weaponList = {
    "Base.Axe","Base.HandAxe","Base.Crowbar","Base.Sledgehammer","Base.Katana","Base.TreeBranch2","Base.WoodAxe",
    "Base.HuntingKnife","Base.PickAxe","Base.BaseballBat","Base.BaseballBat_Can","Base.BaseballBat_Metal","Base.ShortBat",
    "Base.Sword","Base.LeadPipe","Base.Golfclub","Base.Hammer","Base.Nightstick","Base.Pan","Base.Machete","Base.ShortSword",
    "Base.SpearLong","Base.Shovel2","Base.SnowShovel","Base.MeatCleaver","Base.ShortBat_Can","Base.BaseballBat_Metal_Bolts",
    "Base.MetalPipe","Base.AssaultRifle","Base.Pistol","Base.Shotgun","Base.TireIron","Base.BaseballBat_Nails","Base.ShortBat_Nails",
    "Base.Katana_Broken",
}

function BonusRoll.doSpawnWeaponEffect()
    local pl = getPlayer()
    if not pl then return end

    local inv = pl:getInventory()
    local fType = BonusRoll.weaponList[ZombRand(#BonusRoll.weaponList) + 1]
    if not fType then return end

    local item = inv:AddItem(fType)
    if not item then return end

    if BonusRoll.isFirearm(fType) then
        local mType = item:getMagazineType()
        if mType then
            item:setContainsClip(true)
        end
        item:setRoundChambered(true)
        item:setCurrentAmmoCount(item:getMaxAmmo())
    end
end
