-- ===== Acek 菜单 - 移动端稳定版 =====
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- 清理旧界面
local oldGui = gui:FindFirstChild("AcekMenu")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcekMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = gui

-- ============================================
-- 1. 简化的加载动画
-- ============================================
local loadingFrame = Instance.new("Frame", screenGui)
loadingFrame.Size = UDim2.new(0, 220, 0, 100)
loadingFrame.Position = UDim2.new(0.5, -110, 0.5, -50)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
loadingFrame.BackgroundTransparency = 0.1
Instance.new("UICorner").CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel", loadingFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🚀 Acek 加载中"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold

local progressBg = Instance.new("Frame", loadingFrame)
progressBg.Size = UDim2.new(0.8, 0, 0, 12)
progressBg.Position = UDim2.new(0.1, 0, 0.5, -6)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 45, 58)
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

local progressFill = Instance.new("Frame", progressBg)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

local progressText = Instance.new("TextLabel", loadingFrame)
progressText.Size = UDim2.new(1, 0, 0, 20)
progressText.Position = UDim2.new(0, 0, 0.7, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(180, 190, 210)
progressText.TextSize = 14
progressText.Font = Enum.Font.Gotham

-- 模拟加载进度
for i = 0, 100 do
    progressFill.Size = UDim2.new(i/100, 0, 1, 0)
    progressText.Text = i .. "%"
    task.wait(0.01)
end
task.wait(0.2)
loadingFrame.Visible = false

-- ============================================
-- 2. 主菜单 UI
-- ============================================
local windowWidth, windowHeight = 230, 340
local isMenuOpen = false

-- 主窗口
local mainWindow = Instance.new("Frame", screenGui)
mainWindow.Size = UDim2.new(0, windowWidth, 0, windowHeight)
mainWindow.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
mainWindow.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
mainWindow.Visible = false
Instance.new("UICorner").CornerRadius = UDim.new(0, 14)
local border = Instance.new("UIStroke", mainWindow)
border.Color = Color3.fromRGB(30, 144, 255)
border.Thickness = 1.5

-- 标题栏 (可拖动区域)
local titleBar = Instance.new("Frame", mainWindow)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Acek"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -36, 0, 4)
closeButton.BackgroundTransparency = 1
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold

-- 内容区域 (滚动列表)
local contentFrame = Instance.new("ScrollingFrame", mainWindow)
contentFrame.Size = UDim2.new(1, -16, 1, -55)
contentFrame.Position = UDim2.new(0, 8, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 3

local uiList = Instance.new("UIListLayout", contentFrame)
uiList.Padding = UDim.new(0, 6)

-- ============================================
-- 3. 辅助函数
-- ============================================
local function getCharacter()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        return char
    end
    return nil
end

local function createValueItem(label, defaultValue, applyFunction, maxValue)
    local itemFrame = Instance.new("Frame", contentFrame)
    itemFrame.Size = UDim2.new(1, 0, 0, 38)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
    itemFrame.BackgroundTransparency = 0.3
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

    local labelText = Instance.new("TextLabel", itemFrame)
    labelText.Size = UDim2.new(0.3, 0, 1, 0)
    labelText.Position = UDim2.new(0, 8, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    labelText.TextSize = 13
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left

    local inputBox = Instance.new("TextBox", itemFrame)
    inputBox.Size = UDim2.new(0.4, 0, 1, -8)
    inputBox.Position = UDim2.new(0.35, 0, 0, 4)
    inputBox.BackgroundColor3 = Color3.fromRGB(15, 17, 27)
    inputBox.Text = tostring(defaultValue)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 13
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

    local applyButton = Instance.new("TextButton", itemFrame)
    applyButton.Size = UDim2.new(0, 32, 1, -8)
    applyButton.Position = UDim2.new(1, -36, 0, 4)
    applyButton.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    applyButton.Text = "✓"
    applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyButton.TextSize = 14
    applyButton.Font = Enum.Font.GothamBold
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

    local function applyValue()
        local value = tonumber(inputBox.Text)
        if not value then
            inputBox.Text = tostring(defaultValue)
            return
        end
        if maxValue and value > maxValue then
            value = maxValue
            inputBox.Text = tostring(value)
        end
        if value < 0 then value = 0 end
        if applyFunction then applyFunction(value) end
    end

    applyButton.MouseButton1Down:Connect(applyValue)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then applyValue() end
    end)

    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y)
    end)
