-- ==========================================================
-- BLOX STRIKE ESP + КРАСИВЫЙ ГУИ (ПОЛНАЯ ВЕРСИЯ)
-- ==========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local espObjects = {}
local espActive = false
local renderConnection = nil

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = {
    Enabled = false,
    ShowTeam = false,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    BoxThickness = 1.5,
    BoxColor = "Red", -- Red, Green, Blue, Purple, Yellow
    Transparency = 0.4
}

-- ============================================
-- ЦВЕТА ДЛЯ БОКСОВ
-- ============================================
local BoxColors = {
    Red = Color3.fromRGB(255, 50, 50),
    Green = Color3.fromRGB(50, 255, 50),
    Blue = Color3.fromRGB(50, 150, 255),
    Purple = Color3.fromRGB(180, 50, 255),
    Yellow = Color3.fromRGB(255, 255, 50)
}

-- ============================================
-- ФУНКЦИЯ ОЧИСТКИ ESP
-- ============================================
local function ClearESP()
    for player, obj in pairs(espObjects) do
        pcall(function()
            obj.Box:Remove()
            obj.Name:Remove()
            obj.Health:Remove()
            obj.Distance:Remove()
            obj.HealthBar:Remove()
            obj.HealthBg:Remove()
        end)
    end
    espObjects = {}
end

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ ОБЪЕКТОВ ESP
-- ============================================
local function CreateESPObject()
    return {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBg = Drawing.new("Square")
    }
end

-- ============================================
-- ФУНКЦИЯ ЗАПУСКА ESP
-- ============================================
local function StartESP()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    ClearESP()
    espActive = true
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if not settings.Enabled then
            ClearESP()
            return
        end
        
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
            
            -- ПРОВЕРКА ЖИЗНИ
            if humanoid.Health <= 0 then
                if espObjects[player] then
                    local obj = espObjects[player]
                    obj.Box.Visible = false
                    obj.Name.Visible = false
                    obj.Health.Visible = false
                    obj.Distance.Visible = false
                    obj.HealthBar.Visible = false
                    obj.HealthBg.Visible = false
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
                end
                continue
            end
            
            -- ПРОЕКЦИЯ
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
                end
                continue
            end
            
            -- СОЗДАЕМ ОБЪЕКТ
            if not espObjects[player] then
                espObjects[player] = CreateESPObject()
            end
            
            local obj = espObjects[player]
            local distance = math.floor((Camera.CFrame.Position - torso.Position).Magnitude)
            local scale = math.clamp(450 / distance, 0.4, 2.0)
            
            -- РАЗМЕРЫ
            local width = 55 * scale
            local height = (math.abs(headPos.Y - torsoPos.Y)) + 15 * scale
            local x = torsoPos.X - (width / 2)
            local y = headPos.Y - (height / 2) - 5 * scale
            
            -- ЦВЕТА
            local boxColor
            if isTeammate then
                boxColor = Color3.fromRGB(0, 255, 0)
            else
                boxColor = BoxColors[settings.BoxColor] or BoxColors.Red
            end
            
            -- БОКС
            obj.Box.Size = Vector2.new(width, height)
            obj.Box.Position = Vector2.new(x, y)
            obj.Box.Thickness = settings.BoxThickness
            obj.Box.Color = boxColor
            obj.Box.Filled = false
            obj.Box.Transparency = settings.Transparency
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
        end
        
        -- ОЧИСТКА ВЫШЕДШИХ
        for player, obj in pairs(espObjects) do
            if not Players:FindFirstChild(player.Name) then
                pcall(function()
                    obj.Box:Remove()
                    obj.Name:Remove()
                    obj.Health:Remove()
                    obj.Distance:Remove()
                    obj.HealthBar:Remove()
                    obj.HealthBg:Remove()
                end)
                espObjects[player] = nil
            end
        end
    end)
end

