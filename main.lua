-- UnissHub: Tap Simulator Edition
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local DISCORD_LINK = "https://discord.gg/mVzz2KaZ"

-- Переменные автокликера
local autoClickerEnabled = false
local clickDelay = 0.1

-- Функция анимации клика (универсальная)
local function applyClickEffect(button)
    local startSize = button.Size
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            button:TweenSize(UDim2.new(startSize.X.Scale, startSize.X.Offset - 3, startSize.Y.Scale, startSize.Y.Offset - 3), "Out", "Quad", 0.1, true)
        end
    end)
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            button:TweenSize(startSize, "Out", "Quad", 0.1, true)
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
sg.Name = "UnissHub_TapSim"; sg.ResetOnSpawn = false

-- КНОПКА U
local uBtn = Instance.new("TextButton", sg)
uBtn.Size = UDim2.new(0, 50, 0, 50); uBtn.Position = UDim2.new(0, 50, 0.5, 0)
uBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); uBtn.Text = "U"
uBtn.TextColor3 = Color3.fromRGB(0, 150, 255); uBtn.Font = Enum.Font.GothamBold; uBtn.TextSize = 25
Instance.new("UICorner", uBtn)
Instance.new("UIStroke", uBtn).Color = Color3.fromRGB(0, 150, 255)
makeDraggable(uBtn)
applyClickEffect(uBtn)

-- ГЛАВНОЕ ОКНО (35% экрана примерно)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, 0, 0.5, 0); main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.ClipsDescendants = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 120, 255)
makeDraggable(main)

-- Боковая панель
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 120, 1, 0); sideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", sideBar)

local hubTitle = Instance.new("TextLabel", sideBar)
hubTitle.Size = UDim2.new(1, 0, 0, 40); hubTitle.Text = "UnissHub"; hubTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
hubTitle.Font = Enum.Font.GothamBold; hubTitle.TextSize = 18; hubTitle.BackgroundTransparency = 1

-- Кнопки меню
local btnMain = Instance.new("TextButton", sideBar)
btnMain.Size = UDim2.new(0.9, 0, 0, 35); btnMain.Position = UDim2.new(0.05, 0, 0.2, 0)
btnMain.Text = "Основное"; btnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btnMain.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnMain)

local btnComm = Instance.new("TextButton", sideBar)
btnComm.Size = UDim2.new(0.9, 0, 0, 35); btnComm.Position = UDim2.new(0.05, 0, 0.35, 0)
btnComm.Text = "Комьюнити"; btnComm.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btnComm.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnComm)

-- Контентные части
local container = Instance.new("Frame", main)
container.Size = UDim2.new(0, 330, 1, 0); container.Position = UDim2.new(0, 120, 0, 0); container.BackgroundTransparency = 1

-- СТРАНИЦА: ОСНОВНОЕ
local pageMain = Instance.new("Frame", container)
pageMain.Size = UDim2.new(1, 0, 1, 0); pageMain.BackgroundTransparency = 1; pageMain.Visible = true

local toggleAC = Instance.new("TextButton", pageMain)
toggleAC.Size = UDim2.new(0.8, 0, 0, 40); toggleAC.Position = UDim2.new(0.1, 0, 0.2, 0)
toggleAC.BackgroundColor3 = Color3.fromRGB(200, 50, 50); toggleAC.Text = "Автокликер: ВЫКЛ"
toggleAC.TextColor3 = Color3.new(1,1,1); toggleAC.Font = Enum.Font.GothamBold; Instance.new("UICorner", toggleAC)

local speedLabel = Instance.new("TextLabel", pageMain)
speedLabel.Size = UDim2.new(0.8, 0, 0, 20); speedLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
speedLabel.Text = "Скорость (сек):"; speedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8); speedLabel.BackgroundTransparency = 1; speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", pageMain)
speedInput.Size = UDim2.new(0.8, 0, 0, 35); speedInput.Position = UDim2.new(0.1, 0, 0.55, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30); speedInput.Text = "0.1"; speedInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedInput)

-- СТРАНИЦА: КОМЬЮНИТИ
local pageComm = Instance.new("Frame", container)
pageComm.Size = UDim2.new(1, 0, 1, 0); pageComm.BackgroundTransparency = 1; pageComm.Visible = false

local dsBtn = Instance.new("TextButton", pageComm)
dsBtn.Size = UDim2.new(0.8, 0, 0, 40); dsBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
dsBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); dsBtn.Text = "Скопировать Discord"; dsBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", dsBtn)

-- ЛОГИКА ПЕРЕКЛЮЧЕНИЯ СТРАНИЦ
btnMain.MouseButton1Click:Connect(function()
    pageMain.Visible = true; pageComm.Visible = false
    btnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btnComm.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

btnComm.MouseButton1Click:Connect(function()
    pageMain.Visible = false; pageComm.Visible = true
    btnMain.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btnComm.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

-- ЛОГИКА АВТОКЛИКЕРА
toggleAC.MouseButton1Click:Connect(function()
    autoClickerEnabled = not autoClickerEnabled
    if autoClickerEnabled then
        toggleAC.Text = "Автокликер: ВКЛ"
        toggleAC.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        toggleAC.Text = "Автокликер: ВЫКЛ"
        toggleAC.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then clickDelay = val else speedInput.Text = tostring(clickDelay) end
end)

task.spawn(function()
    while true do
        if autoClickerEnabled then
            -- Виртуальный клик в позицию мышки
            pcall(function()
                local virtualUser = game:GetService("VirtualUser")
                virtualUser:CaptureController()
                virtualUser:ClickButton1(Vector2.new(Mouse.X, Mouse.Y))
            end)
        end
        task.wait(clickDelay)
    end
end)

-- Копирование дискорда
dsBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_LINK)
    dsBtn.Text = "Скопировано!"
    task.wait(2)
    dsBtn.Text = "Скопировать Discord"
end)

-- Открытие/Закрытие
uBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
