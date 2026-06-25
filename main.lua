-- ASTRA HUB — ПЕРЕТАСКИВАНИЕ ПО ВСЕЙ РАМКЕ
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ===== ОСНОВНОЕ ОКНО =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 320)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

-- ===== ШАПКА =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
header.BackgroundTransparency = 0.2
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ ASTRA HUB"
title.TextColor3 = Color3.fromRGB(210, 170, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

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

-- ===== ПЛАВАЮЩАЯ ИКОНКА =====
local iconFrame = Instance.new("ImageButton")
iconFrame.Size = UDim2.new(0, 45, 0, 45)
iconFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
iconFrame.AnchorPoint = Vector2.new(0, 0)
iconFrame.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
iconFrame.BackgroundTransparency = 0.2
iconFrame.BorderSizePixel = 2
iconFrame.BorderColor3 = Color3.fromRGB(138, 43, 226)
iconFrame.Image = "rbxassetid://4483362458"
iconFrame.Visible = false
iconFrame.Parent = ScreenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = iconFrame

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "✦"
iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
iconLabel.TextSize = 22
iconLabel.Font = Enum.Font.GothamBold
iconLabel.Parent = iconFrame

-- ===== ЛОГИКА КНОПОК =====
btnRed.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

btnYellow.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    iconFrame.Visible = true
end)

iconFrame.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    iconFrame.Visible = false
end)

-- ===== ПЕРЕТАСКИВАНИЕ ПО ВСЕЙ РАМКЕ =====
local dragging = false
local dragInput, mousePos, framePos

-- Захват нажатия на любую часть меню (кроме кнопок)
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
        mainFrame.Position = UDim2.new(
            framePos.X.Scale, framePos.X.Offset + delta.X,
            framePos.Y.Scale, framePos.Y.Offset + delta.Y
        )
    end
end)

-- ===== ПЕРЕТАСКИВАНИЕ ИКОНКИ =====
local iconDragging = false
local iconDragInput, iconMousePos, iconFramePos

iconFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconMousePos = input.Position
        iconFramePos = iconFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                iconDragging = false
            end
        end)
    end
end)

iconFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        iconDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == iconDragInput and iconDragging then
        local delta = input.Position - iconMousePos
        iconFrame.Position = UDim2.new(
            iconFramePos.X.Scale, iconFramePos.X.Offset + delta.X,
            iconFramePos.Y.Scale, iconFramePos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- ЛЕВАЯ ПАНЕЛЬ
-- ============================================
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 110, 1, -40)
leftPanel.Position = UDim2.new(0, 0, 0, 40)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

local border = Instance.new("Frame")
border.Size = UDim2.new(0, 1, 0.85, 0)
border.Position = UDim2.new(1, -1, 0.075, 0)
border.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
border.BackgroundTransparency = 0.4
border.Parent = leftPanel

-- ===== ПРОФИЛЬ =====
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(0.9, 0, 0, 38)
profileFrame.Position = UDim2.new(0.05, 0, 1, -42)
profileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
profileFrame.BackgroundTransparency = 0.2
profileFrame.BorderSizePixel = 1
profileFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
profileFrame.Parent = leftPanel

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 8)
profileCorner.Parent = profileFrame

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 24, 0, 24)
avatar.Position = UDim2.new(0.08, 0, 0.08, 0)
avatar.BackgroundTransparency = 1
avatar.BorderSizePixel = 1
avatar.BorderColor3 = Color3.fromRGB(60, 60, 80)
avatar.Parent = profileFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatar

local function LoadAvatar()
    local userId = LP.UserId
    if userId then
        avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
    end
end
LoadAvatar()

local avatarFallback = Instance.new("TextLabel")
avatarFallback.Size = UDim2.new(1, 0, 1, 0)
avatarFallback.BackgroundTransparency = 1
avatarFallback.Text = string.sub(LP.Name, 1, 1):upper()
avatarFallback.TextColor3 = Color3.fromRGB(255, 255, 255)
avatarFallback.TextSize = 14
avatarFallback.Font = Enum.Font.GothamBold
avatarFallback.Parent = avatar

local nickname = Instance.new("TextLabel")
nickname.Size = UDim2.new(0.5, 0, 1, 0)
nickname.Position = UDim2.new(0.32, 0, 0, 0)
nickname.BackgroundTransparency = 1
nickname.Text = LP.Name
nickname.TextColor3 = Color3.fromRGB(200, 200, 220)
nickname.TextSize = 11
nickname.Font = Enum.Font.Gotham
nickname.TextXAlignment = Enum.TextXAlignment.Left
nickname.Parent = profileFrame

local arrow = Instance.new("TextLabel")
arrow.Size = UDim2.new(0, 14, 0, 1)
arrow.Position = UDim2.new(0.85, 0, 0, 0)
arrow.BackgroundTransparency = 1
arrow.Text = ">"
arrow.TextColor3 = Color3.fromRGB(140, 140, 170)
arrow.TextSize = 14
arrow.Font = Enum.Font.GothamBold
arrow.Parent = profileFrame

-- ===== КНОПКИ НАВИГАЦИИ =====
local btnData = {"🏠 Home", "⚔️ Combat", "🌾 Farm", "⚙️ Settings"}
local btnObjects = {}

for i = 1, #btnData do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 26)
    btn.Position = UDim2.new(0.075, 0, 0, 8 + (i-1) * 32)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(80, 40, 140) or Color3.fromRGB(30, 30, 40)
    btn.Text = btnData[i]
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 1
    btn.BorderColor3 = (i == 1) and Color3.fromRGB(80, 40, 140) or Color3.fromRGB(40, 40, 50)
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
rightPanel.Size = UDim2.new(1, -120, 1, -40)
rightPanel.Position = UDim2.new(0, 115, 0, 40)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = mainFrame

