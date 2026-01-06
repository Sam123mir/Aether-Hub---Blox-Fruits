--[[
    AETHER SCRIPTS - AUTO LOADER / INSTALLER
    Repo: Sam123mir/Aether-Hub---Blox-Fruits
]]

local REPO_USER = "Sam123mir"
local REPO_NAME = "Aether-Hub---Blox-Fruits"
local BRANCH = "main"
local BASE_URL = "https://raw.githubusercontent.com/"..REPO_USER.."/"..REPO_NAME.."/"..BRANCH.."/"

local Files = {
    "main.lua",
    "lua/Engine.lua",
    "lua/Configuration.lua",
    "lua/Utilities.lua",
    "lua/Workspace.lua",
    "lua/core/Auth.lua",
    "lua/ui/Theme.lua",
    "lua/ui/UIManager.lua",
    "lua/ui/Window.lua",
    "lua/ui/Tab.lua",
    "lua/ui/Button.lua",
    "lua/ui/Toggle.lua",
    "lua/ui/Slider.lua",
    "lua/ui/Dropdown.lua",
    "lua/ui/KeyWindow.lua",
    "lua/ui/FloatingIcon.lua",
    "lua/modules/AutoFarm.lua",
    "lua/modules/AutoLevel.lua",
    "lua/modules/AutoMastery.lua",
    "lua/modules/Stats.lua",
}

-- 1. Download System
if not isfolder("AetherScripts") then makefolder("AetherScripts") end
local function EnsureFolder(path) if not isfolder(path) then makefolder(path) end end
EnsureFolder("AetherScripts/lua")
EnsureFolder("AetherScripts/lua/core")
EnsureFolder("AetherScripts/lua/ui")
EnsureFolder("AetherScripts/lua/modules")

local function DownloadFile(path)
    local url = BASE_URL .. path
    local success, content = pcall(function() return game:HttpGet(url) end)
    if success then
        writefile("AetherScripts/" .. path, content)
    else
        warn("[AetherLoader] Failed to download: " .. path)
    end
end

for _, file in ipairs(Files) do
    DownloadFile(file)
end

-- 2. Custom Require System
local ModuleCache = {}

getgenv().AetherRequire = function(path)
    if ModuleCache[path] then return ModuleCache[path] end
    
    local filePath = "AetherScripts/" .. string.gsub(path, "%.", "/") .. ".lua"
    if not isfile(filePath) then
        error("[AetherRequire] File not found: " .. filePath)
    end
    
    local content = readfile(filePath)
    local func, err = loadstring(content)
    
    if not func then
        error("[AetherRequire] Syntax error in " .. path .. ": " .. tostring(err))
    end
    
    -- Execute module
    local success, result = pcall(func)
    if not success then
        error("[AetherRequire] Runtime error in " .. path .. ": " .. tostring(result))
    end
    
    ModuleCache[path] = result
    return result
end

-- 3. Run Main
print("[AetherLoader] Starting...")
AetherRequire("main")
