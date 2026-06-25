-- ASTRA HUB — СТАБИЛЬНАЯ ВЕРСИЯ (С АККОРДЕОНАМИ В COMBAT)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ===== ЗАГРУЗКА НАСТРОЕК =====
local function LoadSettings()
    if not shared.AstraSettings then
        shared.AstraSettings = {
            Theme = "Astral",
            Transparent = false,
        }
    end
    return shared.AstraSettings
end
local settings = LoadSettings()

-- ============================================
-- ИКОНКА
-- ============================================
local iconFrame = Instance.new("ImageButton")
iconFrame.Name = "iconFrame"
iconFrame.Size = UDim2.new(0, 50, 0, 50)
iconFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
iconFrame.AnchorPoint = Vector2.new(0, 0)
iconFrame.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
iconFrame.BackgroundTransparency = 0.1
iconFrame.BorderSizePixel = 2
iconFrame.BorderColor3 = Color3.fromRGB(138, 43, 226)
iconFrame.Image = "rbxassetid://4483362458"
iconFrame.Visible = false
iconFrame.Active = true
iconFrame.Selectable = true
iconFrame.ZIndex = 100
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

-- ============================================
-- ОСНОВНОЕ ОКНО
-- ============================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "mainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 320)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BackgroundTransparency = settings.Transparent and 0.15 or 0
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
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ASTRA HUB"
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
btnRed.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

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
    iconFrame.Visible = true
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
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
end)

-- ============================================
-- КЛИК ПО ИКОНКЕ
-- ============================================
iconFrame.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    iconFrame.Visible = false
end)

-- ============================================
-- ПЕРЕТАСКИВАНИЕ ИКОНКИ
-- ============================================
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
-- ПЕРЕТАСКИВАНИЕ ОКНА
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
        mainFrame.Position = UDim2.new(
            framePos.X.Scale, framePos.X.Offset + delta.X,
            framePos.Y.Scale, framePos.Y.Offset + delta.Y
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
    contents[i] = f
end

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ АККОРДЕОНА
-- ============================================
local function createAccordion(parent, title, yPos, contentHeight)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -20, 0, 50)
    card.Position = UDim2.new(0, 10, 0, yPos)
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    card.BorderSizePixel = 1
    card.BorderColor3 = Color3.fromRGB(50, 50, 60)
    card.ClipsDescendants = true
    card.Parent = parent
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    header.Text = title
    header.TextColor3 = Color3.fromRGB(220, 220, 240)
    header.TextSize = 14
    header.Font = Enum.Font.Gotham
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.Parent = card

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 180)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBold
    arrow.TextXAlignment = Enum.TextXAlignment.Right
    arrow.TextYAlignment = Enum.TextYAlignment.Center
    arrow.Parent = header

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, 50)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true
    content.Parent = card

    local isOpen = false
    local height = contentHeight or 40

    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            arrow.Text = "▲"
            card.Size = UDim2.new(1, -20, 0, 50 + height)
            content.Size = UDim2.new(1, 0, 0, height)
        else
            arrow.Text = "▼"
            card.Size = UDim2.new(1, -20, 0, 50)
            content.Size = UDim2.new(1, 0, 0, 0)
        end
    end)

    return content
end

-- ============================================
-- COMBAT — АККОРДЕОНЫ
-- ============================================
local combatContent = contents[2]
combatContent.CanvasSize = UDim2.new(0, 0, 0, 350)

local combatLabel = Instance.new("TextLabel")
combatLabel.Size = UDim2.new(1, 0, 0, 35)
combatLabel.Position = UDim2.new(0, 0, 0, 5)
combatLabel.BackgroundTransparency = 1
combatLabel.Text = "⚔️ Combat"
combatLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
combatLabel.TextSize = 16
combatLabel.Font = Enum.Font.GothamBold
combatLabel.TextXAlignment = Enum.TextXAlignment.Center
combatLabel.Parent = combatContent

-- Аккордеон 1: Auto Click
local acc1Content = createAccordion(combatContent, "🔫 Auto Click", 50, 40)

local toggleFrame1 = Instance.new("Frame")
toggleFrame1.Size = UDim2.new(1, -30, 0, 30)
toggleFrame1.Position = UDim2.new(0, 15, 0, 5)
toggleFrame1.BackgroundTransparency = 1
toggleFrame1.Parent = acc1Content

local toggleLabel1 = Instance.new("TextLabel")
toggleLabel1.Size = UDim2.new(0.5, 0, 1, 0)
toggleLabel1.Position = UDim2.new(0, 0, 0, 0)
toggleLabel1.BackgroundTransparency = 1
toggleLabel1.Text = "Включить"
toggleLabel1.TextColor3 = Color3.fromRGB(200, 200, 220)
toggleLabel1.TextSize = 13
toggleLabel1.Font = Enum.Font.Gotham
toggleLabel1.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel1.Parent = toggleFrame1

