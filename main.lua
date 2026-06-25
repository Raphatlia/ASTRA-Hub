-- Astra Hub (Ringta Edition) — ФИНАЛЬНАЯ ВЕРСИЯ
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ===== ОСНОВНОЕ ОКНО =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 400)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

-- ===== КРУГЛАЯ ПЛАВАЮЩАЯ ИКОНКА =====
local Icon = Instance.new("ImageButton")
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.02, 0, 0.02, 0)
Icon.AnchorPoint = Vector2.new(0, 0)
Icon.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
Icon.BackgroundTransparency = 0.2
Icon.BorderSizePixel = 2
Icon.BorderColor3 = Color3.fromRGB(138, 43, 226)
Icon.Image = "rbxassetid://4483362458"
Icon.Parent = ScreenGui
Icon.Visible = false

-- ЗАКРУГЛЕНИЕ ИКОНКИ (круглая)
local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = Icon

-- Неоновая обводка (свечение)
local NeonGlow = Instance.new("Frame")
NeonGlow.Size = UDim2.new(1, 10, 1, 10)
NeonGlow.Position = UDim2.new(0, -5, 0, -5)
NeonGlow.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
NeonGlow.BackgroundTransparency = 0.85
NeonGlow.BorderSizePixel = 0
NeonGlow.Parent = Icon

local IconText = Instance.new("TextLabel")
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.BackgroundTransparency = 1
IconText.Text = "✦"
IconText.TextColor3 = Color3.fromRGB(255, 255, 255)
IconText.TextSize = 24
IconText.Font = Enum.Font.GothamBold
IconText.Parent = Icon

Icon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    Icon.Visible = false
end)

-- ===== ШАПКА =====
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
Header.BackgroundTransparency = 0.2
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ ASTRA HUB"
Title.TextColor3 = Color3.fromRGB(210, 170, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- ===== MACOS КНОПКИ =====
local MacOSContainer = Instance.new("Frame")
MacOSContainer.Size = UDim2.new(0, 55, 0, 18)
MacOSContainer.Position = UDim2.new(1, -63, 0, 13)
MacOSContainer.BackgroundTransparency = 1
MacOSContainer.Parent = Header

local function MakeMacOSButton(color, x)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 13, 0, 13)
    btn.Position = UDim2.new(0, x, 0, 2)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = MacOSContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    return btn
end

local RedBtn = MakeMacOSButton(Color3.fromRGB(255, 95, 87), 0)
local YellowBtn = MakeMacOSButton(Color3.fromRGB(254, 188, 46), 20)
local GreenBtn = MakeMacOSButton(Color3.fromRGB(40, 200, 64), 40)

-- Красная — полностью скрыть всё
RedBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Жёлтая — свернуть в иконку
YellowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Icon.Visible = true
end)

-- Зелёная — закрепить
GreenBtn.MouseButton1Click:Connect(function()
    local pinned = not getgenv()._pinned
    getgenv()._pinned = pinned
    GreenBtn.BackgroundColor3 = pinned and Color3.fromRGB(20, 180, 40) or Color3.fromRGB(40, 200, 64)
end)

-- ===== ПЕРЕТАСКИВАНИЕ =====
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = MainFrame.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ===== ЛЕВАЯ ПАНЕЛЬ =====
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 115, 1, -45)
LeftPanel.Position = UDim2.new(0, 0, 0, 45)
LeftPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
LeftPanel.BackgroundTransparency = 0.2
LeftPanel.Parent = MainFrame

local Border = Instance.new("Frame")
Border.Size = UDim2.new(0, 1, 0.85, 0)
Border.Position = UDim2.new(1, -1, 0.075, 0)
Border.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
Border.BackgroundTransparency = 0.4
Border.Parent = LeftPanel

-- ===== ПРОФИЛЬ =====
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0.9, 0, 0, 45)
ProfileFrame.Position = UDim2.new(0.05, 0, 1, -50)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ProfileFrame.BackgroundTransparency = 0.2
ProfileFrame.BorderSizePixel = 1
ProfileFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
ProfileFrame.Parent = LeftPanel

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 8)
ProfileCorner.Parent = ProfileFrame

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 28, 0, 28)
Avatar.Position = UDim2.new(0.08, 0, 0.08, 0)
Avatar.BackgroundTransparency = 1
Avatar.BorderSizePixel = 1
Avatar.BorderColor3 = Color3.fromRGB(60, 60, 80)
Avatar.Parent = ProfileFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = Avatar

local function LoadAvatar()
    local userId = LP.UserId
    if userId then
        Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
    end
end
LoadAvatar()

local AvatarFallback = Instance.new("TextLabel")
AvatarFallback.Size = UDim2.new(1, 0, 1, 0)
AvatarFallback.BackgroundTransparency = 1
AvatarFallback.Text = string.sub(LP.Name, 1, 1):upper()
AvatarFallback.TextColor3 = Color3.fromRGB(255, 255, 255)
AvatarFallback.TextSize = 16
AvatarFallback.Font = Enum.Font.GothamBold
AvatarFallback.Parent = Avatar

