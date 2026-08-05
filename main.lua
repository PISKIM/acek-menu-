-- ===== Acek 菜单 - 完整功能版 =====
-- 功能：加载动画 | 自由修改数值 | 拖动 | 最小化/最大化
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local ts = game:GetService("TweenService")
local input = game:GetService("UserInputService")

-- ===== 清理旧界面 =====
local old = gui:FindFirstChild("AcekMenu")
if old then old:Destroy() end

-- ===== 创建主界面 =====
local screen = Instance.new("ScreenGui")
screen.Name = "AcekMenu"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
screen.Parent = gui

-- ============================================
-- 1. 加载动画界面
-- ============================================
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 280, 0, 160)
loadFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
loadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
loadFrame.BackgroundTransparency = 0.1
loadFrame.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)

-- 标题
local loadTitle = Instance.new("TextLabel", loadFrame)
loadTitle.Size = UDim2.new(1, 0, 0, 40)
loadTitle.Position = UDim2.new(0, 0, 0, 10)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "🚀 Acek 加载中..."
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextSize = 20
loadTitle.Font = Enum.Font.GothamBold

-- 进度条背景
local pgBg = Instance.new("Frame", loadFrame)
pgBg.Size = UDim2.new(0.85, 0, 0, 20)
pgBg.Position = UDim2.new(0.075, 0, 0.5, -10)
pgBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Instance.new("UICorner").CornerRadius = UDim.new(0, 10)

-- 进度条填充
local pgFill = Instance.new("Frame", pgBg)
pgFill.Size = UDim2.new(0, 0, 1, 0)
pgFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(0, 10)

-- 进度文字
local pgText = Instance.new("TextLabel", loadFrame)
pgText.Size = UDim2.new(1, 0, 0, 30)
pgText.Position = UDim2.new(0, 0, 0.7, 0)
pgText.BackgroundTransparency = 1
pgText.Text = "0%"
pgText.TextColor3 = Color3.fromRGB(200, 200, 200)
pgText.TextSize = 16
pgText.Font = Enum.Font.Gotham

-- 状态文字
local statusText = Instance.new("TextLabel", loadFrame)
statusText.Size = UDim2.new(1, 0, 0, 25)
statusText.Position = UDim2.new(0, 0, 1, -30)
statusText.BackgroundTransparency = 1
statusText.Text = "准备中..."
statusText.TextColor3 = Color3.fromRGB(150, 150, 170)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham

-- ============================================
-- 2. 执行加载动画
-- ============================================
local loadSuccess = true
local loadErrors = {}

local function updateProgress(percent, status)
    percent = math.clamp(percent, 0, 100)
    pgFill.Size = UDim2.new(percent / 100, 0, 1, 0)
    pgText.Text = math.floor(percent) .. "%"
    if status then statusText.Text = status end
    task.wait(0.015)
end

-- 模拟加载步骤
local function runLoading()
    updateProgress(0, "初始化环境...")
    task.wait(0.3)
    
    updateProgress(15, "检查玩家状态...")
    if not player then loadSuccess = false; table.insert(loadErrors, "玩家对象不存在") end
    task.wait(0.2)
    
    updateProgress(30, "加载角色数据...")
    local char = player.Character or player.CharacterAdded:Wait()
    if not char or not char:FindFirstChild("Humanoid") then 
        loadSuccess = false 
        table.insert(loadErrors, "角色加载失败")
    end
    task.wait(0.2)
    
    updateProgress(50, "创建界面组件...")
    task.wait(0.2)
    
    updateProgress(70, "配置功能模块...")
    task.wait(0.2)
    
    updateProgress(85, "准备就绪...")
    task.wait(0.2)
    
    updateProgress(100, "✅ 加载完成！")
    task.wait(0.3)
end

runLoading()

-- ============================================
-- 3. 隐藏加载界面，显示主菜单
-- ============================================
loadFrame.Visible = false

-- ============================================
-- 4. 主菜单（可拖动 + 可最小化）
-- ============================================
local isMinimized = false
local isDragging = false
local dragStart, startPos

-- 窗口尺寸
local winW, winH = 320, 420
local minW, minH = 60, 60

-- 主窗口
local win = Instance.new("Frame")
win.Size = UDim2.new(0, winW, 0, winH)
win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
win.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
win.BackgroundTransparency = 0.05
win.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)

-- 边框
local stroke = Instance.new("UIStroke", win)
stroke.Color = Color3.fromRGB(30, 144, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3

-- ===== 标题栏（拖动区域）=====
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundTransparency = 1

-- 标题文字
local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -120, 1, 0)
titleLbl.Position = UDim2.new(0, 15, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Acek Menu"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 18
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- 最小化按钮
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -80, 0, 7)
minBtn.BackgroundTransparency = 1
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
minBtn.TextSize = 22
minBtn.Font = Enum.Font.GothamBold

-- 关闭按钮
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold

