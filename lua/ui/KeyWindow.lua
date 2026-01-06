local Theme = AetherRequire("lua.ui.Theme")
local Button = AetherRequire("lua.ui.Button")
local Auth = AetherRequire("lua.core.Auth")
local Utilities = AetherRequire("lua.Utilities")

local KeyWindow = {}

function KeyWindow:Create(gui, onVerify)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    Theme.ApplyStyle(frame, "Window") -- Dark background
    frame.Parent = gui
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Theme.Colors.Accent
    stroke.Thickness = 1
    
    -- Logo / Title
    local title = Instance.new("TextLabel")
    title.Text = "AETHER SCRIPTS"
    title.Font = Theme.Fonts.Bold
    title.TextSize = 32
    title.TextColor3 = Theme.Colors.Accent
    title.Size = UDim2.new(1, 0, 0, 60)
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    -- Input Box
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.8, 0, 0, 40)
    input.Position = UDim2.new(0.1, 0, 0.3, 0)
    Theme.ApplyStyle(input, "Input")
    input.Text = ""
    input.PlaceholderText = "Paste Key Here..."
    input.Parent = frame
    
    -- Status Label
    local status = Instance.new("TextLabel")
    status.Text = ""
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.5, 0)
    status.BackgroundTransparency = 1
    status.TextColor3 = Theme.Colors.Error
    status.Parent = frame
    
    -- Verify Button
    Button.Create(frame, {
        Text = "VERIFY KEY",
        Size = UDim2.new(0.35, 0, 0, 40),
        Position = UDim2.new(0.52, 0, 0.65, 0),
        Variant = "AccentButton",
        Callback = function()
            status.Text = "Verifying..."
            status.TextColor3 = Theme.Colors.TextMid
            
            -- Call Auth
            local success, msg = Auth.VerifyKey(input.Text)
            
            if success then
                status.Text = "Success!"
                status.TextColor3 = Theme.Colors.Success
                wait(0.5)
                Utilities.CreateTween(frame, {BackgroundTransparency = 1}, 0.5):Completed:Connect(function()
                    frame:Destroy()
                    onVerify()
                end)
                -- Fade out children
                for _, child in ipairs(frame:GetChildren()) do
                    if child:IsA("GuiObject") then
                        Utilities.CreateTween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.5)
                    end
                end
            else
                status.Text = msg
                status.TextColor3 = Theme.Colors.Error
                input.Text = ""
            end
        end
    })
    
    -- Get Key Button
    Button.Create(frame, {
        Text = "GET KEY",
        Size = UDim2.new(0.35, 0, 0, 40),
        Position = UDim2.new(0.12, 0, 0.65, 0),
        Variant = "Panel",
        Callback = function()
            setclipboard(Auth.GetKeyLink())
            status.Text = "Link copied to clipboard!"
            status.TextColor3 = Theme.Colors.TextHigh
            wait(2)
            status.Text = ""
        end
    })
    
    -- Premium Upsell
    local premium = Instance.new("TextButton")
    premium.Text = "<u>Buy Premium (No Key)</u>"
    premium.RichText = true
    premium.BackgroundTransparency = 1
    premium.TextColor3 = Theme.Colors.TextMid
    premium.Size = UDim2.new(1, 0, 0, 30)
    premium.Position = UDim2.new(0, 0, 0.85, 0)
    premium.Parent = frame
end

return KeyWindow
