-- ASTRA HUB V3.0 — ФИНАЛ (АККОРДЕОНЫ С LAYOUTORDER)
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
    Dark = Color3.fromRGB(10, 10, 15),
}

local themeNames = {"Astral", "Blood", "Ocean", "Dark"}

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================
local isOpen = false
local mainFrame = nil
local floatingBtn = nil

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА
-- ============================================
floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 150, 0, 38)
floatingBtn.Position = UDim2.new(0.5, -75, 0.05, 0)
floatingBtn.AnchorPoint = Vector2.new(0.5, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
floatingBtn.BackgroundTransparency = 0.15
floatingBtn.BorderSizePixel = 2
floatingBtn.BorderColor3 = Color3.fromRGB(138, 43, 226)
floatingBtn.Text = "Open Script"
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.TextSize = 13
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
-- ЛОГОТИП
-- ============================================
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 30, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 8)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://107794916759230"
logo.ZIndex = 999
logo.Parent = ScreenGui

-- ============================================
-- ФУНКЦИИ ОТКРЫТИЯ/ЗАКРЫТИЯ
-- ============================================
local function openMenu()
    if not mainFrame then return end
    isOpen = true
    floatingBtn.Visible = false
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local openTween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 340, 0, 280)
    })
    openTween:Play()
end

local function closeMenu()
    if not mainFrame then return end
    isOpen = false
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
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
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

-- ============================================
-- ШАПКА
-- ============================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ASTRA HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local versionTag = Instance.new("Frame")
versionTag.Size = UDim2.new(0, 40, 0, 18)
versionTag.Position = UDim2.new(0, 100, 0.5, 0)
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
versionText.TextSize = 10
versionText.Font = Enum.Font.GothamBold
versionText.Parent = versionTag

-- MACOS КНОПКИ
local btnRed = Instance.new("TextButton")
btnRed.Size = UDim2.new(0, 10, 0, 10)
btnRed.Position = UDim2.new(1, -48, 0.5, 0)
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
btnYellow.Size = UDim2.new(0, 10, 0, 10)
btnYellow.Position = UDim2.new(1, -34, 0.5, 0)
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
btnGreen.Size = UDim2.new(0, 10, 0, 10)
btnGreen.Position = UDim2.new(1, -20, 0.5, 0)
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
-- ЛЕВАЯ ПАНЕЛЬ (С ИКОНКАМИ)
-- ============================================
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 80, 1, -36)
leftPanel.Position = UDim2.new(0, 0, 0, 36)
leftPanel.BackgroundTransparency = 1
leftPanel.BorderSizePixel = 0
leftPanel.ClipsDescendants = true
leftPanel.Parent = mainFrame

local tabIcons = {["Features"] = "✦", ["Settings"] = "⚙️", ["Visuals"] = "👁️"}
local btnData = {"Features", "Settings", "Visuals"}
local btnObjects = {}
for i = 1, #btnData do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 24)
    btn.Position = UDim2.new(0.05, 0, 0, 6 + (i-1) * 30)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = tabIcons[btnData[i]] .. " " .. btnData[i]
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 12
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
rightPanel.Size = UDim2.new(1, -85, 1, -36)
rightPanel.Position = UDim2.new(0, 82, 0, 36)
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
    f.ScrollBarThickness = 2
    f.ScrollBarImageColor3 = Color3.fromRGB(80, 40, 140)
    f.Visible = (i == 1)
    f.Parent = rightPanel
    contents[i] = f
end

-- ============================================
-- КОМПАКТНАЯ КАРТОЧКА
-- ============================================
local function createAeroCard(parent, title, yPos, defaultOn, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 32)
    card.Position = UDim2.new(0, 5, 0, yPos)
    card.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 75)
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Parent = card
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = defaultOn and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
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
                circle.Position = UDim2.new(1, -20, 0.5, 0)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                circle.Position = UDim2.new(0, 2, 0.5, 0)
            end
            if callback then callback(isOn) end
        end
    end)
end