local toggleBtn1 = Instance.new("Frame")
toggleBtn1.Size = UDim2.new(0, 40, 0, 22)
toggleBtn1.Position = UDim2.new(1, -10, 0.5, 0)
toggleBtn1.AnchorPoint = Vector2.new(1, 0.5)
toggleBtn1.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
toggleBtn1.BorderSizePixel = 0
toggleBtn1.Parent = toggleFrame1
local toggleBtn1Corner = Instance.new("UICorner")
toggleBtn1Corner.CornerRadius = UDim.new(1, 0)
toggleBtn1Corner.Parent = toggleBtn1

local toggleCircle1 = Instance.new("Frame")
toggleCircle1.Size = UDim2.new(0, 18, 0, 18)
toggleCircle1.Position = UDim2.new(0, 2, 0.5, 0)
toggleCircle1.AnchorPoint = Vector2.new(0, 0.5)
toggleCircle1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle1.BorderSizePixel = 0
toggleCircle1.Parent = toggleBtn1
local toggleCircle1Corner = Instance.new("UICorner")
toggleCircle1Corner.CornerRadius = UDim.new(1, 0)
toggleCircle1Corner.Parent = toggleCircle1

local isOn1 = false
toggleBtn1.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isOn1 = not isOn1
        if isOn1 then
            toggleBtn1.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            toggleCircle1.Position = UDim2.new(1, -20, 0.5, 0)
            print("Auto Click ON")
        else
            toggleBtn1.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            toggleCircle1.Position = UDim2.new(0, 2, 0.5, 0)
            print("Auto Click OFF")
        end
    end
end)

-- Аккордеон 2: Fast Attack
local acc2Content = createAccordion(combatContent, "⚡ Fast Attack", 110, 40)

local toggleFrame2 = Instance.new("Frame")
toggleFrame2.Size = UDim2.new(1, -30, 0, 30)
toggleFrame2.Position = UDim2.new(0, 15, 0, 5)
toggleFrame2.BackgroundTransparency = 1
toggleFrame2.Parent = acc2Content

local toggleLabel2 = Instance.new("TextLabel")
toggleLabel2.Size = UDim2.new(0.5, 0, 1, 0)
toggleLabel2.Position = UDim2.new(0, 0, 0, 0)
toggleLabel2.BackgroundTransparency = 1
toggleLabel2.Text = "Включить"
toggleLabel2.TextColor3 = Color3.fromRGB(200, 200, 220)
toggleLabel2.TextSize = 13
toggleLabel2.Font = Enum.Font.Gotham
toggleLabel2.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel2.Parent = toggleFrame2

local toggleBtn2 = Instance.new("Frame")
toggleBtn2.Size = UDim2.new(0, 40, 0, 22)
toggleBtn2.Position = UDim2.new(1, -10, 0.5, 0)
toggleBtn2.AnchorPoint = Vector2.new(1, 0.5)
toggleBtn2.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
toggleBtn2.BorderSizePixel = 0
toggleBtn2.Parent = toggleFrame2
local toggleBtn2Corner = Instance.new("UICorner")
toggleBtn2Corner.CornerRadius = UDim.new(1, 0)
toggleBtn2Corner.Parent = toggleBtn2

local toggleCircle2 = Instance.new("Frame")
toggleCircle2.Size = UDim2.new(0, 18, 0, 18)
toggleCircle2.Position = UDim2.new(0, 2, 0.5, 0)
toggleCircle2.AnchorPoint = Vector2.new(0, 0.5)
toggleCircle2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle2.BorderSizePixel = 0
toggleCircle2.Parent = toggleBtn2
local toggleCircle2Corner = Instance.new("UICorner")
toggleCircle2Corner.CornerRadius = UDim.new(1, 0)
toggleCircle2Corner.Parent = toggleCircle2

local isOn2 = false
toggleBtn2.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isOn2 = not isOn2
        if isOn2 then
            toggleBtn2.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            toggleCircle2.Position = UDim2.new(1, -20, 0.5, 0)
            print("Fast Attack ON")
        else
            toggleBtn2.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            toggleCircle2.Position = UDim2.new(0, 2, 0.5, 0)
            print("Fast Attack OFF")
        end
    end
end)

combatContent.CanvasSize = UDim2.new(0, 0, 0, 400)

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settingsContent = contents[4]
settingsContent.BackgroundTransparency = 1
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 400)

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

