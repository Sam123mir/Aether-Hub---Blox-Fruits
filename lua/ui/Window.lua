local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Window = {}
Window.__index = Window

function Window.new(title)
    local self = setmetatable({}, Window)
    
    local gui = AetherRequire("lua.ui.UIManager").Gui
    
    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Name = "WindowFrame"
    frame.Size = UDim2.new(0, 550, 0, 350)
    frame.Position = UDim2.new(0.5, -275, 0.5, -175)
    Theme.ApplyStyle(frame, "Window")
    frame.ClipsDescendants = true
    frame.Parent = gui
    
    -- Outline (Matrix Green Glow)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Colors.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, Theme.Layout.HeaderHeight)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title .. " <font color=\"rgb(0,255,65)\">BETA</font>"
    titleLabel.RichText = true
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    Theme.ApplyStyle(titleLabel, "Text")
    titleLabel.Font = Theme.Fonts.Bold
    titleLabel.TextSize = 16
    titleLabel.Parent = titleBar
    
    -- Content Container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -Theme.Layout.HeaderHeight)
    content.Position = UDim2.new(0, 0, 0, Theme.Layout.HeaderHeight)
    content.BackgroundTransparency = 1
    content.Parent = frame
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Text = "-"
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -35, 0, 5)
    Theme.ApplyStyle(minBtn, "Text")
    minBtn.Parent = titleBar
    
    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            Utilities.CreateTween(frame, {Position = targetPos}, 0.05)
        end
    end)
    
    -- Minimize Logic
    minBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)

    self.Instance = frame
    return self
end

function Window:Show()
    self.Instance.Visible = true
    self.Instance.Size = UDim2.new(0, 550, 0, 0)
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 550, 0, 350)}, 0.5, Enum.EasingStyle.Back)
end

function Window:Minimize()
    local FloatingIcon = AetherRequire("lua.ui.FloatingIcon")
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 550, 0, 0)}, 0.3).Completed:Connect(function()
        self.Instance.Visible = false
        FloatingIcon:Show()
    end)
end

function Window:Restore()
    self.Instance.Visible = true
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 550, 0, 350)}, 0.3)
end

return Window
