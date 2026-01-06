local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Toggle = {}

function Toggle.Create(parent, props)
    local container = Instance.new("TextButton")
    container.Name = props.Text .. "_Toggle"
    container.Text = ""
    container.AutoButtonColor = false
    container.Size = UDim2.new(0.95, 0, 0, 42) -- Taller
    container.BackgroundColor3 = Theme.Colors.Main
    container.Parent = parent
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Thickness = 1
    stroke.Color = Theme.Colors.AccentDim
    stroke.Transparency = 0.5

    -- Label
    local label = Instance.new("TextLabel")
    label.Text = props.Text
    label.Font = Theme.Fonts.Regular
    label.TextSize = 14
    label.TextColor3 = Theme.Colors.TextHigh
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Switch Background
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.AnchorPoint = Vector2.new(1, 0.5)
    switchBg.Position = UDim2.new(1, -15, 0.5, 0)
    switchBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    switchBg.Parent = container
    
    local switchCorner = Instance.new("UICorner", switchBg)
    switchCorner.CornerRadius = UDim.new(1, 0)
    
    -- Switch Circle
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.AnchorPoint = Vector2.new(0, 0.5)
    circle.Position = UDim2.new(0, 2, 0.5, 0) -- Off Position
    circle.BackgroundColor3 = Theme.Colors.TextMid
    circle.Parent = switchBg
    
    local circleCorner = Instance.new("UICorner", circle)
    circleCorner.CornerRadius = UDim.new(1, 0)
    
    -- State
    local isOn = props.Default or false
    
    local function UpdateState()
        if isOn then
            Utilities.CreateTween(switchBg, {BackgroundColor3 = Theme.Colors.Accent}, 0.2)
            Utilities.CreateTween(circle, {Position = UDim2.new(1, -20, 0.5, 0), BackgroundColor3 = Color3.new(1,1,1)}, 0.2)
            if props.Callback then props.Callback(true) end
        else
            Utilities.CreateTween(switchBg, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
            Utilities.CreateTween(circle, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Theme.Colors.TextMid}, 0.2)
            if props.Callback then props.Callback(false) end
        end
    end
    
    -- Initial State (No Callback trigger)
    if isOn then
        switchBg.BackgroundColor3 = Theme.Colors.Accent
        circle.Position = UDim2.new(1, -20, 0.5, 0)
        circle.BackgroundColor3 = Color3.new(1,1,1)
    end
    
    container.MouseButton1Click:Connect(function()
        isOn = not isOn
        UpdateState()
    end)
    
    return container
end

return Toggle
