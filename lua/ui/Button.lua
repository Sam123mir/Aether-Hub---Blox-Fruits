local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Button = {}

function Button.Create(parent, props)
    local btn = Instance.new("TextButton")
    btn.Size = props.Size or UDim2.new(1, 0, 0, 35)
    btn.Position = props.Position or UDim2.new(0, 0, 0, 0)
    btn.Text = props.Text or "Button"
    btn.AutoButtonColor = false
    Theme.ApplyStyle(btn, props.Variant or "Panel") -- "AccentButton" for green ones
    
    -- Rounded corners
    local uic = Instance.new("UICorner", btn)
    uic.CornerRadius = Theme.Layout.CornerRadius
    
    -- Stroke if not accent
    if props.Variant ~= "AccentButton" then
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Theme.Colors.TextLow
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end
    
    btn.Parent = parent
    
    -- Hover Animation
    btn.MouseEnter:Connect(function()
        Utilities.CreateTween(btn, {BackgroundTransparency = 0.2}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        Utilities.CreateTween(btn, {BackgroundTransparency = 0}, 0.2)
    end)
    
    -- Click Effect
    btn.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Theme.Colors.Accent
        ripple.BackgroundTransparency = 0.6
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BorderSizePixel = 0
        local corner = Instance.new("UICorner", ripple)
        corner.CornerRadius = UDim.new(1, 0)
        ripple.Parent = btn
        
        Utilities.CreateTween(ripple, {Size = UDim2.new(1.5, 0, 1.5, 0), BackgroundTransparency = 1}, 0.4).Completed:Connect(function()
            ripple:Destroy()
        end)
        
        if props.Callback then props.Callback() end
    end)
    
    return btn
end

return Button
