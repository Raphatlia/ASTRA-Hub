-- ASTRA HUB V3.0 — ЧИСТАЯ ВЕРСИЯ (БЕЗ ФОНОВ)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")

-- УБИВАЕМ ВСЁ СТАРОЕ
local function KillOldGUI()
    local playerGui = LP:WaitForChild("PlayerGui")
    for _, obj in pairs(playerGui:GetChildren()) do
        if obj:IsA("ScreenGui") then
            if obj.Name:find("Astra") or obj.Name:find("GUI") or obj.Name:find("Hub") then
                pcall(function() obj:Destroy() end)
            end
        end
    end
end
KillOldGUI()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ============================================
-- ЗАГРУЗОЧНОЕ СООБЩЕНИЕ
-- ============================================
local loader = Instance.new("TextLabel")
loader.Size = UDim2.new(0, 200, 0, 40)
loader.Position = UDim2.new(1, -20, 0, 20)
loader.AnchorPoint = Vector2.new(1, 0)
loader.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
loader.BackgroundTransparency = 0.3
loader.BorderSizePixel = 0
loader.Text = "ASTRA HUB - Loading Script..."
loader.TextColor3 = Color3.fromRGB(255, 255, 255)
loader.TextSize = 12
loader.Font = Enum.Font.GothamBold
loader.Parent = ScreenGui
local loaderCorner = Instance.new("UICorner")
loaderCorner.CornerRadius = UDim.new(0, 8)
loaderCorner.Parent = loader
task.delay(3, function()
    TweenService:Create(loader, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1.2, 0, 0, 20)
    }):Play()
    task.wait(0.5)
    loader:Destroy()
end)

-- ============================================
-- TOAST-УВЕДОМЛЕНИЯ
-- ============================================
local toastContainer = Instance.new("Frame")
toastContainer.Size = UDim2.new(0, 260, 0, 0)
toastContainer.Position = UDim2.new(1, -20, 0, 70)
toastContainer.AnchorPoint = Vector2.new(1, 0)
toastContainer.BackgroundTransparency = 1
toastContainer.Parent = ScreenGui

local function ShowToast(text, isSuccess)
    local toast = Instance.new("TextLabel")
    toast.Size = UDim2.new(1, 0, 0, 40)
    toast.BackgroundColor3 = isSuccess and Color3.fromRGB(20, 30, 20) or Color3.fromRGB(30, 20, 20)
    toast.BackgroundTransparency = 0.2
    toast.BorderSizePixel = 0
    toast.Text = text
    toast.TextColor3 = Color3.fromRGB(255, 255, 255)
    toast.TextSize = 12
    toast.Font = Enum.Font.GothamBold
    toast.Parent = toastContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toast
    toast.Position = UDim2.new(1, 0, 0, 0)
    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(3)
    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    toast:Destroy()
end

-- ============================================
-- ПРЕДЗАГРУЗКА
-- ============================================
local ICON_ID = "rbxassetid://125002618965503"
ContentProvider:PreloadAsync({ICON_ID})

-- ============================================
-- СОБЫТИЯ
-- ============================================
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

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = { 
    Theme = "Astral", 
    Transparent = false,
    Skybox = "Clouds",
    GUISize = "Medium",
}
local themeColors = {
    Astral = Color3.fromRGB(25,15,45),
    Blood = Color3.fromRGB(60,15,20),
    Ocean = Color3.fromRGB(10,25,50),
    Dark = Color3.fromRGB(10,10,15)
}
local themeNames = {"Astral","Blood","Ocean","Dark"}

local skyboxList = {
    ["Clouds"] = "rbxassetid://8373058195",
}

local guiSizes = {
    ["Small"] = UDim2.new(0, 380, 0, 300),
    ["Medium"] = UDim2.new(0, 480, 0, 380),
    ["Large"] = UDim2.new(0, 580, 0, 450),
}

local isOpen = false
local mainFrame, floatingBtn
local animDuration = 0.39

-- ============================================
-- НЕБО
-- ============================================
local function updateSkybox(id)
    local oldSky = Lighting:FindFirstChild("AstraSky")
    if oldSky then oldSky:Destroy() end
    if id == "" then return end
    local newSky = Instance.new("Sky")
    newSky.Name = "AstraSky"
    newSky.SkyboxUp = id
    newSky.Parent = Lighting
    Lighting.Brightness = Lighting.Brightness + 0.01
    task.wait(0.05)
    Lighting.Brightness = Lighting.Brightness - 0.01
