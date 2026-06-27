-- ASTRA HUB — МОДУЛЬ ДЛЯ A DESERT
-- Загружается автоматически при входе в игру

print("[ASTRA] Загрузка модуля A Desert...")

-- Ждём, пока загрузится главный каркас
repeat task.wait() until getgenv().AstraHubLoaded

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ============================================
-- ESP ДЛЯ A DESERT
-- ============================================
local espDistance = shared.AstraSettings.ESPDistance or 1000

local function createItemESP(instance, text, icon)
    if instance:FindFirstChild("ESP_Item") then return end
    local gui = Instance.new("BillboardGui")
    gui.Name = "ESP_Item"
    gui.Size = UDim2.new(0, 100, 0, 28)
    gui.StudsOffset = Vector3.new(0, 1.8, 0)
    gui.AlwaysOnTop = true
    gui.Parent = instance

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 15, 45)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame

    local nameTag = Instance.new("TextLabel")
    nameTag.Size = UDim2.new(1, 0, 1, 0)
    nameTag.BackgroundTransparency = 1
    nameTag.Text = icon .. " " .. text
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTag.TextSize = 11
    nameTag.Font = Enum.Font.GothamBold
    nameTag.Parent = frame
end

local function clearESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "ESP_Item" then
            v:Destroy()
        end
    end
end

local function runItemESP()
    task.spawn(function()
        while getgenv().espEnabled do
            task.wait(0.4)
            if not getgenv().espEnabled then break end
            
            local playerPos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not playerPos then continue end
            
            local espCount = 0
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if not getgenv().espEnabled then break end
                if espCount >= 75 then break end
                
                if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
                    local model = obj.Parent
                    local name = string.lower(model.Name)
                    
                    local objPos = obj.Position
                    local distance = (playerPos.Position - objPos).Magnitude
                    if distance > espDistance then continue end
                    
                    if model == LP.Character then continue end
                    
                    local isResource = false
                    local icon = "📦"
                    
                    if string.find(name, "gas") or string.find(name, "fuel") or 
                       string.find(name, "jerry") or string.find(name, "barrel") or 
                       string.find(name, "oil") then
                        isResource = true
                        icon = "⛽"
                    elseif string.find(name, "food") or string.find(name, "can") or 
                       string.find(name, "bandage") or string.find(name, "med") or 
                       string.find(name, "water") then
                        isResource = true
                        icon = "🥫"
                    elseif string.find(name, "wheel") or string.find(name, "tire") then
                        isResource = true
                        icon = "⚙️"
                    elseif string.find(name, "part") or string.find(name, "engine") or 
                       string.find(name, "motor") or string.find(name, "battery") or 
                       string.find(name, "radiator") or string.find(name, "scrap") then
                        isResource = true
                        icon = "🔧"
                    elseif string.find(name, "gun") or string.find(name, "rifle") or 
                       string.find(name, "shotgun") or string.find(name, "weapon") then
                        isResource = true
                        icon = "🔫"
                    end

                    if isResource then
                        createItemESP(model, model.Name, icon)
                        espCount = espCount + 1
                    end
                end
            end
        end
    end)
end

-- ============================================
-- ПОДКЛЮЧАЕМ ФУНКЦИИ К GUI
-- ============================================

-- Находим свитчер Resource ESP в Visuals и подключаем его
local function findToggle()
    local gui = LP.PlayerGui:FindFirstChild("AstraGUI")
    if not gui then return end
    local mainFrame = gui:FindFirstChild("mainFrame")
    if not mainFrame then return end
    local rightPanel = mainFrame:FindFirstChild("rightPanel")
    if not rightPanel then return end
    local visualsContent = rightPanel:FindFirstChild("Visuals")
    if not visualsContent then return end
    
    -- Ищем карточку с Resource ESP
    for _, child in pairs(visualsContent:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("label") then
            local label = child:FindFirstChild("label")
            if label and label.Text == "Resource ESP" then
                local toggle = child:FindFirstChild("toggle")
                if toggle then
                    return toggle
                end
            end
        end
    end
    return nil
end

-- Переопределяем функцию toggleESP, чтобы она работала с нашим ESP
local function toggleESP(state)
    getgenv().espEnabled = state
    if state then
        clearESP()
        getgenv().espThread = task.spawn(runItemESP)
        print("[ASTRA] ESP включён (A Desert)")
    else
        if getgenv().espThread then
            task.cancel(getgenv().espThread)
            getgenv().espThread = nil
        end
        clearESP()
        print("[ASTRA] ESP выключен (A Desert)")
    end
end

-- Автоматически включаем ESP
task.wait(2)
toggleESP(true)
print("[ASTRA] Модуль A Desert загружен! ESP включён.")

-- Даём доступ к функциям для ручного управления
getgenv().toggleAstraESP = toggleESP
