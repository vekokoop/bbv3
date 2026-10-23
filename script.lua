-- BlockSpin Pro Hub - Mobile Delta Touch Fixed Edition
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ضمان استمرارية السكربت عند الانتقال
local queue_func = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if queue_func then
    queue_func([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vekokoop/bbv2/refs/heads/main/script.lua"))()
    ]])
end

-- إزالة أي واجهة قديمة لمنع التكرار
if CoreGui:FindFirstChild("BlockSpinSilentESP") then
    CoreGui.BlockSpinSilentESP:Destroy()
end

-- إعداد دوائر الـ FOV
local SilentFOV_Radius = 100
local AimbotFOV_Radius = 100

-- دائرة السايلنت أيم (برتقالي)
local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Visible = false
silentFovCircle.Radius = SilentFOV_Radius
silentFovCircle.Filled = false
silentFovCircle.Color = Color3.fromRGB(255, 69, 0)
silentFovCircle.Thickness = 1.5
silentFovCircle.Transparency = 0.7

-- دائرة الأيم بوت (أزرق/سماوي)
local aimbotFovCircle = Drawing.new("Circle")
aimbotFovCircle.Visible = false
aimbotFovCircle.Radius = AimbotFOV_Radius
aimbotFovCircle.Filled = false
aimbotFovCircle.Color = Color3.fromRGB(0, 191, 255)
aimbotFovCircle.Thickness = 1.5
aimbotFovCircle.Transparency = 0.7

-- واجهة المستخدم الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockSpinSilentESP"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الأيقونة العائمة الفخمة (قابل للسحب)
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
FloatingIcon.Position = UDim2.new(0, 35, 0, 150)
FloatingIcon.Size = UDim2.new(0, 54, 0, 54)
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Text = "🎯"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 69, 0)
FloatingIcon.TextSize = 26

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 69, 0)
IconStroke.Thickness = 2.5
IconStroke.Parent = FloatingIcon

-- النافذة الرئيسية للقائمة
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
MainFrame.Size = UDim2.new(0, 340, 0, 400)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 69, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- شريط العنوان العلوي
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
TopBar.Size = UDim2.new(1, 0, 0, 48)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local FixFrame = Instance.new("Frame")
FixFrame.Parent = TopBar
FixFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
FixFrame.BorderSizePixel = 0
FixFrame.Position = UDim2.new(0, 0, 0.5, 0)
FixFrame.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BLOCKSPIN | Pro Hub"
Title.TextColor3 = Color3.fromRGB(255, 69, 0)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق القائمة (X)
local CloseXBtn = Instance.new("TextButton")
CloseXBtn.Parent = TopBar
CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseXBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseXBtn.Size = UDim2.new(0, 26, 0, 26)
CloseXBtn.Font = Enum.Font.SourceSansBold
CloseXBtn.Text = "X"
CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseXBtn.TextSize = 13
CloseXBtn.AutoButtonColor = false

local XCorner = Instance.new("UICorner")
XCorner.CornerRadius = UDim.new(1, 0)
XCorner.Parent = CloseXBtn

-- حاوية العناصر الداخلية
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 55)
Container.Size = UDim2.new(1, 0, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

local UIPad = Instance.new("UIPadding")
UIPad.Parent = Container
UIPad.PaddingTop = UDim.new(0, 5)

-- دالة إنشاء أزرار التفعيل (محدثة لتستخدم Activated للموبايل)
local function createFeatureToggle(name, desc)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = ""
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Thickness = 1.2
    stroke.Parent = btn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 16, 0, 7)
    nameLabel.Size = UDim2.new(0.7, 0, 0, 18)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = btn
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 16, 0, 25)
    statusLabel.Size = UDim2.new(0.7, 0, 0, 16)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Text = "Status: [ OFF ]"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left

    return btn, statusLabel, stroke
end

-- دالة إنشاء أزرار التحكم بالحجم (تكبير وتصغير الدائرة)
local function createFovControl(labelText, initialVal, onMinus, onPlus)
    local frame = Instance.new("Frame")
    frame.Parent = Container
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Size = UDim2.new(0.9, 0, 0, 40)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 40, 55)
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Font = Enum.Font.SourceSansBold
    label.Text = labelText .. ": " .. initialVal
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- زر التصغير (-)
    local minusBtn = Instance.new("TextButton")
    minusBtn.Parent = frame
    minusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    minusBtn.Position = UDim2.new(1, -74, 0.5, -13)
    minusBtn.Size = UDim2.new(0, 26, 0, 26)
    minusBtn.Font = Enum.Font.SourceSansBold
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.TextSize = 16

    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 6)
    minusCorner.Parent = minusBtn

    -- زر التكبير (+)
    local plusBtn = Instance.new("TextButton")
    plusBtn.Parent = frame
    plusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    plusBtn.Position = UDim2.new(1, -40, 0.5, -13)
    plusBtn.Size = UDim2.new(0, 26, 0, 26)
    plusBtn.Font = Enum.Font.SourceSansBold
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.TextSize = 16

    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 6)
    plusCorner.Parent = plusBtn

    minusBtn.Activated:Connect(function()
        local newVal = onMinus()
        label.Text = labelText .. ": " .. newVal
    end)

    plusBtn.Activated:Connect(function()
        local newVal = onPlus()
        label.Text = labelText .. ": " .. newVal
    end)

    return frame
end

