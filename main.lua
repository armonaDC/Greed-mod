local mod = RegisterMod("Greed mod", 1)

local game = Game() --game object so we can call functions from the game class
local rng = RNG() --rng object used for QueryRoomTypeIndex
local startRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_DEFAULT, false, rng, false) --room type found from in game console
local treasureRoomIndex = 85 --value found from in game console
local shopRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, rng, false)
local curseRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_CURSE, false, rng, false)
local bossItemRoomIndex = 98 --value found from in game console

function mod:TeleportAndCheckItems(roomIndex)
    game:StartRoomTransition(roomIndex,Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, game:GetPlayer(0), -1) --teleports isaac to room index
    local ItemTable = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false) --finds collectibles in room and puts them in an array "table" in lua

    return ItemTable --lists start from ONE in lua
end

function mod:checkItems()
    local bossItem = mod:TeleportAndCheckItems(bossItemRoomIndex)
    local treasureItem = mod:TeleportAndCheckItems(treasureRoomIndex)
    local shopItem = mod:TeleportAndCheckItems(shopRoomIndex)
    local curseItem = mod:TeleportAndCheckItems(curseRoomIndex)

    game:StartRoomTransition(startRoomIndex,Direction.NO_DIRECTION, RoomTransitionAnim.PORTAL_TELEPORT, game:GetPlayer(0), -1) --teleport isaac to starting room

    mod:printItems(bossItem)
    mod:printItems(treasureItem)
    mod:printItems(shopItem)
    mod:printItems(curseItem)
end

function mod:printItems(table)
    for i=1,4 do
        if table[i] ~= nil then
            print(table[i].Subtype)
        end
    end
end

if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE1_GREED then
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.checkItems)
end

-- player:SetFullHearts() is the same as player.SetFullHearts(player)