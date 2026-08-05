-- ===== Acek 菜单 - 带加载成功提示版 =====
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local input = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

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
-- 1. 加载进度条
-- ============================================
local loadBg = Instance.new("Frame", screen)
loadBg.Size = UDim2.new(0.8, 0, 0, 24)
loadBg.Position = UDim2.new(0.1, 0, 0.02, 0)
loadBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Instance.new("UICorner").CornerRadius = UDim.new(0, 12)

local loadFill = Instance.new("Frame", loadBg)
loadFill.Size = UDim2.new(0, 0, 1, 0)
loadFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(0, 12)

local loadText = Instance.new("TextLabel", loadBg)
loadText.Size = UDim2.new(1, 0, 1, 0)
loadText.BackgroundTransparency = 1
loadText.Text = "0%"
loadText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadText.TextSize = 13
loadText.Font = Enum.Font.GothamBold

-- 加载状态文字（显示在进度条下方）
local loadStatus = Instance.new("TextLabel", screen)
loadStatus.Size = UDim2.new(0.8, 0, 0, 20)
loadStatus.Position = UDim2.new(0.1, 0, 0.02, 28)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "初始化..."
loadStatus.TextColor3 = Color3.fromRGB(200, 200, 220)
loadStatus.TextSize = 13
loadStatus.Font = Enum.Font.Gotham
loadStatus.TextXAlignment = Enum.TextXAlignment.Center

-- 加载步骤
local steps = {
    {pct = 10, text = "检查玩家..."},
    {pct = 25, text = "加载角色..."},
    {pct = 45, text = "创建界面..."},
    {pct = 65, text = "配置功能..."},
    {pct = 85, text = "准备就绪..."},
}

local stepIndex = 1
for i = 0, 100 do
    loadFill.Size = UDim2.new(i/100, 0, 1, 0)
    loadText.Text = i .. "%"
    
    -- 更新状态文字
    while stepIndex <= #steps and i >= steps[stepIndex].pct do
        loadStatus.Text = steps[stepIndex].text
        stepIndex = stepIndex + 1
    end
    task.wait(0.012)
end

-- ============================================
-- 2. 加载成功弹窗（醒目提示）
-- ============================================
local successFrame = Instance.new("Frame", screen)
successFrame.Size = UDim2.new(0, 200, 0, 80)
successFrame.Position = UDim2.new(0.5, -100, 0.5, -40)
successFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 25)
successFrame.BackgroundTransparency = 0.05
successFrame.Visible = false
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)

local successStroke = Instance.new("UIStroke", successFrame)
successStroke.Color = Color3.fromRGB(0, 200, 100)
successStroke.Thickness = 2

local successIcon = Instance.new("TextLabel", successFrame)
successIcon.Size = UDim2.new(0, 40, 0, 40)
successIcon.Position = UDim2.new(0, 15, 0.5, -20)
successIcon.BackgroundTransparency = 1
successIcon.Text = "✅"
successIcon.TextSize = 32
successIcon.TextColor3 = Color3.fromRGB(0, 200, 100)

local successText = Instance.new("TextLabel", successFrame)
successText.Size = UDim2.new(1, -70, 0, 30)
successText.Position = UDim2.new(0, 60, 0.2, 0)
successText.BackgroundTransparency = 1
successText.Text = "加载成功！"
successText.TextColor3 = Color3.fromRGB(255, 255, 255)
successText.TextSize = 20
successText.Font = Enum.Font.GothamBold
successText.TextXAlignment = Enum.TextXAlignment.Left

local successSub = Instance.new("TextLabel", successFrame)
successSub.Size = UDim2.new(1, -70, 0, 20)
successSub.Position = UDim2.new(0, 60, 0.55, 0)
successSub.BackgroundTransparency = 1
successSub.Text = "Acek 菜单已就绪"
successSub.TextColor3 = Color3.fromRGB(180, 200, 180)
successSub.TextSize = 13
successSub.Font = Enum.Font.Gotham
successSub.TextXAlignment = Enum.TextXAlignment.Left

-- 显示成功弹窗（带弹入动画）
successFrame.Visible = true
successFrame.Size = UDim2.new(0, 0, 0, 0)
successFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
successFrame.BackgroundTransparency = 1

