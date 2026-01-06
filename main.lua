--[[
    AETHER SCRIPTS - EXECUTOR ENTRY POINT
    Game: Blox Fruits
    Version: 1.0.0 Alpha
]]

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ScriptFolder = ReplicatedFirst:FindFirstChild("AetherScripts")

-- Fallback for local testing if not in ReplicatedFirst (e.g., Workspace)
if not ScriptFolder and game.PlaceId == 0 then
     -- Debugging/Studio mode logic could go here
     ScriptFolder = script.Parent -- Assuming main.lua is inside AetherScripts
end

if not ScriptFolder then
    warn("Aether Scripts Critical Error: Folder 'AetherScripts' not found in ReplicatedFirst")
    return
end

local Engine = require(ScriptFolder.lua.Engine)
Engine:Start()
