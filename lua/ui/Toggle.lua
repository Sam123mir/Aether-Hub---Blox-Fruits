local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Toggle = {}

function Toggle.Create(parent, props)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Text = props.Text or "Feature Toggle"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    Theme.ApplyStyle(label, "Text")
    label.Parent = frame
    
    -- Switch Container
    local switch = Instance.new("TextButton")
    switch.Text = ""
    switch.Size = UDim2.new(0, 50, 0, 26)
    switch.Position = UDim2.new(1, -60, 0.5, -13)
    switch.BackgroundColor3 = Theme.Colors.PanelBackground
    switch.AutoButtonColor = false
    
    local uic = Instance.new("UICorner", switch)
    uic.CornerRadius = UDim.new(1, 0)
    
    local stroke = Instance.new("UIStroke", switch)
    stroke.Color = Theme.Colors.TextLow
    stroke.Thickness = 1
    
    switch.Parent = frame
    
    -- Knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = Theme.Colors.TextLow
    
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    knob.Parent = switch
    
    -- State
    local enabled = props.Default or false
    
    local function UpdateState(animate)
        if enabled then
            if animate then
                Utilities.CreateTween(knob, {Position = UDim2.new(1, -23, 0.5, -10), BackgroundColor3 = Theme.Colors.MainBackground}, 0.2)
                Utilities.CreateTween(switch, {BackgroundColor3 = Theme.Colors.Accent}, 0.2)
                stroke.Color = Theme.Colors.Accent
            else
                knob.Position = UDim2.new(1, -23, 0.5, -10)
                knob.BackgroundColor3 = Theme.Colors.MainBackground
                switch.BackgroundColor3 = Theme.Colors.Accent
                stroke.Color = Theme.Colors.Accent
            end
        else
            if animate then
                Utilities.CreateTween(knob, {Position = UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = Theme.Colors.TextLow}, 0.2)
                Utilities.CreateTween(switch, {BackgroundColor3 = Theme.Colors.PanelBackground}, 0.2)
                stroke.Color = Theme.Colors.TextLow
            else
                knob.Position = UDim2.new(0, 3, 0.5, -10)
                knob.BackgroundColor3 = Theme.Colors.TextLow
                switch.BackgroundColor3 = Theme.Colors.PanelBackground
                stroke.Color = Theme.Colors.TextLow
            end
        end
    end
    
    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        UpdateState(true)
        if props.Callback then props.Callback(enabled) end
    end)
    
    UpdateState(false)
    
    return frame
end

return Toggle
