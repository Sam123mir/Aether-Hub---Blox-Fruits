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

local function LoadingScreen()
    -- Simple loading UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AetherLoader"
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = game.CoreGui end
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 100)
    Frame.Position = UDim2.new(0.5, -150, 0.4, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Text = "DOWNLOADING AETHER SCRIPTS..."
    Title.Size = UDim2.new(1, 0, 0.5, 0)
    Title.TextColor3 = Color3.fromRGB(0, 255, 65)
    Title.BackgroundTransparency = 1
    Title.Parent = Frame
    
    local Status = Instance.new("TextLabel")
    Status.Text = "Initializing..."
    Status.Size = UDim2.new(1, 0, 0.5, 0)
    Status.Position = UDim2.new(0, 0, 0.5, 0)
    Status.TextColor3 = Color3.fromRGB(200, 200, 200)
    Status.BackgroundTransparency = 1
    Status.Parent = Frame
    
    return ScreenGui, Status
end

local Gui, StatusLabel = LoadingScreen()

-- Create Folder Structure
if not isfolder("AetherScripts") then makefolder("AetherScripts") end
if not isfolder("AetherScripts/lua") then makefolder("AetherScripts/lua") end
if not isfolder("AetherScripts/lua/core") then makefolder("AetherScripts/lua/core") end
if not isfolder("AetherScripts/lua/ui") then makefolder("AetherScripts/lua/ui") end
if not isfolder("AetherScripts/lua/modules") then makefolder("AetherScripts/lua/modules") end

local function DownloadFile(path)
    StatusLabel.Text = "Downloading: " .. path
    local url = BASE_URL .. path
    local success, content = pcall(function() return game:HttpGet(url) end)
    
    if success then
        writefile("AetherScripts/" .. path, content)
    else
        warn("Failed to download: " .. path)
    end
end

-- Download All
for _, file in ipairs(Files) do
    DownloadFile(file)
end

StatusLabel.Text = "Loading..."
task.wait(1)
Gui:Destroy()

-- Execute Main
-- We use loadstring on the saved file or the main file directly
local mainPath = "AetherScripts/main.lua"
if isfile(mainPath) then
    -- We need to ensure 'require' works for local files relative to the script
    -- Most executors allow 'dofile' or 'loadfile'
    -- Or we can just run the main content, but main relies on 'require(script.Parent...)'
    -- Since 'script' is different in 'loadstring', we might need to patch main.lua or use a loop loader.
    
    -- EASIER APPROACH FOR EXECUTORS: 
    -- We assume the user put the files in workspace folder via this script.
    -- But 'require' usually works on ModuleScripts in Roblox hierarchy.
    -- Executors have 'getgenv().import' or custom require.
    
    -- WORKAROUND: We will load 'main.lua' which tries to require from game.ReplicatedFirst.AetherScripts
    -- We must SIMULATE that structure if we want the "Modular" require to work exactly as written.
    
    -- CREATING VIRTUAL OBJECTS
    local RF = game:GetService("ReplicatedFirst")
    local MainFolder = RF:FindFirstChild("AetherScripts") or Instance.new("Folder")
    MainFolder.Name = "AetherScripts"
    MainFolder.Parent = RF
    
    -- Function to reconstruct folder tree from saved files
    local function LoadToGame(folder, localPath)
        for _, file in ipairs(listfiles(localPath)) do
            local fileName = string.match(file, "[^/\\]+$")
            if isfolder(file) then
                local newFolder = folder:FindFirstChild(fileName) or Instance.new("Folder")
                newFolder.Name = fileName
                newFolder.Parent = folder
                LoadToGame(newFolder, file)
            else
                -- It is a file
                local content = readfile(file)
                local moduleName = string.gsub(fileName, "%.lua$", "")
                
                -- Detect if main.lua (LocalScript) or ModuleScript
                local obj
                if fileName == "main.lua" then
                    -- Main is typically a LocalScript, but here we just run it
                    -- We don't necessarily need to object-ify it, but for structure:
                    obj = Instance.new("LocalScript")
                else
                    obj = Instance.new("ModuleScript")
                end
                
                obj.Name = moduleName
                -- We cannot set .Source property due to Roblox security, 
                -- EXCEPT in some executors or plugins. 
                -- BUT 'require' needs a ModuleScript with valid bytecode/source, which we can't easily inject 
                -- without 'loadstring' wrapping.
                
                -- ALTERNATE STRATEGY FOR CLOUD EXECUTION:
                -- Rewrite 'require' to a custom function? Too complex.
                
                -- BEST STRATEGY: 
                -- Use 'loadstring'. Our code does `game:GetService("ReplicatedFirst").AetherScripts...`
                -- We can mock `script.Parent` environment.
            end
        end
    end
    
    -- SINCE BUILDING ACTUAL INSTANCES IS HARD/IMPOSSIBLE (Source property is locked),
    -- WE WILL USE A COMPATIBILITY LAYER.
    -- Actually, for now, telling the user to put it in auto-execute folder is best.
    -- OR: We just run this loader and it executes 'main.lua' from disk?
    -- `dofile("AetherScripts/main.lua")` works in some executors.
    loadfile("AetherScripts/main.lua")()
end
