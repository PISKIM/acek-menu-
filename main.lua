-- ===== Acek 菜单 - 强制显示修复版 =====
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- 1. 等待玩家和角色完全加载（关键）
local player = Players.LocalPlayer
if not player then
    warn("未找到玩家，等待中...")
    player = Players.LocalPlayer or Players.PlayerAdded:Wait()
end

-- 如果角色还没出现，一直等到它出现
if not player.Character or not player.Character:FindFirstChild("Humanoid") then
    print("等待角色加载...")
    player.CharacterAdded:Wait()
    task.wait(1) -- 多等一秒，让身体各部分稳定
end

local gui = player:WaitForChild("PlayerGui")
local screenSize = gui.AbsoluteSize

-- 2. 清理旧界面，避免冲突
local oldGui = gui:FindFirstChild("AcekMenu")
if oldGui then oldGui:Destroy() end

-- 3. 创建主屏幕
local screen = Instance.new("ScreenGui")
screen.Name = "AcekMenu"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
screen.Parent = gui

print("✅ 1. 基础界面已创建")

-- ============================================
-- 4. 强制显示主按钮 (放在屏幕中央偏下，确保可见)
-- ============================================
local btnSize = 60
local btn = Instance.new("ImageButton")
btn.Size = UDim2.new(0, btnSize, 0, btnSize)
-- ★★★ 关键修复：使用绝对偏移，让按钮固定在屏幕中央偏下 ★★★
btn.Position = UDim2.new(0.5, -btnSize/2, 0.8, -btnSize/2) 
btn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
btn.BackgroundTransparency = 0
btn.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)

-- 按钮文字
local label = Instance.new("TextLabel", btn)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "acek"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold

print("✅ 2. 主按钮已创建在屏幕中央")

-- ============================================
-- 5. 创建菜单（在屏幕中央）
-- ============================================
local menuWidth, menuHeight = 300, 400
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, menuWidth, 0, menuHeight)
menu.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
menu.BackgroundTransparency = 0.1
menu.Visible = false -- 默认隐藏
menu.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", menu)
stroke.Color = Color3.fromRGB(30, 144, 255)
stroke.Thickness = 2

-- 标题栏
local title = Instance.new("Frame", menu)
title.Size = UDim2.new(1, 0, 0, 44)
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
close.Position = UDim2.new(1, -40, 0, 7)
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

-- 添加菜单项函数
local function addItem(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 44)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.BackgroundTransparency = 0.3
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 16
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(cb)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
    end)
end

-- 功能函数
local function getHumanoid()
    local c = player.Character
    return c and c:FindFirstChild("Humanoid")
end

addItem("🔹 重生值显示 9999", function()
    local ls = player:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rebirths")
    if r then r:SetAttribute("FakeValue", 9999) end
end)

addItem("🔸 清除所有假值", function()
    local ls = player:FindFirstChild("leaderstats")
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

print("✅ 3. 菜单内容已创建")

-- ============================================
-- 6. 控制逻辑（开/关动画）
-- ============================================
local isOpen = false

local function toggleMenu()
    isOpen = not isOpen
    menu.Visible = isOpen
    if isOpen then
        -- 打开动画
        menu.Size = UDim2.new(0, 0, 0, 0)
        menu.Position = UDim2.new(0.5, 0, 0.5, 0)
        menu.BackgroundTransparency = 0.8
        TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, menuWidth, 0, menuHeight),
            Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2),
            BackgroundTransparency = 0.1
        }):Play()
    else
        -- 关闭动画
        local t = TweenService:Create(menu, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 0.8
        })
        t:Play()
        t.Completed:Connect(function()
            menu.Visible = false
        end)
    end
end

-- 绑定按钮事件
btn.MouseButton1Click:Connect(toggleMenu)
close.MouseButton1Click:Connect(toggleMenu)

-- 键盘 R 键快捷键
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then
        toggleMenu()
    end
end)

-- 按钮悬停/触摸反馈
btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 160, 255)}):Play()
    TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, 70, 0, 70)}):Play()
end)
btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 144, 255)}):Play()
    TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)

print("🎉 Acek 菜单修复版加载完成！")
print("📌 请查看屏幕中央偏下位置，应该有一个蓝色 'acek' 按钮")
print("⌨️  也可以按键盘 R 键来开关菜单")