-- بناء العناصر بالترتيب المطلوب
local SilentAimBtn, SilentStatus, SilentStroke = createFeatureToggle("Silent Aim", "تصويب صامت")
createFovControl("Silent FOV", SilentFOV_Radius, 
    function()
        if SilentFOV_Radius > 30 then SilentFOV_Radius = SilentFOV_Radius - 15 end
        silentFovCircle.Radius = SilentFOV_Radius
        return SilentFOV_Radius
    end,
    function()
        if SilentFOV_Radius < 300 then SilentFOV_Radius = SilentFOV_Radius + 15 end
        silentFovCircle.Radius = SilentFOV_Radius
        return SilentFOV_Radius
    end
)

local AimbotBtn, AimbotStatus, AimbotStroke = createFeatureToggle("Aimbot", "أيم بوت مباشر داخل الدائرة")
createFovControl("Aimbot FOV", AimbotFOV_Radius,
    function()
        if AimbotFOV_Radius > 30 then AimbotFOV_Radius = AimbotFOV_Radius - 15 end
        aimbotFovCircle.Radius = AimbotFOV_Radius
        return AimbotFOV_Radius
    end,
    function()
        if AimbotFOV_Radius < 300 then AimbotFOV_Radius = AimbotFOV_Radius + 15 end
        aimbotFovCircle.Radius = AimbotFOV_Radius
        return AimbotFOV_Radius
    end
)

local EspBtn, EspStatus, EspStroke = createFeatureToggle("Players ESP", "كشف الجسم والأسماء والمسافة")

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)

local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
end

-- استخدام Activated لضمان الاستجابة السريعة باللمس على أجهزة الهواتف
FloatingIcon.Activated:Connect(toggleMenu)
CloseXBtn.Activated:Connect(toggleMenu)

local function setupFeatureLogic(button, statusLabel, stroke, callback)
    local state = false
    button.Activated:Connect(function()
        state = not state
        if state then
            statusLabel.Text = "Status: [ ACTIVE ]"
            statusLabel.TextColor3 = Color3.fromRGB(255, 69, 0)
            stroke.Color = Color3.fromRGB(255, 69, 0)
            task.spawn(function()
                callback(true)
            end)
        else
            statusLabel.Text = "Status: [ OFF ]"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            stroke.Color = Color3.fromRGB(50, 50, 70)
            callback(false)
        end
    end)
end

-- دوال استهداف الأقرب لكل دائرة
local function getClosestSilentTarget()
    local closest = nil
    local shortest = silentFovCircle.Radius
    local mouse = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = math.random(1, 10) <= 3 and p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

local function getClosestAimbotTarget()
    local closest = nil
    local shortest = aimbotFovCircle.Radius
    local mouse = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

-- 1. منطق السايلنت أيم
local silentEnabled = false
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if silentEnabled and not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") then
        local target = getClosestSilentTarget()
        if target and self == Workspace then
            if method == "Raycast" and args[1] and args[2] then
                args[2] = (target.Position - args[1]).Unit * args[2].Magnitude
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

setupFeatureLogic(SilentAimBtn, SilentStatus, SilentStroke, function(enabled)
    silentEnabled = enabled
    silentFovCircle.Visible = enabled
end)

-- 2. منطق الأيم بوت المباشر
local aimbotEnabled = false
setupFeatureLogic(AimbotBtn, AimbotStatus, AimbotStroke, function(enabled)
    aimbotEnabled = enabled
    aimbotFovCircle.Visible = enabled
end)

-- تحديث دوائر الفوف وموقع الكاميرا للأيم بوت
RunService.RenderStepped:Connect(function()
    local camCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    silentFovCircle.Position = camCenter
    aimbotFovCircle.Position = camCenter

    if aimbotEnabled then
        pcall(function()
            local targetPart = getClosestAimbotTarget()
            if targetPart then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end)
    end
end)

-- 3. منطق الـ ESP (تلوين الجسم + اسم اللاعب والمسافة بخط صغير وثابت)
local espEnabled = false
local espObjects = {}

local function setupEspForCharacter(char, p)
    if not char:FindFirstChild("BlockSpinHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "BlockSpinHighlight"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 69, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.Parent = char
        table.insert(espObjects, hl)

        local head = char:FindFirstChild("Head")
        if head and not head:FindFirstChild("BlockSpinTag") then
            local bill = Instance.new("BillboardGui")
            bill.Name = "BlockSpinTag"
            bill.Size = UDim2.new(0, 120, 0, 30)
            bill.StudsOffset = Vector3.new(0, 2.2, 0)
            bill.AlwaysOnTop = true

            local lbl = Instance.new("TextLabel")
            lbl.Name = "TagLabel"
            lbl.Parent = bill
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(255, 200, 150)
            lbl.TextStrokeTransparency = 0.3
            lbl.TextSize = 11
            lbl.Font = Enum.Font.SourceSansBold
            lbl.Text = p.Name .. " [--m]"
            
            bill.Parent = head
            table.insert(espObjects, bill)
        end
    end
end

setupFeatureLogic(EspBtn, EspStatus, EspStroke, function(enabled)
    espEnabled = enabled
    if enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                setupEspForCharacter(p.Character, p)
            end
        end
    else
        for _, obj in ipairs(espObjects) do
            if obj then obj:Destroy() end
        end
        espObjects = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local bill = head:FindFirstChild("BlockSpinTag")
                if bill and bill:FindFirstChild("TagLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude)
                    bill.TagLabel.Text = p.Name .. " [" .. dist .. "m]"
                end
            end
        end
    end
end)

for _, p in ipairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function(char)
        if espEnabled then
            task.wait(0.6)
            setupEspForCharacter(char, p)
        end
    end)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if espEnabled then
            task.wait(0.6)
            setupEspForCharacter(char, p)
        end
    end)
end)

-- سحب وإفلات الأيقونة العائمة بسلاسة
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("BlockSpin Pro Hub - Mobile Delta Fix Loaded Successfully!")
