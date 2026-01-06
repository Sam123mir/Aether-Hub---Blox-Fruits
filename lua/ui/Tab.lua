local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local TabSystem = {}
TabSystem.__index = TabSystem

function TabSystem.new(window)
    local self = setmetatable({}, TabSystem)
    self.Window = window
    self.CurrentTab = nil
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -20, 1, -60)
    container.Position = UDim2.new(0, 10, 0, 60)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 2
    container.Parent = window.Sidebar
    
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 4)
    
    self.Container = container
    return self
end

function TabSystem:AddTab(name)
    -- Button
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Theme.Colors.Sidebar
    btn.BackgroundTransparency = 1 -- Ghost by default
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = self.Container
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = Theme.CornerRadius
    
    -- Indicator Pill (Left)
    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 3, 0.5, 0)
    pill.Position = UDim2.new(0, 0, 0.25, 0)
    pill.BackgroundColor3 = Theme.Colors.Accent
    pill.Visible = false
    pill.Parent = btn
    local pCorp = Instance.new("UICorner", pill)
    pCorp.CornerRadius = UDim.new(1,0)

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Text = name
    lbl.Font = Theme.Font
    lbl.TextSize = 14
    lbl.TextColor3 = Theme.Colors.TextMid
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn
    
    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -40, 1, -60)
    page.Position = UDim2.new(0, 20, 0, 50) -- Below topbar
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Theme.Colors.TextLow
    page.Visible = false
    page.Parent = self.Window.Content
    
    local pLayout = Instance.new("UIListLayout", page)
    pLayout.Padding = UDim.new(0, 10)
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local tabData = {
        Button = btn,
        Pill = pill,
        Label = lbl,
        Page = page
    }
    
    btn.MouseButton1Click:Connect(function() self:Select(tabData) end)
    
    -- Initial select if first
    if not self.CurrentTab then self:Select(tabData) end
    
    return page
end

function TabSystem:Select(tabData)
    if self.CurrentTab then
        local old = self.CurrentTab
        Utilities.CreateTween(old.Button, {BackgroundTransparency = 1}, 0.2)
        Utilities.CreateTween(old.Label, {TextColor3 = Theme.Colors.TextMid}, 0.2)
        old.Pill.Visible = false
        old.Page.Visible = false
    end
    
    self.CurrentTab = tabData
    
    -- Active State
    Utilities.CreateTween(tabData.Button, {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.new(1,1,1)}, 0.2) -- Subtle lighter bg
    Utilities.CreateTween(tabData.Label, {TextColor3 = Theme.Colors.TextHigh}, 0.2)
    tabData.Pill.Visible = true
    tabData.Page.Visible = true
end

return TabSystem
