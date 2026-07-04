-- ASTRA HUB V3.0 — ФИНАЛ (МГНОВЕННОЕ НЕБО)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ПРЕДЗАГРУЗКА
local BG_ID = "rbxassetid://76908073265475"
ContentProvider:PreloadAsync({BG_ID})

-- ГЛОБАЛЬНЫЕ СОБЫТИЯ
local Events = {}
function Events:Fire(name, ...)
    if self[name] then
        for _, cb in pairs(self[name]) do task.spawn(cb, ...) end
    end
end
function Events:Connect(name, cb)
    if not self[name] then self[name] = {} end
    table.insert(self[name], cb)
end
getgenv().AstraEvents = Events

-- НАСТРОЙКИ
local settings = { 
    Theme = "Astral", 
    Transparent = false,
    MenuBackground = "Space",
    Skybox = "Clouds",
}
local themeColors = {
    Astral = Color3.fromRGB(25,15,45),
    Blood = Color3.fromRGB(60,15,20),
    Ocean = Color3.fromRGB(10,25,50),
    Dark = Color3.fromRGB(10,10,15)
}
local themeNames = {"Astral","Blood","Ocean","Dark"}

-- СПИСОК ФОНОВ ДЛЯ МЕНЮ
local menuBackgrounds = {
    ["Default"] = "",
    ["Space"] = BG_ID,
}

-- СПИСОК НЕБЕС
local skyboxList = {
    ["Default"] = "",
    ["Clouds"] = "rbxassetid://8373058195",
    ["Space"] = "rbxassetid://107291590742397",
    ["Sunset"] = "rbxassetid://15983996673",
    ["Anime"] = "rbxassetid://591067775",
    ["Sky2"] = "rbxassetid://4607457995",
    ["Sky3"] = "rbxassetid://7108851308",
}

local isOpen = false
local mainFrame, floatingBtn, bgImage

-- ============================================
-- ФУНКЦИЯ СМЕНЫ НЕБА (МГНОВЕННАЯ!)
-- ============================================
local function updateSkybox(id)
    local oldSky = Lighting:FindFirstChild("AstraSky")
    if oldSky then oldSky:Destroy() end
    
    if id == "" then return end
    
    local newSky = Instance.new("Sky")
    newSky.Name = "AstraSky"
    newSky.SkyboxUp = id
    newSky.Parent = Lighting

    -- МГНОВЕННОЕ ОБНОВЛЕНИЕ (ДЁРГАЕМ ЯРКОСТЬ)
    Lighting.Brightness = Lighting.Brightness + 0.01
    task.wait(0.05)
    Lighting.Brightness = Lighting.Brightness - 0.01
end

-- Применяем начальное небо
updateSkybox(skyboxList[settings.Skybox])

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА
-- ============================================
floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0,150,0,38)
floatingBtn.Position = UDim2.new(0.5,-75,0.05,0)
floatingBtn.AnchorPoint = Vector2.new(0.5,0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(15,12,25)
floatingBtn.BackgroundTransparency = 0.15
floatingBtn.BorderSizePixel = 2
floatingBtn.BorderColor3 = Color3.fromRGB(138,43,226)
floatingBtn.Text = "Open Script"
floatingBtn.TextColor3 = Color3.fromRGB(255,255,255)
floatingBtn.TextSize = 13
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.Parent = ScreenGui
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1,0)
btnCorner.Parent = floatingBtn

-- ДРАГАБЛ КНОПКИ
local dragData = {}
floatingBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragData.dragging = true
        dragData.start = inp.Position
        dragData.pos = floatingBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if not dragData.dragging then return end
    if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = inp.Position - dragData.start
    floatingBtn.Position = UDim2.new(dragData.pos.X.Scale, dragData.pos.X.Offset + delta.X, dragData.pos.Y.Scale, dragData.pos.Y.Offset + delta.Y)
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragData.dragging = false
    end
