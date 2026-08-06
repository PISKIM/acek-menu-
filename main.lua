-- ===== Acek 菜单 - 超限数值版 =====
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
-- 1. 加载界面
-- ============================================
local overlay = Instance.new("Frame", screen)
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.ZIndex = 999

local loadFrame = Instance.new("Frame", screen)
loadFrame.Size = UDim2.new(0, 260, 0, 140)
loadFrame.Position = UDim2.new(0.5, -130, 0.5, -70)
loadFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
loadFrame.BackgroundTransparency = 0.05
loadFrame.ZIndex = 1000
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)

local loadStroke = Instance.new("UIStroke", loadFrame)
loadStroke.Color = Color3.fromRGB(30, 144, 255)
loadStroke.Thickness = 2

local loadTitle = Instance.new("TextLabel", loadFrame)
loadTitle.Size = UDim2.new(1, 0, 0, 34)
loadTitle.Position = UDim2.new(0, 0, 0, 10)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "🚀 Acek 加载中"
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextSize = 20
loadTitle.Font = Enum.Font.GothamBold
loadTitle.ZIndex = 1001

local pgBg = Instance.new("Frame", loadFrame)
pgBg.Size = UDim2.new(0.85, 0, 0, 18)
pgBg.Position = UDim2.new(0.075, 0, 0.42, 0)
pgBg.BackgroundColor3 = Color3.fromRGB(40, 45, 58)
pgBg.ZIndex = 1001
Instance.new("UICorner").CornerRadius = UDim.new(0, 9)

local pgFill = Instance.new("Frame", pgBg)
pgFill.Size = UDim2.new(0, 0, 1, 0)
pgFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
pgFill.ZIndex = 1002
Instance.new("UICorner").CornerRadius = UDim.new(0, 9)

local pgText = Instance.new("TextLabel", loadFrame)
pgText.Size = UDim2.new(1, 0, 0, 28)
pgText.Position = UDim2.new(0, 0, 0.65, 0)
pgText.BackgroundTransparency = 1
pgText.Text = "0%"
pgText.TextColor3 = Color3.fromRGB(200, 210, 225)
pgText.TextSize = 16
pgText.Font = Enum.Font.GothamBold
pgText.ZIndex = 1001

local loadStatus = Instance.new("TextLabel", loadFrame)
loadStatus.Size = UDim2.new(1, 0, 0, 22)
loadStatus.Position = UDim2.new(0, 0, 1, -30)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "准备中..."
loadStatus.TextColor3 = Color3.fromRGB(160, 170, 190)
loadStatus.TextSize = 14
loadStatus.Font = Enum.Font.Gotham
loadStatus.ZIndex = 1001

-- 加载动画
local steps = {
    {pct = 5, text = "检查玩家..."},
    {pct = 18, text = "加载角色..."},
    {pct = 38, text = "创建界面..."},
    {pct = 58, text = "配置功能..."},
    {pct = 78, text = "准备就绪..."},
}

local stepIndex = 1
for i = 0, 100 do
    pgFill.Size = UDim2.new(i/100, 0, 1, 0)
    pgText.Text = i .. "%"
    while stepIndex <= #steps and i >= steps[stepIndex].pct do
        loadStatus.Text = steps[stepIndex].text
        stepIndex = stepIndex + 1
    end
    task.wait(0.015)
end
loadStatus.Text = "✅ 加载完成！"

-- 成功弹窗
local successFrame = Instance.new("Frame", screen)
successFrame.Size = UDim2.new(0, 0, 0, 0)
successFrame.Position = UDim2.new(0.5, 0, 0.35, 0)
successFrame.BackgroundColor3 = Color3.fromRGB(20, 42, 30)
successFrame.BackgroundTransparency = 1
successFrame.ZIndex = 2000
Instance.new("UICorner").CornerRadius = UDim.new(0, 14)

local sucStroke = Instance.new("UIStroke", successFrame)
sucStroke.Color = Color3.fromRGB(0, 220, 100)
sucStroke.Thickness = 2

local sucIcon = Instance.new("TextLabel", successFrame)
sucIcon.Size = UDim2.new(0, 36, 0, 36)
sucIcon.Position = UDim2.new(0, 14, 0.5, -18)
sucIcon.BackgroundTransparency = 1
sucIcon.Text = "✅"
sucIcon.TextSize = 30
sucIcon.ZIndex = 2001

local sucText = Instance.new("TextLabel", successFrame)
sucText.Size = UDim2.new(1, -65, 0, 28)
sucText.Position = UDim2.new(0, 55, 0.15, 0)
sucText.BackgroundTransparency = 1
sucText.Text = "加载成功！"
sucText.TextColor3 = Color3.fromRGB(255, 255, 255)
sucText.TextSize = 20
sucText.Font = Enum.Font.GothamBold
sucText.TextXAlignment = Enum.TextXAlignment.Left
sucText.ZIndex = 2001

local sucSub = Instance.new("TextLabel", successFrame)
sucSub.Size = UDim2.new(1, -65, 0, 20)
sucSub.Position = UDim2.new(0, 55, 0.5, 0)
sucSub.BackgroundTransparency = 1
sucSub.Text = "Acek 菜单已就绪"
sucSub.TextColor3 = Color3.fromRGB(160, 210, 170)
sucSub.TextSize = 13
sucSub.Font = Enum.Font.Gotham
sucSub.TextXAlignment = Enum.TextXAlignment.Left
sucSub.ZIndex = 2001

successFrame.Visible = true
local t = ts:Create(successFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 210, 0, 72),
    Position = UDim2.new(0.5, -105, 0.35, -36),
    BackgroundTransparency = 0.05
})
t:Play()
t.Completed:Wait()

task.wait(1.8)

