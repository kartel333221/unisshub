-- UnissHub: Tap Simulator (Sharp Rectangles & Big Font)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager") 
local Player = Players.LocalPlayer

local DISCORD_LINK = "https://discord.gg/mVzz2KaZ"

-- Variables
local autoClickerEnabled = false
local clickDelay = 0.1
local settingsVisible = false

-- УЛУЧШЕННАЯ АНИМАЦИЯ (Сжатие к центру)
local function applyClickEffect(button)
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    local originalPos = button.Position
    -- Корректируем позицию, так как AnchorPoint теперь 0.5
    button.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + (button.Size.X.Offset/2), originalPos.Y.Scale, originalPos.Y.Offset + (button.Size.Y.Offset/2))
    
    local startSize = button.Size
    local clickSize = UDim2.new(startSize.X.Scale, startSize.X.Offset - 4, startSize.Y.Scale, startSize.Y.Offset - 4)

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            TweenService:Create(button, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = clickSize}):Play()
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = startSize}):Play()
        end
    end)
end

-- Dragging
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
sg.Name = "UnissHub_Sharp_Edition"; sg.ResetOnSpawn = false

-- КНОПКА U
local uBtn = Instance.new("TextButton", sg)
uBtn.Size = UDim2.new(0, 50, 0, 50); uBtn.Position = UDim2.new(0, 50, 0.5, 0)
uBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); uBtn.Text = "U"
uBtn.TextColor3 = Color3.fromRGB(0, 150, 255); uBtn.Font = Enum.Font.GothamBold; uBtn.TextSize = 25
Instance.new("UIStroke", uBtn).Color = Color3.fromRGB(0, 150, 255)
makeDraggable(uBtn)

-- ГЛАВНОЕ ОКНО
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, 0, 0.5, 0); main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BorderSizePixel = 0
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 120, 255)
makeDraggable(main)

-- TOP BUTTONS (X and -)
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 35, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40); closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.BorderSizePixel = 0

local miniBtn = Instance.new("TextButton", main)
miniBtn.Size = UDim2.new(0, 35, 0, 30); miniBtn.Position = UDim2.new(1, -70, 0, 0)
miniBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); miniBtn.Text = "_"
miniBtn.TextColor3 = Color3.new(1,1,1); miniBtn.Font = Enum.Font.GothamBold; miniBtn.BorderSizePixel = 0

-- Sidebar
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 130, 1, 0); sideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); sideBar.BorderSizePixel = 0

local hubTitle = Instance.new("TextLabel", sideBar)
hubTitle.Size = UDim2.new(1, 0, 0, 50); hubTitle.Text = "UnissHub"; hubTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
hubTitle.Font = Enum.Font.GothamBold; hubTitle.TextSize = 22; hubTitle.BackgroundTransparency = 1

local btnMain = Instance.new("TextButton", sideBar)
btnMain.Size = UDim2.new(1, 0, 0, 45); btnMain.Position = UDim2.new(0, 0, 0.2, 0)
btnMain.Text = "Main"; btnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btnMain.TextColor3 = Color3.new(1,1,1); btnMain.BorderSizePixel = 0

local btnComm = Instance.new("TextButton", sideBar)
btnComm.Size = UDim2.new(1, 0, 0, 45); btnComm.Position = UDim2.new(0, 0, 0.35, 0)
btnComm.Text = "Community"; btnComm.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btnComm.TextColor3 = Color3.new(1,1,1); btnComm.BorderSizePixel = 0

-- Container
local container = Instance.new("Frame", main)
container.Size = UDim2.new(0, 320, 1, 0); container.Position = UDim2.new(0, 130, 0, 0); container.BackgroundTransparency = 1

-- PAGE: MAIN
local pageMain = Instance.new("Frame", container)
pageMain.Size = UDim2.new(1, 0, 1, 0); pageMain.BackgroundTransparency = 1; pageMain.Visible = true