-- ===== 内容区域 =====
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 55)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- 5. 添加功能项（支持自定义数值）
-- ============================================

-- 获取角色
local function getChar()
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then
        return c
    end
    return nil
end

-- 创建带输入框的数值修改项
local function addValueItem(label, statName, defaultVal, minVal, maxVal, applyFn)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.3
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    
    -- 标签
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.5, -10, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 输入框
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.35, 0, 1, -10)
    box.Position = UDim2.new(0.65, 0, 0, 5)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 14
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    -- 应用按钮
    local applyBtn = Instance.new("TextButton", frame)
    applyBtn.Size = UDim2.new(0, 30, 1, -10)
    applyBtn.Position = UDim2.new(1, -40, 0, 5)
    applyBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    applyBtn.Text = "✓"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.TextSize = 16
    applyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    local function applyValue()
        local val = tonumber(box.Text)
        if not val then
            box.Text = "无效"
            task.wait(0.5)
            box.Text = tostring(defaultVal)
            return
        end
        val = math.clamp(val, minVal or -99999, maxVal or 99999)
        box.Text = tostring(val)
        if applyFn then
            applyFn(val)
        end
    end
    
    applyBtn.MouseButton1Click:Connect(applyValue)
    box.FocusLost:Connect(function(enter)
        if enter then applyValue() end
    end)
    
    -- 更新内容高度
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- 普通按钮
local function addButton(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 15
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(cb)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- ===== 添加功能 =====

-- 数值修改：行走速度
addValueItem("🚀 行走速度", "WalkSpeed", 16, 0, 500, function(val)
    local c = getChar()
    if c then c.Humanoid.WalkSpeed = val end
end)

-- 数值修改：跳跃高度
addValueItem("⬆ 跳跃高度", "JumpHeight", 7.2, 0, 500, function(val)
    local c = getChar()
    if c then c.Humanoid.JumpHeight = val end
end)

-- 数值修改：重力
addValueItem("🌍 重力", "Gravity", 196.2, 0, 500, function(val)
    game.Workspace.Gravity = val
end)

-- 数值修改：重生值显示
addValueItem("🔹 重生值显示", "Rebirths", 0, 0, 999999, function(val)
    local ls = player:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rebirths")
    if r then r:SetAttribute("FakeValue", val) end
end)

-- 分隔线
local sep = Instance.new("Frame", content)
sep.Size = UDim2.new(1, 0, 0, 2)
sep.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sep.BackgroundTransparency = 0.5

-- 按钮功能
addButton("🔸 清除所有假值", function()
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        for _, v in pairs(ls:GetChildren()) do
            v:SetAttribute("FakeValue", nil)
        end
    end
end)

addButton("🔄 恢复默认速度/跳跃", function()
    local c = getChar()
    if c then
        c.Humanoid.WalkSpeed = 16
        c.Humanoid.JumpHeight = 7.2
    end
    game.Workspace.Gravity = 196.2
end)

local god = false
addButton("🛡 切换无敌模式", function()
    god = not god
    local c = getChar()
    if c and god then
        c.Humanoid.Health = c.Humanoid.MaxHealth
    end
end)

-- ============================================
-- 6. 最小化/最大化功能
-- ============================================
local function minimize()
    if isMinimized then return end
    isMinimized = true
    content.Visible = false
    win.Size = UDim2.new(0, minW, 0, minH)
    win.Position = UDim2.new(1, -minW - 20, 1, -minH - 100)
    titleLbl.Text = "Acek"
    minBtn.Text = "□"
    stroke.Transparency = 0.8
end

local function maximize()
    if not isMinimized then return end
    isMinimized = false
    content.Visible = true
    win.Size = UDim2.new(0, winW, 0, winH)
    win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
    titleLbl.Text = "Acek Menu"
    minBtn.Text = "─"
    stroke.Transparency = 0.3
end

local function toggleMinimize()
    if isMinimized then
        maximize()
    else
        minimize()
    end
end

minBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============================================
-- 7. 拖动功能
-- ============================================
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

-- ============================================
-- 8. 关闭 & 快捷键
-- ============================================
closeBtn.MouseButton1Click:Connect(function()
    win.Visible = false
end)

-- 按 R 键显示/隐藏窗口
input.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then
        win.Visible = not win.Visible
        if win.Visible and isMinimized then
            maximize()
        end
    end
end)

-- ============================================
-- 9. 加载完成提示
-- ============================================
print("✅ Acek 完整版加载成功！")
print("📌 功能说明：")
print("   - 拖动标题栏移动窗口")
print("   - 点击 ─ 最小化 / □ 还原")
print("   - 点击 ✕ 隐藏窗口")
print("   - 按 R 键显示/隐藏窗口")
print("   - 在输入框修改数值后点击 ✓ 应用")

if not loadSuccess then
    warn("⚠️ 加载过程中有警告：")
    for _, err in pairs(loadErrors) do
        warn("   - " .. err)
    end
end
