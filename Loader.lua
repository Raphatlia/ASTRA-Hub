-- ASTRA HUB V3.0 - УНИВЕРСАЛЬНЫЙ ЗАГРУЗЧИК
local HttpService = game:GetService("HttpService")

-- Список всех файлов, которые нужны для работы хаба
local Files = {
    ["main"] = "https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/main.lua",
    ["AstraHub_A_Desrt"] = "https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Desrt.lua",
    ["AstraHub_A_Long_Road"] = "https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/AstraHub_A_Long_Road.lua",
    ["Astra_Hub_mm2"] = "https://raw.githubusercontent.com/Raphatlia/ASTRA-Hub/main/Astra_Hub_mm2.lua"  -- <-- НОВЫЙ
}

-- Создаём папку в ReplicatedStorage, если её нет
local RS = game:GetService("ReplicatedStorage")
local ModuleFolder = RS:FindFirstChild("ASTRA_Modules")
if not ModuleFolder then
    ModuleFolder = Instance.new("Folder")
    ModuleFolder.Name = "ASTRA_Modules"
    ModuleFolder.Parent = RS
end

-- Скачиваем и сохраняем каждый файл
for name, url in pairs(Files) do
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)
    
    if success then
        local module = Instance.new("ModuleScript")
        module.Name = name
        module.Source = result
        module.Parent = ModuleFolder
        print("[ASTRA] Модуль " .. name .. " успешно скачан и установлен!")
    else
        warn("[ASTRA] Ошибка при скачивании " .. name)
    end
end

-- Запускаем главный хаб
local mainScript = ModuleFolder:FindFirstChild("main")
if mainScript then
    require(mainScript)
    print("[ASTRA] ASTRA HUB V3.0 запущен!")
else
    warn("[ASTRA] Не удалось найти main скрипт после загрузки!")
end
