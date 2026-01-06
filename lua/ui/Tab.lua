local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local TabSystem = {}
TabSystem.__index = TabSystem

function TabSystem.new(window)
    local self = setmetatable({}, TabSystem)
    self.Window = window
    self.Tabs = {}
    self.CurrentTab = nil
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, -20)
    container.Position = UDim2.new(0, 0, 0, 10)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = window.Sidebar
    
    local layout = Instance.new("UIListLayout", container)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    
    self.Container = container
    return self
end

function TabSystem:AddTab(name)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Theme.Colors.Sidebar -- Fixed: explicit color
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Theme.Fonts.Medium
    btn.TextSize = 14
    btn.TextColor3 = Theme.Colors.TextMid
    btn.AutoButtonColor = false
    btn.Parent = self.Container
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "_Page"
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.Parent = self.Window.Content
    
    local pLayout = Instance.new("UIListLayout", page)
    pLayout.Padding = UDim.new(0, 10)
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pPad = Instance.new("UIPadding", page)
    pPad.PaddingBottom = UDim.new(0, 20)
    
    local tabData = {
        Button = btn,
        Page = page
    }
    
    btn.MouseButton1Click:Connect(function()
        self:SelectTab(tabData)
    end)
    
    if not self.CurrentTab then
        self:SelectTab(tabData)
    end
    
    return page
end

function TabSystem:SelectTab(tabData)
    if self.CurrentTab then
        Utilities.CreateTween(self.CurrentTab.Button, {BackgroundColor3 = Theme.Colors.Sidebar, TextColor3 = Theme.Colors.TextMid}, 0.2)
        self.CurrentTab.Page.Visible = false
    end
    
    self.CurrentTab = tabData
    -- Highlight
    Utilities.CreateTween(tabData.Button, {BackgroundColor3 = Theme.Colors.Section, TextColor3 = Theme.Colors.Accent}, 0.2)
    tabData.Page.Visible = true
end

return TabSystem
