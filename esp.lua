-- ==========================================================
-- BLOX STRIKE ESP (ИСПРАВЛЕННЫЙ + УМНЫЙ ФИЛЬТР)
-- ==========================================================

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local espObjects = {}

-- НАСТРОЙКИ
local settings = {
    Enabled = true,
    BoxColor = Color3.fromRGB(0, 255, 255),
    Thickness = 1.2,
    ShowName = true,
    ShowHealth = true,
    ShowTeam = false,
    Scale = 250
}

-- ===== МИНИ-МЕНЮ =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpaceBerq_ESP_Menu"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
Title.BackgroundTransparency = 0.2
Title.Text = "⚡ ESP Settings"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local CornerTop = Instance.new("UICorner")
CornerTop.Parent = Title
CornerTop.CornerRadius = UDim.new(0, 12)

-- ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ (ИСПРАВЛЕНА!)
local function createToggle(yPos, text, getter, setter)
    local frame = Instance.new("Frame")
    frame.Parent = MainFrame
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    toggleBtn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = toggleBtn
    btnCorner.CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame")
    knob.Parent = toggleBtn
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    knob.BorderSizePixel = 0
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.Parent = knob
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local function updateUI()
        local val = getter()
        toggleBtn.BackgroundColor3 = val and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(80, 80, 90)
        knob.Position = val and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end
    
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(not getter())
            updateUI()
        end
    end)
    updateUI()
end

local function createSlider(yPos, text, getter, setter, min, max)
    local frame = Instance.new("Frame")
    frame.Parent = MainFrame
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.Size = UDim2.new(0.3, 0, 0, 4)
    sliderBg.Position = UDim2.new(1, -45, 0.5, -2)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = sliderBg
    sliderCorner.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Parent = sliderBg
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.Parent = fill
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateSliderFromMouse(input)
        local pos = input.Position
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local percent = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
        local val = min + (max - min) * percent
        setter(val)
        fill.Size = UDim2.new(percent, 0, 1, 0)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSliderFromMouse(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSliderFromMouse(input)
        end
    end)
    
    local initVal = getter()
    local initPercent = (initVal - min) / (max - min)
    fill.Size = UDim2.new(initPercent, 0, 1, 0)
end

-- МЕНЮ НАСТРОЕК (ПОРЯДОК ИСПРАВЛЕН)
createToggle(50, "Enable ESP", function() return settings.Enabled end, function(v) settings.Enabled = v end)
createToggle(90, "Show Teammates", function() return settings.ShowTeam end, function(v) settings.ShowTeam = v end)
createToggle(130, "Show Name", function() return settings.ShowName end, function(v) settings.ShowName = v end)
createToggle(170, "Show Health", function() return settings.ShowHealth end, function(v) settings.ShowHealth = v end)
createSlider(210, "Box Thickness", function() return settings.Thickness end, function(v) settings.Thickness = v end, 0.5, 3)

-- ГОРЯЧАЯ КЛАВИША F4
local hidden = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
        hidden = not hidden
        MainFrame.Visible = not hidden
    end
end)

-- ===== САМ ESP =====
local function createFpsEsp()
    local obj = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBg = Drawing.new("Square")
    }
    obj.Box.Thickness = settings.Thickness
    obj.Box.Color = settings.BoxColor
    obj.Box.Filled = false
    obj.Box.Transparency = 0.6
    
    obj.Name.Size = 14
    obj.Name.Outline = true
    obj.Name.Color = Color3.fromRGB(255, 255, 255)
    obj.Name.Center = true
    
    obj.Health.Size = 12
    obj.Health.Outline = true
    obj.Health.Color = Color3.fromRGB(200, 200, 200)
    obj.Health.Center = true
    
    obj.HealthBg.Size = Vector2.new(40, 4)
    obj.HealthBg.Filled = true
    obj.HealthBg.Color = Color3.fromRGB(30, 30, 30)
    obj.HealthBg.Transparency = 0.3
    
    obj.HealthBar.Size = Vector2.new(40, 4)
    obj.HealthBar.Filled = true
    obj.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    return obj
end

