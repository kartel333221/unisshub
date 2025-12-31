-- UnissHub: Tap Simulator (Big Font & Rounded)
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

-- Click Animation
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
sg.Name = "UnissHub_BigText_Final"; sg.ResetOnSpawn = false

-- BUTTON U (Floating Toggle)
local uBtn = Instance.new("TextButton", sg)
uBtn.Size = UDim2.new(0, 50, 0, 50); uBtn.Position = UDim2.new(0, 50, 0.5, 0)
uBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); uBtn.Text = "U"
uBtn.TextColor3 = Color3.fromRGB(0, 150, 255); uBtn.Font = Enum.Font.GothamBold; uBtn.TextSize = 25
Instance.new("UICorner", uBtn)
Instance.new("UIStroke", uBtn).Color = Color3.fromRGB(0, 150, 255)
makeDraggable(uBtn)
applyClickEffect(uBtn)

-- MAIN WINDOW
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, 0, 0.5, 0); main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.ClipsDescendants = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 120, 255)
makeDraggable(main)

-- TOP CONTROL BUTTONS (X and Minimize)
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn)

local miniBtn = Instance.new("TextButton", main)
miniBtn.Size = UDim2.new(0, 30, 0, 30); miniBtn.Position = UDim2.new(1, -70, 0, 5)
miniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1); miniBtn.Font = Enum.Font.GothamBold; miniBtn.TextSize = 18
Instance.new("UICorner", miniBtn)

-- Sidebar
local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 130, 1, 0); sideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", sideBar)

local hubTitle = Instance.new("TextLabel", sideBar)
hubTitle.Size = UDim2.new(1, 0, 0, 50); hubTitle.Text = "UnissHub"; hubTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
hubTitle.Font = Enum.Font.GothamBold; hubTitle.TextSize = 20; hubTitle.BackgroundTransparency = 1

local btnMain = Instance.new("TextButton", sideBar)
btnMain.Size = UDim2.new(0.9, 0, 0, 35); btnMain.Position = UDim2.new(0.05, 0, 0.25, 0)
btnMain.Text = "Main"; btnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btnMain.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnMain)

local btnComm = Instance.new("TextButton", sideBar)
btnComm.Size = UDim2.new(0.9, 0, 0, 35); btnComm.Position = UDim2.new(0.05, 0, 0.4, 0)
btnComm.Text = "Community"; btnComm.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btnComm.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnComm)

-- Container
local container = Instance.new("Frame", main)
container.Size = UDim2.new(0, 320, 1, 0); container.Position = UDim2.new(0, 130, 0, 0); container.BackgroundTransparency = 1

-- PAGE: MAIN
local pageMain = Instance.new("Frame", container)
pageMain.Size = UDim2.new(1, 0, 1, 0); pageMain.BackgroundTransparency = 1; pageMain.Visible = true

local toggleAC = Instance.new("TextButton", pageMain)
toggleAC.Size = UDim2.new(0.7, 0, 0, 55); toggleAC.Position = UDim2.new(0.03, 0, 0.18, 0) -- Чуть шире и выше
toggleAC.BackgroundColor3 = Color3.fromRGB(200, 50, 50); toggleAC.Text = "Auto Clicker: OFF"
toggleAC.TextColor3 = Color3.new(1,1,1); toggleAC.Font = Enum.Font.GothamBold; toggleAC.TextSize = 24 -- УВЕЛИЧЕННЫЙ ШРИФТ
Instance.new("UICorner", toggleAC)
applyClickEffect(toggleAC)

local gearBtn = Instance.new("TextButton", pageMain)
gearBtn.Size = UDim2.new(0, 55, 0, 55); gearBtn.Position = UDim2.new(0.76, 0, 0.18, 0)
gearBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); gearBtn.Text = "⚙️"; gearBtn.TextSize = 24
gearBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", gearBtn)
applyClickEffect(gearBtn)

local speedFrame = Instance.new("Frame", pageMain)
speedFrame.Size = UDim2.new(0.88, 0, 0, 0); speedFrame.Position = UDim2.new(0.05, 0, 0.42, 0)
speedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); speedFrame.ClipsDescendants = true; Instance.new("UICorner", speedFrame)
Instance.new("UIStroke", speedFrame).Color = Color3.fromRGB(50, 50, 50)

local speedInput = Instance.new("TextBox", speedFrame)
speedInput.Size = UDim2.new(0.9, 0, 0, 35); speedInput.Position = UDim2.new(0.05, 0, 0.35, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); speedInput.Text = "0.1"; speedInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedInput)

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 20); speedLabel.Text = "Click Delay (seconds)"; speedLabel.TextColor3 = Color3.new(0.7,0.7,0.7)
speedLabel.BackgroundTransparency = 1; speedLabel.TextSize = 12

-- PAGE: COMMUNITY
local pageComm = Instance.new("Frame", container)
pageComm.Size = UDim2.new(1, 0, 1, 0); pageComm.BackgroundTransparency = 1; pageComm.Visible = false

local dsBtn = Instance.new("TextButton", pageComm)
dsBtn.Size = UDim2.new(0.8, 0, 0, 45); dsBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
dsBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); dsBtn.Text = "Copy Discord Link"; dsBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", dsBtn)

-- Navigation
btnMain.MouseButton1Click:Connect(function()
    pageMain.Visible = true; pageComm.Visible = false
    btnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btnComm.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

btnComm.MouseButton1Click:Connect(function()
    pageMain.Visible = false; pageComm.Visible = true
    btnMain.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btnComm.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

gearBtn.MouseButton1Click:Connect(function()
    settingsVisible = not settingsVisible
    local targetSize = settingsVisible and UDim2.new(0.88, 0, 0, 75) or UDim2.new(0.88, 0, 0, 0)
    speedFrame:TweenSize(targetSize, "Out", "Quart", 0.3, true)
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

-- Loop
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
