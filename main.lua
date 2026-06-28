--- ASTRA HUB V2.0 — С РАЗМЫТИЕМ (ИСПРАВЛЕННЫЙ БЛЮР)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = {
    Theme = "Astral",
    Transparent = false,
    ESPDistance = 1000,
    AutoCollect = false,
    SpeedBoost = false,
}

local themeColorsList = {
    Astral = Color3.fromRGB(25, 15, 45),
    Blood = Color3.fromRGB(60, 15, 20),
    Ocean = Color3.fromRGB(10, 25, 50),
}

-- ============================================
-- РАЗМЫТИЕ ФОНА (BLUR) — ПРАВИЛЬНО
-- ============================================
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

local function setBlur(size)
    TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = size
    }):Play()
end

-- ============================================
-- ПЕРЕМЕННЫЕ ДЛЯ АНИМАЦИИ
-- ============================================
local isOpen = false
local mainFrame = nil
local floatingBtn = nil

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА
-- ============================================
floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 180, 0, 46)
floatingBtn.Position = UDim2.new(0.5, -90, 0.05, 0)
floatingBtn.AnchorPoint = Vector2.new(0.5, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
floatingBtn.BackgroundTransparency = 0.1
floatingBtn.BorderSizePixel = 2
floatingBtn.BorderColor3 = Color3.fromRGB(138, 43, 226)
floatingBtn.Text = "Open Script"
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.TextSize = 16
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.TextXAlignment = Enum.TextXAlignment.Center
floatingBtn.Visible = true
floatingBtn.Active = true
floatingBtn.Selectable = true
floatingBtn.ZIndex = 100
floatingBtn.Parent = ScreenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

-- ============================================
-- ФУНКЦИИ ОТКРЫТИЯ/ЗАКРЫТИЯ
-- ============================================
local function openMenu()
    if not mainFrame then return end
    isOpen = true
    floatingBtn.Visible = false
    mainFrame.Visible = true
    
    -- Включаем размытие
    setBlur(8)
    
    -- Анимация появления
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local openTween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 380, 0, 320),
        BackgroundTransparency = settings.Transparent and 0.2 or 0.1
    })
    openTween:Play()
end

local function closeMenu()
    if not mainFrame then return end
    isOpen = false
    
    -- Анимация закрытия
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local closeTween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()
    closeTween.Completed:Wait()
    
    mainFrame.Visible = false
    floatingBtn.Visible = true
    
    -- ВЫКЛЮЧАЕМ РАЗМЫТИЕ
    setBlur(0)
end

-- Горячая клавиша RightShift
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then
            closeMenu()
        else
            openMenu()
        end
    end
end)

floatingBtn.MouseButton1Click:Connect(openMenu)
floatingBtn.TouchTap:Connect(openMenu)

-- ============================================
-- ОСНОВНОЕ ОКНО
-- ============================================
mainFrame = Instance.new("Frame")
mainFrame.Name = "mainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = themeColorsList[settings.Theme]
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- ============================================
-- ШАПКА
-- ============================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ASTRA HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local versionTag = Instance.new("Frame")
versionTag.Size = UDim2.new(0, 48, 0, 22)
versionTag.Position = UDim2.new(0, 120, 0.5, 0)
versionTag.AnchorPoint = Vector2.new(0, 0.5)
versionTag.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
versionTag.BorderSizePixel = 1
versionTag.BorderColor3 = Color3.fromRGB(255, 255, 255)
versionTag.Parent = header
local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(0, 4)
versionCorner.Parent = versionTag
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 1, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "V2.0"
versionText.TextColor3 = Color3.fromRGB(255, 255, 255)
versionText.TextSize = 11
versionText.Font = Enum.Font.GothamBold
versionText.Parent = versionTag