-- ===== КОНТЕНТ =====
local contents = {}

for i = 1, #btnData do
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.ScrollBarThickness = 4
    f.ScrollBarImageColor3 = Color3.fromRGB(80, 40, 140)
    f.Visible = (i == 1)
    f.Parent = rightPanel
    
    if i == 4 then
        -- Настройки
    else
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 35)
        label.Position = UDim2.new(0, 0, 0.2, 0)
        label.BackgroundTransparency = 1
        label.Text = "📁 " .. btnData[i]
        label.TextColor3 = Color3.fromRGB(200, 200, 220)
        label.TextSize = 16
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Parent = f
        f.CanvasSize = UDim2.new(0, 0, 0, 80)
    end
    contents[i] = f
end

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settingsContent = contents[4]
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 250)

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, 0, 0, 35)
settingsLabel.Position = UDim2.new(0, 0, 0, 5)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "⚙️ Настройки"
settingsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
settingsLabel.TextSize = 16
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.TextXAlignment = Enum.TextXAlignment.Center
settingsLabel.Parent = settingsContent

-- Прозрачность
local transCard = Instance.new("Frame")
transCard.Size = UDim2.new(0.9, 0, 0, 40)
transCard.Position = UDim2.new(0.05, 0, 0, 45)
transCard.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
transCard.BackgroundTransparency = 0.2
transCard.BorderSizePixel = 1
transCard.BorderColor3 = Color3.fromRGB(50, 50, 60)
transCard.Parent = settingsContent

local transCardCorner = Instance.new("UICorner")
transCardCorner.CornerRadius = UDim.new(0, 8)
transCardCorner.Parent = transCard

local transLabel = Instance.new("TextLabel")
transLabel.Size = UDim2.new(0.6, 0, 1, 0)
transLabel.Position = UDim2.new(0, 10, 0, 0)
transLabel.BackgroundTransparency = 1
transLabel.Text = "🪟 Прозрачность"
transLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
transLabel.TextSize = 13
transLabel.Font = Enum.Font.GothamBold
transLabel.TextXAlignment = Enum.TextXAlignment.Left
transLabel.Parent = transCard

local transToggle = Instance.new("TextButton")
transToggle.Size = UDim2.new(0.15, 0, 0, 24)
transToggle.Position = UDim2.new(0.8, 0, 0.1, 0)
transToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
transToggle.Text = "OFF"
transToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
transToggle.TextSize = 11
transToggle.Font = Enum.Font.GothamBold
transToggle.BorderSizePixel = 1
transToggle.BorderColor3 = Color3.fromRGB(50, 50, 60)
transToggle.Parent = transCard

local transCorner = Instance.new("UICorner")
transCorner.CornerRadius = UDim.new(0, 6)
transCorner.Parent = transToggle

local isTransparent = false
transToggle.MouseButton1Click:Connect(function()
    isTransparent = not isTransparent
    transToggle.Text = isTransparent and "ON" or "OFF"
    transToggle.BackgroundColor3 = isTransparent and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
    mainFrame.BackgroundTransparency = isTransparent and 0.15 or 0
end)

-- Темы
local themeCard = Instance.new("Frame")
themeCard.Size = UDim2.new(0.9, 0, 0, 70)
themeCard.Position = UDim2.new(0.05, 0, 0, 95)
themeCard.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
themeCard.BackgroundTransparency = 0.2
themeCard.BorderSizePixel = 1
themeCard.BorderColor3 = Color3.fromRGB(50, 50, 60)
themeCard.Parent = settingsContent

local themeCardCorner = Instance.new("UICorner")
themeCardCorner.CornerRadius = UDim.new(0, 8)
themeCardCorner.Parent = themeCard

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, 0, 0, 25)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "🎨 Темы"
themeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
themeLabel.TextSize = 13
themeLabel.Font = Enum.Font.GothamBold
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = themeCard

local themeColors = {
    {"Astral", Color3.fromRGB(80, 40, 140)},
    {"Blood", Color3.fromRGB(180, 40, 40)},
    {"Ocean", Color3.fromRGB(40, 80, 180)},
}

local themeButtons = {}
for i, data in pairs(themeColors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, 0, 0, 26)
    btn.Position = UDim2.new(0.05 + (i-1) * 0.24, 0, 0, 30)
    btn.BackgroundColor3 = data[2]
    btn.BackgroundTransparency = 0.2
    btn.Text = data[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(50, 50, 60)
    btn.Parent = themeCard
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        mainFrame.BackgroundColor3 = data[2]
        for _, b in pairs(themeButtons) do
            b.BorderSizePixel = 1
            b.BorderColor3 = Color3.fromRGB(50, 50, 60)
        end
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(themeButtons, btn)
end

settingsContent.CanvasSize = UDim2.new(0, 0, 0, 190)

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ============================================
local function SwitchTab(index)
    for i, btn in pairs(btnObjects) do
        if i == index then
            btn.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BorderColor3 = Color3.fromRGB(80, 40, 140)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            btn.BorderColor3 = Color3.fromRGB(40, 40, 50)
        end
    end
    for i, content in pairs(contents) do
        content.Visible = (i == index)
    end
end

for i, btn in pairs(btnObjects) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

print("✦ ASTRA HUB (Перетаскивание по всей рамке) загружена!")
