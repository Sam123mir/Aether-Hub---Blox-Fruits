local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StatsService = game:GetService("Stats")

local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Window = {}
Window.__index = Window

function Window.new(title)
    local self = setmetatable({}, Window)
    local gui = AetherRequire("lua.ui.UIManager").Gui
    
    -- 1. Main Frame (Draggable Center)
    local main = Instance.new("Frame")
    main.Name = "MainWindow"
    main.Size = UDim2.new(0, 750, 0, 500)
    main.Position = UDim2.new(0.5, -375, 0.5, -250)
    main.BackgroundColor3 = Theme.Colors.Main
    main.BorderSizePixel = 0
    main.Parent = gui
    
    local mainRec = Instance.new("UICorner", main)
    mainRec.CornerRadius = Theme.CornerRadius
    
    -- Shadow
    local shadow = Instance.new("UIStroke", main)
    shadow.Thickness = 1
    shadow.Color = Theme.Colors.Accent
    shadow.Transparency = 0.8
    
    self.Instance = main
    
    -- 2. Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundTransparency = 1
    header.Parent = main
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text = title .. " <font color=\"rgb(0,255,65)\">V3</font>"
    titleLbl.RichText = true
    titleLbl.Font = Theme.Fonts.Bold
    titleLbl.TextSize = 18
    titleLbl.TextColor3 = Theme.Colors.TextHigh
    titleLbl.Size = UDim2.new(0, 200, 1, 0)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = header
    
    -- Controls (Min/Close)
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 80, 1, 0)
    controls.Position = UDim2.new(1, -80, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = header
    
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Image = Theme.Icons.Close
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -10)
    closeBtn.ImageColor3 = Theme.Colors.TextMid
    closeBtn.Parent = controls
    
    local minBtn = Instance.new("ImageButton")
    minBtn.Image = Theme.Icons.Min
    minBtn.BackgroundTransparency = 1
    minBtn.Size = UDim2.new(0, 20, 0, 20)
    minBtn.Position = UDim2.new(1, -60, 0.5, -10)
    minBtn.ImageColor3 = Theme.Colors.TextMid
    minBtn.Parent = controls
    
    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)
    minBtn.MouseButton1Click:Connect(function() self:Minimize() end)
    
    -- 3. Layout (Sidebar / Content)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = Theme.Colors.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    
    local sbCorner = Instance.new("UICorner", sidebar)
    sbCorner.CornerRadius = UDim.new(0, 0) -- Square logic or adjust
    -- Actually for sleek look, maybe round bottom left
    
    self.Sidebar = sidebar
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -200, 1, -40)
    content.Position = UDim2.new(0, 200, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = main
    self.Content = content

    -- 4. Footer / Stats Bar (Detached below)
    local footer = Instance.new("Frame")
    footer.Name = "StatsFooter"
    footer.Size = UDim2.new(0, 750, 0, 40)
    footer.Position = UDim2.new(0, 0, 1, 15) -- 15px gap below
    footer.BackgroundColor3 = Theme.Colors.Section
    footer.BorderSizePixel = 0
    footer.Parent = main
    
    local fCorner = Instance.new("UICorner", footer)
    fCorner.CornerRadius = Theme.CornerRadius
    
    local fStroke = Instance.new("UIStroke", footer)
    fStroke.Thickness = 1
    fStroke.Color = Theme.Colors.AccentDim
    fStroke.Transparency = 0.5
    
    -- Footer Content
    local list = Instance.new("UIListLayout", footer)
    list.FillDirection = Enum.FillDirection.Horizontal
    list.VerticalAlignment = Enum.VerticalAlignment.Center
    list.Padding = UDim.new(0, 20)
    
    local pad = Instance.new("UIPadding", footer)
    pad.PaddingLeft = UDim.new(0, 15)
    
    -- Profile
    local plr = Players.LocalPlayer
    
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 24, 0, 24)
    avatar.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    avatar.BackgroundColor3 = Theme.Colors.Main
    avatar.Parent = footer
    local avCorner = Instance.new("UICorner", avatar)
    avCorner.CornerRadius = UDim.new(1,0)
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
    nameLbl.Font = Theme.Fonts.Medium
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = Theme.Colors.TextHigh
    nameLbl.AutomaticSize = Enum.AutomaticSize.X
    nameLbl.BackgroundTransparency = 1
    nameLbl.Parent = footer
    
    -- Stats Labels
    local function CreateStat(name, icon)
        local frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
        frame.AutomaticSize = Enum.AutomaticSize.X
        frame.Size = UDim2.new(0, 0, 1, 0)
        frame.Parent = footer
        
        local txt = Instance.new("TextLabel")
        txt.Name = "Val"
        txt.Text = name .. ": ..."
        txt.Font = Theme.Fonts.Mono
        txt.TextSize = 12
        txt.TextColor3 = Theme.Colors.TextMid
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(0,0,1,0)
        txt.AutomaticSize = Enum.AutomaticSize.X
        txt.Parent = frame
        return txt
    end
    
    local fpsLbl = CreateStat("FPS")
    local pingLbl = CreateStat("Ping")
    
    -- Loop for stats
    task.spawn(function()
        while main.Parent do 
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            fpsLbl.Text = "FPS: " .. fps
            pingLbl.Text = "PING: " .. ping .. "ms"
            task.wait(1)
        end
    end)
    
    self:MakeDraggable(header)
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
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            self.Instance.Position = newPos
        end
    end)
end

function Window:Show()
    self.Instance.Visible = true
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 750, 0, 500)}, 0.5, Enum.EasingStyle.Elastic)
end

function Window:Minimize()
    local FloatingIcon = AetherRequire("lua.ui.FloatingIcon")
    self.Instance.Visible = false
    FloatingIcon:Show()
end

function Window:Destroy()
    self.Instance:Destroy()
end

return Window
