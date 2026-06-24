-- Astra Hub v2.0 (Ringta Style)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local Config = {
    Title = "✦ ASTRA HUB",
    Icon = "rbxassetid://4483362458",
    Theme = Color3.fromRGB(80, 40, 140),
    Glass = true,
    Animations = true,
    Sounds = true,
}

-- ============================================
-- ЗВУК (для телефона)
-- ============================================
local ClickSound = Instance.new("Sound")
ClickSound.Name = "ClickSound"
ClickSound.SoundId = "rbxassetid://9120385441" -- Звук клика
ClickSound.Volume = 0.5
ClickSound.Parent = SoundService

local function PlayClick()
    if Config.Sounds then
        local s = ClickSound:Clone()
        s.Parent = SoundService
        s:Play()
        game:GetService("Debris"):AddItem(s, 0.5)
    end
end

-- ============================================
-- ЭКРАН
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ============================================
-- ИКОНКА (как у Ringta)
-- ============================================
local Icon = Instance.new("ImageButton")
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.02, 0, 0.02, 0)
Icon.AnchorPoint = Vector2.new(0, 0)
Icon.BackgroundColor3 = Config.Theme
Icon.BackgroundTransparency = 0.2
Icon.BorderSizePixel = 2
Icon.BorderColor3 = Config.Theme
Icon.Image = Config.Icon
Icon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 12)
IconCorner.Parent = Icon

local IconText = Instance.new("TextLabel")
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.BackgroundTransparency = 1
IconText.Text = "✦"
IconText.TextColor3 = Color3.fromRGB(255, 255, 255)
IconText.TextSize = 28
IconText.Font = Enum.Font.GothamBold
IconText.Parent = Icon

-- Перетаскивание иконки
local iconDragging = false
local iconDragStart, iconStartPos

Icon.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = true
        iconDragStart = i.Position
        iconStartPos = Icon.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then iconDragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if iconDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - iconDragStart
        Icon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + d.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + d.Y)
    end
end)

-- ============================================
-- ОСНОВНОЕ ОКНО
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BackgroundTransparency = Config.Glass and 0.15 or 0
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

-- ============================================
-- ОТКРЫТИЕ / ЗАКРЫТИЕ
-- ============================================
local function OpenMenu()
    MainFrame.Visible = true
    Icon.Visible = false
    PlayClick()
    if Config.Animations then
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 440, 0, 420)
        }):Play()
    else
        MainFrame.Size = UDim2.new(0, 440, 0, 420)
    end
end

local function CloseMenu()
    PlayClick()
    if Config.Animations then
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.2)
    end
    MainFrame.Visible = false
    Icon.Visible = true
end

Icon.MouseButton1Click:Connect(OpenMenu)

-- ============================================
-- ШАПКА
-- ============================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
Header.BackgroundTransparency = 0.2
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = Config.Title
Title.TextColor3 = Color3.fromRGB(210, 170, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- ===== MACOS КНОПКИ =====
local MacOSContainer = Instance.new("Frame")
MacOSContainer.Size = UDim2.new(0, 60, 0, 18)
MacOSContainer.Position = UDim2.new(1, -68, 0, 16)
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
local YellowBtn = MakeMacOSButton(Color3.fromRGB(254, 188, 46), 22)
local GreenBtn = MakeMacOSButton(Color3.fromRGB(40, 200, 64), 44)

local contentVisible = true
local isPinned = false

RedBtn.MouseButton1Click:Connect(CloseMenu)

YellowBtn.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    if LeftPanel then LeftPanel.Visible = contentVisible end
    if RightPanel then RightPanel.Visible = contentVisible end
    if contentVisible then
        MainFrame.Size = UDim2.new(0, 440, 0, 420)
        Icon.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 440, 0, 55)
        task.wait(0.3)
        Icon.Visible = true
        MainFrame.Visible = false
    end
end)

GreenBtn.MouseButton1Click:Connect(function()
    isPinned = not isPinned
    GreenBtn.BackgroundColor3 = isPinned and Color3.fromRGB(20, 180, 40) or Color3.fromRGB(40, 200, 64)
    MainFrame.ZIndex = isPinned and 100 or 0
end)

-- ===== ПЕРЕТАСКИВАНИЕ =====
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 and not isPinned then
        dragging = true
        dragStart = i.Position
        startPos = MainFrame.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ============================================
-- САЙДБАР
-- ============================================
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 120, 1, -50)
LeftPanel.Position = UDim2.new(0, 0, 0, 50)
LeftPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
LeftPanel.BackgroundTransparency = 0.2
LeftPanel.Parent = MainFrame

local Border = Instance.new("Frame")
Border.Size = UDim2.new(0, 1, 0.85, 0)
Border.Position = UDim2.new(1, -1, 0.075, 0)
Border.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
Border.BackgroundTransparency = 0.4
Border.Parent = LeftPanel

-- Профиль
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