-- ============================================
-- ИДЕАЛЬНЫЙ АККОРДЕОН (С LayoutOrder)
-- ============================================
local function createAccordion(parent, title, yPos, order, elements)
    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, -10, 0, 28)
    headerBtn.Position = UDim2.new(0, 5, 0, yPos)
    headerBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
    headerBtn.BackgroundTransparency = 0.2
    headerBtn.BorderSizePixel = 0
    headerBtn.Text = "▶ " .. title
    headerBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    headerBtn.TextSize = 13
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left
    headerBtn.Parent = parent
    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 8)
    hCorner.Parent = headerBtn

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Position = UDim2.new(0, 0, 0, yPos + 28)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.Parent = parent
    container.LayoutOrder = order -- ГЛАВНОЕ: порядок в UIListLayout

    -- UIListLayout внутри контейнера для карточек
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = container

    local isOpen = false
    local contentHeight = 0
    local elementY = 4
    for _, el in pairs(elements) do
        local card = createAeroCard(container, el.title, elementY, el.defaultOn, el.callback)
        elementY = elementY + 32
        contentHeight = contentHeight + 32
    end
    container.Size = UDim2.new(1, 0, 0, 0)

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        headerBtn.Text = (isOpen and "▼ " or "▶ ") .. title
        local targetSize = isOpen and contentHeight or 0
        local tween = TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, targetSize)
        })
        tween:Play()
    end)
end

-- ============================================
-- FEATURES (С LayoutOrder)
-- ============================================
local featuresContent = contents[1]
featuresContent.CanvasSize = UDim2.new(0, 0, 0, 200)

local fLabel = Instance.new("TextLabel")
fLabel.Size = UDim2.new(1, 0, 0, 28)
fLabel.Position = UDim2.new(0, 0, 0, 2)
fLabel.BackgroundTransparency = 1
fLabel.Text = "✦ Features"
fLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fLabel.TextSize = 14
fLabel.Font = Enum.Font.GothamBold
fLabel.TextXAlignment = Enum.TextXAlignment.Center
fLabel.Parent = featuresContent

-- UIListLayout для аккордеонов (главное!)
local accordionLayout = Instance.new("UIListLayout")
accordionLayout.SortOrder = Enum.SortOrder.LayoutOrder
accordionLayout.Padding = UDim.new(0, 6)
accordionLayout.Parent = featuresContent

createAccordion(featuresContent, "🚀 Movement", 0, 1, {
    {title = "Speed Boost", defaultOn = false, callback = function(s) Events:Fire("SpeedBoost", s) end},
    {title = "Auto Collect", defaultOn = false, callback = function(s) Events:Fire("AutoCollect", s) end},
})

createAccordion(featuresContent, "⚔️ Combat", 0, 2, {
    {title = "Fast Attack", defaultOn = false, callback = function(s) Events:Fire("FastAttack", s) end},
})

featuresContent.CanvasSize = UDim2.new(0, 0, 0, 150)

-- ============================================
-- SETTINGS
-- ============================================
local settingsContent = contents[2]
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 200)

local sLabel = Instance.new("TextLabel")
sLabel.Size = UDim2.new(1, 0, 0, 28)
sLabel.Position = UDim2.new(0, 0, 0, 2)
sLabel.BackgroundTransparency = 1
sLabel.Text = "⚙️ Settings"
sLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sLabel.TextSize = 14
sLabel.Font = Enum.Font.GothamBold
sLabel.TextXAlignment = Enum.TextXAlignment.Center
sLabel.Parent = settingsContent

-- TRANSPARENCY
local function createSettingCard(parent, title, yPos, defaultOn, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 32)
    card.Position = UDim2.new(0, 5, 0, yPos)
    card.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 75)
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Parent = card
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = defaultOn and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
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
                circle.Position = UDim2.new(1, -20, 0.5, 0)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                circle.Position = UDim2.new(0, 2, 0.5, 0)
            end
            if callback then callback(isOn) end
        end
    end)
end

createSettingCard(settingsContent, "Transparency", 32, false, function(s)
    settings.Transparent = s
    mainFrame.BackgroundTransparency = s and 0.2 or 0.1
end)

-- ТЕМЫ (ВЫПАДАЮЩИЙ СПИСОК)
local themeCard = Instance.new("Frame")
themeCard.Size = UDim2.new(1, -10, 0, 32)
themeCard.Position = UDim2.new(0, 5, 0, 68)
themeCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
themeCard.BackgroundTransparency = 0.3
themeCard.BorderSizePixel = 0
themeCard.ClipsDescendants = true
themeCard.Parent = settingsContent
local themeCardCorner = Instance.new("UICorner")
themeCardCorner.CornerRadius = UDim.new(0, 8)
themeCardCorner.Parent = themeCard

