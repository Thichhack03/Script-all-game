local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function protectCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Đặt máu rất cao và khôi phục nếu bị giảm
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge

    -- Vô hiệu hoá mọi sát thương ngay khi bị cố gắng giảm
    humanoid.HealthChanged:Connect(function()
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    -- Ngăn bị giết bằng State (rất cần trong nhiều game PvP)
    humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    -- Xóa các công cụ gây chết từ game (nếu cần)
    humanoid.BreakJointsOnDeath = false
end

-- Lặp lại khi nhân vật respawn
player.CharacterAdded:Connect(protectCharacter)

-- Nếu nhân vật đã tồn tại sẵn
if player.Character then
    protectCharacter(player.Character)
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tạo highlight cho model với màu sắc
local function createHighlight(model, color)
    if model:FindFirstChild("ESP_Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.Parent = model
end

local function removeHighlight(model)
    local h = model:FindFirstChild("ESP_Highlight")
    if h then h:Destroy() end
end

local function updateESP()
    -- Xóa hết highlight cũ (để tránh dư thừa)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            removeHighlight(obj)
        end
    end

    -- Highlight người chơi (phe ta)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createHighlight(player.Character, Color3.fromRGB(0, 170, 255)) -- Màu xanh dương
        end
    end

    -- Highlight Zombie (phe địch)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower():find("zombie") then
            createHighlight(obj, Color3.fromRGB(255, 0, 0)) -- Màu đỏ
        end
    end
end

-- Lặp liên tục cập nhật ESP
while true do
    pcall(updateESP)
    task.wait(1)
end
