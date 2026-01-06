local Configuration = {}

--[[
    AETHER SCRIPTS - CONFIGURATION
    Theme: Matrix Green (Energía Focalizada)
]]

Configuration.Version = "1.0.0 Alpha"
Configuration.DebugMode = true

--[[ THEME & VISUALS ]]
Configuration.Theme = {
    -- Paleta Principal
    Colors = {
        MainBackground = Color3.fromRGB(10, 15, 10),      -- #0A0F0A (Negro con matiz verde)
        PanelBackground = Color3.fromRGB(17, 27, 17),     -- #111B11 (Gris oscuro con matiz verde)
        Accent = Color3.fromRGB(0, 255, 65),              -- #00FF41 (Verde Matrix)
        TextHigh = Color3.fromRGB(209, 231, 209),         -- #D1E7D1 (Blanco tintado)
        TextMid = Color3.fromRGB(150, 180, 150),          -- Gris verdoso
        TextLow = Color3.fromRGB(80, 100, 80),            -- Texto oscuro
        
        -- Estados
        Success = Color3.fromRGB(0, 255, 65),             -- Verde Matrix
        Warning = Color3.fromRGB(255, 230, 0),            -- Amarilo Alerta
        Error = Color3.fromRGB(255, 50, 50),              -- Rojo Fallo
        
        -- Elementos
        Border = Color3.fromRGB(0, 255, 65),              -- Borde neón
        Shadow = Color3.fromRGB(0, 50, 10),               -- Sombra verdosa
    },
    
    -- Tipografía y Tamaños
    Fonts = {
        Main = Enum.Font.Gotham,
        Bold = Enum.Font.GothamBold,
        Mono = Enum.Font.Code, -- Para datos técnicos
    },
    
    Layout = {
        CornerRadius = UDim.new(0, 2), -- Bordes filosos (casi cuadrados)
        Padding = 10,
        HeaderHeight = 40,
    }
}

--[[ KEYBINDS ]]
Configuration.Keybinds = {
    ToggleUI = Enum.KeyCode.RightControl, -- Tecla por defecto para abrir/cerrar
    EmergencyStop = Enum.KeyCode.Delete,   -- Pánico
}

--[[ GAME SETTINGS ]]
Configuration.Game = {
    PlaceId = 2753915549, -- Blox Fruits (Sea 1) - Debemos agregar los otros IDs de los mares
    SupportedPlaces = {
        [2753915549] = "Sea 1",
        [4442272183] = "Sea 2",
        [7449423635] = "Sea 3",
    },
    TeleportDelay = 0.5, -- Seguridad
}

return Configuration
