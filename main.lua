-- ASTRA HUB V3.0 — МОДУЛЬНАЯ АРХИТЕКТУРА (ИСПРАВЛЕННАЯ ЗАГРУЗКА)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ============================================
-- ГЛОБАЛЬНАЯ СИСТЕМА СОБЫТИЙ
-- ============================================
local Events = {}
function Events:Fire(name, ...)
    if self[name] then
        for _, callback in pairs(self[name]) do
            task.spawn(callback, ...)
        end
    end
end
function Events:Connect(name, callback)
    if not self[name] then self[name] = {} end
    table.insert(self[name], callback)
end
getgenv().AstraEvents = Events

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = {
    Theme = "Astral",
    Transparent = false,
    ESPDistance = 1000,
}

local themeColorsList = {
    Astral = Color3.fromRGB(25, 15, 45),
    Blood = Color3.fromRGB(60, 15, 20),
    Ocean = Color3.fromRGB(10, 25, 50),
}

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================
local isOpen = false
local mainFrame = nil
local floatingBtn = nil
local templateCard = nil

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
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local openTween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 380, 0, 320)
    })
    openTween:Play()
end

local function closeMenu()
    if not mainFrame then return end
    isOpen = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local closeTween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0)
    })
    closeTween:Play()
    closeTween.Completed:Wait()
    mainFrame.Visible = false
    floatingBtn.Visible = true
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then closeMenu() else openMenu() end
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
mainFrame.BackgroundTransparency = settings.Transparent and 0.2 or 0.1
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
versionText.Text = "V3.0"
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
btnYellow.MouseButton1Click:Connect(closeMenu)

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
-- ШАБЛОН КАРТОЧКИ
-- ============================================
templateCard = Instance.new("Frame")
templateCard.Size = UDim2.new(1, -12, 0, 54)
templateCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
templateCard.BackgroundTransparency = 0.3
templateCard.BorderSizePixel = 0
templateCard.Visible = false
templateCard.Parent = ScreenGui
local tcCorner = Instance.new("UICorner")
tcCorner.CornerRadius = UDim.new(0, 10)
tcCorner.Parent = templateCard

local tcLabel = Instance.new("TextLabel")
tcLabel.Size = UDim2.new(0.6, 0, 1, 0)
tcLabel.Position = UDim2.new(0, 16, 0, 0)
tcLabel.BackgroundTransparency = 1
tcLabel.Text = "Toggle"
tcLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tcLabel.TextSize = 16
tcLabel.Font = Enum.Font.GothamBold
tcLabel.TextXAlignment = Enum.TextXAlignment.Left
tcLabel.Parent = templateCard

local tcToggle = Instance.new("Frame")
tcToggle.Size = UDim2.new(0, 50, 0, 28)
tcToggle.Position = UDim2.new(1, -14, 0.5, 0)
tcToggle.AnchorPoint = Vector2.new(1, 0.5)
tcToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
tcToggle.BackgroundTransparency = 0.1
tcToggle.BorderSizePixel = 0
tcToggle.Parent = templateCard
local tcToggleCorner = Instance.new("UICorner")
tcToggleCorner.CornerRadius = UDim.new(1, 0)
tcToggleCorner.Parent = tcToggle

local tcCircle = Instance.new("Frame")
tcCircle.Size = UDim2.new(0, 22, 0, 22)
tcCircle.Position = UDim2.new(0, 3, 0.5, 0)
tcCircle.AnchorPoint = Vector2.new(0, 0.5)
tcCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tcCircle.BackgroundTransparency = 0.05
tcCircle.BorderSizePixel = 0
tcCircle.Parent = tcToggle
local tcCircleCorner = Instance.new("UICorner")
tcCircleCorner.CornerRadius = UDim.new(1, 0)
tcCircleCorner.Parent = tcCircle

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ КАРТОЧКИ
-- ============================================
local function createAeroCard(parent, title, yPos, defaultOn, callback)
    local card = templateCard:Clone()
    card.Visible = true
    card.Position = UDim2.new(0, 6, 0, yPos)
    card.Parent = parent
    
    local label = card:FindFirstChild("TextLabel")
    label.Text = title
    
    local toggle = card:FindFirstChild("Frame")
    local circle = toggle:FindFirstChild("Frame")
    
    local isOn = defaultOn or false
    if isOn then
        toggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        circle.Position = UDim2.new(1, -25, 0.5, 0)
    end
    
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
    
    return card
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

createAeroCard(featuresContent, "Auto Collect", 50, false, function(state)
    Events:Fire("AutoCollect", state)
end)

createAeroCard(featuresContent, "Speed Boost", 110, false, function(state)
    Events:Fire("SpeedBoost", state)
end)

createAeroCard(featuresContent, "Fast Attack", 170, false, function(state)
    Events:Fire("FastAttack", state)
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

local function toggleESP(state)
    espEnabled = state
    Events:Fire("ESP", state)
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
-- ЗАГРУЗКА МОДУЛЕЙ (БЕЗ PCALL)
-- ============================================
local function loadModule(name)
    local module = game.ReplicatedStorage:FindFirstChild(name)
    if module then
        local loaded = require(module)
        if loaded and type(loaded) == "table" then
            print("[ASTRA] Модуль " .. name .. " успешно загружен!")
            return loaded
        end
    end
    print("[ASTRA] Модуль " .. name .. " не найден.")
    return nil
end

-- Загружаем модули
local desrtModule = loadModule("AstraHub_A_Desrt")
local longRoadModule = loadModule("AstraHub_A_Long_Road")

-- Если ни один модуль не загрузился — игра не поддерживается
if not desrtModule and not longRoadModule then
    print("[ASTRA] Игра не поддерживается. Модули не загружены.")
end

print("ASTRA HUB V3.0 — МОДУЛЬНАЯ АРХИТЕКТУРА ЗАГРУЖЕНА!")