local themeHeader = Instance.new("TextButton")
themeHeader.Size = UDim2.new(1, 0, 0, 32)
themeHeader.BackgroundTransparency = 1
themeHeader.Text = "🎨 Theme: " .. settings.Theme
themeHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
themeHeader.TextSize = 13
themeHeader.Font = Enum.Font.GothamBold
themeHeader.TextXAlignment = Enum.TextXAlignment.Left
themeHeader.TextYAlignment = Enum.TextYAlignment.Center
themeHeader.Parent = themeCard

local themeArrow = Instance.new("TextLabel")
themeArrow.Size = UDim2.new(0, 20, 1, 0)
themeArrow.Position = UDim2.new(1, -12, 0, 0)
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
themeList.Position = UDim2.new(0, 0, 0, 32)
themeList.BackgroundTransparency = 1
themeList.ClipsDescendants = true
themeList.Parent = themeCard

local isThemeOpen = false
themeCard.Size = UDim2.new(1, -10, 0, 32)

for i, opt in pairs(themeNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Position = UDim2.new(0, 0, 0, (i-1) * 28)
    btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
    btn.BackgroundTransparency = 0
    btn.Text = "  " .. opt
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 13
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
        themeHeader.Text = "🎨 Theme: " .. opt
        mainFrame.BackgroundColor3 = themeColorsList[opt]
        isThemeOpen = false
        themeCard.Size = UDim2.new(1, -10, 0, 32)
        themeList.Size = UDim2.new(1, 0, 0, 0)
        themeArrow.Text = "▼"
    end)
end

themeHeader.MouseButton1Click:Connect(function()
    isThemeOpen = not isThemeOpen
    if isThemeOpen then
        themeArrow.Text = "▲"
        themeCard.Size = UDim2.new(1, -10, 0, 32 + #themeNames * 28)
        themeList.Size = UDim2.new(1, 0, 0, #themeNames * 28)
    else
        themeArrow.Text = "▼"
        themeCard.Size = UDim2.new(1, -10, 0, 32)
        themeList.Size = UDim2.new(1, 0, 0, 0)
    end
end)

settingsContent.CanvasSize = UDim2.new(0, 0, 0, 130)

-- ============================================
-- VISUALS (ESP)
-- ============================================
local visualsContent = contents[3]
visualsContent.CanvasSize = UDim2.new(0, 0, 0, 100)

local vLabel = Instance.new("TextLabel")
vLabel.Size = UDim2.new(1, 0, 0, 28)
vLabel.Position = UDim2.new(0, 0, 0, 2)
vLabel.BackgroundTransparency = 1
vLabel.Text = "👁️ Visuals"
vLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
vLabel.TextSize = 14
vLabel.Font = Enum.Font.GothamBold
vLabel.TextXAlignment = Enum.TextXAlignment.Center
vLabel.Parent = visualsContent

local espEnabled = false
local function toggleESP(state)
    espEnabled = state
    Events:Fire("ESP", state)
end

createAeroCard(visualsContent, "Resource ESP", 32, false, function(state)
    toggleESP(state)
end)

visualsContent.CanvasSize = UDim2.new(0, 0, 0, 80)

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ============================================
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local allContents = {contents[1], contents[2], contents[3]}

local function SwitchTab(index)
    for i, content in pairs(allContents) do
        if content.Visible then
            local slideOut = TweenService:Create(content, tweenInfo, {Position = UDim2.new(0, 0, 0, 30)})
            slideOut:Play()
            task.wait(0.08)
            content.Visible = false
            content.Position = UDim2.new(0, 0, 0, 0)
        end
    end
    local newContent = allContents[index]
    newContent.Position = UDim2.new(0, 0, 0, 30)
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
-- АВТО-ЗАГРУЗКА МОДУЛЕЙ
-- ============================================
local function loadModuleFromGit(name, url)
    local success, module = pcall(function()
        local script = loadstring(game:HttpGet(url))()
        return script
    end)
    if success and module and type(module) == "table" then
        print("[ASTRA] Модуль " .. name .. " загружен с GitHub!")
        return module
    else
        print("[ASTRA] Модуль " .. name .. " не загружен с GitHub.")
        return nil
    end
end

task.wait(1)

local desrtModule = loadModuleFromGit("AstraHub_A_Desrt", "https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Desrt.lua")
local longRoadModule = loadModuleFromGit("AstraHub_A_Long_Road", "https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Long_Road.lua")

if desrtModule then
    print("[ASTRA] A Desert модуль активен!")
end

if longRoadModule then
    print("[ASTRA] A Long Road модуль активен!")
end

print("ASTRA HUB V3.0 — АККОРДЕОНЫ С LAYOUTORDER ЗАГРУЖЕНЫ!")