-- ============================================
-- MACOS КНОПКИ
-- ============================================
local btnRed = Instance.new("TextButton")
btnRed.Size = UDim2.new(0, 12, 0, 12)
btnRed.Position = UDim2.new(1, -55, 0.5, 0)
btnRed.AnchorPoint = Vector2.new(0, 0.5)
btnRed.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
btnRed.BorderSizePixel = 0
btnRed.Text = ""
btnRed.Parent = header
local btnRedCorner = Instance.new("UICorner")
btnRedCorner.CornerRadius = UDim.new(1, 0)
btnRedCorner.Parent = btnRed
btnRed.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local btnYellow = Instance.new("TextButton")
btnYellow.Size = UDim2.new(0, 12, 0, 12)
btnYellow.Position = UDim2.new(1, -37, 0.5, 0)
btnYellow.AnchorPoint = Vector2.new(0, 0.5)
btnYellow.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
btnYellow.BorderSizePixel = 0
btnYellow.Text = ""
btnYellow.Parent = header
local btnYellowCorner = Instance.new("UICorner")
btnYellowCorner.CornerRadius = UDim.new(1, 0)
btnYellowCorner.Parent = btnYellow
btnYellow.MouseButton1Click:Connect(function()
    closeMenu()
end)

local btnGreen = Instance.new("TextButton")
btnGreen.Size = UDim2.new(0, 12, 0, 12)
btnGreen.Position = UDim2.new(1, -19, 0.5, 0)
btnGreen.AnchorPoint = Vector2.new(0, 0.5)
btnGreen.BackgroundColor3 = Color3.fromRGB(50, 215, 75)
btnGreen.BorderSizePixel = 0
btnGreen.Text = ""
btnGreen.Parent = header
local btnGreenCorner = Instance.new("UICorner")
btnGreenCorner.CornerRadius = UDim.new(1, 0)
btnGreenCorner.Parent = btnGreen
btnGreen.MouseButton1Click:Connect(function()
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end)

-- ============================================
-- ПЕРЕТАСКИВАНИЕ МЕНЮ
-- ============================================
local dragging = false
local dragInput, mousePos, framePos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- ============================================
-- ЛЕВАЯ ПАНЕЛЬ
-- ============================================
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 100, 1, -44)
leftPanel.Position = UDim2.new(0, 0, 0, 44)
leftPanel.BackgroundTransparency = 1
leftPanel.BorderSizePixel = 0
leftPanel.ClipsDescendants = true
leftPanel.Parent = mainFrame

local btnData = {"Features", "Settings", "Visuals"}
local btnObjects = {}
for i = 1, #btnData do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, 10 + (i-1) * 36)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = btnData[i]
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = leftPanel
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btnObjects[i] = btn
end

-- ============================================
-- ПРАВАЯ ПАНЕЛЬ
-- ============================================
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -110, 1, -44)
rightPanel.Position = UDim2.new(0, 105, 0, 44)
rightPanel.BackgroundTransparency = 1
rightPanel.BorderSizePixel = 0
rightPanel.Parent = mainFrame

local contents = {}
for i = 1, #btnData do
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.ScrollBarThickness = 3
    f.ScrollBarImageColor3 = Color3.fromRGB(80, 40, 140)
    f.Visible = (i == 1)
    f.Parent = rightPanel
    contents[i] = f
end

