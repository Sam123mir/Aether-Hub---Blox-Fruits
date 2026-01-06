local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Utilities = {}

--[[ TWEENING ]]
function Utilities.CreateTween(instance, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.3, 
        style or Enum.EasingStyle.Quad, 
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

--[[ MATH & VECTORS ]]
function Utilities.GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function Utilities.GetLocalPlayer()
    return Players.LocalPlayer
end

function Utilities.GetCharacter()
    local plr = Utilities.GetLocalPlayer()
    return plr.Character or plr.CharacterAdded:Wait()
end

function Utilities.GetRootPart()
    local char = Utilities.GetCharacter()
    return char:WaitForChild("HumanoidRootPart", 5)
end

--[[ FLOW CONTROL ]]
function Utilities.SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[Aether Error]: " .. tostring(result))
    end
    return success, result
end

function Utilities.Debounce(func, delay)
    local lastCall = 0
    return function(...)
        if tick() - lastCall >= delay then
            lastCall = tick()
            return func(...)
        end
    end
end

--[[ OBJECT MANAGEMENT ]]
function Utilities.WaitForChild(parent, name, timeout)
    return parent:WaitForChild(name, timeout or 10)
end

--[[ NETWORKING (MOCKUP FOR EXECUTORS) ]]
function Utilities.HttpRequest(options)
    -- Detectar función del executor
    local requestFunc = identifyexecutor and http_request or request or HttpPost or syn.request
    if requestFunc then
        return requestFunc(options)
    else
        warn("Executor no soporta Http Request")
        return {Body = "Error", StatusCode = 500}
    end
end

return Utilities
