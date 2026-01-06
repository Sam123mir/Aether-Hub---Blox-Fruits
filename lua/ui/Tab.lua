local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local TabSystem = {}
TabSystem.__index = TabSystem

function TabSystem.new(window)
    local self = setmetatable({}, TabSystem)
    self.Window = window
    self.Tabs = {}
    self.ActiveTab = nil
    
    -- Container for Tab Buttons (Left Side)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    tabContainer.Parent = window.Instance.Content
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = tabContainer
    
    self.ButtonContainer = tabContainer
    
    -- Container for Tab Content (Right Side)
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "TabContent"
    contentContainer.Size = UDim2.new(1, -135, 1, -10)
    contentContainer.Position = UDim2.new(0, 130, 0, 5)
    contentContainer.BackgroundColor3 = Theme.Colors.PanelBackground
    contentContainer.BorderSizePixel = 0
    local uic = Instance.new("UICorner", contentContainer)
    uic.CornerRadius = Theme.Layout.CornerRadius
    contentContainer.Parent = window.Instance.Content
    
    self.ContentContainer = contentContainer
    
    return self
end

function TabSystem:AddTab(name)
    -- Tab Button
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(1, 0, 0, 35)
    Theme.ApplyStyle(btn, "Panel") -- Default style
    btn.Font = Theme.Fonts.Main
    btn.TextColor3 = Theme.Colors.TextMid
    btn.Parent = self.ButtonContainer
    
    -- Selection Indicator (Bar on left)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 1, 0)
    indicator.BackgroundColor3 = Theme.Colors.Accent
    indicator.BackgroundTransparency = 1 -- Hidden by default
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    
    -- Content Frame
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "_Page"
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Colors.Accent
    page.Visible = false
    page.Parent = self.ContentContainer
    
    -- Helper for layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = page
    
    local tabData = {
        Button = btn,
        Indicator = indicator,
        Page = page,
        Name = name
    }
    
    btn.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    self.Tabs[name] = tabData
    
    -- Select first tab by default
    if not self.ActiveTab then
        self:SelectTab(name)
    end
    
    return page -- Return page so modules can add items to it
end

function TabSystem:SelectTab(name)
    if self.ActiveTab == name then return end
    
    -- Deactivate current
    if self.ActiveTab and self.Tabs[self.ActiveTab] then
        local old = self.Tabs[self.ActiveTab]
        Utilities.CreateTween(old.Button, {BackgroundColor3 = Theme.Colors.PanelBackground}, 0.2)
        Utilities.CreateTween(old.Button, {TextColor3 = Theme.Colors.TextMid}, 0.2)
        Utilities.CreateTween(old.Indicator, {BackgroundTransparency = 1}, 0.2)
        old.Page.Visible = false
    end
    
    -- Activate new
    local new = self.Tabs[name]
    self.ActiveTab = name
    
    -- Animate Button (Glow effect logic could go here)
    Utilities.CreateTween(new.Button, {BackgroundColor3 = Color3.fromRGB(25, 35, 25)}, 0.2) -- Slightly lighter
    Utilities.CreateTween(new.Button, {TextColor3 = Theme.Colors.Accent}, 0.2)
    Utilities.CreateTween(new.Indicator, {BackgroundTransparency = 0}, 0.2)
    
    -- Show Page with fade
    new.Page.CanvasPosition = Vector2.new(0,0)
    new.Page.Visible = true
    new.Page.BackgroundTransparency = 1
    -- Utilities.CreateTween(new.Page, {BackgroundTransparency = 1}, 0.5) -- Just fade in content if needed
end

return TabSystem
