-- ASTRA HUB — МОДУЛЬ ДЛЯ A LONG ROAD
print("[ASTRA] Загрузка модуля A Long Road...")

repeat task.wait() until getgenv().AstraHubLoaded

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ============================================
-- ESP ДЛЯ A LONG ROAD
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
                    
                    -- Свой список для A Long Road
                    if string.find(name, "gas") or string.find(name, "fuel") or 
                       string.find(name, "canister") or string.find(name, "barrel") then
                        isResource = true
                        icon = "⛽"
                    elseif string.find(name, "food") or string.find(name, "can") or 
                       string.find(name, "bandage") or string.find(name, "med") then
                        isResource = true
                        icon = "🥫"
                    elseif string.find(name, "wheel") or string.find(name, "tire") then
                        isResource = true
                        icon = "⚙️"
                    elseif string.find(name, "part") or string.find(name, "engine") or 
                       string.find(name, "battery") or string.find(name, "radiator") then
                        isResource = true
                        icon = "🔧"
                    elseif string.find(name, "gun") or string.find(name, "weapon") then
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

-- Включаем ESP
task.wait(2)
getgenv().espEnabled = true
clearESP()
getgenv().espThread = task.spawn(runItemESP)

print("[ASTRA] Модуль A Long Road загружен! ESP включён.")
