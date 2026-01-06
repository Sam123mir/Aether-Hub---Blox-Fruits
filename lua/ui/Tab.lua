local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local TabSystem = {}
TabSystem.__index = TabSystem

function TabSystem.new(window)
    local self = setmetatable({}, TabSystem)
    self.Window = window
    self.Tabs = {} -- List of tab helper objects
    self.CurrentTab = nil
    
    -- Container for Tab Buttons
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, 0, 1, -20)
    tabContainer.Position = UDim2.new(0, 0, 0, 10)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = Theme.Colors.Accent
    tabContainer.Parent = window.Sidebar
    
    local layout = Instance.new("UIListLayout", tabContainer)
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    self.Container = tabContainer
    return self
end

function TabSystem:AddTab(name)
    -- 1. Create Button in Sidebar
    local btn = Instance.new("TextButton")
    btn.Name = name .. "_Btn"
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Theme.Colors.Main
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = self.Container
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Theme.Fonts.Medium
    label.TextSize = 14
    label.TextColor3 = Theme.Colors.TextMid
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0) -- Indent
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    -- Selection Indicator (Green Bar on left)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.BackgroundColor3 = Theme.Colors.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false -- Hidden by default
    indicator.Parent = btn
    
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(0, 4)
    
    -- 2. Create Content Page in Content Area
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "_Page"
    page.Size = UDim2.new(1, -4, 1, -4) -- Padding
    page.Position = UDim2.new(0, 2, 0, 2)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Colors.Accent
    page.Visible = false
    page.Parent = self.Window.Content
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pagePad = Instance.new("UIPadding", page)
    pagePad.PaddingTop = UDim.new(0, 10)
    pagePad.PaddingBottom = UDim.new(0, 10)
    
    local tabData = {
        Button = btn,
        Label = label,
        Indicator = indicator,
        Page = page
    }
    
    -- Click Event
    btn.MouseButton1Click:Connect(function()
        self:SelectTab(tabData)
    end)
    
    -- Hover Animation
    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabData then
            Utilities.CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(30,30,30)}, 0.2)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabData then
            Utilities.CreateTween(btn, {BackgroundColor3 = Theme.Colors.Main}, 0.2)
        end
    end)
    
    -- Select first tab automatically
    if not self.CurrentTab then
        self:SelectTab(tabData)
    end
    
    return page -- Return page for adding elements
end

function TabSystem:SelectTab(tabData)
    -- Deselect current
    if self.CurrentTab then
        Utilities.CreateTween(self.CurrentTab.Button, {BackgroundColor3 = Theme.Colors.Main}, 0.2)
        Utilities.CreateTween(self.CurrentTab.Label, {TextColor3 = Theme.Colors.TextMid}, 0.2)
        self.CurrentTab.Indicator.Visible = false
        self.CurrentTab.Page.Visible = false
    end
    
    -- Select new
    self.CurrentTab = tabData
    Utilities.CreateTween(tabData.Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
    Utilities.CreateTween(tabData.Label, {TextColor3 = Theme.Colors.Accent}, 0.2)
    tabData.Indicator.Visible = true
    tabData.Page.Visible = true
end

return TabSystem