end
updateSkybox(skyboxList[settings.Skybox])

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА
-- ============================================
floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 175, 0, 44)
floatingBtn.Position = UDim2.new(0.5, -87.5, 0.05, 0)
floatingBtn.AnchorPoint = Vector2.new(0.5, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
floatingBtn.BackgroundTransparency = 0.1
floatingBtn.Text = ""
floatingBtn.BorderSizePixel = 0
floatingBtn.Parent = ScreenGui
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(138, 43, 226)
mainStroke.Transparency = 0
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.ZIndex = 1
mainStroke.Parent = floatingBtn
local glowStroke = Instance.new("UIStroke")
glowStroke.Thickness = 4
glowStroke.Color = Color3.fromRGB(138, 43, 226)
glowStroke.Transparency = 0.6
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glowStroke.ZIndex = -1
glowStroke.Parent = floatingBtn
local dragIcon = Instance.new("ImageLabel")
dragIcon.Size = UDim2.new(0, 38, 1, 0)
dragIcon.BackgroundColor3 = Color3.fromRGB(28, 26, 38)
dragIcon.BackgroundTransparency = 0.2
dragIcon.BorderSizePixel = 0
dragIcon.Image = ICON_ID
dragIcon.ScaleType = Enum.ScaleType.Fit
dragIcon.Parent = floatingBtn
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = dragIcon
local line = Instance.new("Frame")
line.Size = UDim2.new(0, 1, 0, 28)
line.Position = UDim2.new(0, 38, 0.5, 0)
line.AnchorPoint = Vector2.new(0, 0.5)
line.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
line.BorderSizePixel = 0
line.Parent = floatingBtn
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -50, 1, 0)
label.Position = UDim2.new(0, 45, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Open Script"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 14
label.Font = Enum.Font.Gotham
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center
label.Parent = floatingBtn

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

-- ============================================
-- ОТКРЫТИЕ/ЗАКРЫТИЕ
-- ============================================
local function openMenu()
    if not mainFrame then return end
    if isOpen then return end
    isOpen = true
    floatingBtn.Visible = false
    mainFrame.Visible = true
    local size = guiSizes[settings.GUISize] or guiSizes["Medium"]
    mainFrame.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(mainFrame, TweenInfo.new(animDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = size
    }):Play()
end

local function closeMenu()
    if not mainFrame then return end
    if not isOpen then return end
    isOpen = false
    local size = guiSizes[settings.GUISize] or guiSizes["Medium"]
    local shrinkTarget = UDim2.new(size.X.Scale, size.X.Offset, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(animDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = shrinkTarget
    }):Play()
    task.wait(animDuration + 0.05)
    mainFrame.Visible = false
    floatingBtn.Visible = true
end

UserInputService.InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then closeMenu() else openMenu() end
    end
end)
floatingBtn.MouseButton1Click:Connect(openMenu)
floatingBtn.TouchTap:Connect(openMenu)

-- ============================================
-- ОСНОВНОЕ ОКНО (ЧИСТОЕ, БЕЗ ФОНА)
-- ============================================
mainFrame = Instance.new("Frame")
local defaultSize = guiSizes[settings.GUISize] or guiSizes["Medium"]
mainFrame.Size = defaultSize
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = themeColors[settings.Theme]
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = ScreenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

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

-- ============================================
-- ШАПКА
-- ============================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame
local hCorner = Instance.new("UICorner")
hCorner.CornerRadius = UDim.new(0, 14)
hCorner.Parent = header

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
local vCorner = Instance.new("UICorner")
vCorner.CornerRadius = UDim.new(0, 4)
vCorner.Parent = versionTag
local vText = Instance.new("TextLabel")
vText.Size = UDim2.new(1, 0, 1, 0)
vText.BackgroundTransparency = 1
vText.Text = "V3.0"
vText.TextColor3 = Color3.fromRGB(255, 255, 255)
vText.TextSize = 10
vText.Font = Enum.Font.GothamBold
vText.Parent = versionTag

local function makeMacBtn(x, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 10, 0, 10)
    b.Position = UDim2.new(1, x, 0.5, 0)
    b.AnchorPoint = Vector2.new(0, 0.5)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = ""
    b.Parent = header
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = b
    b.MouseButton1Click:Connect(cb)
end
makeMacBtn(-48, Color3.fromRGB(255, 69, 58), function() ScreenGui:Destroy() end)
makeMacBtn(-34, Color3.fromRGB(255, 189, 46), closeMenu)
makeMacBtn(-20, Color3.fromRGB(50, 215, 75), function() 
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end)