local Nickname = Instance.new("TextLabel")
Nickname.Size = UDim2.new(0.5, 0, 1, 0)
Nickname.Position = UDim2.new(0.32, 0, 0, 0)
Nickname.BackgroundTransparency = 1
Nickname.Text = LP.Name
Nickname.TextColor3 = Color3.fromRGB(200, 200, 220)
Nickname.TextSize = 12
Nickname.Font = Enum.Font.Gotham
Nickname.TextXAlignment = Enum.TextXAlignment.Left
Nickname.Parent = ProfileFrame

local Arrow = Instance.new("TextLabel")
Arrow.Size = UDim2.new(0, 16, 0, 1)
Arrow.Position = UDim2.new(0.85, 0, 0, 0)
Arrow.BackgroundTransparency = 1
Arrow.Text = ">"
Arrow.TextColor3 = Color3.fromRGB(140, 140, 170)
Arrow.TextSize = 16
Arrow.Font = Enum.Font.GothamBold
Arrow.Parent = ProfileFrame

-- ===== КНОПКИ =====
local btnData = {"🏠 Home", "⚔️ Combat", "🌾 Farm", "⚙️ Settings"}
local btnObjects = {}

for i = 1, #btnData do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.Position = UDim2.new(0.075, 0, 0, 8 + (i-1) * 36)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(80, 40, 140) or Color3.fromRGB(30, 30, 40)
    btn.Text = btnData[i]
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 220)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 1
    btn.BorderColor3 = (i == 1) and Color3.fromRGB(80, 40, 140) or Color3.fromRGB(40, 40, 50)
    btn.Parent = LeftPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btnObjects[i] = btn
end

-- ===== ПРАВАЯ ПАНЕЛЬ =====
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -130, 1, -45)
RightPanel.Position = UDim2.new(0, 120, 0, 45)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

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
    f.Parent = RightPanel
    
    if i == 4 then
        -- Настройки
    else
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 40)
        label.Position = UDim2.new(0, 0, 0.2, 0)
        label.BackgroundTransparency = 1
        label.Text = "📁 " .. btnData[i]
        label.TextColor3 = Color3.fromRGB(200, 200, 220)
        label.TextSize = 18
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Parent = f
        f.CanvasSize = UDim2.new(0, 0, 0, 100)
    end
    contents[i] = f
end

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settingsContent = contents[4]
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 300)

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, 0, 0, 40)
settingsLabel.Position = UDim2.new(0, 0, 0, 5)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "⚙️ Настройки"
settingsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
settingsLabel.TextSize = 18
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.TextXAlignment = Enum.TextXAlignment.Center
settingsLabel.Parent = settingsContent

-- Прозрачность
local transCard = Instance.new("Frame")
transCard.Size = UDim2.new(0.9, 0, 0, 46)
transCard.Position = UDim2.new(0.05, 0, 0, 50)
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
transLabel.Position = UDim2.new(0, 12, 0, 0)
transLabel.BackgroundTransparency = 1
transLabel.Text = "🪟 Прозрачность"
transLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
transLabel.TextSize = 14
transLabel.Font = Enum.Font.GothamBold
transLabel.TextXAlignment = Enum.TextXAlignment.Left
transLabel.Parent = transCard

local transToggle = Instance.new("TextButton")
transToggle.Size = UDim2.new(0.15, 0, 0, 28)
transToggle.Position = UDim2.new(0.8, 0, 0.1, 0)
transToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
transToggle.Text = "OFF"
transToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
transToggle.TextSize = 12
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
    MainFrame.BackgroundTransparency = isTransparent and 0.15 or 0
end)

-- Темы
local themeCard = Instance.new("Frame")
themeCard.Size = UDim2.new(0.9, 0, 0, 80)
themeCard.Position = UDim2.new(0.05, 0, 0, 106)
themeCard.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
themeCard.BackgroundTransparency = 0.2
themeCard.BorderSizePixel = 1
themeCard.BorderColor3 = Color3.fromRGB(50, 50, 60)
themeCard.Parent = settingsContent

local themeCardCorner = Instance.new("UICorner")
themeCardCorner.CornerRadius = UDim.new(0, 8)
themeCardCorner.Parent = themeCard

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, 0, 0, 30)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "🎨 Темы"
themeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
themeLabel.TextSize = 14
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
    btn.Size = UDim2.new(0.2, 0, 0, 30)
    btn.Position = UDim2.new(0.05 + (i-1) * 0.24, 0, 0, 35)
    btn.BackgroundColor3 = data[2]
    btn.BackgroundTransparency = 0.2
    btn.Text = data[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(50, 50, 60)
    btn.Parent = themeCard
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        MainFrame.BackgroundColor3 = data[2]
        for _, b in pairs(themeButtons) do
            b.BorderSizePixel = 1
            b.BorderColor3 = Color3.fromRGB(50, 50, 60)
        end
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(themeButtons, btn)
end

settingsContent.CanvasSize = UDim2.new(0, 0, 0, 220)

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ
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

print("✦ Astra Hub (Финальная версия) загружена!")
