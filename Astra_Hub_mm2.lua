-- ASTRA HUB — Модуль Murder Mystery 2
-- Автор: Raphatlia
-- Репозиторий: https://github.com/Raphatlia/ASTRA-Hub

local Module = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Детектор игры MM2
local function IsMM2Game()
    if Workspace:FindFirstChild("Murderer", true) then return true end
    if Workspace:FindFirstChild("Sheriff", true) then return true end
    if Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("GameGui") then return true end
    return false
end

if not IsMM2Game() then
    print("[ASTRA] Не MM2, модуль не загружен")
    return Module
end

print("[ASTRA] Murder Mystery 2 обнаружена! Загружаю функции...")

-- Переменные для функций
local ESPEnabled = false
local ESPLines = {}
local XRayEnabled = false
local FlyEnabled = false
local FlySpeed = 50
local SpeedEnabled = false
local SpeedMultiplier = 1.5
local AimbotEnabled = false
local SilentAimEnabled = false
local flyConnection = nil

-- Функция ESP
local function ToggleESP(state)
    ESPEnabled = state
    if state then
        print("[ASTRA] ESP включён")
        ShowToast("ESP ON")
    else
        print("[ASTRA] ESP выключен")
        for _, line in pairs(ESPLines) do
            line:Destroy()
        end
        ESPLines = {}
        ShowToast("ESP OFF")
    end
end

-- Функция X-Ray
local function ToggleXRay(state)
    XRayEnabled = state
    if state then
        print("[ASTRA] X-Ray включён")
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                if not v.Parent:FindFirstChild("Humanoid") then
                    v.LocalTransparencyModifier = 0.3
                end
            end
        end
        ShowToast("X-Ray ON")
    else
        print("[ASTRA] X-Ray выключен")
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.LocalTransparencyModifier = 0
            end
        end
        ShowToast("X-Ray OFF")
    end
end

-- Функция Fly
local function ToggleFly(state)
    FlyEnabled = state
    if state then
        print("[ASTRA] Fly включён")
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = true
        end
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled then
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            local char = Player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -FlySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, FlySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-FlySpeed, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(FlySpeed, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, FlySpeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -FlySpeed, 0) end
            hrp.Velocity = moveDir
        end)
        ShowToast("Fly ON")
    else
        print("[ASTRA] Fly выключен")
        if flyConnection then 
            flyConnection:Disconnect()
            flyConnection = nil
        end
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
        ShowToast("Fly OFF")
    end
end

-- Функция Speed
local function ToggleSpeed(state)
    SpeedEnabled = state
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            char.Humanoid.WalkSpeed = 16 * SpeedMultiplier
            ShowToast("Speed ON")
        else
            char.Humanoid.WalkSpeed = 16
            ShowToast("Speed OFF")
        end
    end
end

-- Функция Aimbot
local function ToggleAimbot(state)
    AimbotEnabled = state
    ShowToast("Aimbot " .. (state and "ON" or "OFF"))
end

-- Функция Silent Aim
local function ToggleSilentAim(state)
    SilentAimEnabled = state
    ShowToast("Silent Aim " .. (state and "ON" or "OFF"))
end

-- Экспорт функций
Module.ToggleESP = ToggleESP
Module.ToggleXRay = ToggleXRay
Module.ToggleFly = ToggleFly
Module.ToggleSpeed = ToggleSpeed
Module.ToggleAimbot = ToggleAimbot
Module.ToggleSilentAim = ToggleSilentAim

return Module
