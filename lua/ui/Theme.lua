local Theme = {}

-- [[ FLUENT / WINDUI PALETTE ]]
Theme.Colors = {
    -- Acrylic / Mica Emulation
    Main = Color3.fromRGB(20, 20, 20),      -- Window Background
    Sidebar = Color3.fromRGB(15, 15, 15),   -- Darker Sidebar
    
    -- Surface Layers
    Element = Color3.fromRGB(35, 35, 35),   -- Button/Input Fill
    ElementHover = Color3.fromRGB(45, 45, 45),
    
    -- Accents (Matrix Green adapted for Fluent)
    Accent = Color3.fromRGB(0, 255, 65),    
    AccentText = Color3.fromRGB(20, 20, 20), -- Text on Accent
    
    -- Text Hierarchy
    TextHigh = Color3.fromRGB(255, 255, 255),
    TextMid = Color3.fromRGB(160, 160, 160),
    TextLow = Color3.fromRGB(100, 100, 100),
    
    -- Stokes / Borders
    Stroke = Color3.fromRGB(60, 60, 60),
    StrokeAccent = Color3.fromRGB(0, 255, 65)
}

-- [[ ASSETS ]]
Theme.Icons = {
    Home = "rbxassetid://6031068421",
    Combat = "rbxassetid://6031090994", -- Sword
    Stats = "rbxassetid://6031248455",  -- Chart
    Settings = "rbxassetid://6031210120",
    User = "rbxassetid://6031024345",
    
    -- [[ USER LOGO HERE ]]
    -- Replace this ID with the Asset ID of your uploaded Bear Image
    Logo = "rbxassetid://110086558997856" -- Placeholder (Use your ID)
}

Theme.CornerRadius = UDim.new(0, 6) -- Fluent standard
Theme.Font = Enum.Font.Gotham
Theme.FontBold = Enum.Font.GothamBold

return Theme
