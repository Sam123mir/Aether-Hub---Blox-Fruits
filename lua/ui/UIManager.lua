local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Theme = AetherRequire("lua.ui.Theme")
local Auth = AetherRequire("lua.core.Auth")

local UIManager = {}
UIManager.Gui = nil

function UIManager:Init(engine)
    if self.Gui then self.Gui:Destroy() end
    
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "AetherScripts_V3"
    self.Gui.ResetOnSpawn = false
    
    -- Protect GUI (if supported)
    if syn and syn.protect_gui then 
        syn.protect_gui(self.Gui)
        self.Gui.Parent = CoreGui
    elseif gethui then
        self.Gui.Parent = gethui()
    else
        self.Gui.Parent = CoreGui
    end
    
    self:ShowKeyWindow(function()
        self:ShowMainWindow()
    end)
end

function UIManager:ShowKeyWindow(onSuccessCallback)
    local KeyWindow = AetherRequire("lua.ui.KeyWindow")
    KeyWindow:Create(self.Gui, function()
        print("[Aether UI]: Key verificada. Bienvenido.")
        if onSuccessCallback then onSuccessCallback() end
    end)
end

function UIManager:ShowMainWindow()
    print("[Aether UI]: Abriendo Panel Principal V3...")
    local Window = AetherRequire("lua.ui.Window")
    local TabSystem = AetherRequire("lua.ui.Tab")
    local Section = AetherRequire("lua.ui.Section")
    
    local mainWin = Window.new("Aether Scripts")
    local tabs = TabSystem.new(mainWin)
    
    -- Create Tabs
    local combatTab = tabs:AddTab("Combat")
    local statsTab = tabs:AddTab("Stats")
    local miscTab = tabs:AddTab("Misc") -- Was "Settings", renamed for better fit
    local settingsTab = tabs:AddTab("Settings")

    -- [[ COMBAT TAB ]]
    local Toggle = AetherRequire("lua.ui.Toggle")
    local Button = AetherRequire("lua.ui.Button")
    local Dropdown = AetherRequire("lua.ui.Dropdown")
    local AutoFarm = AetherRequire("lua.modules.AutoFarm")
    local AutoLevel = AetherRequire("lua.modules.AutoLevel")
    
    -- Section: Farming
    local farmSection = Section.Create(combatTab, "Auto Farm")
    
    Toggle.Create(farmSection, {
        Text = "Auto Farm Fruit",
        Default = false,
        Callback = function(state)
            AutoFarm:Toggle(state)
        end
    })
    
    -- Section: Leveling
    local levelSection = Section.Create(combatTab, "Level / Combat")
    
    Toggle.Create(levelSection, {
        Text = "Auto Level (Nearest)",
        Default = false,
        Callback = function(state)
            AutoLevel:Toggle(state)
        end
    })
    
    -- Mob Selector in Level Section
    local mobOptions = {"Bandit", "Monkey", "Gorilla", "Pirate", "Marine"}
    local mobDropdown, updateMobs = Dropdown.Create(levelSection, {
        Options = mobOptions,
        Default = "Select Mob...",
        Callback = function(selected)
            AutoLevel:SetTarget(selected)
        end
    })
    
    Button.Create(levelSection, {
        Text = "Refresh Mobs",
        Size = UDim2.new(0.6, 0, 0, 30),
        Variant = "Panel",
        Callback = function()
            local found = {}
            if workspace:FindFirstChild("Enemies") then
                for _, v in ipairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") then
                        if not table.find(found, v.Name) then
                            table.insert(found, v.Name)
                        end
                    end
                end
            end
            if #found > 0 then
                updateMobs(found)
            end
        end
    })

    -- [[ STATS TAB ]]
    local Stats = AetherRequire("lua.modules.Stats")
    
    local statsSection = Section.Create(statsTab, "Auto Stats")
    
    local statOptions = {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"}
    Dropdown.Create(statsSection, {
        Options = statOptions,
        Default = "Melee",
        Callback = function(opt)
            Stats:SetTarget(opt)
        end
    })
    
    Toggle.Create(statsSection, {
        Text = "Auto Add Points",
        Default = false,
        Callback = function(state)
            Stats:Toggle(state)
        end
    })

    -- [[ MISC TAB ]] (Player Mods)
    local Slider = AetherRequire("lua.ui.Slider")
    local Utilities = AetherRequire("lua.Utilities")
    
    local playerSection = Section.Create(miscTab, "Local Player")
    
    Slider.Create(playerSection, {
        Text = "Walk Speed",
        Min = 16,
        Max = 200,
        Default = 16,
        Callback = function(val)
            local char = Utilities.GetCharacter()
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = val
            end
        end
    })
    
    Slider.Create(playerSection, {
        Text = "Jump Power",
        Min = 50,
        Max = 500,
        Default = 50,
        Callback = function(val)
            local char = Utilities.GetCharacter()
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = val
            end
        end
    })

    -- [[ SETTINGS TAB ]]
    local settingsSection = Section.Create(settingsTab, "Calculations")
    
    Button.Create(settingsSection, {
        Text = "Unload Script",
        Variant = "AccentButton",
        Callback = function()
            self.Gui:Destroy()
            -- Cleanup
            AutoFarm:Toggle(false)
            AutoLevel:Toggle(false)
            Stats:Toggle(false)
        end
    })
    
    mainWin:Show()
    
    local FloatingIcon = AetherRequire("lua.ui.FloatingIcon")
    FloatingIcon:Init(self.Gui, mainWin)
end

return UIManager