end)

-- ФОН МЕНЮ
bgImage = Instance.new("ImageLabel")
bgImage.Name = "AstraBackground"
bgImage.Size = UDim2.new(0, 380, 0, 320)
bgImage.AnchorPoint = Vector2.new(0.5, 0.5)
bgImage.Position = UDim2.new(0.5, 0, 0.5, 0)
bgImage.BackgroundTransparency = 1
bgImage.ZIndex = 0
bgImage.Image = menuBackgrounds[settings.MenuBackground]
bgImage.ScaleType = Enum.ScaleType.Fit
bgImage.Visible = false
bgImage.Parent = ScreenGui

-- ОСНОВНОЕ ОКНО
mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,0,0,0)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.BackgroundColor3 = themeColors[settings.Theme]
mainFrame.BackgroundTransparency = settings.Transparent and 0.2 or 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.ZIndex = 1
mainFrame.Parent = ScreenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,14)
mainCorner.Parent = mainFrame

-- СИНХРОНИЗАЦИЯ ФОНА
mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    bgImage.Position = mainFrame.Position
end)
mainFrame:GetPropertyChangedSignal("Size"):Connect(function()
    bgImage.Size = mainFrame.Size
end)
mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    bgImage.Visible = mainFrame.Visible
end)

-- ОТКРЫТИЕ/ЗАКРЫТИЕ
local function openMenu()
    if not mainFrame then return end
    isOpen = true
    floatingBtn.Visible = false
    mainFrame.Visible = true
    bgImage.Visible = true
    mainFrame.Size = UDim2.new(0,0,0,0)
    bgImage.Size = UDim2.new(0,0,0,0)
    TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,380,0,320)}):Play()
    TweenService:Create(bgImage, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,380,0,320)}):Play()
end
local function closeMenu()
    if not mainFrame then return end
    isOpen = false
    local t = TweenService:Create(mainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
    t:Play()
    local t2 = TweenService:Create(bgImage, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
    t2:Play()
    t.Completed:Wait()
    mainFrame.Visible = false
    bgImage.Visible = false
    floatingBtn.Visible = true
end

UserInputService.InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then closeMenu() else openMenu() end
    end
end)
floatingBtn.MouseButton1Click:Connect(openMenu)
floatingBtn.TouchTap:Connect(openMenu)

-- ДРАГАБЛ ОКНА
local winDrag = {}
mainFrame.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        winDrag.dragging = true
        winDrag.start = inp.Position
        winDrag.pos = mainFrame.Position
    end
end)
mainFrame.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
        winDrag.move = inp
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if inp == winDrag.move and winDrag.dragging then
        local delta = inp.Position - winDrag.start
        mainFrame.Position = UDim2.new(winDrag.pos.X.Scale, winDrag.pos.X.Offset + delta.X, winDrag.pos.Y.Scale, winDrag.pos.Y.Offset + delta.Y)
    end
end)

-- ШАПКА
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,36)
header.BackgroundColor3 = Color3.fromRGB(20,18,32)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame
local hCorner = Instance.new("UICorner")
hCorner.CornerRadius = UDim.new(0,14)
hCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5,0,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "ASTRA HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local versionTag = Instance.new("Frame")
versionTag.Size = UDim2.new(0,40,0,18)
versionTag.Position = UDim2.new(0,100,0.5,0)
versionTag.AnchorPoint = Vector2.new(0,0.5)
versionTag.BackgroundColor3 = Color3.fromRGB(138,43,226)
versionTag.BorderSizePixel = 1
versionTag.BorderColor3 = Color3.fromRGB(255,255,255)
versionTag.Parent = header
local vCorner = Instance.new("UICorner")
vCorner.CornerRadius = UDim.new(0,4)
vCorner.Parent = versionTag
local vText = Instance.new("TextLabel")
vText.Size = UDim2.new(1,0,1,0)
vText.BackgroundTransparency = 1
vText.Text = "V3.0"
vText.TextColor3 = Color3.fromRGB(255,255,255)
vText.TextSize = 10
vText.Font = Enum.Font.GothamBold
vText.Parent = versionTag

