-- For a version that isn't heavily commented, check out isaac-helper.
-- https://github.com/maya-bee/isaac-helper

-- You'll want to require this with "require" instead of "include" so that variables will be persistent across files.

local game = Game()
local Scheduler = {}
local scheduled = {}

local function Update()
    for index, task in ipairs(scheduled) do
        if task.When <= game:GetFrameCount() then
            task.Callback(table.unpack(task.Arguments)) -- unpack those arguments and pass them into the callback
            table.remove(scheduled, index)
        end
    end
end

-- frameDelay - how many frames to wait before running the callback
-- callback - the function to run
-- ... - this is a variadic parameter. you can pass in any number of arguments, and it'll pass those arguments to the callback.
-- Example:
-- Scheduler.Schedule(60, functionName, 1, 2, 3)
function Scheduler.Schedule(frameDelay, callback, ...)
    table.insert(scheduled,
        {
            When = game:GetFrameCount() + frameDelay,
            Callback = callback,
            Arguments = table.pack(...) -- pack those arguments into a table
        }
    )
end

-- Since this is running in its own file (for orginization purposes), we need the actual mod object.
-- Just run this function in your main.lua file.
-- Please only call this once.
function Scheduler.Init(YourMod)
    Scheduler.Empty() -- clear the scheduled tasks
    YourMod:AddCallback(ModCallbacks.MC_POST_UPDATE, Update)
    YourMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Scheduler.Empty)
    YourMod:AddCallback(ModCallbacks.MC_POST_GAME_END, Scheduler.Empty)
end

-- We call this function interally whenever the game is ended so that we don't have any lingering tasks.
-- I can't think of any case where you'd want to do it manually, but I added it here just in case.
function Scheduler.Empty()
    scheduled = {}
end

return Scheduler

--[[
    EXAMPLE USAGE:
    -- main.lua
    local mod = RegisterMod("awesome mod 9000", 1)
    local ONE_SECOND = 30 -- Avoid magic numbers -> https://en.wikipedia.org/wiki/Magic_number_(programming)
    local Scheduler = require("path.to.the.scheduler.file")
    Scheduler.Init(mod)
    Scheduler.Schedule(ONE_SECOND * 5, function(str) -- This is much more readable than typing 150.
        print(str)
    end, "Hello, world!")
    -- Hello, world!
]]