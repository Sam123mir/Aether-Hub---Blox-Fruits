local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Theme = AetherRequire("lua.ui.Theme")
local Auth = AetherRequire("lua.core.Auth")

local UIManager = {}
UIManager.Gui = nil
UIManager.Engine = nil

function UIManager:Init(engine)
    self.Engine = engine
    print("[Aether UI]: Inicializando interfaz Matrix Green...")
    
    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "AetherScripts_UI"
    gui.ResetOnSpawn = false
    
    -- Protect GUI if possible (Synapse/KRNL)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    self.Gui = gui
end

function UIManager:ShowKeyWindow(onSuccessCallback)
    local KeyWindow = AetherRequire("lua.ui.KeyWindow")
    KeyWindow:Create(self.Gui, function()
        -- On Verify Success
        print("[Aether UI]: Key verificada. Bienvenido.")
        if onSuccessCallback then onSuccessCallback() end
    end)
end

function UIManager:ShowMainWindow()
    print("[Aether UI]: Abriendo Panel Principal...")
    local Window = AetherRequire("lua.ui.Window")
    local TabSystem = AetherRequire("lua.ui.Tab")
    
    local mainWin = Window.new("Aether Scripts")
    local tabs = TabSystem.new(mainWin)
    
    -- Create Tabs
    local mainTab = tabs:AddTab("Main")
    local combatTab = tabs:AddTab("Combat")
    local statsTab = tabs:AddTab("Stats")
    local settingsTab = tabs:AddTab("Settings")
    
    -- Main Tab Content
    local Toggle = AetherRequire("lua.ui.Toggle")
    local AutoFarm = AetherRequire("lua.modules.AutoFarm")
    
    local farmToggle = Toggle.Create(mainTab, {
        Text = "Auto Farm Fruit",
        Default = false,
        Callback = function(state)
            AutoFarm:Toggle(state)
        end
    })
    farmToggle.Position = UDim2.new(0, 0, 0, 10)
    
    -- Status Label for Farm
    local status = Instance.new("TextLabel")
    status.Text = "Status: Idle"
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 5, 0, 60)
    status.BackgroundTransparency = 1
    status.TextColor3 = Theme.Colors.TextMid
    status.Font = Theme.Fonts.Mono
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = mainTab

    -- [[ COMBAT TAB CONTENT ]]
    local AutoLevel = AetherRequire("lua.modules.AutoLevel")
    local Dropdown = AetherRequire("lua.ui.Dropdown")
    
    -- Mob Selector
    local mobOptions = {"Bandit", "Monkey", "Gorilla", "Pirate", "Marine"}
    local mobDropdownFrame, updateMobs = Dropdown.Create(combatTab, {
        Options = mobOptions,
        Default = "Select Mob...",
        Callback = function(selected)
            AutoLevel:SetTarget(selected)
        end
    })
    mobDropdownFrame.Position = UDim2.new(0, 0, 0, 10)
    
    -- Refresh Mobs Button
    local Button = AetherRequire("lua.ui.Button")
    Button.Create(combatTab, {
        Text = "Refresh Mobs",
        Size = UDim2.new(0.4, 0, 0, 30),
        Position = UDim2.new(0.55, 0, 0, 15),
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

    -- Auto Level Toggle
    local levelToggle = Toggle.Create(combatTab, {
        Text = "Auto Farm Level",
        Default = false,
        Callback = function(state)
            AutoLevel:Toggle(state)
        end
    })
    levelToggle.Position = UDim2.new(0, 0, 0, 60)
    
    -- [[ STATS TAB CONTENT ]]
    local Stats = AetherRequire("lua.modules.Stats")
    
    local statOptions = {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"}
    local statDropdown, _ = Dropdown.Create(statsTab, {
        Options = statOptions,
        Default = "Melee",
        Callback = function(opt)
            Stats:SetTarget(opt)
        end
    })
    statDropdown.Position = UDim2.new(0, 0, 0, 10)
    
    local statsToggle = Toggle.Create(statsTab, {
        Text = "Auto Add Points",
        Default = false,
        Callback = function(state)
            Stats:Toggle(state)
        end
    })
    statsToggle.Position = UDim2.new(0, 0, 0, 60)

    -- [[ SETTINGS TAB CONTENT ]]
    local Slider = AetherRequire("lua.ui.Slider")
    local Utilities = AetherRequire("lua.Utilities")
    
    local speedSlider = Slider.Create(settingsTab, {
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
    speedSlider.Position = UDim2.new(0, 0, 0, 10)
    
    local jumpSlider = Slider.Create(settingsTab, {
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
    jumpSlider.Position = UDim2.new(0, 0, 0, 70)
    
    local unloadBtn = Button.Create(settingsTab, {
        Text = "Unload Script",
        Size = UDim2.new(0.5, 0, 0, 35),
        Position = UDim2.new(0, 0, 0.9, -10),
        Variant = "Panel",
        Callback = function()
            self.Gui:Destroy()
            -- Cleanup loops
            AetherRequire("lua.modules.AutoFarm"):Toggle(false)
            AetherRequire("lua.modules.AutoLevel"):Toggle(false)
            AetherRequire("lua.modules.Stats"):Toggle(false)
        end
    })
    
    mainWin:Show()
    
    -- Setup Floating Icon listener
    local FloatingIcon = AetherRequire("lua.ui.FloatingIcon")
    FloatingIcon:Init(self.Gui, mainWin)
end

return UIManager