-- MACOS КНОПКИ
local function makeMacBtn(x, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,10,0,10)
    b.Position = UDim2.new(1,x,0.5,0)
    b.AnchorPoint = Vector2.new(0,0.5)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = ""
    b.Parent = header
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1,0)
    c.Parent = b
    b.MouseButton1Click:Connect(cb)
end
makeMacBtn(-48, Color3.fromRGB(255,69,58), function() ScreenGui:Destroy() end)
makeMacBtn(-34, Color3.fromRGB(255,189,46), closeMenu)
makeMacBtn(-20, Color3.fromRGB(50,215,75), function() 
    mainFrame.Position = UDim2.new(0.5,0,0.5,0)
end)

-- ЛЕВАЯ ПАНЕЛЬ
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0,80,1,-36)
leftPanel.Position = UDim2.new(0,0,0,36)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

local tabNames = {"Features","Settings","Visuals"}
local tabBtns = {}
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,24)
    btn.Position = UDim2.new(0.05,0,0,6 + (i-1)*30)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180,180,200)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = leftPanel
    tabBtns[i] = btn
end

-- ПРАВАЯ ПАНЕЛЬ
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1,-85,1,-36)
rightPanel.Position = UDim2.new(0,82,0,36)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = mainFrame

local contents = {}
for i = 1,3 do
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.CanvasSize = UDim2.new(0,0,0,0)
    f.ScrollBarThickness = 2
    f.ScrollBarImageColor3 = Color3.fromRGB(80,40,140)
    f.Visible = (i == 1)
    f.Parent = rightPanel
    contents[i] = f
end

-- КАРТОЧКА С АНИМАЦИЕЙ
local function createCard(parent, title, defaultOn, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,-10,0,32)
    card.BackgroundColor3 = Color3.fromRGB(30,28,45)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0,8)
    cCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6,0,1,0)
    label.Position = UDim2.new(0,12,0,0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0,40,0,22)
    toggle.Position = UDim2.new(1,-12,0.5,0)
    toggle.AnchorPoint = Vector2.new(1,0.5)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(138,43,226) or Color3.fromRGB(60,60,75)
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Parent = card
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1,0)
    tCorner.Parent = toggle

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0,18,0,18)
    circle.Position = defaultOn and UDim2.new(1,-20,0.5,0) or UDim2.new(0,2,0.5,0)
    circle.AnchorPoint = Vector2.new(0,0.5)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circle.BackgroundTransparency = 0.05
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    local cCorner2 = Instance.new("UICorner")
    cCorner2.CornerRadius = UDim.new(1,0)
    cCorner2.Parent = circle

    local isOn = defaultOn or false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    toggle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            isOn = not isOn
            if isOn then
                TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(138,43,226)}):Play()
                TweenService:Create(circle, tweenInfo, {Position = UDim2.new(1,-20,0.5,0)}):Play()
            else
                TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60,60,75)}):Play()
                TweenService:Create(circle, tweenInfo, {Position = UDim2.new(0,2,0.5,0)}):Play()
            end
            if callback then callback(isOn) end
        end
    end)
    return card
end

