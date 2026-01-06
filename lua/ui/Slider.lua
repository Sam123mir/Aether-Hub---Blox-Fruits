local UserInputService = game:GetService("UserInputService")
local Theme = AetherRequire("lua.ui.Theme")

local Slider = {}

function Slider.Create(parent, props)
    local min = props.Min or 0
    local max = props.Max or 100
    local default = props.Default or min
    local step = props.Step or 1
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Text = props.Text or "Value"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    Theme.ApplyStyle(label, "Text")
    label.Parent = frame
    
    -- Value Display
    local valLabel = Instance.new("TextLabel")
    valLabel.Text = tostring(default)
    valLabel.Size = UDim2.new(0, 50, 0, 20)
    valLabel.Position = UDim2.new(1, -60, 0, 0)
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    Theme.ApplyStyle(valLabel, "Text")
    valLabel.TextColor3 = Theme.Colors.Accent
    valLabel.Parent = frame
    
    -- Slider Bar Background
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0.7, 0)
    bar.BackgroundColor3 = Theme.Colors.PanelBackground
    bar.BorderSizePixel = 0
    local uic = Instance.new("UICorner", bar)
    uic.CornerRadius = UDim.new(1, 0)
    bar.Parent = frame
    
    -- Fill Bar
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme.Colors.Accent
    fill.BorderSizePixel = 0
    local uic2 = Instance.new("UICorner", fill)
    uic2.CornerRadius = UDim.new(1, 0)
    fill.Parent = bar
    
    -- Knob
    local knob = Instance.new("TextButton")
    knob.Text = ""
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = Theme.Colors.TextHigh
    knob.BorderSizePixel = 0
    local uic3 = Instance.new("UICorner", knob)
    uic3.CornerRadius = UDim.new(1, 0)
    knob.Parent = bar
    
    local currentValue = default
    local dragging = false
    
    local function UpdateVisuals()
        local percent = (currentValue - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, 0, 0.5, 0)
        valLabel.Text = tostring(currentValue)
    end
    
    local function UpdateFromInput(inputX)
        local barAbsPos = bar.AbsolutePosition.X
        local barAbsSize = bar.AbsoluteSize.X
        
        local relativeX = math.clamp(inputX - barAbsPos, 0, barAbsSize)
        local percent = relativeX / barAbsSize
        
        local rawValue = min + (max - min) * percent
        -- Apply step
        currentValue = math.floor(rawValue / step + 0.5) * step
        
        UpdateVisuals()
        if props.Callback then props.Callback(currentValue) end
    end
    
    knob.MouseButton1Down:Connect(function() dragging = true end)
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateFromInput(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateFromInput(input.Position.X)
        end
    end)
    
    UpdateVisuals()
    
    return frame
end

return Slider
