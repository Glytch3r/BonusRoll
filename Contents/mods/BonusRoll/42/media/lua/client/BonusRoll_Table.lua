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
----- ▄   ▄   ▄▄▄   ▄   ▄   ▄▄▄     ▄      ▄   ▄▄▄▄  ▄▄▄▄  -----
----- █   █  █   ▀  █   █  ▀   █    █      █      █  █▄  █ -----
----- ▄▀▀ █  █▀  ▄  █▀▀▀█  ▄   █    █    █▀▀▀█    █  ▄   █ -----
-----  ▀▀▀    ▀▀▀   ▀   ▀   ▀▀▀   ▀▀▀▀▀  ▀   ▀    ▀   ▀▀▀  -----
----------------------------------------------------------------
--client/BonusRoll_Table.lua
BonusRoll = BonusRoll or {}

BonusRoll.faceCount = 10

BonusRoll.EffectsStringTab = {
    [0] = "",
    [1] = "Reduced Movement Speed",
    [2] = "Reduced Attack Damage",
    [3] = "Health Damage",
    [4] = "Increased Movement Speed",
    [5] = "Increased Attack Damage",
    [6] = "Full Heal",
    [7] = "Spawn Weapon",
    [8] = "Injury",
    [9] = "AoE",
    [10] = "Zed Attract",
    [11] = "Reset Dice Rolls",

}

BonusRoll.ImgTab = {
    [0] = "",
    [1] = "You-Rolled-Reduced-Speed.png",
    [2] = "You-Rolled-Reduced-Damage.png",
    [3] = "You-Rolled-Health-Damage.png",
    [4] = "You-Rolled-Increased-Speed.png",
    [5] = "You-Rolled-Increased-Damage.png",
    [6] = "You-Rolled-Full-Heal.png",
    [7] = "You-Rolled-Spawn-Weapon.png",
    [8] = "You-Rolled-Injury.png",
    [9] = "You-Rolled-AoE.png",
    [10] = "You-Rolled-Zed-Attract.png",
    [11] = "You-Rolled-Reset.png",

}

BonusRoll.durationTab = {
    [0] = 0,
    [1] = 60,
    [2] = 60,
    [3] = 1,
    [4] = 60,
    [5] = 60,
    [6] = 1,
    [7] = 1,
    [8] = 1, 
    [9] = 60,
    [10] = 60, 
    [11] = 1, 

}

BonusRoll.weaponList = {
    "Base.Axe","Base.HandAxe","Base.Crowbar","Base.Sledgehammer","Base.Katana","Base.TreeBranch2","Base.WoodAxe",
    "Base.HuntingKnife","Base.PickAxe","Base.BaseballBat","Base.BaseballBat_Can","Base.BaseballBat_Metal","Base.ShortBat",
    "Base.Sword","Base.LeadPipe","Base.Golfclub","Base.Hammer","Base.Nightstick","Base.Pan","Base.Machete","Base.ShortSword",
    "Base.SpearLong","Base.Shovel2","Base.SnowShovel","Base.MeatCleaver","Base.ShortBat_Can","Base.BaseballBat_Metal_Bolts",
    "Base.MetalPipe","Base.AssaultRifle","Base.Pistol","Base.Shotgun","Base.TireIron","Base.BaseballBat_Nails","Base.ShortBat_Nails",
    "Base.Katana_Broken",
}

BonusRoll.diceTab = {
    ["Base.Dice"]=true,
    ["Base.Dice_Bone"]=true,
	["Base.Dice_Wood"]=true,
	["Base.Dice_00"]=true,
	["Base.Dice_10"]=true,
	["Base.Dice_12"]=true,
	["Base.Dice_20"]=true,
	["Base.Dice_4"]=true,
	["Base.Dice_6"]=true,
	["Base.Dice_8"]=true,
}
