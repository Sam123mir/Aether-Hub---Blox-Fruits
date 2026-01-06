local Theme = {}

-- [[ HARDCODED PALETTE ]]
-- Defining directly to avoid any requiring issues
Theme.Colors = {
    Main = Color3.fromRGB(12, 12, 12),       
    Sidebar = Color3.fromRGB(15, 15, 15),    
    Section = Color3.fromRGB(18, 18, 18),    
    
    Accent = Color3.fromRGB(0, 255, 65),     
    AccentDim = Color3.fromRGB(0, 100, 25),  
    
    TextHigh = Color3.fromRGB(255, 255, 255),
    TextMid = Color3.fromRGB(180, 180, 180),
    TextDark = Color3.fromRGB(80, 80, 80),
    
    Success = Color3.fromRGB(50, 255, 100),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 200, 50)
}

Theme.Icons = {
    Close = "rbxassetid://6031094670", -- X icon
    Min = "rbxassetid://6031094678",   -- Minimize icon
    Logo = "rbxassetid://15923623972"  -- Placeholder for Nano Banana (Replace with actual ID)
}

Theme.CornerRadius = UDim.new(0, 6)
Theme.Fonts = {
    Regular = Enum.Font.Gotham,
    Medium = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
    Mono = Enum.Font.Code
}

function Theme.ApplyStyle(obj)
    -- Just a stub if needed, preferring manual styling in components for V3
end

return Theme