local t2 = ts:Create(successFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.35, 0),
    BackgroundTransparency = 1
})
t2:Play()
t2.Completed:Wait()
successFrame.Visible = false

loadFrame.Visible = false
overlay.Visible = false

-- ============================================
-- 2. 主菜单
-- ============================================
local winW, winH = 230, 320
local isOpen = false
local isDragging = false
local isBtnDragging = false
local dragStart, startPos

-- 主窗口
local win = Instance.new("Frame", screen)
win.Size = UDim2.new(0, winW, 0, winH)
win.Position = UDim2.new(0.5, -winW/2, 0.55, -winH/2)
win.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
win.Visible = false
Instance.new("UICorner").CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", win)
stroke.Color = Color3.fromRGB(30, 144, 255)
stroke.Thickness = 1.5

-- 标题栏（可拖动）
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundTransparency = 1

local dragHandle = Instance.new("Frame", titleBar)
dragHandle.Size = UDim2.new(1, -80, 0, 22)
dragHandle.Position = UDim2.new(0, 10, 0, 7)
dragHandle.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
dragHandle.BackgroundTransparency = 0.4
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -80, 1, 0)
titleLbl.Position = UDim2.new(0, 14, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Acek"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 16
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 2

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 3

-- 内容区域
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, -14, 1, -50)
content.Position = UDim2.new(0, 7, 0, 40)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 3

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 6)

-- ============================================
-- 3. 功能函数（超限数值）
-- ============================================
local function getChar()
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then return c end
    return nil
end

-- 数值修改项（无上限/超大上限）
local function addValueItem(label, defaultVal, applyFn)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
    frame.BackgroundTransparency = 0.3
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.3, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.45, 0, 1, -10)
    box.Position = UDim2.new(0.35, 0, 0, 5)
    box.BackgroundColor3 = Color3.fromRGB(15, 17, 27)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
    local applyBtn = Instance.new("TextButton", frame)
    applyBtn.Size = UDim2.new(0, 32, 1, -10)
    applyBtn.Position = UDim2.new(1, -36, 0, 5)
    applyBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    applyBtn.Text = "✓"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.TextSize = 14
    applyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
    local function applyValue()
        local val = tonumber(box.Text)
        if not val then 
            box.Text = tostring(defaultVal)
            return 
        end
        -- 不限制上限，只做基本检查
        if val < 0 then val = 0 end
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
    b.Size = UDim2.new(1, 0, 0, 36)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(50, 52, 68)
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- ============================================
-- 4. 功能列表（超限数值）
-- ============================================
-- 速度：最高 50000000
addValueItem("速度", 16, function(v)
    local c = getChar()
    if c then 
        if v > 50000000 then v = 50000000 end
        c.Humanoid.WalkSpeed = v 
    end
end)

-- 跳跃：最高 10000000
addValueItem("跳跃", 7.2, function(v)
    local c = getChar()
    if c then 
        if v > 10000000 then v = 10000000 end
        c.Humanoid.JumpHeight = v 
    end
end)

-- 重力：自由输入
addValueItem("重力", 196.2, function(v)
    if v < 0 then v = 0 end
    game.Workspace.Gravity = v
end)

-- 重生值：最高 99999999999999
addValueItem("重生值", 0, function(v)
    if v > 99999999999999 then v = 99999999999999 end
    if v < 0 then v = 0 end
    local ls = player:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rebirths")
    if r then r:SetAttribute("FakeValue", v) end
end)

local sep = Instance.new("Frame", content)
sep.Size = UDim2.new(1, 0, 0, 1)
sep.BackgroundColor3 = Color3.fromRGB(60, 62, 80)
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
-- 5. 浮动按钮（显示 "Acek"，可拖动）
-- ============================================
local toggleBtn = Instance.new("TextButton", screen)
toggleBtn.Size = UDim2.new(0, 70, 0, 40)
toggleBtn.Position = UDim2.new(1, -80, 1, -55)
toggleBtn.Text = "Acek"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(0, 20)

local btnShadow = Instance.new("Frame", toggleBtn)
btnShadow.Size = UDim2.new(1, 8, 1, 8)
btnShadow.Position = UDim2.new(0, -4, 0, -4)
btnShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btnShadow.BackgroundTransparency = 0.4
btnShadow.ZIndex = -1
Instance.new("UICorner").CornerRadius = UDim.new(0, 22)

-- ============================================
-- 6. 拖动逻辑
-- ============================================
local function startDrag(input)
    isDragging = true
    dragStart = input.Position
    startPos = win.Position
end

local function updateDrag(input)
    if not isDragging then return end
    local delta = input.Position - dragStart
    win.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end

local function endDrag()
    isDragging = false
end

-- 窗口拖动（标题栏）
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

-- 按钮拖动
local function startBtnDrag(input)
    isBtnDragging = true
    dragStart = input.Position
    startPos = toggleBtn.Position
end

local function updateBtnDrag(input)
    if not isBtnDragging then return end
    local delta = input.Position - dragStart
    toggleBtn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end

local function endBtnDrag()
    isBtnDragging = false
end

toggleBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or 
       i.UserInputType == Enum.UserInputType.Touch then
        startBtnDrag(i)
    end
end)

toggleBtn.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or
       i.UserInputType == Enum.UserInputType.Touch then
        updateBtnDrag(i)
    end
end)

input.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then
        endDrag()
        endBtnDrag()
    end
end)

-- ============================================
-- 7. 控制逻辑
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

print("✅ Acek 超限数值版加载成功！")
print("📌 速度最高 50,000,000")
print("📌 跳跃最高 10,000,000")
print("📌 重生值最高 99,999,999,999,999")
print("📌 按住 Acek 按钮拖动 | 按住标题栏灰色区域拖动窗口")
