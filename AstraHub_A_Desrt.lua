-- ASTRA HUB — МОДУЛЬ ДЛЯ A DESERT (ДЕТЕКТОР ДВИЖЕНИЯ + ESP)
local Module = {}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ============================================
-- ПРОВЕРКА: ЕСТЬ ЛИ РЯДОМ ХАРАКТЕРНЫЕ ОБЪЕКТЫ
-- ============================================
local function IsDesrtGame()
    if not LP.Character then return false end
    local root = LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local radius = 300
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
            if root.Position:Distance(obj.Position) < radius then
                local name = obj.Name
                if name == "Car" or name == "Zombie" or name == "Crate" or 
                   name == "Radiator" or name == "Engine" or name == "Barrel" then
                    return true
                end
            end
        end
    end
    return false
end

-- ============================================
-- ФУНКЦИИ ESP
-- ============================================
local espEnabled = false
local espDistance = 1000

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
        if v.Name == "ESP_Item" then v:Destroy() end
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
                if espCount >= 35 then break end
                
                if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
                    local model = obj.Parent
                    local name = string.lower(model.Name)
                    
                    local objPos = obj.Position
                    local distance = (playerPos.Position - objPos).Magnitude
                    if distance > getgenv().espDistance then continue end
                    
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

getgenv().toggleESP = toggleESP

-- ============================================
-- АВТО-СБОР
-- ============================================
local autoCollectEnabled = false
local collectThread = nil

local function InteractItem(item)
    if not item then return false end
    local prompt = item:FindFirstChildOfClass("ProximityPrompt") or item:FindFirstChild("ProximityPrompt", true)
    if prompt and prompt.Enabled then
        local name = string.lower(item.Name)
        local action = "tap"
        if string.find(name, "door") then action = "swipe" end
        local heavyItems = {"engine", "radiator", "battery", "tire", "wheel", "fuel", "can", "hood", "fender", "bumper", "barrel"}
        for _, heavy in pairs(heavyItems) do
            if string.find(name, heavy) then action = "hold" break end
        end
        if action == "tap" then fireproximityprompt(prompt, 0) return true
        elseif action == "hold" then fireproximityprompt(prompt, 0.8) return true
        elseif action == "swipe" then
            pcall(function() fireproximityprompt(prompt, 0) task.wait(0.1) fireproximityprompt(prompt, 0) end)
            return true
        end
    end
    return false
end

local function autoCollectLoop()
    collectThread = task.spawn(function()
        while autoCollectEnabled do
            task.wait(0.3)
            local char = LP.Character if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart") if not root then continue end
            for _, obj in pairs(workspace:GetDescendants()) do
                if not autoCollectEnabled then break end
                if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
                    local model = obj.Parent
                    local dist = (root.Position - model:GetPivot().Position).Magnitude
                    if dist <= 5 then
                        if InteractItem(model) then task.wait(0.2) end
                    end
                end
            end
        end
    end)
end

local Events = getgenv().AstraEvents
if Events then
    Events:Connect("AutoCollect", function(state)
        autoCollectEnabled = state
        if state then
            autoCollectLoop()
            print("[ASTRA] Auto Collect: ON (A Desert)")
        else
            if collectThread then
                task.cancel(collectThread)
                collectThread = nil
            end
            print("[ASTRA] Auto Collect: OFF (A Desert)")
        end
    end)
end

-- ============================================
-- СПИД-БУСТ
-- ============================================
local speedBoostEnabled = false

local function ApplySpeedBoost(state)
    speedBoostEnabled = state
    local car = workspace:FindFirstChild("car")
    if not car then return end
    local throttle = car.Values and car.Values:FindFirstChild("Throttle")
    if not throttle then return end
    if state then
        local conn = throttle:GetPropertyChangedSignal("Value"):Connect(function()
            if throttle.Value > 0 then
                throttle.Value = math.clamp(throttle.Value * 2, 0, 1)
            end
        end)
        print("[ASTRA] Speed Boost: ON (A Desert)")
    else
        print("[ASTRA] Speed Boost: OFF (A Desert)")
    end
end

if Events then
    Events:Connect("SpeedBoost", function(state)
        ApplySpeedBoost(state)
    end)
end

-- ============================================
-- ЦИКЛИЧЕСКАЯ ПРОВЕРКА (ОБНАРУЖЕНИЕ ИГРЫ)
-- ============================================
task.spawn(function()
    while true do
        if IsDesrtGame() then
            print("[ASTRA] A Desert обнаружена! Загружаю функции...")
            task.wait(2)
            toggleESP(true)
            break
        end
        task.wait(2)
    end
end)

print("[ASTRA] Модуль A Desert загружен! Ожидаю обнаружения игры...")
