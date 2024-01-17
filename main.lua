local mod = RegisterMod("Greed mod", 1)
local Scheduler = require("./scheduler.lua") --import scheduler lua file
Scheduler.Init(mod)
ONE_SECOND = 30 --one second in game is 30 frames, used for scheduler

local startRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_DEFAULT, false, RNG(), false) --room type found from in game console
local treasureRoomIndex = 85 --value found from in game console
local shopRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, RNG(), false)
local curseRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_CURSE, false, RNG(), false)
local bossItemRoomIndex = 98 --value found from in game console

function mod:TeleportToBossItemRoom()
    Game():StartRoomTransition(bossItemRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1) --teleports isaac to boss item room
    VisitBossItemRoom = true
end

function mod:TeleportToTreasureRoom()
    Game():StartRoomTransition(treasureRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
    VisitTreasureRoom = true
end

function mod:TeleportToShop()
    Game():StartRoomTransition(shopRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
    VisitShop = true
end

function mod:TeleportToCurseRoom()
    Game():StartRoomTransition(curseRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
    VisitCurseRoom = true
end

function mod:TeleportToStartRoom()
    Game():StartRoomTransition(startRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1)
end

function mod:FindAndPrintItems()
    ItemTable = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
    --finds collectibles in a room and puts them in an array or "table" in lua

    --prints collectibleID to game console 
    print("PrintItems started") --printed in game console
    for i=1,4 do --lua starts counting from 1, checking up to 4 pedestal items but idk if this is even possible
        if ItemTable[i] ~= nil then --check to make sure something exists at that index
            print(ItemTable[i].EntityType)
            print(ItemTable[i].variant)
            print(ItemTable[i].Subtype)
            --prints entity subtype only (in final version), we know that the Type is a pickup, and that the variant is a collectible due to Isaac.FindByType parameters we set
            --the subtype number will correspond to the CollectibleID for the item
        end
    end
end

function mod:OnNewRoom()
    mod:FindAndPrintItems()
end

function mod:OnUpdate()

    if VisitBossItemRoom == false then
        Scheduler.Schedule(ONE_SECOND, mod.TeleportToBossItemRoom)
    end

    if VisitTreasureRoom == false then
        Scheduler.Schedule(ONE_SECOND, mod.TeleportToTreasureRoom)
    end

    if VisitShop == false then
        Scheduler.Schedule(ONE_SECOND, mod.TeleportToShop)
    end

    if VisitCurseRoom == false then
        Scheduler.Schedule(ONE_SECOND, mod.TeleportToCurseRoom)
    end

    if (VisitBossItemRoom == true and VisitTreasureRoom == true and VisitShop == true and VisitCurseRoom == true) then
        Scheduler.Schedule(ONE_SECOND, mod.TeleportToStartRoom)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)

-- player:SetFullHearts() is the same as player.SetFullHearts(player)
-- "collectible" just means it is a pedestal item
-- AddCallback does not allow function parameters, so each function called must have no arguments
-- Generally, each ModCallbacks paramter should only be typed once in code, with only one associated functions. This mod types UPDATE once and NEW_ROOM once