local Avatar = Instance.new("Frame")
Avatar.Size = UDim2.new(0, 28, 0, 28)
Avatar.Position = UDim2.new(0.08, 0, 0.08, 0)
Avatar.BackgroundColor3 = Config.Theme
Avatar.BackgroundTransparency = 0.3
Avatar.BorderSizePixel = 1
Avatar.BorderColor3 = Color3.fromRGB(60, 60, 80)
Avatar.Parent = ProfileFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = Avatar

local AvatarText = Instance.new("TextLabel")
AvatarText.Size = UDim2.new(1, 0, 1, 0)
AvatarText.BackgroundTransparency = 1
AvatarText.Text = string.sub(LP.Name, 1, 1):upper()
AvatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
AvatarText.TextSize = 16
AvatarText.Font = Enum.Font.GothamBold
AvatarText.Parent = Avatar

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

-- ===== КНОПКИ =====
local btnData = {"🏠 Home", "⚔️ Combat", "🌾 Farm", "⚙️ Settings"}
local btnObjects = {}

for i, name in pairs(btnData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.Position = UDim2.new(0.075, 0, 0, 8 + (i-1) * 36)
    btn.BackgroundColor3 = (i == 1) and Config.Theme or Color3.fromRGB(30, 30, 40)
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 220)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 1
    btn.BorderColor3 = (i == 1) and Config.Theme or Color3.fromRGB(40, 40, 50)
    btn.Parent = LeftPanel
    btn.MouseButton1Click:Connect(PlayClick)
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btnObjects[i] = btn
end

-- ============================================
-- ПРАВАЯ КОЛОНКА
-- ============================================
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -135, 1, -50)
RightPanel.Position = UDim2.new(0, 125, 0, 50)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

-- ============================================
-- КОНТЕНТ
-- ============================================
local allContents = {}

-- Home
local HomeContent = Instance.new("ScrollingFrame")
HomeContent.Size = UDim2.new(1, 0, 1, 0)
HomeContent.BackgroundTransparency = 1
HomeContent.CanvasSize = UDim2.new(0, 0, 0, 0)
HomeContent.ScrollBarThickness = 4
HomeContent.ScrollBarImageColor3 = Color3.fromRGB(80, 40, 140)
HomeContent.Visible = true
HomeContent.Parent = RightPanel
allContents[1] = HomeContent

local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(0.9, 0, 0, 36)
infoCard.Position = UDim2.new(0.05, 0, 0, 12)
infoCard.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
infoCard.BackgroundTransparency = 0.2
infoCard.BorderSizePixel = 1
infoCard.BorderColor3 = Color3.fromRGB(50, 50, 60)
infoCard.Parent = HomeContent

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoCard

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 1, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "💎 Astra Hub v2.0 | SpaceBerq"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.Parent = infoCard

local discordCard = Instance.new("Frame")
discordCard.Size = UDim2.new(0.9, 0, 0, 36)
discordCard.Position = UDim2.new(0.05, 0, 0, 56)
discordCard.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
discordCard.BackgroundTransparency = 0.2
discordCard.BorderSizePixel = 1
discordCard.BorderColor3 = Color3.fromRGB(50, 50, 60)
discordCard.Parent = HomeContent

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordCard

local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.6, 0, 1, 0)
discordLabel.Position = UDim2.new(0, 12, 0, 0)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "💬 Discord"
discordLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
discordLabel.TextSize = 13
discordLabel.Font = Enum.Font.GothamBold
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.Parent = discordCard

local dcBtn = Instance.new("TextButton")
dcBtn.Size = UDim2.new(0, 55, 0, 24)
dcBtn.Position = UDim2.new(0.7, 0, 0.06, 0)
dcBtn.BackgroundColor3 = Config.Theme
dcBtn.BackgroundTransparency = 0.2
dcBtn.Text = "Перейти"
dcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dcBtn.TextSize = 12
dcBtn.Font = Enum.Font.GothamBold
dcBtn.BorderSizePixel = 1
dcBtn.BorderColor3 = Config.Theme
dcBtn.Parent = discordCard
dcBtn.MouseButton1Click:Connect(PlayClick)

local dcBtnCorner = Instance.new("UICorner")
dcBtnCorner.CornerRadius = UDim.new(0, 6)
dcBtnCorner.Parent = dcBtn

dcBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/ringta")
end)

HomeContent.CanvasSize = UDim2.new(0, 0, 0, 110)

-- Combat, Farm, Settings — аналогично

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ============================================
local function SwitchTab(index)
    PlayClick()
    for i, btn in pairs(btnObjects) do
        if i == index then
            btn.BackgroundColor3 = Config.Theme
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BorderColor3 = Config.Theme
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            btn.BorderColor3 = Color3.fromRGB(40, 40, 50)
        end
    end
    for i, content in pairs(allContents) do
        content.Visible = (i == index)
    end
end

for i, btn in pairs(btnObjects) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

print("✦ Astra Hub v2.0 загружена!")
