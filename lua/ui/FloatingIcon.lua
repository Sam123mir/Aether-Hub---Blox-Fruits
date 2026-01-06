local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local FloatingIcon = {}
FloatingIcon.Instance = nil
FloatingIcon.MainWindow = nil

function FloatingIcon:Init(gui, mainWindow)
    self.MainWindow = mainWindow
    
    local btn = Instance.new("ImageButton")
    btn.Name = "FloatingIcon"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, 50, 0.5, 0)
    btn.BackgroundColor3 = Theme.Colors.MainBackground
    btn.Image = "" -- TODO: Agregar ID de logo si el usuario lo provee
    btn.Visible = false
    
    local uic = Instance.new("UICorner", btn)
    uic.CornerRadius = UDim.new(1, 0) -- Circle
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Colors.Accent
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- Icon Text (A) as placeholder
    local label = Instance.new("TextLabel")
    label.Text = "A"
    label.Font = Theme.Fonts.Bold
    label.TextSize = 32
    label.TextColor3 = Theme.Colors.Accent
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Parent = btn
    
    -- Parenting
    btn.Parent = gui
    self.Instance = btn
    
    -- Drag Logic
    local dragging, dragStart, startPos
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = false 
            -- Click detection (if not dragged far)
            if self.Instance.Visible then
                self:Restore()
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Pulse Animation
    self:StartPulse()
end

function FloatingIcon:StartPulse()
    task.spawn(function()
        while self.Instance do
            if self.Instance.Visible then
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
                local tween = TweenService:Create(self.Instance.UIStroke, tweenInfo, {Thickness = 4, Transparency = 0.5})
                tween:Play()
                return -- Run once for loop
            end
            task.wait(1)
        end
    end)
end

function FloatingIcon:Show()
    if self.Instance then
        self.Instance.Visible = true
        self.Instance.Size = UDim2.new(0, 0, 0, 0)
        Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 50, 0, 50)}, 0.5, Enum.EasingStyle.Elastic)
    end
end

function FloatingIcon:Restore()
    if self.Instance then
        Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 0, 0, 0)}, 0.3):Completed:Connect(function()
            self.Instance.Visible = false
            if self.MainWindow then
                self.MainWindow:Restore()
            end
        end)
    end
end

return FloatingIcon