local t = ts:Create(successFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 200, 0, 80),
    Position = UDim2.new(0.5, -100, 0.5, -40),
    BackgroundTransparency = 0.05
})
t:Play()
t.Completed:Wait()

-- 2秒后自动消失
task.wait(2)
local t2 = ts:Create(successFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 1
})
t2:Play()
t2.Completed:Wait()
successFrame.Visible = false

-- 隐藏加载进度条
loadBg.Visible = false
loadStatus.Visible = false

-- ============================================
-- 3. 主菜单
-- ============================================
local winW, winH = 220, 300
local isOpen = false
local isDragging = false
local dragStart, startPos
local dragThreshold = 5

local win = Instance.new("Frame", screen)
win.Size = UDim2.new(0, winW, 0, winH)
win.Position = UDim2.new(0.5, -winW/2, 0.55, -winH/2)
win.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
win.Visible = false
Instance.new("UICorner").CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", win)
stroke.Color = Color3.fromRGB(30, 144, 255)
stroke.Thickness = 1.5

-- 标题栏
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundTransparency = 1

-- 拖动提示条
local dragHandle = Instance.new("Frame", titleBar)
dragHandle.Size = UDim2.new(1, -80, 0, 20)
dragHandle.Position = UDim2.new(0, 10, 0, 6)
dragHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
dragHandle.BackgroundTransparency = 0.5
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -80, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Acek"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 14
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 2

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -34, 0, 1)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 3

-- 内容区域
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, -12, 1, -44)
content.Position = UDim2.new(0, 6, 0, 36)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 2

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 5)

-- ============================================
-- 4. 功能函数
-- ============================================
local function getChar()
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then return c end
    return nil
end

local function addValueItem(label, defaultVal, minVal, maxVal, applyFn)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.3
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.35, 0, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.35, 0, 1, -8)
    box.Position = UDim2.new(0.45, 0, 0, 4)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
    local applyBtn = Instance.new("TextButton", frame)
    applyBtn.Size = UDim2.new(0, 30, 1, -8)
    applyBtn.Position = UDim2.new(1, -34, 0, 4)
    applyBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    applyBtn.Text = "✓"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.TextSize = 14
    applyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
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

local function addButton(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 34)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- ============================================
-- 5. 功能列表
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
addButton("无敌模式", function()
    god = not god
    local c = getChar()
    if c and god then c.Humanoid.Health = c.Humanoid.MaxHealth end
end)

-- ============================================
-- 6. 浮动开关按钮
-- ============================================
local toggleBtn = Instance.new("TextButton", screen)
toggleBtn.Size = UDim2.new(0, 56, 0, 56)
toggleBtn.Position = UDim2.new(1, -66, 1, -76)
toggleBtn.Text = "A"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 22
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)

local shadow = Instance.new("Frame", toggleBtn)
shadow.Size = UDim2.new(1, 8, 1, 8)
shadow.Position = UDim2.new(0, -4, 0, -4)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.4
shadow.ZIndex = -1
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)

-- ============================================
-- 7. 拖动逻辑
-- ============================================
local function startDrag(input)
    isDragging = true
    dragStart = input.Position
    startPos = win.Position
end

local function updateDrag(input)
    if not isDragging then return end
    local delta = input.Position - dragStart
    if delta.Magnitude > dragThreshold then
        win.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    end
end

local function endDrag()
    isDragging = false
end

titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or 
       i.UserInputType == Enum.UserInputType.Touch then
        startDrag(i)
    end
end)

titleBar.InputChanged:Connect(function(i)
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

-- ============================================
-- 8. 控制逻辑
-- ============================================
local function toggleWindow()
    isOpen = not isOpen
    win.Visible = isOpen
end

toggleBtn.MouseButton1Click:Connect(toggleWindow)
closeBtn.MouseButton1Click:Connect(toggleWindow)

input.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then
        toggleWindow()
    end
end)

print("✅ Acek 加载完成！")
print("📌 点击右下角 A 按钮打开菜单")
print("📌 按住标题栏灰色区域拖动窗口")
print("📌 按 R 键开关")
