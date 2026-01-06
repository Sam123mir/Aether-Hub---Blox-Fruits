local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")
local Button = AetherRequire("lua.ui.Button")

local Dropdown = {}

function Dropdown.Create(parent, props)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40) -- Collapsed size
    frame.BackgroundTransparency = 1
    frame.ZIndex = 5 -- Higher zindex for dropdown
    frame.Parent = parent
    
    -- Main Button
    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 35)
    mainBtn.Position = UDim2.new(0, 0, 0, 0)
    mainBtn.Text = ""
    Theme.ApplyStyle(mainBtn, "Panel")
    mainBtn.Parent = frame
    
    local selectedText = props.Default or (props.Options and props.Options[1]) or "Select..."
    
    local label = Instance.new("TextLabel")
    label.Text = selectedText
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    Theme.ApplyStyle(label, "Text")
    label.Parent = mainBtn
    
    local arrow = Instance.new("TextLabel")
    arrow.Text = "v"
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    Theme.ApplyStyle(arrow, "Text")
    arrow.Parent = mainBtn
    
    -- List Container
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 0, 0) -- Hidden
    list.Position = UDim2.new(0, 0, 1, 5)
    list.BackgroundColor3 = Theme.Colors.PanelBackground
    list.BorderSizePixel = 1
    list.BorderColor3 = Theme.Colors.TextLow
    list.ClipsDescendants = true
    list.Visible = false
    list.ZIndex = 6
    list.Parent = mainBtn -- Parent to button so it moves with it or use overlay? 
    -- Actually parenting to mainBtn is tricky if clipped. 
    -- Better to parent to 'frame' but 'frame' needs clip false.
    frame.ClipsDescendants = false
    list.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.Parent = list
    
    local open = false
    
    local function ToggleList()
        open = not open
        if open then
            list.Visible = true
            Utilities.CreateTween(list, {Size = UDim2.new(1, 0, 0, 150)}, 0.2)
            Utilities.CreateTween(arrow, {Rotation = 180}, 0.2)
        else
            Utilities.CreateTween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.2):Completed:Connect(function()
                list.Visible = false
            end)
            Utilities.CreateTween(arrow, {Rotation = 0}, 0.2)
        end
    end
    
    mainBtn.MouseButton1Click:Connect(ToggleList)
    
    -- Populate Options
    local function RefreshOptions(newOptions)
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, opt in ipairs(newOptions) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -4, 0, 30)
            item.Text = opt
            item.BackgroundTransparency = 1
            item.TextColor3 = Theme.Colors.TextMid
            item.Font = Theme.Fonts.Main
            item.ZIndex = 7
            item.Parent = list
            
            item.MouseButton1Click:Connect(function()
                selectedText = opt
                label.Text = opt
                ToggleList()
                if props.Callback then props.Callback(opt) end
            end)
        end
        list.CanvasSize = UDim2.new(0, 0, 0, #newOptions * 32)
    end
    
    if props.Options then RefreshOptions(props.Options) end
    
    return frame, RefreshOptions
end

return Dropdown
