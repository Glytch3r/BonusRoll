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

--client/BonusRoll_Gun.lua
BonusRoll = BonusRoll or {}

function BonusRoll.isFirearm(fType)
    if not fType then return false end
    local scr = getScriptManager():FindItem(fType)
    return scr and scr:isRanged() or false
end


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

----------------------------------------------------------------
----- ▄   ▄   ▄▄▄   ▄   ▄   ▄▄▄     ▄      ▄   ▄▄▄▄  ▄▄▄▄  -----
----- █   █  █   ▀  █   █  ▀   █    █      █      █  █▄  █ -----
----- ▄▀▀ █  █▀  ▄  █▀▀▀█  ▄   █    █    █▀▀▀█    █  ▄   █ -----
-----  ▀▀▀    ▀▀▀   ▀   ▀   ▀▀▀   ▀▀▀▀▀  ▀   ▀    ▀   ▀▀▀  -----
----------------------------------------------------------------