-- ============================================
-- ЛЕВАЯ ПАНЕЛЬ
-- ============================================
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 100, 1, -36)
leftPanel.Position = UDim2.new(0, 0, 0, 36)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

local tabNames = {"Features", "Settings", "Visuals", "Player"}
local tabBtns = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, 6 + (i - 1) * 34)
    btn.BackgroundTransparency = 0.8
    btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = leftPanel
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    tabBtns[i] = btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.4,
            BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.8,
            BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        }):Play()
    end)
end

-- ============================================
-- ПРАВАЯ ПАНЕЛЬ
-- ============================================
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -110, 1, -36)
rightPanel.Position = UDim2.new(0, 105, 0, 36)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = mainFrame

local contents = {}
for i = 1, #tabNames do
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.ScrollBarThickness = 3
    f.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    f.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    f.Visible = (i == 1)
    f.Parent = rightPanel
    contents[i] = f
end

-- ============================================
-- КАРТОЧКА
-- ============================================
local function createCard(parent, title, defaultOn, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 30)
    card.BackgroundColor3 = Color3.fromRGB(25, 23, 40)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 8)
    cCorner.Parent = card
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = Color3.fromRGB(40, 35, 55)
        }):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(25, 23, 40)
        }):Play()
    end)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = card
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 38, 0, 20)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(55, 55, 70)
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Parent = card
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggle
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultOn and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    circle.AnchorPoint = Vector2.new(0, 0.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.1
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    local cCorner2 = Instance.new("UICorner")
    cCorner2.CornerRadius = UDim.new(1, 0)
    cCorner2.Parent = circle
    local isOn = defaultOn or false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    toggle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            isOn = not isOn
            local targetColor = isOn and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(55, 55, 70)
            local targetPos = isOn and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(circle, tweenInfo, {Position = targetPos}):Play()
            if callback then callback(isOn) end
        end
    end)
    return card
end

-- ============================================
-- АККОРДЕОН
-- ============================================
local function createAccordion(parent, title, order, elements)
    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, -10, 0, 28)
    headerBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    headerBtn.BackgroundTransparency = 0.3
    headerBtn.BorderSizePixel = 0
    headerBtn.Text = "▶ " .. title
    headerBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    headerBtn.TextSize = 11
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left
    headerBtn.Parent = parent
    headerBtn.LayoutOrder = order
    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 8)
    hCorner.Parent = headerBtn
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Position = UDim2.new(0, 0, 0, 28)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.Parent = parent
    container.LayoutOrder = order
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = container
    local isOpen = false
    local height = 0
    for _, el in pairs(elements) do
        createCard(container, el.title, el.defaultOn, el.callback)
        height = height + 30
    end
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        headerBtn.Text = (isOpen and "▼ " or "▶ ") .. title
        TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, isOpen and height or 0)
        }):Play()
    end)
end

-- ============================================
-- FEATURES
-- ============================================
local fContent = contents[1]
fContent.CanvasSize = UDim2.new(0, 0, 0, 200)
local fLabel = Instance.new("TextLabel")
fLabel.Size = UDim2.new(1, 0, 0, 28)
fLabel.Position = UDim2.new(0, 0, 0, 2)
fLabel.BackgroundTransparency = 1
fLabel.Text = "Features"
fLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fLabel.TextSize = 13
fLabel.Font = Enum.Font.GothamBold
fLabel.TextXAlignment = Enum.TextXAlignment.Center
fLabel.Parent = fContent
local accordLayout = Instance.new("UIListLayout")
accordLayout.SortOrder = Enum.SortOrder.LayoutOrder
accordLayout.Padding = UDim.new(0, 6)
accordLayout.Parent = fContent
createAccordion(fContent, "Movement", 1, {
    {title = "Speed Boost", defaultOn = false, callback = function(s) 
        ShowToast("Speed Boost: " .. (s and "Включён" or "Выключен"), s)
        Events:Fire("SpeedBoost", s) 
    end},
    {title = "Auto Collect", defaultOn = false, callback = function(s) 
        ShowToast("Auto Collect: " .. (s and "Включён" or "Выключен"), s)
        Events:Fire("AutoCollect", s) 
    end},
})
createAccordion(fContent, "Combat", 2, {
    {title = "Fast Attack", defaultOn = false, callback = function(s) 
        ShowToast("Fast Attack: " .. (s and "Включён" or "Выключен"), s)
        Events:Fire("FastAttack", s) 
    end},
})
fContent.CanvasSize = UDim2.new(0, 0, 0, 150)