-- ============================================
-- КАРТОЧКИ
-- ============================================
local function createAeroCard(parent, title, yPos, defaultOn, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -12, 0, 54)
    card.Position = UDim2.new(0, 6, 0, yPos)
    card.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 50, 0, 28)
    toggle.Position = UDim2.new(1, -14, 0.5, 0)
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 75)
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Parent = card
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 22, 0, 22)
    circle.Position = defaultOn and UDim2.new(1, -25, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    circle.AnchorPoint = Vector2.new(0, 0.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.05
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local isOn = defaultOn or false
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isOn = not isOn
            if isOn then
                toggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
                circle.Position = UDim2.new(1, -25, 0.5, 0)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                circle.Position = UDim2.new(0, 3, 0.5, 0)
            end
            if callback then callback(isOn) end
        end
    end)
end

-- ============================================
-- FEATURES
-- ============================================
local featuresContent = contents[1]
featuresContent.CanvasSize = UDim2.new(0, 0, 0, 280)

local fLabel = Instance.new("TextLabel")
fLabel.Size = UDim2.new(1, 0, 0, 35)
fLabel.Position = UDim2.new(0, 0, 0, 5)
fLabel.BackgroundTransparency = 1
fLabel.Text = "Features"
fLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fLabel.TextSize = 16
fLabel.Font = Enum.Font.GothamBold
fLabel.TextXAlignment = Enum.TextXAlignment.Center
fLabel.Parent = featuresContent

-- АВТО-СБОР
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

createAeroCard(featuresContent, "Auto Collect", 50, false, function(state)
    autoCollectEnabled = state
    if state then autoCollectLoop() print("[ASTRA] Auto Collect: ON")
    else if collectThread then task.cancel(collectThread) collectThread = nil end print("[ASTRA] Auto Collect: OFF") end
end)

-- СПИД-БУСТ
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
        print("[ASTRA] Speed Boost: ON")
    else
        print("[ASTRA] Speed Boost: OFF")
    end
end

createAeroCard(featuresContent, "Speed Boost", 110, false, function(state)
    ApplySpeedBoost(state)
end)

createAeroCard(featuresContent, "Fast Attack", 170, false, function(state)
    print("[ASTRA] Fast Attack: " .. (state and "ON" or "OFF"))
end)

-- ============================================
-- SETTINGS
-- ============================================
local settingsContent = contents[2]
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 220)

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, 0, 0, 35)
settingsLabel.Position = UDim2.new(0, 0, 0, 5)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "Settings"
settingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsLabel.TextSize = 16
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.TextXAlignment = Enum.TextXAlignment.Center
settingsLabel.Parent = settingsContent

-- TRANSPARENCY
local transCard = Instance.new("Frame")
transCard.Size = UDim2.new(1, -12, 0, 54)
transCard.Position = UDim2.new(0, 6, 0, 50)
transCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
transCard.BackgroundTransparency = 0.3
transCard.BorderSizePixel = 0
transCard.Parent = settingsContent
local transCardCorner = Instance.new("UICorner")
transCardCorner.CornerRadius = UDim.new(0, 10)
transCardCorner.Parent = transCard

local transLabel = Instance.new("TextLabel")
transLabel.Size = UDim2.new(0.5, 0, 1, 0)
transLabel.Position = UDim2.new(0, 16, 0, 0)
transLabel.BackgroundTransparency = 1
transLabel.Text = "Transparency"
transLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
transLabel.TextSize = 16
transLabel.Font = Enum.Font.GothamBold
transLabel.TextXAlignment = Enum.TextXAlignment.Left
transLabel.Parent = transCard

local transToggle = Instance.new("Frame")
transToggle.Size = UDim2.new(0, 50, 0, 28)
transToggle.Position = UDim2.new(1, -14, 0.5, 0)
transToggle.AnchorPoint = Vector2.new(1, 0.5)
transToggle.BackgroundColor3 = settings.Transparent and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 75)
transToggle.BackgroundTransparency = 0.1
transToggle.BorderSizePixel = 0
transToggle.Parent = transCard
local transToggleCorner = Instance.new("UICorner")
transToggleCorner.CornerRadius = UDim.new(1, 0)
transToggleCorner.Parent = transToggle

local transCircle = Instance.new("Frame")
transCircle.Size = UDim2.new(0, 22, 0, 22)
transCircle.Position = settings.Transparent and UDim2.new(1, -25, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
transCircle.AnchorPoint = Vector2.new(0, 0.5)
transCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
transCircle.BackgroundTransparency = 0.05
transCircle.BorderSizePixel = 0
transCircle.Parent = transToggle
local transCircleCorner = Instance.new("UICorner")
transCircleCorner.CornerRadius = UDim.new(1, 0)
transCircleCorner.Parent = transCircle

local isTransparent = settings.Transparent
local function UpdateTransparency()
    if isTransparent then
        transToggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        transCircle.Position = UDim2.new(1, -25, 0.5, 0)
        mainFrame.BackgroundTransparency = 0.2
    else
        transToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        transCircle.Position = UDim2.new(0, 3, 0.5, 0)
        mainFrame.BackgroundTransparency = 0.1
    end
    settings.Transparent = isTransparent
end
UpdateTransparency()
transToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isTransparent = not isTransparent
        UpdateTransparency()
    end
end)

