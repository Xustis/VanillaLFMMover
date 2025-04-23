-- Variables globales
local lfmTab = nil

-- Función para crear la pestaña [LFM]
local function CreateLFMTab()
    -- Crear una nueva pestaña de chat
    FCF_OpenNewWindow("LFM") 
    
    -- Buscar la pestaña por índice
    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame"..i]
        if frame ~= DEFAULT_CHAT_FRAME and not frame.isInitialized then
            lfmTab = frame
            break
        end
    end
    
    -- Configurar la pestaña
    if lfmTab then
        FCF_SetWindowName(lfmTab, "LFM")
        lfmTab:SetFading(false)
        lfmTab:SetMaxLines(500)
        FCF_SetLocked(lfmTab, true)
    else
        print("LFMMover: Error al crear la pestaña.")
        return
    end
    
    -- Sobrescribir función de chat (corregido)
    local orig_ChatFrame_OnEvent = ChatFrame_OnEvent
    function ChatFrame_OnEvent(event)
        if event == "CHAT_MSG_CHANNEL" then
            local msg, author = arg1, arg2
            -- Paréntesis corregido y formato clickable
            if msg and (string.find(string.lower(msg), "lfm") 
                or string.find(string.lower(msg), "lf1m") 
                or string.find(string.lower(msg), "lf") 
                or string.find(string.lower(msg), "lfg")) then 
                local playerLink = "|Hplayer:"..author.."|h|cFF00FF00["..author.."]|r|h"
                lfmTab:AddMessage("|cFF00FF00[LFM]|r " .. playerLink .. ": " .. msg)
                return true -- Bloquear en el chat general
            end
        end
        orig_ChatFrame_OnEvent(event)
    end
end

-- Inicializar después de cargar variables
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("VARIABLES_LOADED")
initFrame:SetScript("OnEvent", function()
    CreateLFMTab()
    initFrame:UnregisterAllEvents()
end)

-- Comando para mostrar/ocultar
SLASH_LFMMOVER1 = "/lfmmover"
SlashCmdList["LFMMOVER"] = function()
    if lfmTab and lfmTab:IsShown() then
        lfmTab:Hide()
    else
        lfmTab:Show()
    end
end

print("LFMMover cargado. Usa /lfmmover para gestionar la pestaña [LFM].")