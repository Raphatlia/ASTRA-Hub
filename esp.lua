-- ==========================================================
-- BLOX STRIKE ESP (СТЭНДЭЛОН)
-- ==========================================================

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local espObjects = {}

local function createFpsEsp()
    local obj = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text")
    }
    obj.Box.Thickness = 1.2
    obj.Box.Color = Color3.fromRGB(0, 255, 255)
    obj.Box.Filled = false
    obj.Box.Transparency = 0.6
    
    obj.Name.Size = 14
    obj.Name.Outline = true
    obj.Name.Color = Color3.fromRGB(255, 255, 255)
    obj.Name.Center = true
    
    obj.Health.Size = 12
    obj.Health.Outline = true
    obj.Health.Color = Color3.fromRGB(100, 255, 100)
    obj.Health.Center = true
    return obj
end

RunService.RenderStepped:Connect(function()
    local localPlayer = Players.LocalPlayer
    if not localPlayer then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            
            if head and torso then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health <= 0 then
                    if espObjects[player] then
                        espObjects[player].Box.Visible = false
                        espObjects[player].Name.Visible = false
                        espObjects[player].Health.Visible = false
                    end
                    continue
                end

                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                local torsoPos, torsoOnScreen = Camera:WorldToViewportPoint(torso.Position)
                
                if headOnScreen and torsoOnScreen then
                    local distance = math.floor((Camera.CFrame.Position - torso.Position).Magnitude)
                    local scale = math.clamp(250 / distance, 0.3, 2.0)
                    
                    local width = 60 * scale
                    local height = (headPos.Y - torsoPos.Y) + 30 * scale
                    local x = torsoPos.X - (width / 2)
                    local y = headPos.Y - (height / 2) + 20 * scale
                    
                    if not espObjects[player] then
                        espObjects[player] = createFpsEsp()
                    end
                    
                    local obj = espObjects[player]
                    
                    obj.Box.Size = Vector2.new(width, height)
                    obj.Box.Position = Vector2.new(x, y)
                    obj.Box.Visible = true
                    
                    obj.Name.Text = player.Name
                    obj.Name.Position = Vector2.new(torsoPos.X, headPos.Y - (height/2) - 30 * scale)
                    obj.Name.Visible = true
                    
                    local hpText = "Alive"
                    if humanoid then
                        hpText = tostring(math.floor(humanoid.Health)) .. " HP"
                    end
                    obj.Health.Text = hpText
                    obj.Health.Position = Vector2.new(torsoPos.X, torsoPos.Y + 10)
                    obj.Health.Visible = true
                else
                    if espObjects[player] then
                        espObjects[player].Box.Visible = false
                        espObjects[player].Name.Visible = false
                        espObjects[player].Health.Visible = false
                    end
                end
            end
        end
    end
    
    for player, obj in pairs(espObjects) do
        if not Players:FindFirstChild(player.Name) then
            obj.Box:Remove()
            obj.Name:Remove()
            obj.Health:Remove()
            espObjects[player] = nil
        end
    end
end)

print("✅ SpaceBerq ESP запущен!")