-- THEMES
local themeOptions = {"Astral", "Blood", "Ocean"}
local themeCard = Instance.new("Frame")
themeCard.Size = UDim2.new(1, -12, 0, 54)
themeCard.Position = UDim2.new(0, 6, 0, 110)
themeCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
themeCard.BackgroundTransparency = 0.3
themeCard.BorderSizePixel = 0
themeCard.ClipsDescendants = true
themeCard.Parent = settingsContent
local themeCardCorner = Instance.new("UICorner")
themeCardCorner.CornerRadius = UDim.new(0, 10)
themeCardCorner.Parent = themeCard

local themeHeader = Instance.new("TextButton")
themeHeader.Size = UDim2.new(1, 0, 0, 54)
themeHeader.BackgroundTransparency = 1
themeHeader.Text = "Theme: " .. settings.Theme
themeHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
themeHeader.TextSize = 16
themeHeader.Font = Enum.Font.GothamBold
themeHeader.TextXAlignment = Enum.TextXAlignment.Left
themeHeader.TextYAlignment = Enum.TextYAlignment.Center
themeHeader.Parent = themeCard

local themeArrow = Instance.new("TextLabel")
themeArrow.Size = UDim2.new(0, 20, 1, 0)
themeArrow.Position = UDim2.new(1, -16, 0, 0)
themeArrow.BackgroundTransparency = 1
themeArrow.Text = "▼"
themeArrow.TextColor3 = Color3.fromRGB(180, 180, 200)
themeArrow.TextSize = 14
themeArrow.Font = Enum.Font.GothamBold
themeArrow.TextXAlignment = Enum.TextXAlignment.Right
themeArrow.TextYAlignment = Enum.TextYAlignment.Center
themeArrow.Parent = themeHeader

local themeList = Instance.new("Frame")
themeList.Size = UDim2.new(1, 0, 0, 0)
themeList.Position = UDim2.new(0, 0, 0, 54)
themeList.BackgroundTransparency = 1
themeList.BorderSizePixel = 0
themeList.ClipsDescendants = true
themeList.Parent = themeCard

local isThemeOpen = false

for i, opt in pairs(themeOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, (i-1) * 34)
    btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = "  " .. opt
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.Parent = themeList
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    if opt == settings.Theme then
        btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(138, 43, 226)
    end

    btn.MouseButton1Click:Connect(function()
        settings.Theme = opt
        themeHeader.Text = "Theme: " .. opt
        mainFrame.BackgroundColor3 = themeColorsList[opt]
        isThemeOpen = false
        themeCard.Size = UDim2.new(1, -12, 0, 54)
        themeList.Size = UDim2.new(1, 0, 0, 0)
        themeArrow.Text = "▼"
    end)
end

