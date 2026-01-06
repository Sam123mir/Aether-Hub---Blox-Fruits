local Configuration = require(script.Parent.Parent.Configuration)
local Theme = {}

Theme.Colors = Configuration.Theme.Colors
Theme.Fonts = Configuration.Theme.Fonts
Theme.Layout = Configuration.Theme.Layout

function Theme.ApplyStyle(instance, styleType)
    if styleType == "Window" then
        instance.BackgroundColor3 = Theme.Colors.MainBackground
        instance.BorderSizePixel = 0
    elseif styleType == "Panel" then
        instance.BackgroundColor3 = Theme.Colors.PanelBackground
        instance.BorderSizePixel = 0
        local uic = Instance.new("UICorner", instance)
        uic.CornerRadius = Theme.Layout.CornerRadius
    elseif styleType == "Text" then
        instance.Font = Theme.Fonts.Main
        instance.TextColor3 = Theme.Colors.TextHigh
        instance.BackgroundTransparency = 1
    elseif styleType == "AccentButton" then
        instance.BackgroundColor3 = Theme.Colors.Accent
        instance.TextColor3 = Theme.Colors.MainBackground -- Text black on green
        instance.Font = Theme.Fonts.Bold
    elseif styleType == "Input" then
        instance.BackgroundColor3 = Theme.Colors.PanelBackground
        instance.TextColor3 = Theme.Colors.Accent
        instance.PlaceholderColor3 = Theme.Colors.TextLow
        instance.BorderSizePixel = 1
        instance.BorderColor3 = Theme.Colors.Accent
    end
end

return Theme
