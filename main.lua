local mod = RegisterMod("Greed mod", 1)

local game = Game() --game object so we can call functions from the game class
local rng = RNG() --rng object used for QueryRoomTypeIndex
local startRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_DEFAULT, false, rng, false) --room type found from in game console
local treasureRoomIndex = 85 --value found from in game console
local shopRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, rng, false)
local curseRoomIndex = game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_CURSE, false, rng, false)
local bossItemRoomIndex = 98 --value found from in game console

TreasureRoomDesc = game:GetLevel():GetRoomByIdx(treasureRoomIndex, -1) --RoomDescriptor object
ShopRoomDesc = game:GetLevel():GetRoomByIdx(shopRoomIndex, -1)
CurseRoomDesc = game:GetLevel():GetRoomByIdx(curseRoomIndex, -1)
BossItemRoomDesc = game:GetLevel():GetRoomByIdx(bossItemRoomIndex, -1)

function mod:checkItems()
    local player = game:GetPlayer(0)

end

-- if startRoomIndex ~= game:GetLevel():GetCurrentRoomIndex() then -- probably turn this into a callback 
--     --insert function that turns off display here
-- end

mod:AddCallback(ModCallbacks.LevelStage.STAGE1_GREED, mod.checkItems) -- this tells my mod to look for the level/stage to be floor 1 of greed mode then run the function checkItems


-- player:SetFullHearts() is the same as player.SetFullHearts(player)