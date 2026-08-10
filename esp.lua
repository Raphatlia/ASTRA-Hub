-- ==========================================================
-- BLOX STRIKE ESP (ПОЛНОСТЬЮ РАБОЧИЙ)
-- ==========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer
local espObjects = {}

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = {
    Enabled = true,
    ShowTeam = false,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    BoxThickness = 1.5
}

-- ============================================
-- СОЗДАНИЕ GUI МЕНЮ (F4)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxStrike_ESP"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
Title.BackgroundTransparency = 0.2
Title.Text = "✦ BloxStrike ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ СВИТЧА
-- ============================================
local function CreateToggle(parent, yPos, text, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    
    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob
    
    local function UpdateUI()
        local val = getter()
        toggleBtn.BackgroundColor3 = val and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 75)
        knob.Position = val and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end
    
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(not getter())
            UpdateUI()
        end
    end)
    
    UpdateUI()
end

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА
-- ============================================
local function CreateSlider(parent, yPos, text, getter, setter, min, max)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.35, 0, 0, 4)
    sliderBg.Position = UDim2.new(0.65, 0, 0.5, -2)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = fill
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.1, 0, 1, 0)
    valLabel.Position = UDim2.new(0.9, 0, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(getter())
    valLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    valLabel.TextSize = 11
    valLabel.Font = Enum.Font.Gotham
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = frame
    
    local dragging = false
    
    local function UpdateSlider(input)
        local pos = input.Position
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local percent = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
        local val = min + (max - min) * percent
        setter(val)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valLabel.Text = string.format("%.1f", val)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    local initVal = getter()
    local initPercent = (initVal - min) / (max - min)
    fill.Size = UDim2.new(initPercent, 0, 1, 0)
    valLabel.Text = string.format("%.1f", initVal)
end

-- ============================================
-- СОЗДАЕМ МЕНЮ
-- ============================================
CreateToggle(MainFrame, 45, "Enable ESP", function() return settings.Enabled end, function(v) settings.Enabled = v end)
CreateToggle(MainFrame, 80, "Show Teammates", function() return settings.ShowTeam end, function(v) settings.ShowTeam = v end)
CreateToggle(MainFrame, 115, "Show Name", function() return settings.ShowName end, function(v) settings.ShowName = v end)
CreateToggle(MainFrame, 150, "Show Health", function() return settings.ShowHealth end, function(v) settings.ShowHealth = v end)
CreateToggle(MainFrame, 185, "Show Distance", function() return settings.ShowDistance end, function(v) settings.ShowDistance = v end)
CreateSlider(MainFrame, 220, "Box Thickness", function() return settings.BoxThickness end, function(v) settings.BoxThickness = v, 0.5, 3)

-- F4 для скрытия меню
local menuHidden = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
        menuHidden = not menuHidden
        MainFrame.Visible = not menuHidden
    end
end)

-- ============================================
-- ОСНОВНАЯ ЛОГИКА ESP
-- ============================================
local function CreateESPObject()
    return {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBg = Drawing.new("Square"),
        Visible = false
    }
end

