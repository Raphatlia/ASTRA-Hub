-- ASTRA HUB — МОДУЛЬ ДЛЯ MURDER MYSTERY 2 (ПО ID/NAME)
local Module = {}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- ДЕТЕКТОР MM2 ПО ID И НАЗВАНИЮ
-- ============================================
local function IsMM2Game()
    if game.PlaceId == 142823291 then
        return true
    end
    if string.match(game.Name, "Murder Mystery 2") then
        return true
    end
    return false
end

-- Если игра не MM2 — отключаем модуль
if not IsMM2Game() then
    print("[ASTRA] Не MM2, модуль отключён")
    return Module
end

print("[ASTRA] Murder Mystery 2 обнаружена! Загружаю функции...")

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================
local espEnabled = false
local xrayEnabled = false
local flyEnabled = false
local flySpeed = 50
local speedEnabled = false
local speedMultiplier = 1.5
local aimbotEnabled = false
local silentAimEnabled = false
local flyConnection = nil

-- ============================================
-- ESP
-- ============================================
local function ToggleESP(state)
    espEnabled = state
    print("[ASTRA] ESP: " .. (state and "ON" or "OFF"))
end

-- ============================================
-- X-RAY
-- ============================================
local function ToggleXRay(state)
    xrayEnabled = state
    if state then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                if not v.Parent:FindFirstChild("Humanoid") then
                    v.LocalTransparencyModifier = 0.3
                end
            end
        end
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.LocalTransparencyModifier = 0
            end
        end
    end
    print("[ASTRA] X-Ray: " .. (state and "ON" or "OFF"))
end

-- ============================================
-- FLY
-- ============================================
local function ToggleFly(state)
    flyEnabled = state
    if state then
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = true
        end
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = RunService.RenderStepped:Connect(function()
            if not flyEnabled then
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -flySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, flySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-flySpeed, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(flySpeed, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, flySpeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -flySpeed, 0) end
            hrp.Velocity = moveDir
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
    print("[ASTRA] Fly: " .. (state and "ON" or "OFF"))
end

-- ============================================
-- SPEED
-- ============================================
local function ToggleSpeed(state)
    speedEnabled = state
    local char = LP.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = state and (16 * speedMultiplier) or 16
    end
    print("[ASTRA] Speed: " .. (state and "ON" or "OFF"))
end

-- ============================================
-- AIMBOT
-- ============================================
local function ToggleAimbot(state)
    aimbotEnabled = state
    print("[ASTRA] Aimbot: " .. (state and "ON" or "OFF"))
end

-- ============================================
-- SILENT AIM
-- ============================================
local function ToggleSilentAim(state)
    silentAimEnabled = state
    print("[ASTRA] Silent Aim: " .. (state and "ON" or "OFF"))
end

-- ============================================
-- ПОДПИСКА НА СОБЫТИЯ
-- ============================================
local Events = getgenv().AstraEvents
if Events then
    Events:Connect("ESP", function(state) ToggleESP(state) end)
    Events:Connect("XRay", function(state) ToggleXRay(state) end)
    Events:Connect("Fly", function(state) ToggleFly(state) end)
    Events:Connect("Speed", function(state) ToggleSpeed(state) end)
    Events:Connect("Aimbot", function(state) ToggleAimbot(state) end)
    Events:Connect("SilentAim", function(state) ToggleSilentAim(state) end)
end

-- ============================================
-- АВТОЗАПУСК
-- ============================================
task.wait(1)
print("[ASTRA] Модуль Murder Mystery 2 загружен!")

return Module
