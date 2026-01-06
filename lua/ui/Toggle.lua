local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Toggle = {}

function Toggle.Create(parent, props)
    local container = Instance.new("TextButton")
    container.Name = props.Text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = Theme.Colors.Element
    container.AutoButtonColor = false
    container.Text = ""
    container.Parent = parent
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = Theme.CornerRadius
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = Theme.Colors.Stroke
    stroke.Thickness = 1
    
    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Text = props.Text
    lbl.Font = Theme.Font
    lbl.TextSize = 14
    lbl.TextColor3 = Theme.Colors.TextHigh
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = container
    
    -- Switch
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.Position = UDim2.new(1, -12, 0.5, 0)
    switch.BackgroundColor3 = Theme.Colors.Main -- Off bg
    switch.Parent = container
    
    local sc = Instance.new("UICorner", switch)
    sc.CornerRadius = UDim.new(1,0)
    
    local ss = Instance.new("UIStroke", switch)
    ss.Color = Theme.Colors.TextLow
    ss.Thickness = 1
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 4, 0.5, -6)
    dot.BackgroundColor3 = Theme.Colors.TextMid
    dot.Parent = switch
    
    local dc = Instance.new("UICorner", dot)
    dc.CornerRadius = UDim.new(1,0)
    
    local isOn = props.Default or false
    
    local function Update()
        if isOn then
            Utilities.CreateTween(switch, {BackgroundColor3 = Theme.Colors.Accent}, 0.2)
            Utilities.CreateTween(ss, {Transparency = 1}, 0.2) -- Remove outline when on
            Utilities.CreateTween(dot, {Position = UDim2.new(1, -16, 0.5, -6), BackgroundColor3 = Theme.Colors.AccentText}, 0.2)
        else
            Utilities.CreateTween(switch, {BackgroundColor3 = Theme.Colors.Main}, 0.2)
            Utilities.CreateTween(ss, {Transparency = 0}, 0.2)
            Utilities.CreateTween(dot, {Position = UDim2.new(0, 4, 0.5, -6), BackgroundColor3 = Theme.Colors.TextMid}, 0.2)
        end
        if props.Callback then props.Callback(isOn) end
    end
    
    container.MouseButton1Click:Connect(function()
        isOn = not isOn
        Update()
    end)
    
    -- Init
    if isOn then Update() end
    
    return container
end

return Toggle
