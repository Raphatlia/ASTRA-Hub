--- ASTRA HUB V1.0 — ФИНАЛ (ДВОЙНАЯ ПРОВЕРКА ИГРЫ)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

-- ============================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
getgenv().AstraHubLoaded = false
getgenv().espEnabled = false
getgenv().espThread = nil
getgenv().espDistance = 1000

-- ============================================
-- GUI (МЕНЮ)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ===== НАСТРОЙКИ =====
local function LoadSettings()
    if not shared.AstraSettings then
        shared.AstraSettings = {
            Theme = "Astral",
            Transparent = false,
            ESPDistance = 1000,
        }
    end
    return shared.AstraSettings
end
local settings = LoadSettings()

local themeColorsList = {
    Astral = Color3.fromRGB(25, 15, 45),
    Blood = Color3.fromRGB(60, 15, 20),
    Ocean = Color3.fromRGB(10, 25, 50),
}

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА
-- ============================================
local floatingBtn = Instance.new("TextButton")
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
floatingBtn.TextXAlignment = Enum.TextXAlignment.Left
floatingBtn.Visible = true
floatingBtn.Active = true
floatingBtn.Selectable = true
floatingBtn.ZIndex = 100
floatingBtn.Parent = ScreenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local dragIcon = Instance.new("TextLabel")
dragIcon.Size = UDim2.new(0, 30, 1, 0)
dragIcon.Position = UDim2.new(0, 10, 0, 0)
dragIcon.BackgroundTransparency = 1
dragIcon.Text = "⠿"
dragIcon.TextColor3 = Color3.fromRGB(180, 175, 210)
dragIcon.TextSize = 20
dragIcon.Font = Enum.Font.GothamBold
dragIcon.TextXAlignment = Enum.TextXAlignment.Center
dragIcon.TextYAlignment = Enum.TextYAlignment.Center
dragIcon.Parent = floatingBtn

local function openMenu()
    local menu = ScreenGui:FindFirstChild("mainFrame")
    if menu then
        menu.Visible = true
        floatingBtn.Visible = false
        menu.Size = UDim2.new(0, 0, 0, 0)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local openTween = TweenService:Create(menu, tweenInfo, {Size = UDim2.new(0, 380, 0, 320)})
        openTween:Play()
    end
end

floatingBtn.MouseButton1Click:Connect(openMenu)
floatingBtn.TouchTap:Connect(openMenu)

-- ============================================
-- ОСНОВНОЕ ОКНО
-- ============================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "mainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 320)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = themeColorsList[settings.Theme]
mainFrame.BackgroundTransparency = settings.Transparent and 0.2 or 0.1
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(60, 50, 100)
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- ===== ШАПКА =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
header.BackgroundTransparency = 0.3
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
versionText.Text = "V1.0"
versionText.TextColor3 = Color3.fromRGB(255, 255, 255)
versionText.TextSize = 11
versionText.Font = Enum.Font.GothamBold
versionText.Parent = versionTag

task.spawn(function()
    while versionTag and versionTag.Parent do
        local tween1 = TweenService:Create(versionTag, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(180, 80, 255)
        })
        local tween2 = TweenService:Create(versionTag, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        })
        tween1:Play()
        tween1.Completed:Wait()
        tween2:Play()
        tween2.Completed:Wait()
    end
end)

-- ===== MACOS КНОПКИ =====
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
    mainFrame.Visible = false
    floatingBtn.Visible = true
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
leftPanel.ClipsDescendants = true
leftPanel.Parent = mainFrame

local btnData = {"Features", "Settings", "Visuals"}
local btnObjects = {}
for i = 1, #btnData do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, 10 + (i-1) * 36)
    btn.BackgroundTransparency = 1
    btn.Text = btnData[i]
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
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
rightPanel.Parent = mainFrame

local contents = {}
for i = 1, #btnData do
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
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
    card.BorderSizePixel = 1
    card.BorderColor3 = Color3.fromRGB(255, 255, 255, 0.1)
    card.Parent = parent
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 0, 0, 2)
    shadow.BackgroundTransparency = 1
    shadow.BorderSizePixel = 1
    shadow.BorderColor3 = Color3.fromRGB(20, 15, 35)
    shadow.ZIndex = -1
    shadow.Parent = card
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 10)
    shadowCorner.Parent = shadow

    local cardBlur = Instance.new("BlurEffect")
    cardBlur.Parent = card
    cardBlur.Size = 2

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
featuresContent.CanvasSize = UDim2.new(0, 0, 0, 240)
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

createAeroCard(featuresContent, "Auto Click", 50, false)
createAeroCard(featuresContent, "Fast Attack", 110, true)
createAeroCard(featuresContent, "Auto Collect", 170, false)