-- ============================================
-- SETTINGS
-- ============================================
local sContent = contents[2]
sContent.CanvasSize = UDim2.new(0, 0, 0, 200)
local sLabel = Instance.new("TextLabel")
sLabel.Size = UDim2.new(1, 0, 0, 28)
sLabel.Position = UDim2.new(0, 0, 0, 2)
sLabel.BackgroundTransparency = 1
sLabel.Text = "Settings"
sLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sLabel.TextSize = 13
sLabel.Font = Enum.Font.GothamBold
sLabel.TextXAlignment = Enum.TextXAlignment.Center
sLabel.Parent = sContent

local sLayout = Instance.new("UIListLayout")
sLayout.Padding = UDim.new(0, 6)
sLayout.SortOrder = Enum.SortOrder.LayoutOrder
sLayout.Parent = sContent

-- TRANSPARENCY
local function createSetting(parent, title, defaultOn, cb)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 28)
    card.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    card.LayoutOrder = 1
    local cCorner3 = Instance.new("UICorner")
    cCorner3.CornerRadius = UDim.new(0, 8)
    cCorner3.Parent = card
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Parent = card
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 38, 0, 20)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 75)
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Parent = card
    local tCorner2 = Instance.new("UICorner")
    tCorner2.CornerRadius = UDim.new(1, 0)
    tCorner2.Parent = toggle
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultOn and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    circle.AnchorPoint = Vector2.new(0, 0.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.05
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    local cCorner4 = Instance.new("UICorner")
    cCorner4.CornerRadius = UDim.new(1, 0)
    cCorner4.Parent = circle
    local isOn = defaultOn or false
    local tInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    toggle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            isOn = not isOn
            if isOn then
                TweenService:Create(toggle, tInfo, {BackgroundColor3 = Color3.fromRGB(138, 43, 226)}):Play()
                TweenService:Create(circle, tInfo, {Position = UDim2.new(1, -18, 0.5, 0)}):Play()
            else
                TweenService:Create(toggle, tInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
                TweenService:Create(circle, tInfo, {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
            end
            if cb then cb(isOn) end
        end
    end)
end

createSetting(sContent, "Transparency", false, function(s)
    settings.Transparent = s
    ShowToast("Transparency: " .. (s and "Включена" or "Выключена"), s)
end)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(0.9, 0, 0, 1)
sep.Position = UDim2.new(0.05, 0, 0, 0)
sep.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
sep.BackgroundTransparency = 0.5
sep.BorderSizePixel = 0
sep.Parent = sContent

-- THEMES DROPDOWN
local function createThemeDropdown(parent)
    local themeCard = Instance.new("Frame")
    themeCard.Size = UDim2.new(1, -10, 0, 28)
    themeCard.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    themeCard.BackgroundTransparency = 0.3
    themeCard.BorderSizePixel = 0
    themeCard.ClipsDescendants = true
    themeCard.Parent = parent
    themeCard.LayoutOrder = 2
    local tCardCorner = Instance.new("UICorner")
    tCardCorner.CornerRadius = UDim.new(0, 8)
    tCardCorner.Parent = themeCard
    local themeHeader = Instance.new("TextButton")
    themeHeader.Size = UDim2.new(1, 0, 0, 28)
    themeHeader.BackgroundTransparency = 1
    themeHeader.Text = "Theme: " .. settings.Theme
    themeHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeHeader.TextSize = 11
    themeHeader.Font = Enum.Font.Gotham
    themeHeader.TextXAlignment = Enum.TextXAlignment.Left
    themeHeader.TextYAlignment = Enum.TextYAlignment.Center
    themeHeader.Parent = themeCard
    local themeArrow = Instance.new("TextLabel")
    themeArrow.Size = UDim2.new(0, 20, 1, 0)
    themeArrow.Position = UDim2.new(1, -12, 0, 0)
    themeArrow.BackgroundTransparency = 1
    themeArrow.Text = "▼"
    themeArrow.TextColor3 = Color3.fromRGB(180, 180, 200)
    themeArrow.TextSize = 12
    themeArrow.Font = Enum.Font.GothamBold
    themeArrow.TextXAlignment = Enum.TextXAlignment.Right
    themeArrow.TextYAlignment = Enum.TextYAlignment.Center
    themeArrow.Parent = themeHeader
    local themeList = Instance.new("ScrollingFrame")
    themeList.Size = UDim2.new(1, 0, 0, 0)
    themeList.Position = UDim2.new(0, 0, 0, 28)
    themeList.BackgroundTransparency = 1
    themeList.BorderSizePixel = 0
    themeList.ScrollBarThickness = 3
    themeList.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    themeList.ClipsDescendants = true
    themeList.Parent = themeCard
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = themeList
    themeList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local isThemeOpen = false
    themeCard.Size = UDim2.new(1, -10, 0, 28)
    for i, opt in pairs(themeNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
        btn.BackgroundTransparency = 0
        btn.Text = "  " .. opt
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.Parent = themeList
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 6)
        bCorner.Parent = btn
        if opt == settings.Theme then
            btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            btn.BackgroundTransparency = 0.2
            btn.BorderSizePixel = 2
            btn.BorderColor3 = Color3.fromRGB(138, 43, 226)
        end
        btn.MouseButton1Click:Connect(function()
            settings.Theme = opt
            themeHeader.Text = "Theme: " .. opt
            mainFrame.BackgroundColor3 = themeColors[opt]
            ShowToast("Theme changed to: " .. opt, true)
            isThemeOpen = false
            themeCard.Size = UDim2.new(1, -10, 0, 28)
            themeList.Size = UDim2.new(1, 0, 0, 0)
            themeArrow.Text = "▼"
        end)
    end
    themeHeader.MouseButton1Click:Connect(function()
        isThemeOpen = not isThemeOpen
        if isThemeOpen then
            themeArrow.Text = "▲"
            themeCard.Size = UDim2.new(1, -10, 0, 28 + 100)
            themeList.Size = UDim2.new(1, 0, 0, 100)
        else
            themeArrow.Text = "▼"
            themeCard.Size = UDim2.new(1, -10, 0, 28)
            themeList.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
end
createThemeDropdown(sContent)

-- SKYBOX DROPDOWN
local function createSkyboxDropdown(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 28)
    container.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = parent
    container.LayoutOrder = 3
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 8)
    cCorner.Parent = container
    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundTransparency = 1
    header.Text = "Skybox: " .. settings.Skybox
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 11
    header.Font = Enum.Font.Gotham
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.Parent = container
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -12, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(180, 180, 200)
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.TextXAlignment = Enum.TextXAlignment.Right
    arrow.TextYAlignment = Enum.TextYAlignment.Center
    arrow.Parent = header
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 0, 28)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    list.ClipsDescendants = true
    list.Parent = container
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = list
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local isOpen = false
    local skyNames = {}
    for name, _ in pairs(skyboxList) do table.insert(skyNames, name) end
    for i, name in ipairs(skyNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
        btn.BackgroundTransparency = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.Parent = list
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 6)
        bCorner.Parent = btn
        if name == settings.Skybox then
            btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            btn.BackgroundTransparency = 0.2
        end
        btn.MouseButton1Click:Connect(function()
            settings.Skybox = name
            header.Text = "Skybox: " .. name
            updateSkybox(skyboxList[name])
            ShowToast("Skybox changed to: " .. name, true)
            isOpen = false
            container.Size = UDim2.new(1, -10, 0, 28)
            list.Size = UDim2.new(1, 0, 0, 0)
            arrow.Text = "▼"
        end)
    end
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            arrow.Text = "▲"
            container.Size = UDim2.new(1, -10, 0, 28 + 60)
            list.Size = UDim2.new(1, 0, 0, 60)
        else
            arrow.Text = "▼"
            container.Size = UDim2.new(1, -10, 0, 28)
            list.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
end
createSkyboxDropdown(sContent)

-- GUI SIZE DROPDOWN
local function createSizeDropdown(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 28)
    container.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = parent
    container.LayoutOrder = 4
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 8)
    cCorner.Parent = container
    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundTransparency = 1
    header.Text = "GUI Size: " .. settings.GUISize
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 11
    header.Font = Enum.Font.Gotham
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.Parent = container
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -12, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(180, 180, 200)
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.TextXAlignment = Enum.TextXAlignment.Right
    arrow.TextYAlignment = Enum.TextYAlignment.Center
    arrow.Parent = header
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 0, 28)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    list.ClipsDescendants = true
    list.Parent = container
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = list
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local isOpen = false
    local sizeNames = {"Small", "Medium", "Large"}
    for i, name in ipairs(sizeNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
        btn.BackgroundTransparency = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.Parent = list
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 6)
        bCorner.Parent = btn
        if name == settings.GUISize then
            btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            btn.BackgroundTransparency = 0.2
        end
        btn.MouseButton1Click:Connect(function()
            settings.GUISize = name
            header.Text = "GUI Size: " .. name
            local newSize = guiSizes[name]
            mainFrame.Size = newSize
            ShowToast("GUI Size changed to: " .. name, true)
            isOpen = false
            container.Size = UDim2.new(1, -10, 0, 28)
            list.Size = UDim2.new(1, 0, 0, 0)
            arrow.Text = "▼"
        end)
    end
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            arrow.Text = "▲"
            container.Size = UDim2.new(1, -10, 0, 28 + 100)
            list.Size = UDim2.new(1, 0, 0, 100)
        else
            arrow.Text = "▼"
            container.Size = UDim2.new(1, -10, 0, 28)
            list.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
