-- ===== Acek Menu - 手机适配版 =====
local p = game.Players.LocalPlayer
local gui = p:WaitForChild("PlayerGui")
local ts = game:GetService("TweenService")
local input = game:GetService("UserInputService")

-- ===== 获取屏幕尺寸用于适配 =====
local screenSize = gui.AbsoluteSize
local isTablet = screenSize.X > 800  -- 粗略判断平板/手机

-- ===== 创建GUI（手机置顶修复）=====
local screen = Instance.new("ScreenGui")
screen.Name = "AcekMenu"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true  -- 避开刘海/圆角
screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
screen.Parent = gui

-- ===== 圆形按钮（手机友好尺寸）=====
local btn = Instance.new("ImageButton")
btn.Size = UDim2.new(0, isTablet and 70 or 55, 0, isTablet and 70 or 55)  -- 手机稍小，平板稍大
btn.Position = UDim2.new(1, -(isTablet and 90 or 70), 1, -(isTablet and 120 or 100))  -- 右下角，避开虚拟按键
btn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
btn.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
Instance.new("UICorner", btn).Parent = btn

-- 按钮文字（手机字体适配）
local label = Instance.new("TextLabel", btn)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "acek"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold

-- ===== 菜单窗口（手机全屏适配）=====
local menuWidth = isTablet and 400 or 300
local menuHeight = isTablet and 500 or 400

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, menuWidth, 0, menuHeight)
menu.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)  -- 居中
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
menu.Visible = false
menu.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", menu)
stroke.Color = Color3.fromRGB(30, 144, 255)
stroke.Thickness = 2

-- ===== 标题栏（可拖动）=====
local title = Instance.new("Frame", menu)
title.Size = UDim2.new(1, 0, 0, isTablet and 50 or 44)
title.BackgroundTransparency = 1

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Acek Menu"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = isTablet and 24 or 20
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", title)
close.Size = UDim2.new(0, isTablet and 40 or 34, 0, isTablet and 40 or 34)
close.Position = UDim2.new(1, -(isTablet and 48 or 40), 0, (isTablet and 5 or 5))
close.BackgroundTransparency = 1
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = isTablet and 24 or 20
close.Font = Enum.Font.GothamBold

-- ===== 内容区域（手机滚动适配）=====
local content = Instance.new("ScrollingFrame", menu)
content.Size = UDim2.new(1, -20, 1, -(isTablet and 90 or 80))
content.Position = UDim2.new(0, 10, 0, isTablet and 55 or 50)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 8)

-- ===== 添加菜单项（手机触摸适配）=====
local function addItem(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, isTablet and 50 or 44)  -- 手机触控更大
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.BackgroundTransparency = 0.3
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = isTablet and 18 or 15
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    
    -- 手机触摸反馈
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(60, 60, 80) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(40, 40, 55) end)
    b.MouseButton1Click:Connect(cb)
    b.MouseButton1Down:Connect(function()  -- 触摸按下反馈
        b.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end)
    b.MouseButton1Up:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- ===== 功能列表 =====
local function getHumanoid()
    local c = p.Character
    return c and c:FindFirstChild("Humanoid")
end

addItem("🔹 重生值显示 9999", function()
    local ls = p:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rebirths")
    if r then r:SetAttribute("FakeValue", 9999) end
end)

addItem("🔸 清除所有假值", function()
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        for _, v in pairs(ls:GetChildren()) do v:SetAttribute("FakeValue", nil) end
    end
end)

addItem("🚀 行走速度 100", function()
    local h = getHumanoid()
    if h then h.WalkSpeed = 100 end
end)

addItem("🔄 恢复行走速度", function()
    local h = getHumanoid()
    if h then h.WalkSpeed = 16 end
end)

addItem("⬆ 跳跃高度 100", function()
    local h = getHumanoid()
    if h then h.JumpHeight = 100 end
end)

local god = false
addItem("🛡 切换无敌模式", function()
    god = not god
    local h = getHumanoid()
    if h and god then h.Health = h.MaxHealth end
end)

-- ===== 开关动画 =====
local open = false

local function toggleMenu()
    open = not open
    menu.Visible = open
    if open then
        menu.Size = UDim2.new(0, 0, 0, 0)
        menu.Position = UDim2.new(0.5, 0, 0.5, 0)
        menu.BackgroundTransparency = 0.5
        local t = ts:Create(menu, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, menuWidth, 0, menuHeight),
            Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2),
            BackgroundTransparency = 0.05
        })
        t:Play()
    else
        local t = ts:Create(menu, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 0.5
        })
        t:Play()
        t.Completed:Connect(function()
            menu.Visible = false
        end)
    end
end

-- ===== 手机拖拽功能（触摸支持）=====
local dragging, dragStart, startPos = false

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = menu.Position
end

local function updateDrag(input)
    if not dragging then return end
    local d = input.Position - dragStart
    -- 计算新位置，允许略微超出边界
    local newX = startPos.X.Offset + d.X
    local newY = startPos.Y.Offset + d.Y
    menu.Position = UDim2.new(0, newX, 0, newY)
end

local function endDrag()
    dragging = false
end

-- 支持鼠标和触摸
title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or 
       i.UserInputType == Enum.UserInputType.Touch then
        startDrag(i)
    end
end)

title.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or
       i.UserInputType == Enum.UserInputType.Touch then
        updateDrag(i)
    end
end)

input.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then
        endDrag()
    end
end)

-- ===== 事件绑定 =====
btn.MouseButton1Click:Connect(toggleMenu)
close.MouseButton1Click:Connect(toggleMenu)

-- 按钮悬停/触摸反馈
btn.MouseEnter:Connect(function()
    ts:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 160, 255)}):Play()
    ts:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, (isTablet and 75 or 60), 0, (isTablet and 75 or 60))}):Play()
end)
btn.MouseLeave:Connect(function()
    ts:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 144, 255)}):Play()
    ts:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, (isTablet and 70 or 55), 0, (isTablet and 70 or 55))}):Play()
end)

-- ===== 手机物理返回键（如果有）=====
input.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Back then
        if open then toggleMenu() end
    end
end)

-- ===== 键盘快捷键（外接键盘时）=====
input.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then
        toggleMenu()
    end
end)

print("[Acek] 手机版加载完成 ✓")
print("[Acek] 提示：点击右下角蓝色圆形按钮打开菜单")
print("[Acek] 提示：按 R 键（外接键盘）或物理返回键也可开关")
