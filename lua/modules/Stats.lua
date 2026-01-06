local Utilities = AetherRequire("lua.Utilities")
local RunService = game:GetService("RunService")

local Stats = {}
Stats.Enabled = false
Stats.TargetStat = "Melee" -- Default
Stats.Connection = nil

-- Blox Fruits Stat Mapping
local StatMap = {
    ["Melee"] = "Melee",
    ["Defense"] = "Defense",
    ["Sword"] = "Sword",
    ["Gun"] = "Gun",
    ["Devil Fruit"] = "Demon Fruit" -- Verify actual remote arg name
}

function Stats:Toggle(state)
    self.Enabled = state
    if self.Enabled then
        print("[Aether Module]: Auto Stats Started (" .. self.TargetStat .. ")")
        self:StartLoop()
    else
        self:StopLoop()
    end
end

function Stats:SetTarget(statName)
    self.TargetStat = statName
end

function Stats:StartLoop()
    if self.Connection then return end
    
    -- Check every 1 second is enough
    task.spawn(function()
        while self.Enabled do
            self:AllocatePoints()
            task.wait(1)
        end
        self.Connection = nil
    end)
    self.Connection = true
end

function Stats:StopLoop()
    self.Enabled = false
end

function Stats:AllocatePoints()
    local plr = Utilities.GetLocalPlayer()
    local data = plr:FindFirstChild("Data") -- Blox Fruits stores stats in Data folder usually
    
    if data and data:FindFirstChild("Points") and data.Points.Value > 0 then
        local points = data.Points.Value
        
        -- Fire Remote
        -- Validating standard Blox Fruits remote location
        local remotesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local remote = remotesFolder and remotesFolder:FindFirstChild("CommF_")
        
        if remote then
            local args = {
                [1] = "AddPoint",
                [2] = StatMap[self.TargetStat],
                [3] = points -- Add all? Or step by step? Usually can add all.
            }
            remote:InvokeServer(unpack(args))
            print("[AutoStats]: Added " .. points .. " to " .. self.TargetStat)
        else
            warn("[AutoStats]: Remoto 'CommF_' no encontrado. ¿Estás en Blox Fruits?")
        end
    end
end

return Stats
