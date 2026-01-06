local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Section = {}

function Section.Create(parent, text)
    local section = Instance.new("Frame")
    section.Name = text .. "_Section"
    section.BackgroundTransparency = 1
    -- Height will be automatic via UIListLayout
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.Parent = parent
    
    local padding = Instance.new("UIPadding", section)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 5)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Theme.Fonts.Bold
    label.TextSize = 12
    label.TextColor3 = Theme.Colors.TextDark
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Parent = section
    
    -- Content Holder
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 0, 0, 25)
    container.Parent = section
    
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    return container 
    -- We return the container so items can be parented to it
end

return Section
