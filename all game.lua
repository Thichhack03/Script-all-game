-- Noclip có GUI nút bật/tắt
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclip = false

-- Tạo GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton", screenGui)

button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Noclip: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true
button.BorderSizePixel = 0
button.BackgroundTransparency = 0.2

-- Bật/tắt khi bấm nút
button.MouseButton1Click:Connect(function()
	noclip = not noclip
	button.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

-- Cập nhật CanCollide mỗi frame
game:GetService("RunService").Stepped:Connect(function()
	if noclip and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Fly bằng cách giữ phím Space (Jump)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local flySpeed = 60

-- Lắng nghe phím nhảy
uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then
        flying = true
    end
end)

uis.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then
        flying = false
    end
end)

-- Cập nhật bay
runService.RenderStepped:Connect(function()
    if flying then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, flySpeed, hrp.Velocity.Z)
    end
end)

-- ESP MM2 đầy đủ: Murder đỏ, Sheriff lam, Innocent xanh lục
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local espEnabled = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "MM2FullESP"

-- GUI bật/tắt
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.3, 0)
button.Text = "ESP: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true
button.BorderSizePixel = 0
button.BackgroundTransparency = 0.2

-- Tạo box màu cho từng body part
local function applyESP(player)
	if player == LocalPlayer then return end
	local character = player.Character or player.CharacterAdded:Wait()
	local highlights = Instance.new("Highlight", espFolder)
	highlights.Name = player.Name .. "_ESP"
	highlights.Adornee = character
	highlights.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlights.FillTransparency = 0.5
	highlights.OutlineTransparency = 1
-- Cập nhật màu theo vai trò
	spawn(function()
		while espEnabled and character and highlights.Parent do
			local roleColor = Color3.fromRGB(0, 255, 0) -- Default: Innocent (xanh lục)
			for _, tool in pairs(character:GetChildren()) do
				if tool:IsA("Tool") then
					if tool.Name == "Knife" then
						roleColor = Color3.fromRGB(255, 0, 0) -- Murder (đỏ)
					elseif tool.Name == "Gun" then
						roleColor = Color3.fromRGB(0, 150, 255) -- Sheriff (xanh lam)
					end
				end
			end
			highlights.FillColor = roleColor
			wait(0.5)
		end
	end)
end

-- Bật/Tắt ESP
local function toggleESP()
	espEnabled = not espEnabled
	button.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	
	if espEnabled then
		for _, player in pairs(Players:GetPlayers()) do
			applyESP(player)
		end

		Players.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function()
				wait(1)
				if espEnabled then
					applyESP(player)
				end
			end)
		end)
	else
		espFolder:ClearAllChildren()
	end
end

button.MouseButton1Click:Connect(toggleESP)

-- Tăng máu tối đa lên 20000 + Hồi máu liên tục
local Players = game:GetService("Players")
local player = Players.LocalPlayer

while true do
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        -- Luôn giữ MaxHealth ở mức 20000
        if humanoid.MaxHealth ~= 20000 then
            humanoid.MaxHealth = 20000
        end
        -- Luôn hồi máu đầy
        humanoid.Health = humanoid.MaxHealth
    end

    wait(0.2) -- tốc độ hồi máu (có thể chỉnh nhanh hơn nếu muốn)
end

-- Tăng damage tất cả vũ khí lên 5000
local Players = game:GetService("Players")
local player = Players.LocalPlayer

while true do
    local char = player.Character or player.CharacterAdded:Wait()

    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            -- Tìm các giá trị số có tên liên quan đến Damage
            for _, val in pairs(tool:GetDescendants()) do
                if val:IsA("NumberValue") and string.lower(val.Name):find("damage") then
                    val.Value = 5000
                end
            end
        end
    end

    wait(0.5) -- kiểm tra lại mỗi 0.5 giây nếu bạn thay vũ khí
end
