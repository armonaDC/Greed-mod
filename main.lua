local mod = RegisterMod("Greed mod", 1)
local Scheduler = require("./scheduler.lua") --import scheduler lua file
Scheduler.Init(mod)
ONE_SECOND = 30 --one second in game is 30 frames, used for scheduler

local rng = RNG() --rng object used for QueryRoomTypeIndex
local startRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_DEFAULT, false, rng, false) --room type found from in Game() console
local treasureRoomIndex = 85 --value found from in Game() console
local shopRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, rng, false)
local curseRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_CURSE, false, rng, false)
local bossItemRoomIndex = 98 --value found from in Game() console

function mod:TeleportToBossItemRoom()
    Game():StartRoomTransition(bossItemRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1) --teleports isaac to boss item room
end

function mod:TeleportToTreasureRoom()
    Game():StartRoomTransition(treasureRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
end

function mod:TeleportToShop()
    Game():StartRoomTransition(shopRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
end

function mod:TeleportToCurseRoom()
    Game():StartRoomTransition(curseRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
end

function mod:TeleportToStartRoom()
    Game():StartRoomTransition(startRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
end

function mod:FindAndPrintItems()
    local itemTable = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
    --finds collectibles in a room and puts them in an array or "table" in lua
    mod:PrintItems(itemTable) --prints collectibleID to Game() console
end

function mod:StartMod()
    print("Aperture's Greed Mod Started")
    --AddCallback does not allow function parameters, so each function called must have no arguments 
    Scheduler.Schedule(ONE_SECOND * 5, mod.TeleportToBossItemRoom)
    Scheduler.Schedule(ONE_SECOND * 5, mod.FindAndPrintItems)

    Scheduler.Schedule(ONE_SECOND * 5, mod.TeleportToTreasureRoom)
    Scheduler.Schedule(ONE_SECOND * 5, mod.FindAndPrintItems)

    Scheduler.Schedule(ONE_SECOND * 5, mod.TeleportToShop)
    Scheduler.Schedule(ONE_SECOND * 5, mod.FindAndPrintItems)

    Scheduler.Schedule(ONE_SECOND * 5, mod.TeleportToCurseRoom)
    Scheduler.Schedule(ONE_SECOND * 5, mod.FindAndPrintItems)

    Scheduler.Schedule(ONE_SECOND * 5, mod.TeleportToStartRoom)
    print("Aperture's Greed Mod Ended")
end

function mod:PrintItems(table)
    print("PrintItems started")
    for i=1,4 do --lua starts counting from 1, checking up to 4 pedestal items but idk if this is even possible
        if table[i] ~= nil then --check to make sure something exists at that index
            print(table[i].Subtype)
            --prints entity subtype only, we know that the Type is a pickup, and that the variant is a collectible due to Isaac.FindByType parameters we set
            --the subtype number will correspond to the CollectibleID for the item
        end
    end
end

function mod:ConditionToStartMod()
    if ((Game():GetLevel():GetStage() == 1) and (Game():IsGreedMode() == true)) then
        mod:StartMod()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ConditionToStartMod)

-- player:SetFullHearts() is the same as player.SetFullHearts(player)
-- "collectible" just means it is a pedestal item