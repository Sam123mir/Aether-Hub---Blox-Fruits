local Utilities = require(script.Parent.Parent.Utilities)
local Configuration = require(script.Parent.Parent.Configuration)

local Auth = {}
Auth.IsAuthenticated = false
Auth.Key = nil

local API_ENDPOINT = "https://tu-api-web.com/verify" -- Placeholder

function Auth.VerifyKey(keyInput)
    if Configuration.DebugMode and keyInput == "DEV-KEY" then
        Auth.IsAuthenticated = true
        return true, "Developer Bypass"
    end

    if not keyInput or #keyInput < 5 then
        return false, "Key inválida (muy corta)"
    end

    -- MOCKUP DE VERIFICACIÓN (Hasta que tengas el backend listo)
    -- En el futuro, esto hará un Request HTTP a tu API
    
    -- Simulando request de red
    local headers = {
        ["Content-Type"] = "application/json",
        ["HWID"] = game:GetService("RbxAnalyticsService"):GetClientId() -- Ejemplo de fingerprint
    }
    
    -- COMENTADO: Código real de producción
    --[[
    local response = Utilities.HttpRequest({
        Url = API_ENDPOINT .. "?key=" .. keyInput,
        Method = "GET",
        Headers = headers
    })
    
    if response and response.StatusCode == 200 then
        local data = game:GetService("HttpService"):JSONDecode(response.Body)
        if data.valid then
            Auth.IsAuthenticated = true
            Auth.Key = keyInput
            return true, "Acceso Concedido"
        else
            return false, "Key Expirada o Inválida"
        end
    end
    ]]
    
    -- MOCKUP: Simulando éxito si la key empieza por "AETHER"
    if string.sub(keyInput, 1, 6) == "AETHER" then
        Auth.IsAuthenticated = true
        Auth.Key = keyInput
        return true, "Acceso Concedido"
    else
        return false, "Key Inválida"
    end
end

function Auth.GetKeyLink()
    return "https://discord.gg/tuserver"
end

return Auth
