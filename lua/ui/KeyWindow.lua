local Theme = AetherRequire("lua.ui.Theme")
local Button = AetherRequire("lua.ui.Button")
local Auth = AetherRequire("lua.core.Auth")
local Utilities = AetherRequire("lua.Utilities")

local KeyWindow = {}

function KeyWindow:Create(gui, onVerify)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 260)
    frame.Position = UDim2.new(0.5, -210, 0.5, -130)
    frame.BackgroundColor3 = Theme.Colors.Main
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = Theme.CornerRadius
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1
    stroke.Color = Theme.Colors.Stroke
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "AETHER KEY SYSTEM"
    title.Font = Theme.FontBold
    title.TextSize = 20
    title.TextColor3 = Theme.Colors.TextHigh
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    -- Input Box
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.8, 0, 0, 45)
    input.Position = UDim2.new(0.1, 0, 0.3, 0)
    input.BackgroundColor3 = Theme.Colors.Element
    input.TextColor3 = Theme.Colors.TextHigh
    input.Font = Theme.Font
    input.TextSize = 14
    input.Text = ""
    input.PlaceholderText = "Paste Key Here..."
    input.Parent = frame
    
    local inCorner = Instance.new("UICorner", input)
    inCorner.CornerRadius = Theme.CornerRadius
    
    local inStroke = Instance.new("UIStroke", input)
    inStroke.Thickness = 1
    inStroke.Color = Theme.Colors.Stroke
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Text = ""
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.5, 0)
    status.BackgroundTransparency = 1
    status.TextColor3 = Theme.Colors.Accent
    status.Font = Theme.Font
    status.Parent = frame
    
    -- Buttons
    local btnSize = UDim2.new(0.38, 0, 0, 40)
    
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Text = "VERIFY"
    verifyBtn.Size = btnSize
    verifyBtn.Position = UDim2.new(0.52, 0, 0.65, 0)
    verifyBtn.BackgroundColor3 = Theme.Colors.Accent
    verifyBtn.TextColor3 = Theme.Colors.AccentText -- Dark Text on Green
    verifyBtn.Font = Theme.FontBold
    verifyBtn.Parent = frame
    
    local vCor = Instance.new("UICorner", verifyBtn)
    vCor.CornerRadius = Theme.CornerRadius
    
    verifyBtn.MouseButton1Click:Connect(function()
        status.Text = "Verifying..."
        local success, msg = Auth.VerifyKey(input.Text)
        if success then
            status.Text = "Success!"
            status.TextColor3 = Theme.Colors.Accent
            wait(0.5)
            Utilities.CreateTween(frame, {BackgroundTransparency = 1}, 0.5).Completed:Connect(function()
                frame:Destroy()
                onVerify()
            end)
            -- Fade children
             for _, child in ipairs(frame:GetChildren()) do
                if child:IsA("GuiObject") then
                    Utilities.CreateTween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.5)
                end
            end
        else
            status.Text = msg
            status.TextColor3 = Theme.Colors.Error
        end
    end)
    
    local getBtn = Instance.new("TextButton")
    getBtn.Text = "GET KEY"
    getBtn.Size = btnSize
    getBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    getBtn.BackgroundColor3 = Theme.Colors.Element
    getBtn.TextColor3 = Theme.Colors.TextHigh
    getBtn.Font = Theme.FontBold
    getBtn.Parent = frame
    
    local gCor = Instance.new("UICorner", getBtn)
    gCor.CornerRadius = Theme.CornerRadius
    local gStr = Instance.new("UIStroke", getBtn)
    gStr.Color = Theme.Colors.Stroke
    
    getBtn.MouseButton1Click:Connect(function()
        setclipboard(Auth.GetKeyLink())
        status.Text = "Link copied!"
        wait(2)
        status.Text = ""
    end)
end

return KeyWindow