local toggleAC = Instance.new("TextButton", pageMain)
toggleAC.Size = UDim2.new(0, 180, 0, 50); toggleAC.Position = UDim2.new(0, 20, 0, 60)
toggleAC.BackgroundColor3 = Color3.fromRGB(200, 50, 50); toggleAC.Text = "Auto Clicker: OFF"
toggleAC.TextColor3 = Color3.new(1,1,1); toggleAC.Font = Enum.Font.GothamBold; toggleAC.TextSize = 20; toggleAC.BorderSizePixel = 0
applyClickEffect(toggleAC)

local gearBtn = Instance.new("TextButton", pageMain)
gearBtn.Size = UDim2.new(0, 50, 0, 50); gearBtn.Position = UDim2.new(0, 210, 0, 60)
gearBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); gearBtn.Text = "⚙️"; gearBtn.TextSize = 24; gearBtn.BorderSizePixel = 0
applyClickEffect(gearBtn)

local speedFrame = Instance.new("Frame", pageMain)
speedFrame.Size = UDim2.new(0.88, 0, 0, 0); speedFrame.Position = UDim2.new(0.06, 0, 0, 120)
speedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); speedFrame.ClipsDescendants = true; speedFrame.BorderSizePixel = 0

local speedInput = Instance.new("TextBox", speedFrame)
speedInput.Size = UDim2.new(0.9, 0, 0, 35); speedInput.Position = UDim2.new(0.05, 0, 0, 30)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); speedInput.Text = "0.1"; speedInput.TextColor3 = Color3.new(1,1,1); speedInput.BorderSizePixel = 0

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 25); speedLabel.Text = "Click Delay (seconds)"; speedLabel.TextColor3 = Color3.new(0.7,0.7,0.7)
speedLabel.BackgroundTransparency = 1; speedLabel.TextSize = 14

-- Community Page Logic
local pageComm = Instance.new("Frame", container)
pageComm.Size = UDim2.new(1, 0, 1, 0); pageComm.BackgroundTransparency = 1; pageComm.Visible = false
local dsBtn = Instance.new("TextButton", pageComm)
dsBtn.Size = UDim2.new(0.8, 0, 0, 50); dsBtn.Position = UDim2.new(0.1, 0, 0.4, 0); dsBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); dsBtn.Text = "Copy Discord Link"; dsBtn.TextColor3 = Color3.new(1,1,1); dsBtn.BorderSizePixel = 0

-- LOGIC
btnMain.MouseButton1Click:Connect(function() pageMain.Visible = true; pageComm.Visible = false; btnMain.BackgroundColor3 = Color3.fromRGB(30,30,30); btnComm.BackgroundColor3 = Color3.fromRGB(20,20,20) end)
btnComm.MouseButton1Click:Connect(function() pageMain.Visible = false; pageComm.Visible = true; btnMain.BackgroundColor3 = Color3.fromRGB(20,20,20); btnComm.BackgroundColor3 = Color3.fromRGB(30,30,30) end)

gearBtn.MouseButton1Click:Connect(function()
    settingsVisible = not settingsVisible
    speedFrame:TweenSize(settingsVisible and UDim2.new(0.88, 0, 0, 80) or UDim2.new(0.88, 0, 0, 0), "Out", "Quart", 0.3, true)
end)

toggleAC.MouseButton1Click:Connect(function()
    autoClickerEnabled = not autoClickerEnabled
    toggleAC.Text = autoClickerEnabled and "Auto Clicker: ON" or "Auto Clicker: OFF"
    toggleAC.BackgroundColor3 = autoClickerEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then clickDelay = val else speedInput.Text = tostring(clickDelay) end
end)

task.spawn(function()
    while true do
        if autoClickerEnabled then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
        end
        task.wait(clickDelay)
    end
end)

closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = false end)
uBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
dsBtn.MouseButton1Click:Connect(function() if setclipboard then setclipboard(DISCORD_LINK) dsBtn.Text = "Copied!" task.wait(2) dsBtn.Text = "Copy Discord Link" end end)
