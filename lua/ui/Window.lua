local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Window = {}
Window.__index = Window

function Window.new(title)
    local self = setmetatable({}, Window)
    local gui = AetherRequire("lua.ui.UIManager").Gui
    
    -- :: MAIN UNIFIED WINDOW ::
    local main = Instance.new("Frame")
    main.Name = "FluentWindow"
    main.Size = UDim2.new(0, 700, 0, 420)
    main.Position = UDim2.new(0.5, -350, 0.5, -210)
    main.BackgroundColor3 = Theme.Colors.Main
    main.BorderSizePixel = 0
    main.ClipsDescendants = true -- For corner radius
    main.Parent = gui
    
    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 1
    stroke.Color = Theme.Colors.Stroke
    stroke.Transparency = 0.5
    
    self.Instance = main
    
    -- :: SIDEBAR (Left) ::
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, 0)
    sidebar.BackgroundColor3 = Theme.Colors.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    self.Sidebar = sidebar
    
    -- Sidebar Border
    local sideDiv = Instance.new("Frame")
    sideDiv.Name = "Divider"
    sideDiv.Size = UDim2.new(0, 1, 1, 0)
    sideDiv.Position = UDim2.new(1, -1, 0, 0)
    sideDiv.BackgroundColor3 = Theme.Colors.Stroke
    sideDiv.BorderSizePixel = 0
    sideDiv.Parent = sidebar
    
    -- Title in Sidebar
    local appTitle = Instance.new("TextLabel")
    appTitle.Text = title
    appTitle.Font = Theme.FontBold
    appTitle.TextSize = 16
    appTitle.TextColor3 = Theme.Colors.TextHigh
    appTitle.Size = UDim2.new(1, -30, 0, 50)
    appTitle.Position = UDim2.new(0, 20, 0, 0)
    appTitle.BackgroundTransparency = 1
    appTitle.TextXAlignment = Enum.TextXAlignment.Left
    appTitle.Parent = sidebar

    -- :: CONTENT (Right) ::
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -180, 1, 0)
    content.Position = UDim2.new(0, 180, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = main
    self.Content = content
    
    -- Topbar (in Content for Dragging)
    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundTransparency = 1
    topbar.Parent = content
    
    -- Dragging
    self:MakeDraggable(sidebar) -- Drag from sidebar
    self:MakeDraggable(topbar) -- Drag from top content
    
    -- Close/Min (Mac Style or Win11 Style? Using Win11 simplified)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "×"
    closeBtn.Font = Theme.Font
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = Theme.Colors.TextMid
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = topbar
    
    closeBtn.MouseButton1Click:Connect(function() main:Destroy() end)
    
    return self
end

function Window:MakeDraggable(dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Instance.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.Instance.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Window:Show()
    self.Instance.Visible = true
    -- Scale in effect
    self.Instance.Size = UDim2.new(0, 0, 0, 420)
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 700, 0, 420)}, 0.4, Enum.EasingStyle.Exponential)
end

function Window:Restore()
    self.Instance.Visible = true
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 700, 0, 420)}, 0.4, Enum.EasingStyle.Exponential)
end

return Window