-- Аккордеон настроек
local accordionBg = Instance.new("Frame")
accordionBg.Size = UDim2.new(0.9, 0, 0, 140)
accordionBg.Position = UDim2.new(0.05, 0, 0, 45)
accordionBg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
accordionBg.BackgroundTransparency = 0.2
accordionBg.BorderSizePixel = 1
accordionBg.BorderColor3 = Color3.fromRGB(50, 50, 60)
accordionBg.ClipsDescendants = true
accordionBg.Parent = settingsContent
local accordionCorner = Instance.new("UICorner")
accordionCorner.CornerRadius = UDim.new(0, 8)
accordionCorner.Parent = accordionBg

local accordionHeader = Instance.new("TextButton")
accordionHeader.Size = UDim2.new(1, 0, 0, 35)
accordionHeader.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
accordionHeader.BackgroundTransparency = 0.2
accordionHeader.BorderSizePixel = 0
accordionHeader.Text = "▼ Внешний вид"
accordionHeader.TextColor3 = Color3.fromRGB(200, 200, 220)
accordionHeader.TextSize = 13
accordionHeader.Font = Enum.Font.GothamBold
accordionHeader.TextXAlignment = Enum.TextXAlignment.Left
accordionHeader.TextYAlignment = Enum.TextYAlignment.Center
accordionHeader.Parent = accordionBg
local accordionHeaderCorner = Instance.new("UICorner")
accordionHeaderCorner.CornerRadius = UDim.new(0, 8)
accordionHeaderCorner.Parent = accordionHeader

local accordionContent = Instance.new("Frame")
accordionContent.Size = UDim2.new(1, 0, 0, 100)
accordionContent.Position = UDim2.new(0, 0, 0, 35)
accordionContent.BackgroundTransparency = 1
accordionContent.Parent = accordionBg

-- Прозрачность
local transCard = Instance.new("Frame")
transCard.Size = UDim2.new(0.95, 0, 0, 40)
transCard.Position = UDim2.new(0.025, 0, 0, 5)
transCard.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
transCard.BackgroundTransparency = 0.3
transCard.BorderSizePixel = 1
transCard.BorderColor3 = Color3.fromRGB(40, 40, 50)
transCard.Parent = accordionContent
local transCardCorner = Instance.new("UICorner")
transCardCorner.CornerRadius = UDim.new(0, 6)
transCardCorner.Parent = transCard

local transLabel = Instance.new("TextLabel")
transLabel.Size = UDim2.new(0.6, 0, 1, 0)
transLabel.Position = UDim2.new(0, 10, 0, 0)
transLabel.BackgroundTransparency = 1
transLabel.Text = "🪟 Прозрачность"
transLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
transLabel.TextSize = 13
transLabel.Font = Enum.Font.Gotham
transLabel.TextXAlignment = Enum.TextXAlignment.Left
transLabel.Parent = transCard

local transToggle = Instance.new("Frame")
transToggle.Size = UDim2.new(0, 40, 0, 22)
transToggle.Position = UDim2.new(1, -12, 0.5, 0)
transToggle.AnchorPoint = Vector2.new(1, 0.5)
transToggle.BackgroundColor3 = settings.Transparent and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
transToggle.BorderSizePixel = 0
transToggle.Parent = transCard
local transToggleCorner = Instance.new("UICorner")
transToggleCorner.CornerRadius = UDim.new(1, 0)
transToggleCorner.Parent = transToggle

local transCircle = Instance.new("Frame")
transCircle.Size = UDim2.new(0, 18, 0, 18)
transCircle.Position = settings.Transparent and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
transCircle.AnchorPoint = Vector2.new(0, 0.5)
transCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
transCircle.BorderSizePixel = 0
transCircle.Parent = transToggle
local transCircleCorner = Instance.new("UICorner")
transCircleCorner.CornerRadius = UDim.new(1, 0)
transCircleCorner.Parent = transCircle

local isTransparent = settings.Transparent
local function UpdateTransparency()
    if isTransparent then
        transToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        transCircle.Position = UDim2.new(1, -20, 0.5, 0)
        mainFrame.BackgroundTransparency = 0.15
    else
        transToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        transCircle.Position = UDim2.new(0, 2, 0.5, 0)
        mainFrame.BackgroundTransparency = 0
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

-- Выпадающий список тем
local themeDropdownBg = Instance.new("Frame")
themeDropdownBg.Size = UDim2.new(0.95, 0, 0, 40)
themeDropdownBg.Position = UDim2.new(0.025, 0, 0, 50)
themeDropdownBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
themeDropdownBg.BackgroundTransparency = 0.3
themeDropdownBg.BorderSizePixel = 1
themeDropdownBg.BorderColor3 = Color3.fromRGB(40, 40, 50)
themeDropdownBg.ClipsDescendants = true
themeDropdownBg.Parent = accordionContent
local themeDropdownCorner = Instance.new("UICorner")
themeDropdownCorner.CornerRadius = UDim.new(0, 6)
themeDropdownCorner.Parent = themeDropdownBg

