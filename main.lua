-- ===== Acek 极简版（保证可用）=====
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- 清理旧界面
local old = gui:FindFirstChild("AcekMenu")
if old then old:Destroy() end

-- 创建主界面
local screen = Instance.new("ScreenGui")
screen.Name = "AcekMenu"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.Parent = gui

-- ===== 主按钮（屏幕中央偏下）=====
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 70, 0, 70)
btn.Position = UDim2.new(0.5, -35, 0.8, -35)
btn.Text = "acek"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 20
btn.Font = Enum.Font.GothamBold
btn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
btn.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)

-- ===== 菜单窗口 =====
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 280, 0, 350)
menu.Position = UDim2.new(0.5, -140, 0.5, -175)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
menu.Visible = false
menu.Parent = screen
Instance.new("UICorner").CornerRadius = UDim.new(0, 12)

-- 标题栏
local title = Instance.new("Frame", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.Text = "Acek Menu"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1

local close = Instance.new("TextButton", title)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 5)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.BackgroundTransparency = 1

-- 内容区域
local content = Instance.new("Frame", menu)
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 6)

-- ===== 添加功能按钮 =====
local function addItem(text, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 15
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

-- 功能：获取角色
local function getChar()
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then
        return c
    end
    return nil
end

addItem("🔹 重生值显示 9999", function()
    local ls = player:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rebirths")
    if r then r:SetAttribute("FakeValue", 9999) end
end)

addItem("🔸 清除所有假值", function()
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        for _, v in pairs(ls:GetChildren()) do
            v:SetAttribute("FakeValue", nil)
        end
    end
end)

addItem("🚀 行走速度 100", function()
    local c = getChar()
    if c then c.Humanoid.WalkSpeed = 100 end
end)

addItem("🔄 恢复行走速度", function()
    local c = getChar()
    if c then c.Humanoid.WalkSpeed = 16 end
end)

addItem("⬆ 跳跃高度 100", function()
    local c = getChar()
    if c then c.Humanoid.JumpHeight = 100 end
end)

local god = false
addItem("🛡 切换无敌模式", function()
    god = not god
    local c = getChar()
    if c and god then
        c.Humanoid.Health = c.Humanoid.MaxHealth
    end
end)

-- ===== 控制逻辑 =====
local isOpen = false

local function toggle()
    isOpen = not isOpen
    menu.Visible = isOpen
end

btn.MouseButton1Click:Connect(toggle)
close.MouseButton1Click:Connect(toggle)

-- 按 R 键开关
game:GetService("UserInputService").InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.R then
        toggle()
    end
end)

print("✅ Acek 极简版加载成功！点击蓝色按钮或按 R 键")