-- ============================================
-- ФУНКЦИЯ ОСТАНОВКИ ESP
-- ============================================
local function StopESP()
    espActive = false
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    ClearESP()
end

-- ============================================
-- ФУНКЦИЯ ПЕРЕКЛЮЧЕНИЯ ESP
-- ============================================
local function ToggleESP(state)
    settings.Enabled = state
    if state then
        StartESP()
    else
        StopESP()
    end
end

-- ============================================
-- СОЗДАНИЕ ГУИ
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxStrike_ESP"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true

-- ============================================
-- ОСНОВНОЙ ФРЕЙМ
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- ОБВОДКА
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(138, 43, 226)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.Parent = MainFrame

-- ============================================
-- ЗАГОЛОВОК
-- ============================================
local Title = Instance.new("Frame")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
Title.BackgroundTransparency = 0.2
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = Title

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "✦ BloxStrike ESP"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = Title

-- КНОПКА ЗАКРЫТИЯ (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, 0)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- DRAGGABLE (ПЕРЕТАСКИВАНИЕ)
-- ============================================
local dragging = false
local dragInput, mousePos, framePos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale, framePos.X.Offset + delta.X,
            framePos.Y.Scale, framePos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- СКРОЛЛИНГ ДЛЯ НАСТРОЕК
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -12, 1, -52)
ScrollFrame.Position = UDim2.new(0, 6, 0, 46)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
ScrollFrame.ScrollBarImageTransparency = 0.2
ScrollFrame.Parent = MainFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 6)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Parent = ScrollFrame

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ КАРТОЧКИ-СВИТЧА
-- ============================================
local function CreateToggle(parent, text, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 8)
    fCorner.Parent = frame
    
    -- HOVER ЭФФЕКТ
    frame.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.05
        }):Play()
    end)
    frame.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.2
        }):Play()
    end)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 44, 0, 24)
    toggleBtn.Position = UDim2.new(1, -12, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    
    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob
    
    local function UpdateUI()
        local val = getter()
        toggleBtn.BackgroundColor3 = val and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 75)
        knob.Position = val and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    end
    
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(not getter())
            UpdateUI()
        end
    end)
    
    UpdateUI()
    return frame
end

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ ДРОПДАУНА
-- ============================================
local function CreateDropdown(parent, text, options, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 8)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0, 80, 0, 28)
    dropdownBtn.Position = UDim2.new(1, -90, 0.5, -14)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = getter()
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextSize = 12
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Parent = frame
    
    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(0, 6)
    dCorner.Parent = dropdownBtn
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(180, 180, 200)
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.Parent = dropdownBtn
    
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0, 80, 0, 0)
    listFrame.Position = UDim2.new(1, -90, 0, 36)
    listFrame.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.Parent = frame
    
    local lCorner = Instance.new("UICorner")
    lCorner.CornerRadius = UDim.new(0, 6)
    lCorner.Parent = listFrame
    
    local isOpen = false
    local itemHeight = 0
    
    for _, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
        btn.BorderSizePixel = 0
        btn.Text = option
        btn.TextColor3 = Color3.fromRGB(220, 220, 230)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.Parent = listFrame
        itemHeight = itemHeight + 26
        
        btn.MouseButton1Click:Connect(function()
            setter(option)
            dropdownBtn.Text = option
            isOpen = false
            listFrame.Size = UDim2.new(0, 80, 0, 0)
            frame.Size = UDim2.new(1, -10, 0, 36)
            arrow.Text = "▼"
        end)
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            listFrame.Size = UDim2.new(0, 80, 0, itemHeight)
            frame.Size = UDim2.new(1, -10, 0, 36 + itemHeight)
            arrow.Text = "▲"
        else
            listFrame.Size = UDim2.new(0, 80, 0, 0)
            frame.Size = UDim2.new(1, -10, 0, 36)
            arrow.Text = "▼"
        end
    end)
    
    return frame