-- АККОРДЕОН
local function createAccordion(parent, title, order, elements)
    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1,-10,0,28)
    headerBtn.BackgroundColor3 = Color3.fromRGB(40,35,60)
    headerBtn.BackgroundTransparency = 0.2
    headerBtn.BorderSizePixel = 0
    headerBtn.Text = "▶ " .. title
    headerBtn.TextColor3 = Color3.fromRGB(220,220,240)
    headerBtn.TextSize = 13
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left
    headerBtn.Parent = parent
    headerBtn.LayoutOrder = order
    local hCorner2 = Instance.new("UICorner")
    hCorner2.CornerRadius = UDim.new(0,8)
    hCorner2.Parent = headerBtn

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,0)
    container.Position = UDim2.new(0,0,0,28)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.Parent = parent
    container.LayoutOrder = order

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,4)
    layout.Parent = container

    local isOpen = false
    local height = 0
    for _, el in pairs(elements) do
        createCard(container, el.title, el.defaultOn, el.callback)
        height = height + 32
    end

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        headerBtn.Text = (isOpen and "▼ " or "▶ ") .. title
        TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1,0,0,isOpen and height or 0)
        }):Play()
    end)
end

-- FEATURES
local fContent = contents[1]
fContent.CanvasSize = UDim2.new(0,0,0,200)
local fLabel = Instance.new("TextLabel")
fLabel.Size = UDim2.new(1,0,0,28)
fLabel.Position = UDim2.new(0,0,0,2)
fLabel.BackgroundTransparency = 1
fLabel.Text = "Features"
fLabel.TextColor3 = Color3.fromRGB(255,255,255)
fLabel.TextSize = 14
fLabel.Font = Enum.Font.GothamBold
fLabel.TextXAlignment = Enum.TextXAlignment.Center
fLabel.Parent = fContent

local accordLayout = Instance.new("UIListLayout")
accordLayout.SortOrder = Enum.SortOrder.LayoutOrder
accordLayout.Padding = UDim.new(0,12)
accordLayout.Parent = fContent

createAccordion(fContent, "Movement", 1, {
    {title = "Speed Boost", defaultOn = false, callback = function(s) Events:Fire("SpeedBoost", s) end},
    {title = "Auto Collect", defaultOn = false, callback = function(s) Events:Fire("AutoCollect", s) end},
})
createAccordion(fContent, "Combat", 2, {
    {title = "Fast Attack", defaultOn = false, callback = function(s) Events:Fire("FastAttack", s) end},
})
fContent.CanvasSize = UDim2.new(0,0,0,180)

-- SETTINGS
local sContent = contents[2]
sContent.CanvasSize = UDim2.new(0,0,0,400)
local sLabel = Instance.new("TextLabel")
sLabel.Size = UDim2.new(1,0,0,28)
sLabel.Position = UDim2.new(0,0,0,2)
sLabel.BackgroundTransparency = 1
sLabel.Text = "Settings"
sLabel.TextColor3 = Color3.fromRGB(255,255,255)
sLabel.TextSize = 14
sLabel.Font = Enum.Font.GothamBold
sLabel.TextXAlignment = Enum.TextXAlignment.Center
sLabel.Parent = sContent

local sLayout = Instance.new("UIListLayout")
sLayout.Padding = UDim.new(0,8)
sLayout.SortOrder = Enum.SortOrder.LayoutOrder
sLayout.Parent = sContent

-- TRANSPARENCY
local function createSetting(parent, title, defaultOn, cb)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,-10,0,32)
    card.BackgroundColor3 = Color3.fromRGB(30,28,45)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    card.LayoutOrder = 1
    local cCorner3 = Instance.new("UICorner")
    cCorner3.CornerRadius = UDim.new(0,8)
    cCorner3.Parent = card
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6,0,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0,40,0,22)
    toggle.Position = UDim2.new(1,-12,0.5,0)
    toggle.AnchorPoint = Vector2.new(1,0.5)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(138,43,226) or Color3.fromRGB(60,60,75)
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Parent = card
    local tCorner2 = Instance.new("UICorner")
    tCorner2.CornerRadius = UDim.new(1,0)
    tCorner2.Parent = toggle
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0,18,0,18)
    circle.Position = defaultOn and UDim2.new(1,-20,0.5,0) or UDim2.new(0,2,0.5,0)
    circle.AnchorPoint = Vector2.new(0,0.5)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circle.BackgroundTransparency = 0.05
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    local cCorner4 = Instance.new("UICorner")
    cCorner4.CornerRadius = UDim.new(1,0)
    cCorner4.Parent = circle
    local isOn = defaultOn or false
    local tInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    toggle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            isOn = not isOn
            if isOn then
                TweenService:Create(toggle, tInfo, {BackgroundColor3 = Color3.fromRGB(138,43,226)}):Play()
                TweenService:Create(circle, tInfo, {Position = UDim2.new(1,-20,0.5,0)}):Play()
            else
                TweenService:Create(toggle, tInfo, {BackgroundColor3 = Color3.fromRGB(60,60,75)}):Play()
                TweenService:Create(circle, tInfo, {Position = UDim2.new(0,2,0.5,0)}):Play()
            end
            if cb then cb(isOn) end
        end
    end)
