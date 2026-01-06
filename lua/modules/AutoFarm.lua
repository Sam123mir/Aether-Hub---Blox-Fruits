local Utilities = require(script.Parent.Parent.Utilities)
local Configuration = require(script.Parent.Parent.Configuration)
local RunService = game:GetService("RunService")

local AutoFarm = {}
AutoFarm.Enabled = false
AutoFarm.Connection = nil

--[[ LOGIC ]]
function AutoFarm:Toggle(state)
    self.Enabled = state
    if self.Enabled then
        print("[Aether Module]: Auto Farm Fruit Iniciado")
        self:StartLoop()
    else
        print("[Aether Module]: Auto Farm Fruit Detenido")
        self:StopLoop()
    end
end

function AutoFarm:StartLoop()
    if self.Connection then return end
    
    -- Using a coroutine or task.spawn loop that checks periodically
    -- We don't need Heartbeat for fruit searching, it's too fast. 
    -- A loop every 0.5s is enough.
    
    task.spawn(function()
        while self.Enabled do
            local targetFruit = self:FindBestFruit()
            if targetFruit then
                print("[AutoFarm]: Fruta encontrada: " .. targetFruit.Name)
                self:CollectFruit(targetFruit)
            end
            task.wait(Configuration.Game.TeleportDelay or 1)
        end
        self.Connection = nil
    end)
    self.Connection = true -- Just a flag in this case
end

function AutoFarm:StopLoop()
    self.Enabled = false
    -- The while loop checks 'self.Enabled' so it will stop naturally
end

function AutoFarm:FindBestFruit()
    -- Blox Fruits usually puts spawned fruits in specific folders or Workspace
    -- We search for Handles or Tools that look like fruits
    local character = Utilities.GetCharacter()
    if not character then return nil end
    local root = Utilities.GetRootPart()
    if not root then return nil end
    
    local bestFruit = nil
    local minDist = math.huge
    
    -- Search Strategy: Look for "Fruit" in name in Workspace
    -- Adjust this filter based on actual game structure
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and string.find(obj.Name, "Fruit")) then
            -- Verify it has a Handle
            local handle = obj:FindFirstChild("Handle")
            if handle then
                local dist = (handle.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    bestFruit = obj
                end
            end
        end
    end
    
    return bestFruit
end

function AutoFarm:CollectFruit(fruit)
    local root = Utilities.GetRootPart()
    local handle = fruit:FindFirstChild("Handle")
    if not root or not handle then return end
    
    -- Teleport Safety (Tweening is better for short distances, CFrame for long)
    local dist = (handle.Position - root.Position).Magnitude
    
    -- If very far, snap (bypass) or tween fast
    -- Using direct CFrame for "Elite" snappy feel, but risky if watched
    -- Let's use Tween for "smooth" feel
    
    local tweenTime = dist / 300 -- Speed control
    if tweenTime > 2 then tweenTime = 2 end -- Cap max time
    
    local tween = Utilities.CreateTween(root, {CFrame = handle.CFrame + Vector3.new(0,2,0)}, tweenTime)
    tween.Completed:Wait()
    
    -- Attempt Pickup
    -- Blox Fruits fruits are often Tools you touch or ClickDetector or ProximityPrompt
    if fruit:FindFirstChild("ProximityPrompt") then
        fireproximityprompt(fruit.ProximityPrompt)
    elseif fruit:IsA("Tool") then
        -- Touch pickup simulation
        firetouchinterest(root, handle, 0)
        firetouchinterest(root, handle, 1)
    end
    
    -- Store in Inventory (Backpack) is automatic if tool
    print("[AutoFarm]: Intentando recoger " .. fruit.Name)
    task.wait(0.5)
end

return AutoFarm
