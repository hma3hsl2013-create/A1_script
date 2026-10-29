--[[
    🔥 REDZ-STYLE HUB — النسخة المخصصة المحسّنة
    Delta / Fluxus / Codex
]]

local Config = {
    BackgroundId = "rbxassetid://0", -- ⚠️ حط رقم صورة لوفي هنا
    Theme = {
        Main    = Color3.fromRGB(20, 16, 16),
        Tab     = Color3.fromRGB(140, 25, 25),
        TabOff  = Color3.fromRGB(45, 30, 30),
        Accent  = Color3.fromRGB(220, 60, 60),
        Text    = Color3.fromRGB(240, 235, 235),
    },
    Protection = {
        RandomizeAttacks = true,
        AttackMin = 0.25, AttackMax = 0.55,
        HideName = true,
        AntiAFK = true,
        AdminDetection = true,
        MaxFarmHours = 3,
    }
}

getgenv().Settings = {
    AutoFarm = false,
    AutoFruit = false,
    FastAttack = false,
    LevelFilter = true,
    WalkSpeed = false,
    NoClip = false,
    InfinityJump = false,
}

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")
local random = Random.new()

-- ═══ الحماية ═══

if Config.Protection.AntiAFK then
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

if Config.Protection.HideName then
    task.spawn(function()
        while true do
            task.wait(2)
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local nm = head:FindFirstChild("Nametag")
                    if nm then nm:Destroy() end
                end
            end
        end
    end)
end

local AdminNames = {"rip_indra", "tencelll", "azlae", "astral"}
task.spawn(function()
    if not Config.Protection.AdminDetection then return end
    while true do
        task.wait(10)
        for _, p in pairs(Players:GetPlayers()) do
            for _, name in pairs(AdminNames) do
                if p.Name:lower():find(name) then
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "⚠️ تحذير",
                        Text = "أدمن دخل السيرفر: " .. p.Name,
                        Duration = 10
                    })
                end
            end
        end
    end
end)

task.delay(Config.Protection.MaxFarmHours * 3600, function()
    getgenv().Settings.AutoFarm = false
    getgenv().Settings.AutoFruit = false
    game.StarterGui:SetCore("SendNotification", {
        Title = "⏰ حماية",
        Text = "تم إيقاف الفارم تلقائياً",
        Duration = 15
    })
end)

-- ═══ الواجهة ═══

local gui = Instance.new("ScreenGui")
gui.Name = "RedzStyleHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local bg = Instance.new("ImageLabel", gui)
bg.Size = UDim2.new(0, 560, 0, 340)
bg.Position = UDim2.new(0.5, -280, 0.5, -170)
if Config.BackgroundId ~= "rbxassetid://0" then
    bg.Image = Config.BackgroundId
    bg.BackgroundTransparency = 0.2
end
bg.BackgroundColor3 = Config.Theme.Main
bg.ImageTransparency = 0.55
bg.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)

local dim = Instance.new("Frame", bg)
dim.Size = UDim2.new(1, 0, 1, 0)
dim.BackgroundColor3 = Color3.new(0, 0, 0)
dim.BackgroundTransparency = 0.45
dim.BorderSizePixel = 0
Instance.new("UICorner", dim).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", bg)
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "🔥 REDZ HUB — النسخة المخصصة"
title.TextColor3 = Config.Theme.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local tabBar = Instance.new("Frame", bg)
tabBar.Size = UDim2.new(1, -20, 0, 34)
tabBar.Position = UDim2.new(0, 10, 0, 42)
tabBar.BackgroundTransparency = 1

local pages, tabBtns = {}, {}

local function newPage(name)
    local page = Instance.new("ScrollingFrame", bg)
    page.Size = UDim2.new(1, -20, 1, -86)
    page.Position = UDim2.new(0, 10, 0, 82)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Config.Theme.Accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 8)
    pages[name] = page
end

local function selectTab(name)
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for n, b in pairs(tabBtns) do
        b.BackgroundColor3 = (n == name) and Config.Theme.Tab or Config.Theme.TabOff
    end
end

local tabNames = {"⚔️ فارم", "🍍 فواكه", "🛡️ حماية", "⚡ أخرى"}
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0.24, -4, 1, 0)
    btn.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = Config.Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Config.Theme.TabOff
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() selectTab(name) end)
    tabBtns[name] = btn
    newPage(name)
end

