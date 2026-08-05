-- ===== Acek 菜单 (最简加载器版本) =====
-- 此代码会显示加载进度条，然后创建菜单
local p, gui, ts, input = game.Players.LocalPlayer, game.Players.LocalPlayer:WaitForChild("PlayerGui"), game:GetService("TweenService"), game:GetService("UserInputService")
local screen = Instance.new("ScreenGui"); screen.Name = "AcekMenu"; screen.ResetOnSpawn = false; screen.IgnoreGuiInset = true; screen.ZIndexBehavior = Enum.ZIndexBehavior.Global; screen.Parent = gui

-- 加载进度条
local loadFrame = Instance.new("Frame"); loadFrame.Size = UDim2.new(0, 260, 0, 140); loadFrame.Position = UDim2.new(0.5, -130, 0.5, -70); loadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30); loadFrame.BackgroundTransparency = 0.1; loadFrame.Parent = screen; Instance.new("UICorner").CornerRadius = UDim.new(0, 16)
local loadTitle = Instance.new("TextLabel", loadFrame); loadTitle.Size = UDim2.new(1, 0, 0, 40); loadTitle.Position = UDim2.new(0, 0, 0, 10); loadTitle.BackgroundTransparency = 1; loadTitle.Text = "Acek 加载中..."; loadTitle.TextColor3 = Color3.fromRGB(255,255,255); loadTitle.TextSize = 18; loadTitle.Font = Enum.Font.GothamBold
local progressBg = Instance.new("Frame", loadFrame); progressBg.Size = UDim2.new(0.85, 0, 0, 18); progressBg.Position = UDim2.new(0.075, 0, 0.5, -9); progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55); Instance.new("UICorner").CornerRadius = UDim.new(0, 9)
local progressFill = Instance.new("Frame", progressBg); progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255); Instance.new("UICorner").CornerRadius = UDim.new(0, 9)
local progressText = Instance.new("TextLabel", loadFrame); progressText.Size = UDim2.new(1, 0, 0, 30); progressText.Position = UDim2.new(0, 0, 0.7, 0); progressText.BackgroundTransparency = 1; progressText.Text = "0%"; progressText.TextColor3 = Color3.fromRGB(200,200,200); progressText.TextSize = 16; progressText.Font = Enum.Font.Gotham

