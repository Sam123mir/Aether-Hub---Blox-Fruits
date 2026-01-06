local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Theme = AetherRequire("lua.ui.Theme")
local Utilities = AetherRequire("lua.Utilities")

local Window = {}
Window.__index = Window

function Window.new(title)
    local self = setmetatable({}, Window)
    
    local gui = AetherRequire("lua.ui.UIManager").Gui
    
    -- :: MAIN CONTAINER (Invisible, holds everything) ::
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "AetherWindow"
    mainContainer.Size = UDim2.new(0, 700, 0, 450) -- Larger size
    mainContainer.Position = UDim2.new(0.5, -350, 0.5, -225)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = gui
    self.Instance = mainContainer
    
    -- :: HEADER BAR (Title + Profile) ::
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Theme.Colors.Main
    header.BorderSizePixel = 0
    header.Parent = mainContainer
    
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = Theme.CornerRadius
    
    -- Header Gradient/Stroke
    local headerStroke = Instance.new("UIStroke", header)
    headerStroke.Transparency = 0.8
    headerStroke.Thickness = 1
    headerStroke.Color = Theme.Colors.Accent
    
    -- Title Text (Left)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title .. " <font color=\"rgb(0,255,65)\">BETA</font>" -- Rich Text
    titleLabel.RichText = true
    titleLabel.Font = Theme.Fonts.Bold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Theme.Colors.TextHigh
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- User Profile (Right)
    local player = Players.LocalPlayer
    
    local profileFrame = Instance.new("Frame")
    profileFrame.Size = UDim2.new(0, 180, 0, 40)
    profileFrame.AnchorPoint = Vector2.new(1, 0.5)
    profileFrame.Position = UDim2.new(1, -10, 0.5, 0)
    profileFrame.BackgroundTransparency = 1
    profileFrame.Parent = header
    
    -- Avatar Image
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 32, 0, 32)
    avatar.Position = UDim2.new(0, 0, 0.5, -16)
    avatar.BackgroundColor3 = Theme.Colors.Section
    avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    avatar.Parent = profileFrame
    
    local avatarCorner = Instance.new("UICorner", avatar)
    avatarCorner.CornerRadius = UDim.new(1, 0) -- Circle
    
    local avatarStroke = Instance.new("UIStroke", avatar)
    avatarStroke.Color = Theme.Colors.Accent
    avatarStroke.Thickness = 1
    
    -- Username & DisplayName
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = player.DisplayName
    nameLabel.Font = Theme.Fonts.Bold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Theme.Colors.TextHigh
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(0, 130, 0, 16)
    nameLabel.Position = UDim2.new(0, 42, 0, 0)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = profileFrame
    
    local userLabel = Instance.new("TextLabel")
    userLabel.Text = "@" .. player.Name
    userLabel.Font = Theme.Fonts.Regular
    userLabel.TextSize = 11
    userLabel.TextColor3 = Theme.Colors.TextDark
    userLabel.BackgroundTransparency = 1
    userLabel.Size = UDim2.new(0, 130, 0, 14)
    userLabel.Position = UDim2.new(0, 42, 0, 16)
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.Parent = profileFrame

    -- :: MINIMIZE BUTTON ::
    local minBtn = Instance.new("TextButton")
    minBtn.Text = "-"
    minBtn.Font = Theme.Fonts.Bold
    minBtn.TextSize = 24
    minBtn.TextColor3 = Theme.Colors.TextMid
    minBtn.BackgroundTransparency = 1
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -220, 0.5, -15) -- To the left of profile
    minBtn.Parent = header
    
    minBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)

    -- :: CONTENT LAYOUT ::
    -- Sidebar (Tabs)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, -60) -- 50px header + 10px Gap
    sidebar.Position = UDim2.new(0, 0, 0, 60)
    Theme.ApplyStyle(sidebar, "FloatingContainer")
    sidebar.Parent = mainContainer
    self.Sidebar = sidebar
    
    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -190, 1, -60) -- Remaining width minus gap
    content.Position = UDim2.new(0, 190, 0, 60)
    Theme.ApplyStyle(content, "FloatingContainer")
    content.Parent = mainContainer
    self.Content = content
    
    -- Dragging Logic
    self:MakeDraggable(header)
    
    return self
end

function Window:MakeDraggable(dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Instance.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            Utilities.CreateTween(self.Instance, {Position = newPos}, 0.1)
        end
    end)
end

function Window:Show()
    self.Instance.Visible = true
    -- Intro Animation
    self.Instance.Size = UDim2.new(0, 0, 0, 0)
    self.Instance.BackgroundTransparency = 1
    
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 700, 0, 450), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Back)
    -- We keep MainContainer transparent, children have color
end

function Window:Minimize()
    local FloatingIcon = AetherRequire("lua.ui.FloatingIcon")
    -- Shrink animation
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quart).Completed:Connect(function()
        self.Instance.Visible = false
        FloatingIcon:Show()
    end)
end

function Window:Restore()
    self.Instance.Visible = true
    Utilities.CreateTween(self.Instance, {Size = UDim2.new(0, 700, 0, 450)}, 0.4, Enum.EasingStyle.Back)
end

return Window
