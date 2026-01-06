local Configuration = AetherRequire("lua.Configuration")
local Theme = {}

-- [[ PALETTE ]]
Theme.Colors = {
    -- Backgrounds
    Main = Color3.fromRGB(15, 15, 15),       -- Heavy Dark
    Sidebar = Color3.fromRGB(10, 10, 10),    -- Sidebar Dark
    Section = Color3.fromRGB(20, 20, 20),    -- Content Section
    
    -- Accents
    Accent = Color3.fromRGB(0, 255, 65),     -- Matrix Green (Bright)
    AccentDim = Color3.fromRGB(0, 100, 25),  -- Darker Green
    AccentGlow = Color3.fromRGB(0, 255, 65), -- For Shadows
    
    -- Text
    TextHigh = Color3.fromRGB(240, 240, 240),
    TextMid = Color3.fromRGB(180, 180, 180),
    TextDark = Color3.fromRGB(100, 100, 100),
    
    -- Status
    Success = Color3.fromRGB(50, 255, 100),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 200, 50)
}

-- [[ STYLES ]]
Theme.CornerRadius = UDim.new(0, 8) -- Standard Radius
Theme.Padding = UDim.new(0, 12)

Theme.Fonts = {
    Regular = Enum.Font.Gotham,
    Medium = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
    Mono = Enum.Font.Code
}

-- Helper to Apply Common Styles
function Theme.ApplyStyle(instance, styleType)
    if styleType == "Window" then
        instance.BackgroundColor3 = Theme.Colors.Main
        instance.BorderSizePixel = 0
    
    elseif styleType == "FloatingContainer" then
        instance.BackgroundColor3 = Theme.Colors.Section
        instance.BorderSizePixel = 0
        local corner = Instance.new("UICorner", instance)
        corner.CornerRadius = Theme.CornerRadius
        
        local stroke = Instance.new("UIStroke", instance)
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(40, 40, 40)
        stroke.Transparency = 0.5
        
    elseif styleType == "Input" then
        instance.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        instance.TextColor3 = Theme.Colors.TextHigh
        instance.Font = Theme.Fonts.Regular
        instance.TextSize = 14
        
        local corner = Instance.new("UICorner", instance)
        corner.CornerRadius = UDim.new(0, 6)
        
        local stroke = Instance.new("UIStroke", instance)
        stroke.Thickness = 1
        stroke.Color = Theme.Colors.AccentDim
        stroke.Transparency = 0.6
        
        -- Padding
        local pad = Instance.new("UIPadding", instance)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
    end
end

-- Helper for "Shadow/Glow" Effect
function Theme.AddShadow(instance)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843" -- Common soft shadow asset
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceScale = 1
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Parent = instance
end

return Theme
