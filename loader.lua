-- JK Hub: Ultimate Steal Panel (Halloween Update)
local PLACE, UNIVERSE = 107778070777162, 10563114921
if game.PlaceId ~= PLACE and game.GameId ~= UNIVERSE then return end

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Данные
local normalEggs = {}
local halloweenEggs = {}
local currentTab = "Normal"
local autoStealOn = false
local tweenSpeed = 120

-- Ивенты
local networking = RS:WaitForChild("Packages"):WaitForChild("Networking")
local remoteCarry = networking:FindFirstChild("RF/EggWorld/AskFieldEggCarry")

-- === ИНТЕРФЕЙС (Кнопка вызова) ===
local gui = Instance.new("ScreenGui")
gui.Name = "UltimatePanel"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
toggleBtn.Text = "🎃"
toggleBtn.TextSize = 24
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- === ОСНОВНАЯ ПАНЕЛЬ (Steal Panel) ===
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 350, 0, 480)
panel.Position = UDim2.new(0.5, -175, 0.5, -240)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
panel.Visible = false
panel.Active = true
panel.Draggable = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local pStroke = Instance.new("UIStroke", panel)
pStroke.Color = Color3.fromRGB(255, 120, 0)
pStroke.Thickness = 2

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
titleBar.Parent = panel
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Steal Panel"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBlack
titleText.TextSize = 22
titleText.Parent = titleBar

-- Кнопки вкладок (Обычные / Хэллоуин)
local tabNormal = Instance.new("TextButton")
tabNormal.Size = UDim2.new(0.45, 0, 0, 30)
tabNormal.Position = UDim2.new(0.03, 0, 0, 50)
tabNormal.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
tabNormal.Text = "Обычные"
tabNormal.TextColor3 = Color3.fromRGB(0,0,0)
tabNormal.Font = Enum.Font.GothamBold
tabNormal.Parent = panel
Instance.new("UICorner", tabNormal).CornerRadius = UDim.new(0, 6)

local tabHalloween = Instance.new("TextButton")
tabHalloween.Size = UDim2.new(0.45, 0, 0, 30)
tabHalloween.Position = UDim2.new(0.52, 0, 0, 50)
tabHalloween.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
tabHalloween.Text = "Хэллоуин 🎃"
tabHalloween.TextColor3 = Color3.fromRGB(255,255,255)
tabHalloween.Font = Enum.Font.GothamBold
tabHalloween.Parent = panel
Instance.new("UICorner", tabHalloween).CornerRadius = UDim.new(0, 6)

-- Панель управления (Auto Steal + Speed)
local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(0.95, 0, 0, 35)
controlFrame.Position = UDim2.new(0.025, 0, 0, 90)
controlFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
controlFrame.Parent = panel
Instance.new("UICorner", controlFrame).CornerRadius = UDim.new(0, 6)

local autoStealBtn = Instance.new("TextButton")
autoStealBtn.Size = UDim2.new(0.48, 0, 1, 0)
autoStealBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
autoStealBtn.Text = "Auto Steal: OFF"
autoStealBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
autoStealBtn.Font = Enum.Font.GothamBold
autoStealBtn.TextSize = 12
autoStealBtn.Parent = controlFrame
Instance.new("UICorner", autoStealBtn).CornerRadius = UDim.new(0, 6)
[18.10.2026 18:15] skript_10: local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.48, 0, 1, 0)
speedLabel.Position = UDim2.new(0.52, 0, 0, 0)
speedLabel.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
speedLabel.Text = "Tween Speed: 120%"
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 12
speedLabel.Parent = controlFrame
Instance.new("UICorner", speedLabel).CornerRadius = UDim.new(0, 6)

-- Список яиц
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0, 330)
scroll.Position = UDim2.new(0.025, 0, 0, 135)
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 4
scroll.Parent = panel
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

-- === ЛОГИКА ИНТЕРФЕЙСА ===
toggleBtn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)

tabNormal.MouseButton1Click:Connect(function()
    currentTab = "Normal"
    tabNormal.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
    tabNormal.TextColor3 = Color3.fromRGB(0,0,0)
    tabHalloween.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    tabHalloween.TextColor3 = Color3.fromRGB(255,255,255)
end)

tabHalloween.MouseButton1Click:Connect(function()
    currentTab = "Halloween"
    tabHalloween.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    tabHalloween.TextColor3 = Color3.fromRGB(0,0,0)
    tabNormal.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    tabNormal.TextColor3 = Color3.fromRGB(255,255,255)
end)

