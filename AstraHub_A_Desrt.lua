-- ASTRA HUB — МОДУЛЬ ДЛЯ A DESERT (ESP + HUD)
print("[ASTRA] Загрузка модуля A Desert...")

repeat task.wait() until getgenv().AstraHubLoaded

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ============================================
-- ESP ДЛЯ A DESERT
-- ============================================

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
            local espDistance = getgenv().espDistance or 1000
            
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
-- HUD ДЛЯ МАШИНЫ
-- ============================================
local CarHud = nil

local function CreateCarHUD()
    if CarHud then
        CarHud:Destroy()
        CarHud = nil
        return
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CarHUD"
    screenGui.Parent = LP:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 150, 0, 150)
    mainFrame.Position = UDim2.new(0.03, 0, 0.5, -75)
    mainFrame.AnchorPoint = Vector2.new(0, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.5
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(138, 43, 226)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 0, 30)
    speedLabel.Position = UDim2.new(0, 0, 0, 10)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0 km/h"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 20
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.Parent = mainFrame

    local fuelLabel = Instance.new("TextLabel")
    fuelLabel.Size = UDim2.new(1, 0, 0, 20)
    fuelLabel.Position = UDim2.new(0, 0, 0, 50)
    fuelLabel.BackgroundTransparency = 1
    fuelLabel.Text = "Fuel: 100%"
    fuelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fuelLabel.TextSize = 14
    fuelLabel.Font = Enum.Font.Gotham
    fuelLabel.TextXAlignment = Enum.TextXAlignment.Center
    fuelLabel.Parent = mainFrame

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 20)
    healthLabel.Position = UDim2.new(0, 0, 0, 75)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "HP: 100%"
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthLabel.TextSize = 14
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextXAlignment = Enum.TextXAlignment.Center
    healthLabel.Parent = mainFrame

    local boostLabel = Instance.new("TextLabel")
    boostLabel.Size = UDim2.new(1, 0, 0, 20)
    boostLabel.Position = UDim2.new(0, 0, 0, 100)
    boostLabel.BackgroundTransparency = 1
    boostLabel.Text = "Boost: OFF"
    boostLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    boostLabel.TextSize = 14
    boostLabel.Font = Enum.Font.Gotham
    boostLabel.TextXAlignment = Enum.TextXAlignment.Center
    boostLabel.Parent = mainFrame

    CarHud = {
        ScreenGui = screenGui,
        Frame = mainFrame,
        SpeedLabel = speedLabel,
        FuelLabel = fuelLabel,
        HealthLabel = healthLabel,
        BoostLabel = boostLabel
    }
end

-- ============================================
-- ОБНОВЛЕНИЕ HUD
-- ============================================
local function UpdateCarHUD()
    task.spawn(function()
        while CarHud do
            task.wait(0.1)
            if not getgenv().hudEnabled then break end
            
            -- Здесь будет логика получения данных из игры
            -- Пример:
            local speed = 0
            local fuel = 100
            local health = 100
            
            CarHud.SpeedLabel.Text = math.floor(speed) .. " km/h"
            CarHud.FuelLabel.Text = "Fuel: " .. math.floor(fuel) .. "%"
            CarHud.HealthLabel.Text = "HP: " .. math.floor(health) .. "%"
        end
    end)
end

-- ============================================
-- АВТО-ЗАПУСК
-- ============================================
task.wait(2)

-- Включаем ESP
getgenv().espEnabled = true
clearESP()
getgenv().espThread = task.spawn(runItemESP)

-- Создаём и включаем HUD
CreateCarHUD()
getgenv().hudEnabled = true
UpdateCarHUD()

print("[ASTRA] Модуль A Desert загружен! ESP и HUD включены.")
