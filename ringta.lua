-- SpaceBerq | Ringta GUI v66 (Финальная центрированная)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- ОСНОВНОЙ ЭКРАН
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RingtaGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ============================================
-- ИКОНКА
-- ============================================
local Icon = Instance.new("ImageButton")
Icon.Name = "RingtaIcon"
Icon.Size = UDim2.new(0, 45, 0, 45)
Icon.Position = UDim2.new(0.02, 0, 0.02, 0)
Icon.AnchorPoint = Vector2.new(0, 0)
Icon.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
Icon.BackgroundTransparency = 0.2
Icon.BorderSizePixel = 0
Icon.Image = "rbxassetid://4483362458"
Icon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 12)
IconCorner.Parent = Icon

local IconText = Instance.new("TextLabel")
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.BackgroundTransparency = 1
IconText.Text = "R"
IconText.TextColor3 = Color3.fromRGB(255, 255, 255)
IconText.TextSize = 22
IconText.Font = Enum.Font.GothamBold
IconText.Parent = Icon

-- ============================================
-- ОСНОВНОЕ ОКНО (ЦЕНТРИРОВАННОЕ)
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = MainFrame

Icon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    Icon.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 360)
    }):Play()
end)

-- ============================================
-- ШАПКА
-- ============================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
Header.BackgroundTransparency = 0.2
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.3, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RINGTA"
Title.TextColor3 = Color3.fromRGB(210, 170, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- ===== MACOS КНОПКИ =====
local MacOSContainer = Instance.new("Frame")
MacOSContainer.Size = UDim2.new(0, 50, 0, 16)
MacOSContainer.Position = UDim2.new(1, -58, 0, 12)
MacOSContainer.BackgroundTransparency = 1
MacOSContainer.Parent = Header

local function MakeMacOSButton(color, x)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 12, 0, 12)
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
local YellowBtn = MakeMacOSButton(Color3.fromRGB(254, 188, 46), 18)
local GreenBtn = MakeMacOSButton(Color3.fromRGB(40, 200, 64), 36)

local contentVisible = true
local isPinned = false

RedBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.2)
    MainFrame.Visible = false
    Icon.Visible = true
end)

YellowBtn.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    if LeftPanel then LeftPanel.Visible = contentVisible end
    if RightPanel then RightPanel.Visible = contentVisible end
    if contentVisible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 400, 0, 360)
        }):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 400, 0, 45)
        }):Play()
        Icon.Visible = true
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

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isPinned then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- ЛЕВАЯ КОЛОНКА
-- ============================================
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 110, 1, -40)
LeftPanel.Position = UDim2.new(0, 0, 0, 40)
LeftPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
LeftPanel.BackgroundTransparency = 0.2
LeftPanel.Parent = MainFrame

local Border = Instance.new("Frame")
Border.Size = UDim2.new(0, 1, 0.85, 0)
Border.Position = UDim2.new(1, -1, 0.075, 0)
Border.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
Border.BackgroundTransparency = 0.4
Border.Parent = LeftPanel

-- ===== КНОПКИ =====
local btnData = {"🏠 Home", "⚔️ Combat", "🌾 Farm", "🧰 Misc"}
local btnObjects = {}

for i, name in pairs(btnData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 28)
    btn.Position = UDim2.new(0.075, 0, 0, 8 + (i-1) * 34)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(80, 40, 140) or Color3.fromRGB(30, 30, 40)
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 1
    btn.BorderColor3 = (i == 1) and Color3.fromRGB(80, 40, 140) or Color3.fromRGB(40, 40, 50)
    btn.Parent = LeftPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btnObjects[i] = btn
end

-- ============================================
-- ПРОФИЛЬ
-- ============================================
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0.9, 0, 0, 40)
ProfileFrame.Position = UDim2.new(0.05, 0, 1, -45)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ProfileFrame.BackgroundTransparency = 0.2
ProfileFrame.BorderSizePixel = 1
ProfileFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
ProfileFrame.Parent = LeftPanel

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 8)
ProfileCorner.Parent = ProfileFrame