-- 进度更新和主菜单创建
local menu, btn, open
local function createMenu()
    local screenSize = gui.AbsoluteSize; local isTablet = screenSize.X > 800; local mW, mH = isTablet and 400 or 300, isTablet and 500 or 400
    btn = Instance.new("ImageButton"); btn.Size = UDim2.new(0, isTablet and 70 or 55, 0, isTablet and 70 or 55); btn.Position = UDim2.new(1, -(isTablet and 90 or 70), 1, -(isTablet and 120 or 100)); btn.BackgroundColor3 = Color3.fromRGB(30, 144, 255); btn.Parent = screen; Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
    local label = Instance.new("TextLabel", btn); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = "acek"; label.TextColor3 = Color3.fromRGB(255,255,255); label.TextScaled = true; label.Font = Enum.Font.GothamBold
    menu = Instance.new("Frame"); menu.Size = UDim2.new(0, mW, 0, mH); menu.Position = UDim2.new(0.5, -mW/2, 0.5, -mH/2); menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35); menu.Visible = false; menu.Parent = screen; Instance.new("UICorner").CornerRadius = UDim.new(0, 16)
    local title = Instance.new("Frame", menu); title.Size = UDim2.new(1, 0, 0, isTablet and 50 or 44); title.BackgroundTransparency = 1
    local titleText = Instance.new("TextLabel", title); titleText.Size = UDim2.new(1, -70, 1, 0); titleText.Position = UDim2.new(0, 15, 0, 0); titleText.BackgroundTransparency = 1; titleText.Text = "Acek Menu"; titleText.TextColor3 = Color3.fromRGB(255,255,255); titleText.TextSize = isTablet and 24 or 20; titleText.Font = Enum.Font.GothamBold; titleText.TextXAlignment = Enum.TextXAlignment.Left
    local close = Instance.new("TextButton", title); close.Size = UDim2.new(0, isTablet and 40 or 34, 0, isTablet and 40 or 34); close.Position = UDim2.new(1, -(isTablet and 48 or 40), 0, (isTablet and 5 or 5)); close.BackgroundTransparency = 1; close.Text = "✕"; close.TextColor3 = Color3.fromRGB(255, 100, 100); close.TextSize = isTablet and 24 or 20; close.Font = Enum.Font.GothamBold
    local content = Instance.new("ScrollingFrame", menu); content.Size = UDim2.new(1, -20, 1, -(isTablet and 90 or 80)); content.Position = UDim2.new(0, 10, 0, isTablet and 55 or 50); content.BackgroundTransparency = 1; content.ScrollBarThickness = 4
    local list = Instance.new("UIListLayout", content); list.Padding = UDim.new(0, 8)
    local function addItem(text, cb) local b = Instance.new("TextButton", content); b.Size = UDim2.new(1, 0, 0, isTablet and 50 or 44); b.BackgroundColor3 = Color3.fromRGB(40, 40, 55); b.BackgroundTransparency = 0.3; b.Text = text; b.TextColor3 = Color3.fromRGB(255,255,255); b.TextSize = isTablet and 18 or 15; b.Font = Enum.Font.Gotham; b.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner").CornerRadius = UDim.new(0, 8); b.MouseButton1Click:Connect(cb); list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y) end) end
    local function gH() local c = p.Character; return c and c:FindFirstChild("Humanoid") end
    addItem("🔹 重生值显示 9999", function() local ls = p:FindFirstChild("leaderstats"); local r = ls and ls:FindFirstChild("Rebirths"); if r then r:SetAttribute("FakeValue", 9999) end end)
    addItem("🔸 清除所有假值", function() local ls = p:FindFirstChild("leaderstats"); if ls then for _, v in pairs(ls:GetChildren()) do v:SetAttribute("FakeValue", nil) end end end)
    addItem("🚀 行走速度 100", function() local h = gH(); if h then h.WalkSpeed = 100 end end)
    addItem("🔄 恢复行走速度", function() local h = gH(); if h then h.WalkSpeed = 16 end end)
    addItem("⬆ 跳跃高度 100", function() local h = gH(); if h then h.JumpHeight = 100 end end)
    local god = false; addItem("🛡 切换无敌模式", function() god = not god; local h = gH(); if h and god then h.Health = h.MaxHealth end end)
    open = false; local function toggle() open = not open; menu.Visible = open; if open then menu.Size = UDim2.new(0,0,0,0); menu.Position = UDim2.new(0.5,0,0.5,0); menu.BackgroundTransparency = 0.5; ts:Create(menu, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, mW, 0, mH), Position = UDim2.new(0.5, -mW/2, 0.5, -mH/2), BackgroundTransparency = 0.05}):Play() else local t = ts:Create(menu, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0), BackgroundTransparency = 0.5}); t:Play(); t.Completed:Connect(function() menu.Visible = false end) end end
    btn.MouseButton1Click:Connect(toggle); close.MouseButton1Click:Connect(toggle)
    input.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.R and i.UserInputType == Enum.UserInputType.Keyboard then toggle() end end)
    print("✅ Acek 菜单已加载，点击右下角按钮或按 R 键打开")
end

-- 执行进度条动画并创建菜单
loadFrame.Visible = true
for i = 0, 100, 1 do
    local percent = math.clamp(i, 0, 100)
    progressFill.Size = UDim2.new(percent / 100, 0, 1, 0)
    progressText.Text = math.floor(percent) .. "%"
    task.wait(0.02)
end
task.wait(0.3)
loadFrame.Visible = false
createMenu()
showLoading()

-- 加载完成后，隐藏进度条，显示主菜单
hideLoadingAndShowMenu()