local themeDropdownHeader = Instance.new("TextButton")
themeDropdownHeader.Size = UDim2.new(1, 0, 0, 40)
themeDropdownHeader.BackgroundTransparency = 1
themeDropdownHeader.Text = "🎨 Тема: " .. settings.Theme
themeDropdownHeader.TextColor3 = Color3.fromRGB(200, 200, 220)
themeDropdownHeader.TextSize = 13
themeDropdownHeader.Font = Enum.Font.Gotham
themeDropdownHeader.TextXAlignment = Enum.TextXAlignment.Left
themeDropdownHeader.TextYAlignment = Enum.TextYAlignment.Center
themeDropdownHeader.Parent = themeDropdownBg

local dropdownArrow = Instance.new("TextLabel")
dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
dropdownArrow.Position = UDim2.new(1, -25, 0, 0)
dropdownArrow.BackgroundTransparency = 1
dropdownArrow.Text = "▼"
dropdownArrow.TextColor3 = Color3.fromRGB(150, 150, 180)
dropdownArrow.TextSize = 12
dropdownArrow.Font = Enum.Font.GothamBold
dropdownArrow.TextXAlignment = Enum.TextXAlignment.Right
dropdownArrow.TextYAlignment = Enum.TextYAlignment.Center
dropdownArrow.Parent = themeDropdownBg

local dropdownList = Instance.new("Frame")
dropdownList.Size = UDim2.new(1, 0, 0, 0)
dropdownList.Position = UDim2.new(0, 0, 0, 40)
dropdownList.BackgroundTransparency = 1
dropdownList.ClipsDescendants = true
dropdownList.Parent = themeDropdownBg

local themeColorsList = {
    {"Astral", Color3.fromRGB(80, 40, 140)},
    {"Blood", Color3.fromRGB(180, 40, 40)},
    {"Ocean", Color3.fromRGB(40, 80, 180)},
}
local isDropdownOpen = false
local dropdownButtons = {}

for i, data in pairs(themeColorsList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.BackgroundTransparency = 0
    btn.Text = data[1]
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(50, 50, 60)
    btn.Parent = dropdownList
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    end)
    btn.MouseButton1Click:Connect(function()
        local themeName = data[1]
        local themeColor = data[2]
        mainFrame.BackgroundColor3 = themeColor
        shared.AstraSettings.Theme = themeName
        themeDropdownHeader.Text = "🎨 Тема: " .. themeName
        CloseDropdown()
        for _, b in pairs(dropdownButtons) do
            b.BorderSizePixel = 1
            b.BorderColor3 = Color3.fromRGB(50, 50, 60)
        end
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end)
    table.insert(dropdownButtons, btn)
end

for i, btn in pairs(dropdownButtons) do
    local themeName = themeColorsList[i][1]
    if themeName == settings.Theme then
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end
end

local function OpenDropdown()
    if isDropdownOpen then return end
    isDropdownOpen = true
    dropdownArrow.Text = "▲"
    local listHeight = #themeColorsList * 30
    themeDropdownBg.Size = UDim2.new(0.95, 0, 0, 40 + listHeight)
    dropdownList.Size = UDim2.new(1, 0, 0, listHeight)
    local newAccordionHeight = 140 + listHeight
    local tween = TweenService:Create(accordionBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.9, 0, 0, newAccordionHeight)
    })
    tween:Play()
    dropdownList.BackgroundTransparency = 1
    local tween2 = TweenService:Create(dropdownList, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween2:Play()
end

local function CloseDropdown()
    if not isDropdownOpen then return end
    isDropdownOpen = false
    dropdownArrow.Text = "▼"
    local tween = TweenService:Create(accordionBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0.9, 0, 0, 140)
    })
    tween:Play()
    local tween2 = TweenService:Create(dropdownList, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    tween2:Play()
    task.wait(0.1)
    themeDropdownBg.Size = UDim2.new(0.95, 0, 0, 40)
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
end

themeDropdownHeader.MouseButton1Click:Connect(function()
    if isDropdownOpen then
        CloseDropdown()
    else
        OpenDropdown()
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDropdownOpen then
            local mousePos = input.Position
            local absPos = themeDropdownBg.AbsolutePosition
            local size = themeDropdownBg.AbsoluteSize
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + size.X and
                    mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + size.Y) then
                CloseDropdown()
            end
        end
    end
end)

settingsContent.CanvasSize = UDim2.new(0, 0, 0, 230)

-- ============================================
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ============================================
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local allContents = {contents[1], contents[2], contents[3], contents[4]}

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
            btn.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BorderColor3 = Color3.fromRGB(80, 40, 140)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            btn.BorderColor3 = Color3.fromRGB(40, 40, 50)
        end
    end
end

for i, btn in pairs(btnObjects) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

print("ASTRA HUB (С АККОРДЕОНАМИ) загружена!")