end

createSetting(sContent, "Transparency", false, function(s)
    settings.Transparent = s
    mainFrame.BackgroundTransparency = s and 0.2 or 0.1
end)

-- THEMES DROPDOWN
local function createThemeDropdown(parent)
    local themeCard = Instance.new("Frame")
    themeCard.Size = UDim2.new(1,-10,0,32)
    themeCard.BackgroundColor3 = Color3.fromRGB(30,28,45)
    themeCard.BackgroundTransparency = 0.3
    themeCard.BorderSizePixel = 0
    themeCard.ClipsDescendants = true
    themeCard.Parent = parent
    themeCard.LayoutOrder = 2
    local tCardCorner = Instance.new("UICorner")
    tCardCorner.CornerRadius = UDim.new(0,8)
    tCardCorner.Parent = themeCard

    local themeHeader = Instance.new("TextButton")
    themeHeader.Size = UDim2.new(1,0,0,32)
    themeHeader.BackgroundTransparency = 1
    themeHeader.Text = "Theme: " .. settings.Theme
    themeHeader.TextColor3 = Color3.fromRGB(255,255,255)
    themeHeader.TextSize = 13
    themeHeader.Font = Enum.Font.GothamBold
    themeHeader.TextXAlignment = Enum.TextXAlignment.Left
    themeHeader.TextYAlignment = Enum.TextYAlignment.Center
    themeHeader.Parent = themeCard

    local themeArrow = Instance.new("TextLabel")
    themeArrow.Size = UDim2.new(0,20,1,0)
    themeArrow.Position = UDim2.new(1,-12,0,0)
    themeArrow.BackgroundTransparency = 1
    themeArrow.Text = "▼"
    themeArrow.TextColor3 = Color3.fromRGB(180,180,200)
    themeArrow.TextSize = 14
    themeArrow.Font = Enum.Font.GothamBold
    themeArrow.TextXAlignment = Enum.TextXAlignment.Right
    themeArrow.TextYAlignment = Enum.TextYAlignment.Center
    themeArrow.Parent = themeHeader

    local themeList = Instance.new("ScrollingFrame")
    themeList.Size = UDim2.new(1,0,0,0)
    themeList.Position = UDim2.new(0,0,0,32)
    themeList.BackgroundTransparency = 1
    themeList.BorderSizePixel = 0
    themeList.ScrollBarThickness = 4
    themeList.ScrollBarImageColor3 = Color3.fromRGB(138,43,226)
    themeList.ClipsDescendants = true
    themeList.Parent = themeCard

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0,2)
    listLayout.Parent = themeList
    themeList.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local isThemeOpen = false
    themeCard.Size = UDim2.new(1,-10,0,32)

    for i, opt in pairs(themeNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,28)
        btn.BackgroundColor3 = Color3.fromRGB(40,35,60)
        btn.BackgroundTransparency = 0
        btn.Text = "  " .. opt
        btn.TextColor3 = Color3.fromRGB(220,220,240)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.Parent = themeList
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0,6)
        bCorner.Parent = btn
        if opt == settings.Theme then
            btn.BackgroundColor3 = Color3.fromRGB(138,43,226)
            btn.BackgroundTransparency = 0.2
            btn.BorderSizePixel = 2
            btn.BorderColor3 = Color3.fromRGB(138,43,226)
        end
        btn.MouseButton1Click:Connect(function()
            settings.Theme = opt
            themeHeader.Text = "Theme: " .. opt
            mainFrame.BackgroundColor3 = themeColors[opt]
            isThemeOpen = false
            themeCard.Size = UDim2.new(1,-10,0,32)
            themeList.Size = UDim2.new(1,0,0,0)
            themeArrow.Text = "▼"
        end)
    end

    themeHeader.MouseButton1Click:Connect(function()
        isThemeOpen = not isThemeOpen
        if isThemeOpen then
            themeArrow.Text = "▲"
            themeCard.Size = UDim2.new(1,-10,0,32 + 120)
            themeList.Size = UDim2.new(1,0,0,120)
        else
            themeArrow.Text = "▼"
            themeCard.Size = UDim2.new(1,-10,0,32)
            themeList.Size = UDim2.new(1,0,0,0)
        end
    end)
