local Utilities = AetherRequire("lua.Utilities")
local Configuration = AetherRequire("lua.Configuration")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local AutoLevel = {}
AutoLevel.Enabled = false
AutoLevel.TargetName = nil -- If nil, kill anything? Or specified list?
AutoLevel.Connection = nil

--[[ LOGIC ]]
function AutoLevel:Toggle(state)
    self.Enabled = state
    if self.Enabled then
        print("[Aether Module]: Auto Level Started")
        self:StartLoop()
    else
        print("[Aether Module]: Auto Level Stopped")
        if self.Connection then self.Connection:Disconnect() end
        self.Connection = nil
    end
end

function AutoLevel:SetTarget(mobName)
    self.TargetName = mobName
end

function AutoLevel:StartLoop()
    if self.Connection then return end
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        local target = self:FindTarget()
        if target then
            self:AttackTarget(target)
        end
    end)
end

function AutoLevel:FindTarget()
    local char = Utilities.GetCharacter()
    if not char then return nil end
    local root = Utilities.GetRootPart()
    
    local bestTarget = nil
    local minDist = 2000 -- Max range scan
    
    -- Blox Fruits NPCs are usually in folder "Enemies" or workspace.Enemies
    -- Safety check for folder existence
    local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("EnemiesV3")
    
    if enemiesFolder then
        for _, obj in ipairs(enemiesFolder:GetChildren()) do
            if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
                if not self.TargetName or obj.Name == self.TargetName then
                    local dist = (obj.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        bestTarget = obj
                    end
                end
            end
        end
    end
    
    return bestTarget
end

function AutoLevel:AttackTarget(enemy)
    local char = Utilities.GetCharacter()
    local root = Utilities.GetRootPart()
    local enemyRoot = enemy.HumanoidRootPart
    
    -- 1. Teleport/Float Position (Safe Distance above head)
    -- We maintain a position slightly above the enemy to avoid getting hit easily
    local attackPos = enemyRoot.CFrame * CFrame.new(0, 20, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    
    -- Using CFrame directly for "locking" on target
    root.CFrame = attackPos
    root.Velocity = Vector3.new(0,0,0) -- Anti-Fall
    
    -- 2. Auto Click
    -- Blox Fruits requires equipping tool and clicking
    local tool = char:FindFirstChildOfClass("Tool") 
                 or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    
    if tool and tool.Parent ~= char then
        tool.Parent = char -- Auto Equip
    end
    
    -- Simulate Click
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0))
end

return AutoLevel
