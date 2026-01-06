local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local FloatingIcon = {}
FloatingIcon.Instance = nil
FloatingIcon.MainWindow = nil

function FloatingIcon:Init(gui, mainWindow)
    self.MainWindow = mainWindow
    
    local icon = Instance.new("ImageButton")
    icon.Name = "AetherIcon"
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0, 50, 0.9, -60)
    icon.BackgroundColor3 = Theme.Colors.Main
    icon.Image = Theme.Icons.Logo -- Logo Nano Banana
    icon.Visible = false -- Hidden initially
    icon.Parent = gui
    
    local corner = Instance.new("UICorner", icon)
    corner.CornerRadius = UDim.new(1, 0)
    
    local stroke = Instance.new("UIStroke", icon)
    stroke.Thickness = 2
    stroke.Color = Theme.Colors.Accent
    
    -- Dragging
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
    
    -- Click to Open
    icon.MouseButton1Click:Connect(function()
        if not dragging then
            self:Restore()
        end
    end)
    
    self.Instance = icon
end

function FloatingIcon:Show()
    if self.Instance then
        self.Instance.Visible = true
        Utilities.CreateTween(self.Instance, {ImageTransparency = 0}, 0.3)
    end
end

function FloatingIcon:Restore()
    if self.Instance and self.MainWindow then
        self.Instance.Visible = false
        self.MainWindow:Restore()
    end
end

return FloatingIcon
