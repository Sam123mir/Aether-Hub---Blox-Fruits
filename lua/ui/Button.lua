local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Button = {}

function Button.Create(parent, props)
    local btn = Instance.new("TextButton")
    btn.Name = props.Text or "Button"
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Size = props.Size or UDim2.new(0.95, 0, 0, 42) -- Taller default
    btn.Position = props.Position or UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Theme.Colors.Main
    btn.Parent = parent
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1
    stroke.Color = Theme.Colors.AccentDim
    stroke.Transparency = 0.5
    
    local label = Instance.new("TextLabel")
    label.Text = props.Text or "Button"
    label.Font = Theme.Fonts.Medium
    label.TextSize = 14
    label.TextColor3 = Theme.Colors.TextHigh
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Parent = btn
    
    -- Variant Styling
    if props.Variant == "AccentButton" then
        btn.BackgroundColor3 = Theme.Colors.AccentDim
        stroke.Color = Theme.Colors.Accent
        label.TextColor3 = Theme.Colors.Accent
    end
    
    -- Logic
    btn.MouseButton1Click:Connect(function()
        -- Ripple Effect
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Color3.new(1,1,1)
        ripple.BackgroundTransparency = 0.8
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        
        local corner = Instance.new("UICorner", ripple)
        corner.CornerRadius = UDim.new(1, 0)
        ripple.Parent = btn
        
        Utilities.CreateTween(ripple, {Size = UDim2.new(1.5, 0, 1.5, 0), BackgroundTransparency = 1}, 0.4).Completed:Connect(function()
            ripple:Destroy()
        end)
        
        if props.Callback then props.Callback() end
    end)
    
    -- Hover
    btn.MouseEnter:Connect(function()
        if props.Variant == "AccentButton" then
             Utilities.CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(0, 120, 30)}, 0.2)
        else
             Utilities.CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if props.Variant == "AccentButton" then
            Utilities.CreateTween(btn, {BackgroundColor3 = Theme.Colors.AccentDim}, 0.2)
        else
            Utilities.CreateTween(btn, {BackgroundColor3 = Theme.Colors.Main}, 0.2)
        end
    end)
    
    return btn
end

return Button