-- ============================================
-- SETTINGS
-- ============================================
local settingsContent = contents[2]
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 280)

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
transCard.BorderSizePixel = 1
transCard.BorderColor3 = Color3.fromRGB(255, 255, 255, 0.1)
transCard.Parent = settingsContent
local transCardCorner = Instance.new("UICorner")
transCardCorner.CornerRadius = UDim.new(0, 10)
transCardCorner.Parent = transCard

local transBlur = Instance.new("BlurEffect")
transBlur.Parent = transCard
transBlur.Size = 2

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
        mainFrame.BackgroundTransparency = 0.15
    end
    shared.AstraSettings.Transparent = isTransparent
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
themeCard.BorderSizePixel = 1
themeCard.BorderColor3 = Color3.fromRGB(255, 255, 255, 0.1)
themeCard.ClipsDescendants = true
themeCard.Parent = settingsContent
local themeCardCorner = Instance.new("UICorner")
themeCardCorner.CornerRadius = UDim.new(0, 10)
themeCardCorner.Parent = themeCard

local themeBlur = Instance.new("BlurEffect")
themeBlur.Parent = themeCard
themeBlur.Size = 2

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
themeList.ClipsDescendants = true
themeList.Parent = themeCard

local isThemeOpen = false

for i, opt in pairs(themeOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, (i-1) * 34)
    btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
    btn.BackgroundTransparency = 0
    btn.Text = "  " .. opt
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.BorderSizePixel = 0
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
        shared.AstraSettings.Theme = opt
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

-- ИНФО-КАРТОЧКА
local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(1, -12, 0, 44)
infoCard.Position = UDim2.new(0, 6, 0, 230)
infoCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
infoCard.BackgroundTransparency = 0.1
infoCard.BorderSizePixel = 1
infoCard.BorderColor3 = Color3.fromRGB(60, 50, 90)
infoCard.Parent = settingsContent
local infoCardCorner = Instance.new("UICorner")
infoCardCorner.CornerRadius = UDim.new(0, 10)
infoCardCorner.Parent = infoCard

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 1, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "v1.0 | by: CMarmoki"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextYAlignment = Enum.TextYAlignment.Center
infoLabel.Parent = infoCard

settingsContent.CanvasSize = UDim2.new(0, 0, 0, 280)

-- ============================================
-- VISUALS
-- ============================================
local visualsContent = contents[3]
visualsContent.CanvasSize = UDim2.new(0, 0, 0, 250)

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

-- ===== СВИТЧЕР RESOURCE ESP =====
local espCard = Instance.new("Frame")
espCard.Size = UDim2.new(1, -12, 0, 54)
espCard.Position = UDim2.new(0, 6, 0, 50)
espCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
espCard.BackgroundTransparency = 0.3
espCard.BorderSizePixel = 1
espCard.BorderColor3 = Color3.fromRGB(255, 255, 255, 0.1)
espCard.Parent = visualsContent
local espCardCorner = Instance.new("UICorner")
espCardCorner.CornerRadius = UDim.new(0, 10)
espCardCorner.Parent = espCard

local espBlur = Instance.new("BlurEffect")
espBlur.Parent = espCard
espBlur.Size = 2

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0.6, 0, 1, 0)
espLabel.Position = UDim2.new(0, 16, 0, 0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "Resource ESP"
espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
espLabel.TextSize = 16
espLabel.Font = Enum.Font.GothamBold
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = espCard

local espToggle = Instance.new("Frame")
espToggle.Size = UDim2.new(0, 50, 0, 28)
espToggle.Position = UDim2.new(1, -14, 0.5, 0)
espToggle.AnchorPoint = Vector2.new(1, 0.5)
espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
espToggle.BackgroundTransparency = 0.1
espToggle.BorderSizePixel = 0
espToggle.Parent = espCard
local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(1, 0)
espToggleCorner.Parent = espToggle

local espCircle = Instance.new("Frame")
espCircle.Size = UDim2.new(0, 22, 0, 22)
espCircle.Position = UDim2.new(0, 3, 0.5, 0)
espCircle.AnchorPoint = Vector2.new(0, 0.5)
espCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
espCircle.BackgroundTransparency = 0.05
espCircle.BorderSizePixel = 0
espCircle.Parent = espToggle
local espCircleCorner = Instance.new("UICorner")
espCircleCorner.CornerRadius = UDim.new(1, 0)
espCircleCorner.Parent = espCircle

local espOn = false
espToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        espOn = not espOn
        if espOn then
            espToggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            espCircle.Position = UDim2.new(1, -25, 0.5, 0)
            getgenv().espEnabled = true
            if getgenv().toggleESP then
                getgenv().toggleESP(true)
            end
        else
            espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            espCircle.Position = UDim2.new(0, 3, 0.5, 0)
            getgenv().espEnabled = false
            if getgenv().toggleESP then
                getgenv().toggleESP(false)
            end
        end
    end
end)