end

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА
-- ============================================
local function CreateSlider(parent, text, getter, setter, min, max)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 8)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0.5, 0)
    label.Position = UDim2.new(0, 14, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    valLabel.Position = UDim2.new(0.7, 0, 0, 2)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(getter())
    valLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    valLabel.TextSize = 13
    valLabel.Font = Enum.Font.Gotham
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.85, 0, 0, 4)
    sliderBg.Position = UDim2.new(0.075, 0, 0.75, 0)
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
    
    local fCorner2 = Instance.new("UICorner")
    fCorner2.CornerRadius = UDim.new(1, 0)
    fCorner2.Parent = fill
    
    local dragging2 = false
    
    local function UpdateSlider(input)
        local pos = input.Position
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local percent = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
        local val = min + (max - min) * percent
        setter(math.round(val * 10) / 10)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valLabel.Text = tostring(getter())
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging2 = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging2 = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    local initVal = getter()
    local initPercent = (initVal - min) / (max - min)
    fill.Size = UDim2.new(initPercent, 0, 1, 0)
    valLabel.Text = tostring(initVal)
    
    return frame
end

-- ============================================
-- СОЗДАЕМ НАСТРОЙКИ
-- ============================================
-- Основные настройки
CreateToggle(ScrollFrame, "Enable ESP", 
    function() return settings.Enabled end, 
    function(v) ToggleESP(v) end
)

CreateToggle(ScrollFrame, "Show Teammates", 
    function() return settings.ShowTeam end, 
    function(v) settings.ShowTeam = v end
)

-- Разделитель
local sep = Instance.new("Frame")
sep.Size = UDim2.new(0.9, 0, 0, 1)
sep.Position = UDim2.new(0.05, 0, 0, 0)
sep.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sep.BackgroundTransparency = 0.5
sep.BorderSizePixel = 0
sep.Parent = ScrollFrame

-- Отображение
CreateToggle(ScrollFrame, "Show Name", 
    function() return settings.ShowName end, 
    function(v) settings.ShowName = v end
)

CreateToggle(ScrollFrame, "Show Health", 
    function() return settings.ShowHealth end, 
    function(v) settings.ShowHealth = v end
)

CreateToggle(ScrollFrame, "Show Distance", 
    function() return settings.ShowDistance end, 
    function(v) settings.ShowDistance = v end
)

-- Разделитель
local sep2 = Instance.new("Frame")
sep2.Size = UDim2.new(0.9, 0, 0, 1)
sep2.Position = UDim2.new(0.05, 0, 0, 0)
sep2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sep2.BackgroundTransparency = 0.5
sep2.BorderSizePixel = 0
sep2.Parent = ScrollFrame

-- Внешний вид
CreateSlider(ScrollFrame, "Box Thickness", 
    function() return settings.BoxThickness end, 
    function(v) settings.BoxThickness = v end, 
    0.5, 3
)

CreateSlider(ScrollFrame, "Transparency", 
    function() return settings.Transparency end, 
    function(v) settings.Transparency = v end, 
    0.1, 0.8
)

CreateDropdown(ScrollFrame, "Box Color", {"Red", "Green", "Blue", "Purple", "Yellow"},
    function() return settings.BoxColor end,
    function(v) settings.BoxColor = v end
)

-- ОБНОВЛЕНИЕ CANVAS
task.wait(0.1)
local height = 0
for _, child in pairs(ScrollFrame:GetChildren()) do
    if child:IsA("Frame") then
        height = height + child.Size.Y.Offset + 6
    end
end
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, height + 10)

-- ============================================
-- F4 ДЛЯ ОТКРЫТИЯ/ЗАКРЫТИЯ
-- ============================================
local menuHidden = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
        menuHidden = not menuHidden
        MainFrame.Visible = not menuHidden
    end
end)

print("✅ BloxStrike ESP загружен! F4 - открыть/закрыть меню.")
