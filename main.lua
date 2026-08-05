-- ===== Acek 菜单 - 手机缩小版 =====
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
-- 1. 加载动画界面（缩小版）
-- ============================================
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 220, 0, 130)
loadFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
loadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
loadFrame.BackgroundTransparency = 0.1
loadFrame.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 14)

-- 标题
local loadTitle = Instance.new("TextLabel", loadFrame)
loadTitle.Size = UDim2.new(1, 0, 0, 30)
loadTitle.Position = UDim2.new(0, 0, 0, 8)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "🚀 Acek"
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextSize = 16
loadTitle.Font = Enum.Font.GothamBold

-- 进度条背景
local pgBg = Instance.new("Frame", loadFrame)
pgBg.Size = UDim2.new(0.85, 0, 0, 16)
pgBg.Position = UDim2.new(0.075, 0, 0.45, -8)
pgBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)

-- 进度条填充
local pgFill = Instance.new("Frame", pgBg)
pgFill.Size = UDim2.new(0, 0, 1, 0)
pgFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)

-- 进度文字
local pgText = Instance.new("TextLabel", loadFrame)
pgText.Size = UDim2.new(1, 0, 0, 25)
pgText.Position = UDim2.new(0, 0, 0.65, 0)
pgText.BackgroundTransparency = 1
pgText.Text = "0%"
pgText.TextColor3 = Color3.fromRGB(200, 200, 200)
pgText.TextSize = 14
pgText.Font = Enum.Font.Gotham

-- 状态文字
local statusText = Instance.new("TextLabel", loadFrame)
statusText.Size = UDim2.new(1, 0, 0, 20)
statusText.Position = UDim2.new(0, 0, 1, -24)
statusText.BackgroundTransparency = 1
statusText.Text = "准备中..."
statusText.TextColor3 = Color3.fromRGB(150, 150, 170)
statusText.TextSize = 12
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

local function runLoading()
    updateProgress(0, "初始化...")
    task.wait(0.25)
    updateProgress(20, "检查玩家...")
    if not player then loadSuccess = false; table.insert(loadErrors, "玩家不存在") end
    task.wait(0.15)
    updateProgress(40, "加载角色...")
    local char = player.Character or player.CharacterAdded:Wait()
    if not char or not char:FindFirstChild("Humanoid") then 
        loadSuccess = false 
        table.insert(loadErrors, "角色加载失败")
    end
    task.wait(0.15)
    updateProgress(60, "创建界面...")
    task.wait(0.15)
    updateProgress(80, "配置功能...")
    task.wait(0.15)
    updateProgress(100, "✅ 完成！")
    task.wait(0.25)
end

runLoading()

-- ============================================
-- 3. 隐藏加载界面，显示主菜单
-- ============================================
loadFrame.Visible = false

-- ============================================
-- 4. 主菜单（缩小版）
-- ============================================
local isMinimized = false
local isDragging = false
local dragStart, startPos

-- 窗口尺寸（缩小）
local winW, winH = 260, 350
local minW, minH = 50, 50

-- 主窗口
local win = Instance.new("Frame")
win.Size = UDim2.new(0, winW, 0, winH)
win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
win.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
win.BackgroundTransparency = 0.05
win.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 14)

-- 边框
local stroke = Instance.new("UIStroke", win)
stroke.Color = Color3.fromRGB(30, 144, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

-- ===== 标题栏 =====
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundTransparency = 1

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -100, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Acek"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 16
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- 最小化按钮
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -68, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold

-- 关闭按钮
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold

-- ===== 内容区域 =====
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, -16, 1, -60)
content.Position = UDim2.new(0, 8, 0, 44)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 3

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 5)
list.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- 5. 添加功能项
-- ============================================

local function getChar()
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then
        return c
    end
    return nil
end

-- 数值修改项（更紧凑）
local function addValueItem(label, defaultVal, minVal, maxVal, applyFn)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.3
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.45, -5, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.35, 0, 1, -8)
    box.Position = UDim2.new(0.5, 0, 0, 4)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
    local applyBtn = Instance.new("TextButton", frame)
    applyBtn.Size = UDim2.new(0, 28, 1, -8)
    applyBtn.Position = UDim2.new(1, -34, 0, 4)
    applyBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    applyBtn.Text = "✓"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.TextSize = 14
    applyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
    local function applyValue()
        local val = tonumber(box.Text)
        if not val then
            box.Text = "错误"
            task.wait(0.4)
            box.Text = tostring(defaultVal)
            return
        end
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

-- 普通按钮（更紧凑）
local function addButton(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 34)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- ===== 功能列表 =====
addValueItem("🚀 速度", 16, 0, 500, function(v) local c = getChar(); if c then c.Humanoid.WalkSpeed = v end end)
addValueItem("⬆ 跳跃", 7.2, 0, 500, function(v) local c = getChar(); if c then c.Humanoid.JumpHeight = v end end)
addValueItem("🌍 重力", 196.2, 0, 500, function(v) game.Workspace.Gravity = v end)
addValueItem("🔹 重生值", 0, 0, 999999, function(v)
    local ls = player:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rebirths")
    if r then r:SetAttribute("FakeValue", v) end
end)

-- 分隔线
local sep = Instance.new("Frame", content)
sep.Size = UDim2.new(1, 0, 0, 1)
sep.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sep.BackgroundTransparency = 0.5

addButton("🔸 清除假值", function()
    local ls = player:FindFirstChild("leaderstats")
    if ls then for _, v in pairs(ls:GetChildren()) do v:SetAttribute("FakeValue", nil) end end
end)

addButton("🔄 恢复默认", function()
    local c = getChar()
    if c then c.Humanoid.WalkSpeed = 16; c.Humanoid.JumpHeight = 7.2 end
    game.Workspace.Gravity = 196.2
end)

local god = false
addButton("🛡 无敌模式", function()
    god = not god
    local c = getChar()
    if c and god then c.Humanoid.Health = c.Humanoid.MaxHealth end
end)

-- ============================================
-- 6. 最小化/最大化
-- ============================================
local function minimize()
    if isMinimized then return end
    isMinimized = true
    content.Visible = false
    win.Size = UDim2.new(0, minW, 0, minH)
    win.Position = UDim2.new(1, -minW - 16, 1, -minH - 80)
    titleLbl.Text = "A"
    minBtn.Text = "□"
    stroke.Transparency = 0.8
end

local function maximize()
    if not isMinimized then return end
    isMinimized = false
    content.Visible = true
    win.Size = UDim2.new(0, winW, 0, winH)
    win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
    titleLbl.Text = "Acek"
    minBtn.Text = "─"
    stroke.Transparency = 0.3
end

minBtn.MouseButton1Click:Connect(function()
    if isMinimized then maximize() else minimize() end
end)

-- ============================================
-- 7. 拖动
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
closeBtn.MouseButton1Click:Connect(function() win.Visible = false end)

input.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then
        win.Visible = not win.Visible
        if win.Visible and isMinimized then maximize() end
    end
end)

-- ============================================
-- 9. 完成
-- ============================================
print("✅ Acek 缩小版加载成功！")
print("📌 拖动标题栏移动 | ─ 最小化 | □ 还原 | ✕ 隐藏 | R键开关")