end

createThemeDropdown(sContent)

-- MENU BACKGROUND DROPDOWN
local function createMenuBackgroundDropdown(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-10,0,32)
    container.BackgroundColor3 = Color3.fromRGB(30,28,45)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = parent
    container.LayoutOrder = 3
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0,8)
    cCorner.Parent = container

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1,0,0,32)
    header.BackgroundTransparency = 1
    header.Text = "Menu BG: " .. settings.MenuBackground
    header.TextColor3 = Color3.fromRGB(255,255,255)
    header.TextSize = 13
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.Parent = container

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0,20,1,0)
    arrow.Position = UDim2.new(1,-12,0,0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(180,180,200)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBold
    arrow.TextXAlignment = Enum.TextXAlignment.Right
    arrow.TextYAlignment = Enum.TextYAlignment.Center
    arrow.Parent = header

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1,0,0,0)
    list.Position = UDim2.new(0,0,0,32)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = Color3.fromRGB(138,43,226)
    list.ClipsDescendants = true
    list.Parent = container

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0,2)
    listLayout.Parent = list
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local isOpen = false
    local bgNames = {}
    for name, _ in pairs(menuBackgrounds) do table.insert(bgNames, name) end

    for i, name in ipairs(bgNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,28)
        btn.BackgroundColor3 = Color3.fromRGB(40,35,60)
        btn.BackgroundTransparency = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(220,220,240)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.Parent = list
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0,6)
        bCorner.Parent = btn
        if name == settings.MenuBackground then
            btn.BackgroundColor3 = Color3.fromRGB(138,43,226)
            btn.BackgroundTransparency = 0.2
        end
        btn.MouseButton1Click:Connect(function()
            settings.MenuBackground = name
            header.Text = "Menu BG: " .. name
            bgImage.Image = menuBackgrounds[name]
            isOpen = false
            container.Size = UDim2.new(1,-10,0,32)
            list.Size = UDim2.new(1,0,0,0)
            arrow.Text = "▼"
        end)
    end

    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            arrow.Text = "▲"
            container.Size = UDim2.new(1,-10,0,32 + 120)
            list.Size = UDim2.new(1,0,0,120)
        else
            arrow.Text = "▼"
            container.Size = UDim2.new(1,-10,0,32)
            list.Size = UDim2.new(1,0,0,0)
        end
    end)
end

createMenuBackgroundDropdown(sContent)

