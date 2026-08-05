-- ===== Acek 菜单 - 极致精简手机版 =====
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local input = game:GetService("UserInputService")

-- 清理旧界面
local old = gui:FindFirstChild("AcekMenu")
if old then old:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "AcekMenu"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
screen.Parent = gui

-- ============================================
-- 1. 加载进度条（屏幕顶部细条）
-- ============================================
local loadBg = Instance.new("Frame", screen)
loadBg.Size = UDim2.new(0.8, 0, 0, 20)
loadBg.Position = UDim2.new(0.1, 0, 0.02, 0)
loadBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Instance.new("UICorner").CornerRadius = UDim.new(0, 10)

local loadFill = Instance.new("Frame", loadBg)
loadFill.Size = UDim2.new(0, 0, 1, 0)
loadFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(0, 10)

local loadText = Instance.new("TextLabel", loadBg)
loadText.Size = UDim2.new(1, 0, 1, 0)
loadText.BackgroundTransparency = 1
loadText.Text = "0%"
loadText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadText.TextSize = 12
loadText.Font = Enum.Font.GothamBold

-- 加载动画
for i = 0, 100 do
    loadFill.Size = UDim2.new(i/100, 0, 1, 0)
    loadText.Text = i .. "%"
    task.wait(0.015)
end
task.wait(0.2)
loadBg.Visible = false

-- ============================================
-- 2. 主菜单（超小窗口）
-- ============================================
local winW, winH = 200, 280
local isOpen = false
local isMinimized = true
local isDragging = false
local dragStart, startPos

-- 主窗口
local win = Instance.new("Frame", screen)
win.Size = UDim2.new(0, winW, 0, winH)
win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
win.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
win.Visible = false
Instance.new("UICorner").CornerRadius = UDim.new(0, 12)

-- 标题栏
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundTransparency = 1

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -70, 1, 0)
titleLbl.Position = UDim2.new(0, 10, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Acek"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 14
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- 最小化按钮（窗口右上角）
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -56, 0, 2)
minBtn.BackgroundTransparency = 1
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold

-- 内容区域（滚动）
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 32)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 2

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 4)

-- ============================================
-- 3. 功能函数
-- ============================================
local function getChar()
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then return c end
    return nil
end

-- 添加数值修改项（超小）
local function addValueItem(label, defaultVal, minVal, maxVal, applyFn)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.3
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.35, 0, 1, -6)
    box.Position = UDim2.new(0.45, 0, 0, 3)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    
    local applyBtn = Instance.new("TextButton", frame)
    applyBtn.Size = UDim2.new(0, 24, 1, -6)
    applyBtn.Position = UDim2.new(1, -28, 0, 3)
    applyBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    applyBtn.Text = "✓"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.TextSize = 12
    applyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    
    local function applyValue()
        local val = tonumber(box.Text)
        if not val then box.Text = tostring(defaultVal); return end
        val = math.clamp(val, minVal or -99999, maxVal or 99999)
        box.Text = tostring(val)
        if applyFn then applyFn(val) end
    end
    
    applyBtn.MouseButton1Click:Connect(applyValue)
    box.FocusLost:Connect(function(enter) if enter then applyValue() end end)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- 添加普通按钮（超小）
local function addButton(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 28)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(cb)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- ============================================
-- 4. 功能列表
-- ============================================
addValueItem("速度", 16, 0, 500, function(v) local c = getChar(); if c then c.Humanoid.WalkSpeed = v end end)
addValueItem("跳跃", 7.2, 0, 500, function(v) local c = getChar(); if c then c.Humanoid.JumpHeight = v end end)
addValueItem("重力", 196.2, 0, 500, function(v) game.Workspace.Gravity = v end)
addValueItem("重生值", 0, 0, 999999, function(v)
    local ls = player:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rebirths")
    if r then r:SetAttribute("FakeValue", v) end
end)

local sep = Instance.new("Frame", content)
sep.Size = UDim2.new(1, 0, 0, 1)
sep.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sep.BackgroundTransparency = 0.5

addButton("清除假值", function()
    local ls = player:FindFirstChild("leaderstats")
    if ls then for _, v in pairs(ls:GetChildren()) do v:SetAttribute("FakeValue", nil) end end
end)

addButton("恢复默认", function()
    local c = getChar()
    if c then c.Humanoid.WalkSpeed = 16; c.Humanoid.JumpHeight = 7.2 end
    game.Workspace.Gravity = 196.2
end)

local god = false
addButton("无敌", function()
    god = not god
    local c = getChar()
    if c and god then c.Humanoid.Health = c.Humanoid.MaxHealth end
end)

-- ============================================
-- 5. 浮动开关按钮（屏幕右下角小圆点）
-- ============================================
local toggleBtn = Instance.new("TextButton", screen)
toggleBtn.Size = UDim2.new(0, 44, 0, 44)
toggleBtn.Position = UDim2.new(1, -54, 1, -64)
toggleBtn.Text = "A"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)

-- ============================================
-- 6. 控制逻辑
-- ============================================
local function toggleWindow()
    isOpen = not isOpen
    win.Visible = isOpen
    if isOpen and isMinimized then
        isMinimized = false
        win.Size = UDim2.new(0, winW, 0, winH)
        win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
        content.Visible = true
        titleLbl.Text = "Acek"
        minBtn.Text = "─"
    end
end

toggleBtn.MouseButton1Click:Connect(toggleWindow)

-- 最小化
minBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        isMinimized = false
        win.Size = UDim2.new(0, winW, 0, winH)
        win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
        content.Visible = true
        titleLbl.Text = "Acek"
        minBtn.Text = "─"
    else
        isMinimized = true
        content.Visible = false
        win.Size = UDim2.new(0, 44, 0, 28)
        win.Position = UDim2.new(0.5, -22, 0.5, -14)
        titleLbl.Text = "A"
        minBtn.Text = "□"
    end
end)

-- 关闭
closeBtn.MouseButton1Click:Connect(function()
    win.Visible = false
    isOpen = false
end)

-- 拖动
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or 
       i.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = i.Position
        startPos = win.Position
    end
end)

titleBar.InputChanged:Connect(function(i)
    if not isDragging then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or
       i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - dragStart
        win.Position = UDim2.new(0, startPos.X.Offset + d.X, 0, startPos.Y.Offset + d.Y)
    end
end)

input.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- R 键快捷键
input.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then
        toggleWindow()
    end
end)

print("✅ Acek 极致精简版加载成功！")
print("📌 点击右下角 A 按钮打开菜单")
print("📌 按 R 键开关")