themeHeader.MouseButton1Click:Connect(function()
    isThemeOpen = not isThemeOpen
    if isThemeOpen then
        themeArrow.Text = "▲"
        themeCard.Size = UDim2.new(1, -12, 0, 54 + #themeOptions * 34)
        themeList.Size = UDim2.new(1, 0, 0, #themeOptions * 34)
    else
        themeArrow.Text = "▼"
        themeCard.Size = UDim2.new(1, -12, 0, 54)
        themeList.Size = UDim2.new(1, 0, 0, 0)
    end
end)

settingsContent.CanvasSize = UDim2.new(0, 0, 0, 220)

-- ============================================
-- VISUALS (ESP)
-- ============================================
local visualsContent = contents[3]
visualsContent.CanvasSize = UDim2.new(0, 0, 0, 150)

local vLabel = Instance.new("TextLabel")
vLabel.Size = UDim2.new(1, 0, 0, 35)
vLabel.Position = UDim2.new(0, 0, 0, 5)
vLabel.BackgroundTransparency = 1
vLabel.Text = "Visuals"
vLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
vLabel.TextSize = 16
vLabel.Font = Enum.Font.GothamBold
vLabel.TextXAlignment = Enum.TextXAlignment.Center
vLabel.Parent = visualsContent

local espEnabled = false
local espThread = nil
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
        while espEnabled do
            task.wait(0.4)
            if not espEnabled then break end
            local playerPos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not playerPos then continue end
            local espCount = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if not espEnabled then break end
                if espCount >= 35 then break end
                if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
                    local model = obj.Parent
                    local name = string.lower(model.Name)
                    local objPos = obj.Position
                    local distance = (playerPos.Position - objPos).Magnitude
                    if distance > espDistance then continue end
                    if model == LP.Character then continue end
                    local isResource = false
                    local icon = "📦"
                    if string.find(name, "gas") or string.find(name, "fuel") or string.find(name, "jerry") or string.find(name, "barrel") or string.find(name, "oil") then
                        isResource = true; icon = "⛽"
                    elseif string.find(name, "food") or string.find(name, "can") or string.find(name, "bandage") or string.find(name, "med") or string.find(name, "water") then
                        isResource = true; icon = "🥫"
                    elseif string.find(name, "wheel") or string.find(name, "tire") then
                        isResource = true; icon = "⚙️"
                    elseif string.find(name, "part") or string.find(name, "engine") or string.find(name, "motor") or string.find(name, "battery") or string.find(name, "radiator") or string.find(name, "scrap") then
                        isResource = true; icon = "🔧"
                    elseif string.find(name, "gun") or string.find(name, "rifle") or string.find(name, "shotgun") or string.find(name, "weapon") then
                        isResource = true; icon = "🔫"
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
    espEnabled = state
    if espEnabled then
        clearESP()
        espThread = task.spawn(runItemESP)
        print("[ASTRA] ESP включён")
    else
        if espThread then
            task.cancel(espThread)
            espThread = nil
        end
        clearESP()
        print("[ASTRA] ESP выключен")
    end
end

createAeroCard(visualsContent, "Resource ESP", 50, false, function(state)
    toggleESP(state)
end)

visualsContent.CanvasSize = UDim2.new(0, 0, 0, 150)

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ============================================
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local allContents = {contents[1], contents[2], contents[3]}

local function SwitchTab(index)
    for i, content in pairs(allContents) do
        if content.Visible then
            local slideOut = TweenService:Create(content, tweenInfo, {Position = UDim2.new(0, 0, 0, 50)})
            slideOut:Play()
            task.wait(0.1)
            content.Visible = false
            content.Position = UDim2.new(0, 0, 0, 0)
        end
    end
    local newContent = allContents[index]
    newContent.Position = UDim2.new(0, 0, 0, 50)
    newContent.Visible = true
    local slideIn = TweenService:Create(newContent, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)})
    slideIn:Play()
    for i, btn in pairs(btnObjects) do
        if i == index then
            btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            btn.BackgroundTransparency = 0.2
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
            btn.BackgroundTransparency = 0.1
            btn.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
    end
end

for i, btn in pairs(btnObjects) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

-- ============================================
-- АВТО-ЗАПУСК
-- ============================================
task.spawn(function()
    task.wait(3)
    local gameName = game.Name
    if string.find(gameName, "desrt") or string.find(gameName, "Desert") then
        print("[ASTRA] Найдена A Desert! Запускаю ESP...")
        toggleESP(true)
        print("[ASTRA] A Desert режим активирован!")
    else
        print("[ASTRA] Игра не A Desert.")
    end
end)

print("ASTRA HUB V2.0 — С РАЗМЫТИЕМ ЗАГРУЖЕН!")