end

local function createActionButton(text, callback)
    local button = Instance.new("TextButton", contentFrame)
    button.Size = UDim2.new(1, 0, 0, 36)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BackgroundColor3 = Color3.fromRGB(50, 52, 68)
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    button.MouseButton1Down:Connect(callback)

    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y)
    end)
end

-- ============================================
-- 4. 添加功能项
-- ============================================
createValueItem("速度", 16, function(v) local c = getCharacter(); if c then c.Humanoid.WalkSpeed = v end end, 50000000)
createValueItem("跳跃", 7.2, function(v) local c = getCharacter(); if c then c.Humanoid.JumpHeight = v end end, 10000000)
createValueItem("重力", 196.2, function(v) game.Workspace.Gravity = v end)
createValueItem("重生值", 0, function(v)
    local stats = player:FindFirstChild("leaderstats")
    local rebirth = stats and stats:FindFirstChild("Rebirths")
    if rebirth then rebirth:SetAttribute("FakeValue", v) end
end, 99999999999999)

-- 分隔线
local divider = Instance.new("Frame", contentFrame)
divider.Size = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(60, 62, 80)
divider.BackgroundTransparency = 0.5

createActionButton("清除假值", function()
    local stats = player:FindFirstChild("leaderstats")
    if stats then
        for _, child in pairs(stats:GetChildren()) do
            child:SetAttribute("FakeValue", nil)
        end
    end
end)

createActionButton("恢复默认", function()
    local c = getCharacter()
    if c then c.Humanoid.WalkSpeed = 16; c.Humanoid.JumpHeight = 7.2 end
    game.Workspace.Gravity = 196.2
end)

local godMode = false
createActionButton("无敌模式", function()
    godMode = not godMode
    local c = getCharacter()
    if c and godMode then c.Humanoid.Health = c.Humanoid.MaxHealth end
end)

-- ============================================
-- 5. 可拖动的浮动按钮
-- ============================================
local floatButton = Instance.new("TextButton", screenGui)
floatButton.Size = UDim2.new(0, 72, 0, 40)
floatButton.Position = UDim2.new(1, -82, 1, -55)
floatButton.Text = "Acek"
floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatButton.TextSize = 18
floatButton.Font = Enum.Font.GothamBold
floatButton.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(0, 20)

-- ============================================
-- 6. 核心交互逻辑 (使用 UserInputService)
-- ============================================
local isDraggingFloat = false
local isDraggingWindow = false
local dragStartPos, dragStartMouse

-- 浮动按钮拖动
floatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingFloat = true
        dragStartPos = floatButton.Position
        dragStartMouse = input.Position
    end
end)

floatButton.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and isDraggingFloat then
        local delta = input.Position - dragStartMouse
        floatButton.Position = UDim2.new(0, dragStartPos.X.Offset + delta.X, 0, dragStartPos.Y.Offset + delta.Y)
    end
end)

-- 窗口拖动
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = true
        dragStartPos = mainWindow.Position
        dragStartMouse = input.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and isDraggingWindow then
        local delta = input.Position - dragStartMouse
        mainWindow.Position = UDim2.new(0, dragStartPos.X.Offset + delta.X, 0, dragStartPos.Y.Offset + delta.Y)
    end
end)

-- 全局释放（手指或鼠标抬起）
inputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingFloat = false
        isDraggingWindow = false
    end
end)

-- ============================================
-- 7. 窗口控制
-- ============================================
local function toggleMenu()
    if isDraggingFloat or isDraggingWindow then return end
    isMenuOpen = not isMenuOpen
    mainWindow.Visible = isMenuOpen
end

floatButton.MouseButton1Down:Connect(toggleMenu)
closeButton.MouseButton1Down:Connect(toggleMenu)

-- R 键快捷键
inputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R and input.UserInputType == Enum.UserInputType.Keyboard then
        toggleMenu()
    end
end)

print("✅ Acek 稳定版已加载！")
print("📌 点击 'Acek' 按钮开关菜单，按住拖动它")
print("📌 按住标题栏灰色区域拖动窗口")
print("📌 按 R 键也可以开关菜单")