end
createSizeDropdown(sContent)
sContent.CanvasSize = UDim2.new(0, 0, 0, 200)

-- ============================================
-- PLAYER
-- ============================================
local pContent = contents[4]
pContent.CanvasSize = UDim2.new(0, 0, 0, 150)
local pLabel = Instance.new("TextLabel")
pLabel.Size = UDim2.new(1, 0, 0, 28)
pLabel.Position = UDim2.new(0, 0, 0, 2)
pLabel.BackgroundTransparency = 1
pLabel.Text = "Player"
pLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pLabel.TextSize = 13
pLabel.Font = Enum.Font.GothamBold
pLabel.TextXAlignment = Enum.TextXAlignment.Center
pLabel.Parent = pContent
local pLayout = Instance.new("UIListLayout")
pLayout.Padding = UDim.new(0, 6)
pLayout.SortOrder = Enum.SortOrder.LayoutOrder
pLayout.Parent = pContent
createAccordion(pContent, "Movement", 1, {
    {title = "Fly", defaultOn = false, callback = function(s) 
        ShowToast("Fly: " .. (s and "Включён" or "Выключен"), s)
        Events:Fire("Fly", s) 
    end},
    {title = "Noclip", defaultOn = false, callback = function(s) 
        ShowToast("Noclip: " .. (s and "Включён" or "Выключен"), s)
        Events:Fire("Noclip", s) 
    end},
    {title = "Infinite Jump", defaultOn = false, callback = function(s) 
        ShowToast("Infinite Jump: " .. (s and "Включён" or "Выключен"), s)
        Events:Fire("InfiniteJump", s) 
    end},
})
pContent.CanvasSize = UDim2.new(0, 0, 0, 120)