-- ============================================
-- ПОЛЗУНОК ESP DISTANCE
-- ============================================
local espDistance = settings.ESPDistance or 1000

local sliderCard = Instance.new("Frame")
sliderCard.Size = UDim2.new(1, -12, 0, 64)
sliderCard.Position = UDim2.new(0, 6, 0, 110)
sliderCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
sliderCard.BackgroundTransparency = 0.3
sliderCard.BorderSizePixel = 1
sliderCard.BorderColor3 = Color3.fromRGB(255, 255, 255, 0.1)
sliderCard.Parent = visualsContent
local sliderCardCorner = Instance.new("UICorner")
sliderCardCorner.CornerRadius = UDim.new(0, 10)
sliderCardCorner.Parent = sliderCard

local sliderBlur = Instance.new("BlurEffect")
sliderBlur.Parent = sliderCard
sliderBlur.Size = 2

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0.6, 0, 1, 0)
sliderLabel.Position = UDim2.new(0, 16, 0, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "ESP Distance: " .. espDistance .. "m"
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.TextSize = 14
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = sliderCard

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(0, 90, 0, 6)
sliderTrack.Position = UDim2.new(1, -14, 0.5, 0)
sliderTrack.AnchorPoint = Vector2.new(1, 0.5)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = sliderCard
local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(espDistance / 3000, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 22, 0, 22)
sliderKnob.Position = UDim2.new(espDistance / 3000, 0, 0.5, 0)
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BackgroundTransparency = 0.05
sliderKnob.BorderSizePixel = 2
sliderKnob.BorderColor3 = Color3.fromRGB(138, 43, 226)
sliderKnob.Text = ""
sliderKnob.Parent = sliderTrack
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

local isDragging = false

sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    local sliderPos = sliderTrack.AbsolutePosition
    local sliderSize = sliderTrack.AbsoluteSize
    local relativeX = math.clamp(input.Position.X - sliderPos.X, 0, sliderSize.X)
    local newValue = math.floor((relativeX / sliderSize.X) * 3000)
    newValue = math.clamp(newValue, 100, 3000)
    
    if newValue ~= espDistance then
        espDistance = newValue
        settings.ESPDistance = espDistance
        shared.AstraSettings.ESPDistance = espDistance
        getgenv().espDistance = espDistance
        
        sliderLabel.Text = "ESP Distance: " .. espDistance .. "m"
        sliderFill.Size = UDim2.new(espDistance / 3000, 0, 1, 0)
        sliderKnob.Position = UDim2.new(espDistance / 3000, 0, 0.5, 0)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

visualsContent.CanvasSize = UDim2.new(0, 0, 0, 250)

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
-- ЗАГРУЗКА МОДУЛЕЙ
-- ============================================
local currentGameName = game.Name

if string.find(currentGameName, "A desrt") or string.find(currentGameName, "A Desrt") or string.find(currentGameName, "desrt") then
    print("[ASTRA] Загружаю модуль A Desrt...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Desrt.lua"))()
elseif string.find(currentGameName, "A Long Road") or string.find(currentGameName, "Long Road") then
    print("[ASTRA] Загружаю модуль A Long Road...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Long_Road.lua"))()
else
    print("[ASTRA] Игра не из списка поддержки: " .. currentGameName)
end

getgenv().AstraHubLoaded = true
print("[ASTRA] Главный каркас загружен! Игра: " .. currentGameName)

-- ============================================
-- АВТО-ЗАПУСК ESP (НАДЁЖНЫЙ МЕТОД)
-- ============================================
task.spawn(function()
    task.wait(3)
    local gameName = game.Name
    
    if string.find(gameName, "A desrt") or string.find(gameName, "A Desrt") or string.find(gameName, "desrt") then
        print("[ASTRA] Найдена игра: A desrt!")
        getgenv().espEnabled = true
        if getgenv().toggleESP then
            getgenv().toggleESP(true)
        end
    elseif string.find(gameName, "A Long Road") or string.find(gameName, "Long Road") then
        print("[ASTRA] Найдена игра: A Long Road!")
        getgenv().espEnabled = true
        if getgenv().toggleESP then
            getgenv().toggleESP(true)
        end
    else
        -- Запасной вариант: если название не совпало, пробуем через интернет
        local success, realName = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)
        if success and (string.find(realName, "desrt") or string.find(realName, "Desrt")) then
            print("[ASTRA] Найдена игра (по ID): A desrt!")
            getgenv().espEnabled = true
            if getgenv().toggleESP then
                getgenv().toggleESP(true)
            end
        elseif success and string.find(realName, "Long Road") then
            print("[ASTRA] Найдена игра (по ID): A Long Road!")
            getgenv().espEnabled = true
            if getgenv().toggleESP then
                getgenv().toggleESP(true)
            end
        else
            print("[ASTRA] Игра не распознана: " .. gameName)
        end
    end
end)
