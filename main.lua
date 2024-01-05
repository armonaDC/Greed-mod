local mod = RegisterMod("Greed mod", 1)

local game = Game() --game object so we can call functions from the game class
local rng = RNG() --rng object used for QueryRoomTypeIndex
local startRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_DEFAULT, false, rng, false) --room type found from in game console
local treasureRoomIndex = 85 --value found from in game console
local shopRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, rng, false)
local curseRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_CURSE, false, rng, false)
local bossItemRoomIndex = 98 --value found from in game console

function mod:Teleport(roomIndex)
    game:StartRoomTransition(roomIndex,Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, game:GetPlayer(0), -1) --teleports isaac to room index
end

function mod:FindAndPrintItems()
    local itemTable = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
    --finds collectibles in a room and puts them in an array or "table" in lua
    mod:PrintItems(itemTable) --prints collectibleID to game console
end

function mod:StartMod()
    mod:Teleport(bossItemRoomIndex)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.FindAndPrintItems)

    mod:Teleport(treasureRoomIndex)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.FindAndPrintItems)

    mod:Teleport(shopRoomIndex)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.FindAndPrintItems)

    mod:Teleport(curseRoomIndex)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.FindAndPrintItems)

    mod:Teleport(startRoomIndex)
end

function mod:PrintItems(table)
    for i=1,4 do --lua starts counting from 1, checking up to 4 pedestal items but idk if this is even possible
        if table[i] ~= nil then --check to make sure something exists at that index
            print(table[i].Subtype)
            --prints entity subtype only, we know that the Type is a pickup, and that the variant is a collectible due to Isaac.FindByType parameters we set
            --the subtype number will correspond to the CollectibleID for the item
        end
    end
end

if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE1_GREED then
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.StartMod)
end

-- player:SetFullHearts() is the same as player.SetFullHearts(player)
-- "collectible" just means it is a pedestal item