-- ============================================
-- VISUALS
-- ============================================
local vContent = contents[3]
vContent.CanvasSize = UDim2.new(0, 0, 0, 80)
local vLabel = Instance.new("TextLabel")
vLabel.Size = UDim2.new(1, 0, 0, 28)
vLabel.Position = UDim2.new(0, 0, 0, 2)
vLabel.BackgroundTransparency = 1
vLabel.Text = "Visuals"
vLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
vLabel.TextSize = 13
vLabel.Font = Enum.Font.GothamBold
vLabel.TextXAlignment = Enum.TextXAlignment.Center
vLabel.Parent = vContent
local vLayout = Instance.new("UIListLayout")
vLayout.Padding = UDim.new(0, 6)
vLayout.SortOrder = Enum.SortOrder.LayoutOrder
vLayout.Parent = vContent
local espEnabled = false
local function toggleESP(s)
    espEnabled = s
    ShowToast("Resource ESP: " .. (s and "Включён" or "Выключен"), s)
    Events:Fire("ESP", s)
end
local espCard = createCard(vContent, "Resource ESP", false, toggleESP)
espCard.LayoutOrder = 1
vContent.CanvasSize = UDim2.new(0, 0, 0, 60)

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ============================================
local function SwitchTab(index)
    for i, content in pairs(contents) do
        content.Visible = (i == index)
        if i == index then
            tabBtns[i].BackgroundTransparency = 0.2
            tabBtns[i].BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            tabBtns[i].TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tabBtns[i].BackgroundTransparency = 0.8
            tabBtns[i].BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            tabBtns[i].TextColor3 = Color3.fromRGB(180, 180, 200)
        end
    end
end
for i, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

-- ============================================
-- ЗАГРУЗКА МОДУЛЕЙ
-- ============================================
task.wait(1)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Desrt.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Long_Road.lua"))()
end)

ShowToast("ASTRA HUB загружен!", true)
print("ASTRA HUB V3.0 — ЧИСТАЯ ВЕРСИЯ ЗАГРУЖЕНА!")