local function addToggle(page, text, key, desc)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, desc and 52 or 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 22, 22)
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -90, 0, desc and 30 or 38)
    label.Position = UDim2.new(0, 12, 0, desc and 4 or 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Theme.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    if desc then
        local d = Instance.new("TextLabel", btn)
        d.Size = UDim2.new(1, -90, 0, 18)
        d.Position = UDim2.new(0, 12, 0, 32)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = Color3.fromRGB(160, 150, 150)
        d.Font = Enum.Font.Gotham
        d.TextSize = 11
        d.TextXAlignment = Enum.TextXAlignment.Left
    end

    local state = Instance.new("TextLabel", btn)
    state.Size = UDim2.new(0, 66, 0, 24)
    state.Position = UDim2.new(1, -78, 0.5, -12)
    state.TextColor3 = Color3.new(1, 1, 1)
    state.Font = Enum.Font.GothamBold
    state.TextSize = 12
    Instance.new("UICorner", state).CornerRadius = UDim.new(1, 0)

    local function update()
        local on = getgenv().Settings[key]
        state.Text = on and "مفعّل ✅" or "متوقف ❌"
        state.BackgroundColor3 = on and Config.Theme.Tab or Color3.fromRGB(60, 40, 40)
    end
    btn.MouseButton1Click:Connect(function()
        getgenv().Settings[key] = not getgenv().Settings[key]
        update()
    end)
    update()
end

addToggle(pages["⚔️ فارم"], "⚔️ Auto Farm", "AutoFarm", "يهاجم أقرب عدو تلقائياً")
addToggle(pages["⚔️ فارم"], "🎯 Level Filter", "LevelFilter", "يهاجم فقط أعداء مناسبين لمستواك")
addToggle(pages["⚔️ فارم"], "💨 Fast Attack", "FastAttack", "ضربات أسرع (أعلى مخاطرة)")

addToggle(pages["🍍 فواكه"], "🍍 Auto Fruit", "AutoFruit", "يلتقط أي فاكهة تنزل فوراً")

local pPage = pages["🛡️ حماية"]
local function addInfo(text)
    local l = Instance.new("TextLabel", pPage)
    l.Size = UDim2.new(1, 0, 0, 34)
    l.BackgroundColor3 = Color3.fromRGB(30, 22, 22)
    l.BackgroundTransparency = 0.25
    l.Text = "  " .. text
    l.TextColor3 = Config.Theme.Text
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 8)
end
addInfo("🛡️ Anti AFK: مفعّل دائماً")
addInfo("👤 إخفاء الاسم: مفعّل دائماً")
addInfo("⚠️ كشف الأدمنز: فحص كل 10 ثواني")
addInfo("⏰ إيقاف تلقائي بعد 3 ساعات")
addInfo("🎲 توقيت عشوائي للهجمات")

addToggle(pages["⚡ أخرى"], "🏃 WalkSpeed", "WalkSpeed")
addToggle(pages["⚡ أخرى"], "👻 No Clip", "NoClip")
addToggle(pages["⚡ أخرى"], "🦘 Infinity Jump", "InfinityJump")

selectTab("⚔️ فارم")

local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 46, 0, 46)
hideBtn.Position = UDim2.new(0, 12, 0.5, -23)
hideBtn.BackgroundColor3 = Config.Theme.Tab
hideBtn.Text = "🔥"
hideBtn.TextSize = 22
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(1, 0)
local open = true
hideBtn.MouseButton1Click:Connect(function()
    open = not open
    bg.Visible = open
end)

local dragging, dragStart, startPos
bg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = bg.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        bg.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ═══ المنطق ═══

local function randomDelay()
    if Config.Protection.RandomizeAttacks and not getgenv().Settings.FastAttack then
        return random:NextNumber(Config.Protection.AttackMin, Config.Protection.AttackMax)
    end
    return 0.15
end

task.spawn(function()
    while true do
        task.wait(0.6)
        if getgenv().Settings.AutoFruit then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetChildren()) do
                    local handle = obj:FindFirstChild("Handle")
                    if handle and obj.Name:lower():find("fruit") then
                        hrp.CFrame = handle.CFrame
                        task.wait(0.4)
                        firetouchinterest(hrp, handle, 0)
                        firetouchinterest(hrp, handle, 1)
                        task.wait(0.4)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.6)
        if getgenv().Settings.AutoFarm then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local myLevel = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") and player.Data.Level.Value or 1
            if hrp then
                local target, bestScore = nil, math.huge
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    local hum = enemy:FindFirstChild("Humanoid")
                    local ehrp = enemy:FindFirstChild("HumanoidRootPart")
                    if hum and ehrp and hum.Health > 0 then
                        local dist = (ehrp.Position - hrp.Position).Magnitude
                        if dist < 300 then
                            if getgenv().Settings.LevelFilter then
                                local lvl = enemy:FindFirstChild("Level") and enemy.Level.Value or 1
                                if math.abs(lvl - myLevel) > 100 then continue end
                            end
                            if dist < bestScore then bestScore = dist; target = enemy end
                        end
                    end
                end
                if target then
                    hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                    for i = 1, 4 do
                        if not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then break end
                        if not getgenv().Settings.AutoFarm then break end
                        Vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(randomDelay() / 2)
                        Vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        task.wait(randomDelay() / 2)
                    end
                end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if getgenv().Settings.WalkSpeed and hum then hum.WalkSpeed = 120 end
    if getgenv().Settings.NoClip and hrp then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().Settings.InfinityJump then
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("✅ REDZ-STYLE HUB جاهز!")
