local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

coroutine.wrap(function()
    while true do
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
        task.wait(0.1)
    end
end)()

Humanoid.WalkSpeed = 50

local function boostDamage(tool)
    if not tool:IsA("Tool") then return end
    local dmgVal = tool:FindFirstChild("Damage")
    if dmgVal and dmgVal:IsA("NumberValue") then
        dmgVal.Value = dmgVal.Value * 5
    else
        local newDmg = Instance.new("NumberValue")
        newDmg.Name = "Damage"
        newDmg.Value = 50
        newDmg.Parent = tool
    end
end

for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
    boostDamage(tool)
end
if LocalPlayer.Character then
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        boostDamage(tool)
    end
end

LocalPlayer.Backpack.ChildAdded:Connect(boostDamage)
LocalPlayer.Character.ChildAdded:Connect(boostDamage)
