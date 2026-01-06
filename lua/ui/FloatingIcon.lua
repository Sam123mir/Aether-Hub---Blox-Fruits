local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local FloatingIcon = {}
FloatingIcon.Instance = nil
FloatingIcon.MainWindow = nil
FloatingIcon.AnimationTrack = nil

function FloatingIcon:Init(gui, mainWindow)
    self.MainWindow = mainWindow
    
    -- Main Button
    local icon = Instance.new("ImageButton")
    icon.Name = "AetherFloatingIcon"
    icon.Size = UDim2.new(0, 70, 0, 70)
    icon.Position = UDim2.new(0, 50, 0.85, 0)
    icon.BackgroundTransparency = 1
    icon.Image = Theme.Icons.Logo -- Your Bear Logo
    icon.Visible = false
    icon.Parent = gui
    
    -- Glow/Pulse Effect (Behind)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(1.2, 0, 1.2, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://6015897843" -- Soft glow
    glow.ImageColor3 = Theme.Colors.Accent
    glow.ImageTransparency = 0.5
    glow.ZIndex = 0
    glow.Parent = icon
    
    -- Dragging Logic
    local dragging, dragStart, startPos
    icon.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = icon.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = inp.Position - dragStart
            icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    icon.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    -- Restore
    icon.MouseButton1Click:Connect(function()
        if not dragging then self:Restore() end
    end)
    
    self.Instance = icon
    self.Glow = glow
end

function FloatingIcon:StartAnimation()
    if not self.Instance then return end
    
    -- Breathing Animation
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(self.Glow, tweenInfo, {
        Size = UDim2.new(1.5, 0, 1.5, 0),
        ImageTransparency = 0.8
    })
    tween:Play()
    self.AnimationTrack = tween
end

function FloatingIcon:StopAnimation()
    if self.AnimationTrack then
        self.AnimationTrack:Cancel()
        self.AnimationTrack = nil
        self.Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
        self.Glow.ImageTransparency = 0.5
    end
end

function FloatingIcon:Show()
    if self.Instance then
        self.Instance.Visible = true
        self.Instance.ImageTransparency = 1
        Utilities.CreateTween(self.Instance, {ImageTransparency = 0}, 0.5)
        self:StartAnimation()
    end
end

function FloatingIcon:Restore()
    if self.Instance and self.MainWindow then
        self:StopAnimation()
        Utilities.CreateTween(self.Instance, {ImageTransparency = 1}, 0.3).Completed:Connect(function()
            self.Instance.Visible = false
            self.MainWindow:Restore()
        end)
    end
end

return FloatingIcon