-- УМНАЯ ПРОВЕРКА КОМАНДЫ (работает в любых играх)
local function isEnemy(player)
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not player then return true end
    
    -- 1. Если нет команды вообще (FFA режим), все враги
    if not localPlayer.TeamColor or not player.TeamColor then
        return true
    end
    
    -- 2. Если команды одинаковые, это тиммейт
    if localPlayer.TeamColor == player.TeamColor then
        return false
    end
    
    -- 3. Во всех остальных случаях враг
    return true
end

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            
            if head and torso then
                local isEnemyPlayer = isEnemy(player)
                
                -- Если это тиммейт и мы не хотим их видеть — скрываем
                if not isEnemyPlayer and not settings.ShowTeam then
                    if espObjects[player] then
                        espObjects[player].Box.Visible = false
                        espObjects[player].Name.Visible = false
                        espObjects[player].Health.Visible = false
                        espObjects[player].HealthBar.Visible = false
                        espObjects[player].HealthBg.Visible = false
                    end
                    continue
                end

                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health <= 0 then
                    if espObjects[player] then
                        espObjects[player].Box.Visible = false
                        espObjects[player].Name.Visible = false
                        espObjects[player].Health.Visible = false
                        espObjects[player].HealthBar.Visible = false
                        espObjects[player].HealthBg.Visible = false
                    end
                    continue
                end

                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                local torsoPos, torsoOnScreen = Camera:WorldToViewportPoint(torso.Position)
                
                if headOnScreen and torsoOnScreen then
                    local distance = math.floor((Camera.CFrame.Position - torso.Position).Magnitude)
                    local scale = math.clamp(settings.Scale / distance, 0.3, 2.0)
                    
                    local width = 60 * scale
                    local height = (headPos.Y - torsoPos.Y) + 30 * scale
                    local x = torsoPos.X - (width / 2)
                    local y = headPos.Y - (height / 2) + 20 * scale
                    
                    if not espObjects[player] then
                        espObjects[player] = createFpsEsp()
                    end
                    
                    local obj = espObjects[player]
                    
                    obj.Box.Size = Vector2.new(width, height)
                    obj.Box.Position = Vector2.new(x, y)
                    obj.Box.Thickness = settings.Thickness
                    obj.Box.Color = isEnemyPlayer and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                    obj.Box.Visible = true
                    
                    if settings.ShowName then
                        obj.Name.Text = player.Name
                        obj.Name.Position = Vector2.new(torsoPos.X, headPos.Y - (height/2) - 30 * scale)
                        obj.Name.Visible = true
                    else
                        obj.Name.Visible = false
                    end
                    
                    if settings.ShowHealth then
                        local hpText = "Alive"
                        if humanoid then
                            hpText = tostring(math.floor(humanoid.Health)) .. " HP"
                        end
                        obj.Health.Text = hpText
                        obj.Health.Position = Vector2.new(torsoPos.X, torsoPos.Y + 20 * scale)
                        obj.Health.Visible = true
                    else
                        obj.Health.Visible = false
                    end
                    
                    if settings.ShowHealth and humanoid then
                        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local barY = y + height + 10
                        obj.HealthBg.Position = Vector2.new(x + 10, barY)
                        obj.HealthBg.Visible = true
                        
                        obj.HealthBar.Size = Vector2.new(40 * healthPercent, 4)
                        obj.HealthBar.Position = Vector2.new(x + 10, barY)
                        obj.HealthBar.Color = Color3.fromRGB(math.floor(255 * (1 - healthPercent)), math.floor(255 * healthPercent), 0)
                        obj.HealthBar.Visible = true
                    else
                        obj.HealthBg.Visible = false
                        obj.HealthBar.Visible = false
                    end
                else
                    if espObjects[player] then
                        espObjects[player].Box.Visible = false
                        espObjects[player].Name.Visible = false
                        espObjects[player].Health.Visible = false
                        espObjects[player].HealthBar.Visible = false
                        espObjects[player].HealthBg.Visible = false
                    end
                end
            end
        end
    end
    
    for player, obj in pairs(espObjects) do
        if not Players:FindFirstChild(player.Name) then
            obj.Box:Remove()
            obj.Name:Remove()
            obj.Health:Remove()
            obj.HealthBar:Remove()
            obj.HealthBg:Remove()
            espObjects[player] = nil
        end
    end
end)

print("✅ SpaceBerq ESP (Умный) загружен! F4 - меню.")
