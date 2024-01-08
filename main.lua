local mod = RegisterMod("Greed mod", 1)

local rng = RNG() --rng object used for QueryRoomTypeIndex
local startRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_DEFAULT, false, rng, false) --room type found from in Game() console
local treasureRoomIndex = 85 --value found from in Game() console
local shopRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, rng, false)
local curseRoomIndex = Game():GetLevel():QueryRoomTypeIndex(RoomType.ROOM_CURSE, false, rng, false)
local bossItemRoomIndex = 98 --value found from in Game() console
-- BossRoomVisited = false
-- TreasureRoomVisited = false

function mod:Teleport(roomIndex)
    Game():StartRoomTransition(roomIndex, Direction.DOWN, RoomTransitionAnim.PORTAL_TELEPORT, Game():GetPlayer(0), -1) --teleports isaac to room index

    -- if Game():GetLevel():GetRoomByIdx(98, -1) then BossRoomVisited = true end
    -- if Game():GetLevel():GetRoomByIdx(85, -1) then TreasureRoomVisited = true end
end

function mod:FindAndPrintItems()
    local itemTable = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
    --finds collectibles in a room and puts them in an array or "table" in lua
    mod:PrintItems(itemTable) --prints collectibleID to Game() console
end

function mod:StartMod()
    print("Aperture's Greed Mod Started")
    -- NEW_ROOM triggers before POST_UPDATE
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.Teleport(bossItemRoomIndex))
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.FindAndPrintItems)

    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.Teleport(treasureRoomIndex))
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.FindAndPrintItems)

    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.Teleport(shopRoomIndex))
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.FindAndPrintItems)

    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.Teleport(curseRoomIndex))
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.FindAndPrintItems)

    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.Teleport(startRoomIndex))
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