-- SKYBOX DROPDOWN
local function createSkyboxDropdown(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-10,0,32)
    container.BackgroundColor3 = Color3.fromRGB(30,28,45)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = parent
    container.LayoutOrder = 4
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0,8)
    cCorner.Parent = container

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1,0,0,32)
    header.BackgroundTransparency = 1
    header.Text = "Skybox: " .. settings.Skybox
    header.TextColor3 = Color3.fromRGB(255,255,255)
    header.TextSize = 13
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.Parent = container

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0,20,1,0)
    arrow.Position = UDim2.new(1,-12,0,0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(180,180,200)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBold
    arrow.TextXAlignment = Enum.TextXAlignment.Right
    arrow.TextYAlignment = Enum.TextYAlignment.Center
    arrow.Parent = header

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1,0,0,0)
    list.Position = UDim2.new(0,0,0,32)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = Color3.fromRGB(138,43,226)
    list.ClipsDescendants = true
    list.Parent = container

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0,2)
    listLayout.Parent = list
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local isOpen = false
    local skyNames = {}
    for name, _ in pairs(skyboxList) do table.insert(skyNames, name) end

    for i, name in ipairs(skyNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,28)
        btn.BackgroundColor3 = Color3.fromRGB(40,35,60)
        btn.BackgroundTransparency = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(220,220,240)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.Parent = list
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0,6)
        bCorner.Parent = btn
        if name == settings.Skybox then
            btn.BackgroundColor3 = Color3.fromRGB(138,43,226)
            btn.BackgroundTransparency = 0.2
        end
        btn.MouseButton1Click:Connect(function()
            settings.Skybox = name
            header.Text = "Skybox: " .. name
            updateSkybox(skyboxList[name])
            isOpen = false
            container.Size = UDim2.new(1,-10,0,32)
            list.Size = UDim2.new(1,0,0,0)
            arrow.Text = "▼"
        end)
    end

    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            arrow.Text = "▲"
            container.Size = UDim2.new(1,-10,0,32 + 140)
            list.Size = UDim2.new(1,0,0,140)
        else
            arrow.Text = "▼"
            container.Size = UDim2.new(1,-10,0,32)
            list.Size = UDim2.new(1,0,0,0)
        end
    end)
end

createSkyboxDropdown(sContent)
sContent.CanvasSize = UDim2.new(0,0,0,280)

-- VISUALS
local vContent = contents[3]
vContent.CanvasSize = UDim2.new(0,0,0,100)

local vLabel = Instance.new("TextLabel")
vLabel.Size = UDim2.new(1,0,0,28)
vLabel.Position = UDim2.new(0,0,0,2)
vLabel.BackgroundTransparency = 1
vLabel.Text = "Visuals"
vLabel.TextColor3 = Color3.fromRGB(255,255,255)
vLabel.TextSize = 14
vLabel.Font = Enum.Font.GothamBold
vLabel.TextXAlignment = Enum.TextXAlignment.Center
vLabel.Parent = vContent

local vLayout = Instance.new("UIListLayout")
vLayout.Padding = UDim.new(0, 10)
vLayout.SortOrder = Enum.SortOrder.LayoutOrder
vLayout.Parent = vContent

local espEnabled = false
local function toggleESP(s)
    espEnabled = s
    Events:Fire("ESP", s)
end

local espCard = createCard(vContent, "Resource ESP", false, toggleESP)
espCard.LayoutOrder = 1

vContent.CanvasSize = UDim2.new(0,0,0,70)

-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
local function SwitchTab(index)
    for i, content in pairs(contents) do
        content.Visible = (i == index)
        tabBtns[i].TextColor3 = (i == index) and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,200)
        tabBtns[i].BackgroundColor3 = (i == index) and Color3.fromRGB(138,43,226) or Color3.fromRGB(25,25,35)
        tabBtns[i].BackgroundTransparency = (i == index) and 0.2 or 1
    end
end
for i, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

-- ЗАГРУЗКА МОДУЛЕЙ
task.wait(1)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Desrt.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Long_Road.lua"))()
end)
print("ASTRA HUB V3.0 — МГНОВЕННОЕ НЕБО ЗАГРУЖЕНО!")
