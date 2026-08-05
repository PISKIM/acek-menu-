-- ===== Acek Menu - Delta手机版（带加载进度条）=====
local p = game.Players.LocalPlayer
local gui = p:WaitForChild("PlayerGui")
local ts = game:GetService("TweenService")
local input = game:GetService("UserInputService")

-- ===== 清理旧界面 =====
local oldGui = gui:FindFirstChild("AcekMenu")
if oldGui then oldGui:Destroy() end

-- ===== 创建主界面容器 =====
local screen = Instance.new("ScreenGui")
screen.Name = "AcekMenu"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
screen.Parent = gui

-- ============================================
-- ===== 1. 加载进度条界面 =====
-- ============================================
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 260, 0, 140)
loadFrame.Position = UDim2.new(0.5, -130, 0.5, -70)
loadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
loadFrame.BackgroundTransparency = 0.1
loadFrame.BorderSizePixel = 0
loadFrame.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)

-- 边框光效
local loadStroke = Instance.new("UIStroke", loadFrame)
loadStroke.Thickness = 2
loadStroke.Color = Color3.fromRGB(30, 144, 255)
loadStroke.Transparency = 0.3

-- 标题
local loadTitle = Instance.new("TextLabel", loadFrame)
loadTitle.Size = UDim2.new(1, 0, 0, 40)
loadTitle.Position = UDim2.new(0, 0, 0, 10)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "Acek 加载中..."
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextSize = 18
loadTitle.Font = Enum.Font.GothamBold

-- 进度条背景
local progressBg = Instance.new("Frame", loadFrame)
progressBg.Size = UDim2.new(0.85, 0, 0, 18)
progressBg.Position = UDim2.new(0.075, 0, 0.5, -9)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
progressBg.BorderSizePixel = 0
Instance.new("UICorner").CornerRadius = UDim.new(0, 9)

-- 进度条填充
local progressFill = Instance.new("Frame", progressBg)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
progressFill.BorderSizePixel = 0
Instance.new("UICorner").CornerRadius = UDim.new(0, 9)

-- 进度文字
local progressText = Instance.new("TextLabel", loadFrame)
progressText.Size = UDim2.new(1, 0, 0, 30)
progressText.Position = UDim2.new(0, 0, 0.7, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(200, 200, 200)
progressText.TextSize = 16
progressText.Font = Enum.Font.Gotham

-- ============================================
-- ===== 2. 进度条更新函数 =====
-- ============================================
local function updateProgress(percent)
    percent = math.clamp(percent, 0, 100)
    local width = (percent / 100) * (progressBg.AbsoluteSize.X - 0)
    progressFill.Size = UDim2.new(percent / 100, 0, 1, 0)
    progressText.Text = math.floor(percent) .. "%"
    task.wait(0.02)
end

-- ============================================
-- ===== 3. 执行加载动画 =====
-- ============================================
local function showLoading()
    loadFrame.Visible = true
    loadFrame.Size = UDim2.new(0, 0, 0, 0)
    loadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    loadFrame.BackgroundTransparency = 1
    
    -- 弹入动画
    local t = ts:Create(loadFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 260, 0, 140),
        Position = UDim2.new(0.5, -130, 0.5, -70),
        BackgroundTransparency = 0.1
    })
    t:Play()
    t.Completed:Wait()
    
    -- 进度条从 0 到 100
    for i = 0, 100, 1 do
        updateProgress(i)
        task.wait(0.02)  -- 总耗时约 2 秒
    end
    
    task.wait(0.3)  -- 显示 100% 停留一下
end

-- ============================================
-- ===== 4. 隐藏加载界面，显示主菜单 =====
-- ============================================
local function hideLoadingAndShowMenu()
    -- 加载界面缩小消失
    local t = ts:Create(loadFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    t:Play()
    t.Completed:Wait()
    loadFrame.Visible = false
    
    -- 显示主菜单
    createMainMenu()
end

-- ============================================
-- ===== 5. 主菜单创建函数 =====
-- ============================================
local function createMainMenu()
    -- 获取屏幕尺寸适配
    local screenSize = gui.AbsoluteSize
    local isTablet = screenSize.X > 800
    local menuWidth = isTablet and 400 or 300
    local menuHeight = isTablet and 500 or 400
    
    -- ===== 圆形按钮（右下角）=====
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, isTablet and 70 or 55, 0, isTablet and 70 or 55)
    btn.Position = UDim2.new(1, -(isTablet and 90 or 70), 1, -(isTablet and 120 or 100))
    btn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    btn.Parent = screen
    Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
    
    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "acek"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    
    -- ===== 菜单窗口 =====
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, menuWidth, 0, menuHeight)
    menu.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
    menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    menu.Visible = false
    menu.Parent = screen
    Instance.new("UICorner").CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", menu)
    stroke.Color = Color3.fromRGB(30, 144, 255)
    stroke.Thickness = 2
    
    -- 标题栏
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
    
    -- 内容区域
    local content = Instance.new("ScrollingFrame", menu)
    content.Size = UDim2.new(1, -20, 1, -(isTablet and 90 or 80))
    content.Position = UDim2.new(0, 10, 0, isTablet and 55 or 50)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    
    local list = Instance.new("UIListLayout", content)
    list.Padding = UDim.new(0, 8)
    
    -- ===== 添加菜单项 =====
    local function addItem(text, cb)
        local b = Instance.new("TextButton", content)
        b.Size = UDim2.new(1, 0, 0, isTablet and 50 or 44)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        b.BackgroundTransparency = 0.3
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = isTablet and 18 or 15
        b.Font = Enum.Font.Gotham
        b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
        
        b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(60, 60, 80) end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(40, 40, 55) end)
        b.MouseButton1Click:Connect(cb)
        b.MouseButton1Down:Connect(function()
            b.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        end)
        b.MouseButton1Up:Connect(function()
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end)
        
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
    
    -- ===== 拖拽功能 =====
    local dragging, dragStart, startPos = false
    
    title.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or 
           i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = menu.Position
        end
    end)
    
    title.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or
           i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - dragStart
            menu.Position = UDim2.new(0, startPos.X.Offset + d.X, 0, startPos.Y.Offset + d.Y)
        end
    end)
    
    input.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or
           i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- ===== 事件绑定 =====
    btn.MouseButton1Click:Connect(toggleMenu)
    close.MouseButton1Click:Connect(toggleMenu)
    
    btn.MouseEnter:Connect(function()
        ts:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 160, 255)}):Play()
        ts:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, (isTablet and 75 or 60), 0, (isTablet and 75 or 60))}):Play()
    end)
    btn.MouseLeave:Connect(function()
        ts:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 144, 255)}):Play()
        ts:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, (isTablet and 70 or 55), 0, (isTablet and 70 or 55))}):Play()
    end)
    
    -- 键盘快捷键
    input.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then
            toggleMenu()
        end
    end)
    
    print("[Acek] 菜单已加载，点击右下角按钮打开")
end

-- ============================================
-- ===== 6. 执行主流程 =====
-- ============================================
-- 先显示加载进度条
showLoading()

-- 加载完成后，隐藏进度条，显示主菜单
hideLoadingAndShowMenu()
