-- 🇻🇳 Hack Menu GUI di chuyển được, có Noclip, Fly, ESP và Auto Anti-Death (kèm tốc độ 20)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- 🛡️ Auto Anti-death + Tốc độ
humanoid.MaxHealth = 20000
humanoid.Health = 20000
humanoid.WalkSpeed = 30

RunService.RenderStepped:Connect(function()
    if humanoid then
        humanoid.MaxHealth = 20000
        humanoid.Health = 20000
        humanoid.WalkSpeed = 30
    end
end)

-- 🖼️ GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 100, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Name = "VNMenu"

local vnFlag = Instance.new("TextButton", frame)
vnFlag.Size = UDim2.new(1, 0, 1, 0)
vnFlag.Text = "🇻🇳"
vnFlag.TextScaled = true
vnFlag.BackgroundTransparency = 1

-- Menu chính
local mainMenu = Instance.new("Frame", gui)
mainMenu.Size = UDim2.new(0, 160, 0, 200)
mainMenu.Position = UDim2.new(0.1, 110, 0.1, 0)
mainMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainMenu.BorderSizePixel = 0
mainMenu.Visible = false

-- Bo góc 3mm (khoảng 12px)
local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

local uicorner2 = Instance.new("UICorner", mainMenu)
uicorner2.CornerRadius = UDim.new(0, 12)

-- Toggle menu
vnFlag.MouseButton1Click:Connect(function()
    mainMenu.Visible = not mainMenu.Visible
end)

-- Nút tạo nhanh
local function createButton(name, order, callback)
    local btn = Instance.new("TextButton", mainMenu)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 10 + (order - 1) * 50)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
end

-- Noclip
local noclip = false
createButton("Noclip", 1, function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip then
        local c = player.Character
        if c then
            for _, part in pairs(c:GetDescendants()) do
                if part:IsA("BasePart") and not part.Anchored then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fly
local flying = false
local bv
createButton("Fly", 2, function()
    flying = not flying
    if flying then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
        bv.Parent = root
        RunService.RenderStepped:Connect(function()
            if flying and root then
                bv.Velocity = root.CFrame.LookVector * 50 + Vector3.new(0, 25, 0)
            end
        end)
    else
        if bv then bv:Destroy() end
    end
end)

-- ESP
local espOn = false
createButton("ESP", 3, function()
    espOn = not espOn
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("ESP") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESP"
                box.Size = Vector3.new(4, 6, 4)
                box.Adornee = head
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Transparency = 0.5
                box.Color3 = Color3.fromRGB(0, 255, 0)
                box.Parent = head
            elseif head and espOn == false and head:FindFirstChild("ESP") then
                head:FindFirstChild("ESP"):Destroy()
            end
        end
    end
end)