-- === ПЕРЕХВАТ ДАННЫХ ===
for _, v in ipairs(RS:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        v.OnClientEvent:Connect(function(...)
            for _, arg in ipairs({...}) do
                if type(arg) == "table" then
                    -- Если это одиночное яйцо
                    if arg.uid and arg.amount then
                        local isHalloween = v.Name:find("PenRoster") or v.Name:find("Coins") -- Эвристика: если ивент связан с коинами, кидаем в хэллоуин
                        local data = {amount = arg.amount, name = arg.name or "Egg ID: "..tostring(arg.uid):sub(1,5)}
                        
                        if currentTab == "Halloween" or isHalloween then
                            halloweenEggs[arg.uid] = data
                        else
                            normalEggs[arg.uid] = data
                        end
                    -- Если массив
                    elseif arg[1] and type(arg[1]) == "table" then
                        for _, item in pairs(arg) do
                            if item.uid and item.amount then
                                local isHalloween = v.Name:find("PenRoster") or v.Name:find("Coins")
                                local data = {amount = item.amount, name = item.name or "Egg ID: "..tostring(item.uid):sub(1,5)}
                                
                                if currentTab == "Halloween" or isHalloween then
                                    halloweenEggs[item.uid] = data
                                else
                                    normalEggs[item.uid] = data
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- === ОБНОВЛЕНИЕ СПИСКА ===
local function updateUI()
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    local targetData = (currentTab == "Normal") and normalEggs or halloweenEggs
    local sorted = {}
    for uid, data in pairs(targetData) do
        if data.amount >= 10000000 then -- Фильтр >10M
            table.insert(sorted, {uid = uid, data = data})
        end
    end
    table.sort(sorted, function(a, b) return a.data.amount > b.data.amount end)
[18.10.2026 18:15] skript_10: for i, egg in ipairs(sorted) do
        -- Рядок яйца (как на скрине)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 55)
        row.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        -- Название / UID
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(0.6, 0, 0, 20)
        nameLbl.Position = UDim2.new(0.05, 0, 0, 5)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = egg.data.name
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Parent = row

        -- Цена
        local priceStr = string.format("%.1fM/s", egg.data.amount / 1000000)
        if egg.data.amount >= 1000000000 then priceStr = string.format("%.1fB/s", egg.data.amount / 1000000000) end
        
        local priceLbl = Instance.new("TextLabel")
        priceLbl.Size = UDim2.new(0.6, 0, 0, 20)
        priceLbl.Position = UDim2.new(0.05, 0, 0, 25)
        priceLbl.BackgroundTransparency = 1
        priceLbl.Text = "💰 " .. priceStr
        priceLbl.TextColor3 = Color3.fromRGB(100, 220, 130)
        priceLbl.Font = Enum.Font.GothamBold
        priceLbl.TextSize = 12
        priceLbl.TextXAlignment = Enum.TextXAlignment.Left
        priceLbl.Parent = row

        -- Кнопка Steal
        local stealBtn = Instance.new("TextButton")
        stealBtn.Size = UDim2.new(0.25, 0, 0, 30)
        stealBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
        stealBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
        stealBtn.Text = "Steal"
        stealBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        stealBtn.Font = Enum.Font.GothamBold
        stealBtn.Parent = row
        Instance.new("UICorner", stealBtn).CornerRadius = UDim.new(0, 4)

        stealBtn.MouseButton1Click:Connect(function()
            if remoteCarry then
                pcall(function() remoteCarry:InvokeServer({uid = egg.uid}) end)
            end
        end)
    end
end

-- Обновляем каждые 1.5 секунды
task.spawn(function()
    while task.wait(1.5) do updateUI() end
end)

-- === АВТОКРАЖА ===
autoStealBtn.MouseButton1Click:Connect(function()
    autoStealOn = not autoStealOn
    if autoStealOn then
        autoStealBtn.Text = "Auto Steal: ON"
        autoStealBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        
        task.spawn(function()
            while autoStealOn do
                local targetData = (currentTab == "Normal") and normalEggs or halloweenEggs
                local bestUid = nil
                local maxAmount = 0
                
                for uid, data in pairs(targetData) do
                    if data.amount > maxAmount then
                        maxAmount = data.amount
                        bestUid = uid
                    end
                end

                if bestUid and remoteCarry then
                    pcall(function() remoteCarry:InvokeServer({uid = bestUid}) end)
                    targetData[bestUid] = nil
                    updateUI()
                end
                task.wait(2.5) -- Пауза античита
            end
        end)
    else
        autoStealBtn.Text = "Auto Steal: OFF"
        autoStealBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
    end
end)