-- ============================================
-- ОБНОВЛЕНИЕ ESP
-- ============================================
RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    if not LP or not LP.Character then return end
    
    local myTeam = LP.TeamColor
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LP then continue end
        if not player.Character then continue end
        
        local char = player.Character
        local head = char:FindFirstChild("Head")
        local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        local humanoid = char:FindFirstChild("Humanoid")
        
        if not head or not torso or not humanoid then continue end
        
        -- ПРОВЕРКА: ЖИВ ЛИ ИГРОК
        if humanoid.Health <= 0 then
            if espObjects[player] then
                local obj = espObjects[player]
                obj.Box.Visible = false
                obj.Name.Visible = false
                obj.Health.Visible = false
                obj.Distance.Visible = false
                obj.HealthBar.Visible = false
                obj.HealthBg.Visible = false
                obj.Visible = false
            end
            continue
        end
        
        -- ОПРЕДЕЛЕНИЕ КОМАНДЫ
        local isTeammate = false
        if myTeam and player.TeamColor then
            isTeammate = (myTeam == player.TeamColor)
        end
        
        -- ЕСЛИ ТИММЕЙТ И SHOWTEAM ВЫКЛЮЧЕН - СКРЫВАЕМ
        if isTeammate and not settings.ShowTeam then
            if espObjects[player] then
                local obj = espObjects[player]
                obj.Box.Visible = false
                obj.Name.Visible = false
                obj.Health.Visible = false
                obj.Distance.Visible = false
                obj.HealthBar.Visible = false
                obj.HealthBg.Visible = false
                obj.Visible = false
            end
            continue
        end
        
        -- ПРОЕКЦИЯ НА ЭКРАН
        local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
        local torsoPos, torsoOnScreen = Camera:WorldToViewportPoint(torso.Position)
        
        if not headOnScreen or not torsoOnScreen then
            if espObjects[player] then
                local obj = espObjects[player]
                obj.Box.Visible = false
                obj.Name.Visible = false
                obj.Health.Visible = false
                obj.Distance.Visible = false
                obj.HealthBar.Visible = false
                obj.HealthBg.Visible = false
                obj.Visible = false
            end
            continue
        end
        
        -- СОЗДАЕМ ОБЪЕКТ ЕСЛИ НЕТ
        if not espObjects[player] then
            espObjects[player] = CreateESPObject()
        end
        
        local obj = espObjects[player]
        local distance = math.floor((Camera.CFrame.Position - torso.Position).Magnitude)
        local scale = math.clamp(450 / distance, 0.4, 2.0)
        
        -- РАЗМЕРЫ БОКСА
        local width = 55 * scale
        local height = (math.abs(headPos.Y - torsoPos.Y)) + 15 * scale
        local x = torsoPos.X - (width / 2)
        local y = headPos.Y - (height / 2) - 5 * scale
        
        -- ЦВЕТА
        local boxColor = isTeammate and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
        
        -- БОКС
        obj.Box.Size = Vector2.new(width, height)
        obj.Box.Position = Vector2.new(x, y)
        obj.Box.Thickness = settings.BoxThickness
        obj.Box.Color = boxColor
        obj.Box.Filled = false
        obj.Box.Transparency = 0.4
        obj.Box.Visible = true
        
        -- ИМЯ
        if settings.ShowName then
            obj.Name.Text = player.Name
            obj.Name.Position = Vector2.new(torsoPos.X, headPos.Y - (height/2) - 25 * scale)
            obj.Name.Color = Color3.fromRGB(255, 255, 255)
            obj.Name.Size = 13
            obj.Name.Center = true
            obj.Name.Outline = true
            obj.Name.Visible = true
        else
            obj.Name.Visible = false
        end
        
        -- ДИСТАНЦИЯ
        if settings.ShowDistance then
            obj.Distance.Text = distance .. "m"
            obj.Distance.Position = Vector2.new(torsoPos.X, headPos.Y + (height/2) + 10 * scale)
            obj.Distance.Color = Color3.fromRGB(200, 200, 210)
            obj.Distance.Size = 11
            obj.Distance.Center = true
            obj.Distance.Outline = true
            obj.Distance.Visible = true
        else
            obj.Distance.Visible = false
        end
        
        -- ХП ТЕКСТ
        if settings.ShowHealth then
            local hp = math.floor(humanoid.Health)
            local maxHp = math.floor(humanoid.MaxHealth)
            obj.Health.Text = hp .. "/" .. maxHp .. " HP"
            obj.Health.Position = Vector2.new(torsoPos.X, torsoPos.Y + 20 * scale)
            obj.Health.Color = Color3.fromRGB(200, 200, 210)
            obj.Health.Size = 11
            obj.Health.Center = true
            obj.Health.Outline = true
            obj.Health.Visible = true
        else
            obj.Health.Visible = false
        end
        
        -- ПОЛОСКА ХП
        if settings.ShowHealth then
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            local barY = y + height + 8 * scale
            local barWidth = width - 10
            local barHeight = 4 * scale
            
            obj.HealthBg.Size = Vector2.new(barWidth, barHeight)
            obj.HealthBg.Position = Vector2.new(x + 5, barY)
            obj.HealthBg.Color = Color3.fromRGB(30, 30, 40)
            obj.HealthBg.Filled = true
            obj.HealthBg.Transparency = 0.3
            obj.HealthBg.Visible = true
            
            obj.HealthBar.Size = Vector2.new(barWidth * healthPercent, barHeight)
            obj.HealthBar.Position = Vector2.new(x + 5, barY)
            obj.HealthBar.Color = Color3.fromRGB(
                math.floor(255 * (1 - healthPercent)),
                math.floor(255 * healthPercent),
                0
            )
            obj.HealthBar.Filled = true
            obj.HealthBar.Transparency = 0.1
            obj.HealthBar.Visible = true
        else
            obj.HealthBg.Visible = false
            obj.HealthBar.Visible = false
        end
        
        obj.Visible = true
    end
    
    -- ОЧИСТКА ВЫШЕДШИХ ИГРОКОВ
    for player, obj in pairs(espObjects) do
        if not Players:FindFirstChild(player.Name) then
            obj.Box:Remove()
            obj.Name:Remove()
            obj.Health:Remove()
            obj.Distance:Remove()
            obj.HealthBar:Remove()
            obj.HealthBg:Remove()
            espObjects[player] = nil
        end
    end
end)

print("✅ BloxStrike ESP загружен! F4 - меню.")