local Avatar = Instance.new("Frame")
Avatar.Size = UDim2.new(0, 24, 0, 24)
Avatar.Position = UDim2.new(0.08, 0, 0.1, 0)
Avatar.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
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
AvatarText.TextSize = 14
AvatarText.Font = Enum.Font.GothamBold
AvatarText.Parent = Avatar

local Nickname = Instance.new("TextLabel")
Nickname.Size = UDim2.new(0.5, 0, 1, 0)
Nickname.Position = UDim2.new(0.3, 0, 0, 0)
Nickname.BackgroundTransparency = 1
Nickname.Text = LP.Name
Nickname.TextColor3 = Color3.fromRGB(200, 200, 220)
Nickname.TextSize = 11
Nickname.Font = Enum.Font.Gotham
Nickname.TextXAlignment = Enum.TextXAlignment.Left
Nickname.Parent = ProfileFrame

local Arrow = Instance.new("TextLabel")
Arrow.Size = UDim2.new(0, 16, 0, 1)
Arrow.Position = UDim2.new(0.85, 0, 0, 0)
Arrow.BackgroundTransparency = 1
Arrow.Text = ">"
Arrow.TextColor3 = Color3.fromRGB(140, 140, 170)
Arrow.TextSize = 14
Arrow.Font = Enum.Font.GothamBold
Arrow.Parent = ProfileFrame

-- ============================================
-- ПРАВАЯ КОЛОНКА
-- ============================================
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -120, 1, -40)
RightPanel.Position = UDim2.new(0, 115, 0, 40)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

-- ============================================
-- КОНТЕНТ
-- ============================================
local HomeContent = Instance.new("Frame")
HomeContent.Size = UDim2.new(1, 0, 1, 0)
HomeContent.BackgroundTransparency = 1
HomeContent.Parent = RightPanel

local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(0.9, 0, 0, 32)
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
infoLabel.Text = "💎 Ringta v2.0 | SpaceBerq"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.Parent = infoCard

local discordCard = Instance.new("Frame")
discordCard.Size = UDim2.new(0.9, 0, 0, 32)
discordCard.Position = UDim2.new(0.05, 0, 0, 52)
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
dcBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
dcBtn.BackgroundTransparency = 0.2
dcBtn.Text = "Перейти"
dcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dcBtn.TextSize = 11
dcBtn.Font = Enum.Font.GothamBold
dcBtn.BorderSizePixel = 1
dcBtn.BorderColor3 = Color3.fromRGB(138, 43, 226)
dcBtn.Parent = discordCard

local dcBtnCorner = Instance.new("UICorner")
dcBtnCorner.CornerRadius = UDim.new(0, 6)
dcBtnCorner.Parent = dcBtn

dcBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/ringta")
end)

-- Пустые контейнеры
local CombatContent = Instance.new("Frame")
CombatContent.Size = UDim2.new(1, 0, 1, 0)
CombatContent.BackgroundTransparency = 1
CombatContent.Visible = false
CombatContent.Parent = RightPanel

local FarmContent = Instance.new("Frame")
FarmContent.Size = UDim2.new(1, 0, 1, 0)
FarmContent.BackgroundTransparency = 1
FarmContent.Visible = false
FarmContent.Parent = RightPanel

local MiscContent = Instance.new("Frame")
MiscContent.Size = UDim2.new(1, 0, 1, 0)
MiscContent.BackgroundTransparency = 1
MiscContent.Visible = false
MiscContent.Parent = RightPanel

local allContents = {HomeContent, CombatContent, FarmContent, MiscContent}

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
    for i, content in pairs(allContents) do
        content.Visible = (i == index)
    end
end

for i, btn in pairs(btnObjects) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

print("Ringta GUI v66 загружена! Финальная центрированная версия.")
