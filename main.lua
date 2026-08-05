-- ===== Acek Menu - 精简版 =====
local p = game.Players.LocalPlayer
local gui = p:WaitForChild("PlayerGui")
local ts = game:GetService("TweenService")
local input = game:GetService("UserInputService")

-- 创建GUI
local screen = Instance.new("ScreenGui")
screen.Name = "AcekMenu"
screen.ResetOnSpawn = false
screen.Parent = gui

-- ===== 圆形按钮 =====
local btn = Instance.new("ImageButton")
btn.Size = UDim2.new(0, 60, 0, 60)
btn.Position = UDim2.new(0, 20, 1, -90)
btn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
btn.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
Instance.new("UICorner", btn).Parent = btn

local label = Instance.new("TextLabel", btn)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "acek"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold

-- ===== 菜单窗口 =====
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 280, 0, 350)
menu.Position = UDim2.new(0, -300, 0, -400)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
menu.Visible = false
menu.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(30, 144, 255)

-- 标题栏
local title = Instance.new("Frame", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Acek Menu"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", title)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 5)
close.BackgroundTransparency = 1
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = 20
close.Font = Enum.Font.GothamBold

-- 内容区域
local content = Instance.new("ScrollingFrame", menu)
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 8)

-- ===== 添加菜单项 =====
local function addItem(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.BackgroundTransparency = 0.3
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 16
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(60, 60, 80) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(40, 40, 55) end)
    b.MouseButton1Click:Connect(cb)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- 功能列表
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

-- ===== 动画 =====
local open = false

local function animateMenu(targetSize, targetPos, targetAlpha, duration, style)
    local t = ts:Create(menu, TweenInfo.new(duration or 0.35, style or Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize,
        Position = targetPos,
        BackgroundTransparency = targetAlpha or 0.05
    })
    t:Play()
    return t
end

local function toggleMenu()
    open = not open
    if open then
        menu.Visible = true
        menu.Size = UDim2.new(0, 140, 0, 175)
        menu.Position = UDim2.new(0, menu.Position.X.Offset + 70, 0, menu.Position.Y.Offset + 87.5)
        menu.BackgroundTransparency = 0.5
        animateMenu(UDim2.new(0, 280, 0, 350), 
            UDim2.new(0, menu.Position.X.Offset - 70, 0, menu.Position.Y.Offset - 87.5), 
            0.05, 0.35, Enum.EasingStyle.Back)
    else
        local pos = menu.Position
        animateMenu(UDim2.new(0, 140, 0, 175), 
            UDim2.new(0, pos.X.Offset + 70, 0, pos.Y.Offset + 87.5), 
            0.5, 0.25, Enum.EasingStyle.Back)
        task.wait(0.25)
        menu.Visible = false
        menu.Size = UDim2.new(0, 280, 0, 350)
        menu.Position = pos
    end
end

-- ===== 拖拽 =====
local dragging, dragStart, startPos = false

title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = menu.Position
    end
end)

title.InputChanged:Connect(function(i)
    if not dragging then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - dragStart
        menu.Position = UDim2.new(0, math.clamp(startPos.X.Offset + d.X, -menu.AbsoluteSize.X + 20, screen.AbsoluteSize.X - 20), 
                                    0, math.clamp(startPos.Y.Offset + d.Y, -menu.AbsoluteSize.Y + 40, screen.AbsoluteSize.Y - 20))
    end
end)

input.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ===== 事件绑定 =====
btn.MouseButton1Click:Connect(toggleMenu)
close.MouseButton1Click:Connect(toggleMenu)

btn.MouseEnter:Connect(function()
    ts:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 160, 255)}):Play()
    ts:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, 65, 0, 65)}):Play()
end)
btn.MouseLeave:Connect(function()
    ts:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 144, 255)}):Play()
    ts:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)

print("[Acek] 加载完成 ✓")
