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
