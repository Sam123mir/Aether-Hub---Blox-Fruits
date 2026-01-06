local Configuration = require(script.Parent.Configuration)
local Utilities = require(script.Parent.Utilities)
local Workspace = require(script.Parent.Workspace)
-- UI Manager will be required later to avoid cyclic dependencies if possible, or lazily

local Engine = {}
Engine.Running = false
Engine.Modules = {}
Engine.Events = {}

--[[ LIFECYCLE ]]
function Engine:Start()
    if self.Running then return warn("Aether Scripts ya está corriendo.") end
    print("[Aether Engine]: Iniciando sistemas...")
    
    -- 1. Security Check
    local secure, reason = Workspace.Init()
    if not secure then
        return warn("[Aether Engine]: Detenido por seguridad - " .. tostring(reason))
    end
    
    -- 2. Load UI & Auth Flow
    self:InitializeUI()
    
    -- 3. Mark as running
    self.Running = true
    print("[Aether Engine]: Sistemas listos. Esperando autenticación...")
end

function Engine:InitializeUI()
    -- Lazy load UIManager
    local UIManager = require(script.Parent.ui.UIManager)
    UIManager:Init(self)
    
    -- Show Key Window first
    UIManager:ShowKeyWindow(function()
        -- On Success Auth
        self:LoadGameModules()
        UIManager:ShowMainWindow()
    end)
end

function Engine:LoadGameModules()
    print("[Aether Engine]: Cargando módulos de juego...")
    -- Here we will require all modules in 'modules' folder
    -- For now, we manually list them or use script.Parent.modules:GetChildren() if structure permits
    
    -- Example:
    -- self.Modules.AutoFarm = require(script.Parent.modules.AutoFarm)
    -- self.Modules.AutoFarm:Init()
    
    print("[Aether Engine]: Módulos cargados.")
end

--[[ EVENT BUS ]]
function Engine:Subscribe(eventName, callback)
    if not self.Events[eventName] then self.Events[eventName] = {} end
    table.insert(self.Events[eventName], callback)
end

function Engine:Publish(eventName, ...)
    if self.Events[eventName] then
        for _, callback in ipairs(self.Events[eventName]) do
            Utilities.SafeCall(callback, ...)
        end
    end
end

return Engine
