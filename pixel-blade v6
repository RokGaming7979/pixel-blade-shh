-- Services
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- State flags
local autofarm = true
local killall = true
local paused = false
local vaultDone = false
local atticusEntered = false

-- Remove upgrade UI
local function cleanUI()
	local gui = player:FindFirstChild("PlayerGui")
	if gui and gui:FindFirstChild("gameUI") and gui.gameUI:FindFirstChild("upgradeFrame") then
		gui.gameUI.upgradeFrame.Visible = false
	end
	if game.Lighting:FindFirstChild("deathBlur") then game.Lighting.deathBlur:Destroy() end
	if game.Lighting:FindFirstChild("screenBlur") then game.Lighting.screenBlur:Destroy() end
end
cleanUI()

-- GUI Pause Button
local button = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
button.Name = "AutoFarmToggleGui"
local pauseButton = Instance.new("TextButton")
pauseButton.Size = UDim2.new(0, 120, 0, 40)
pauseButton.Position = UDim2.new(1, -130, 1, -50)
pauseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
pauseButton.TextColor3 = Color3.new(1, 1, 1)
pauseButton.Text = "⏸ Pause"
pauseButton.Font = Enum.Font.SourceSansBold
pauseButton.TextSize = 20
pauseButton.Parent = button

pauseButton.MouseButton1Click:Connect(function()
	paused = not paused
	pauseButton.Text = paused and "▶️ Resume" or "⏸ Pause"
end)

-- Vault Button Activation
local function pressVaultButtons(character)
	for _, v in workspace:GetDescendants() do
		if v:IsA("ProximityPrompt") and v.Parent and v.Parent.Name:lower():find("buttonpress") and v.Enabled then
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = v.Parent.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.2)
				fireproximityprompt(v, true)
				task.wait(v.HoldDuration + 0.1)
			end
		end
	end
end

-- Enter Final Boss Room
local function enterAtticusRoom(character)
	local atticus = workspace:FindFirstChild("Atticus")
	if not atticus then return false end
	local root = atticus:FindFirstChild("HumanoidRootPart")
	if root then
		character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 5, 0)
		atticusEntered = true
		return true
	end
	return false
end

-- Run Autofarm Loop
runService.RenderStepped:Connect(function()
	if paused then return end

	local character = player.Character
	if not character then return end

	if autofarm then
		if not vaultDone then
			pressVaultButtons(character)
			vaultDone = true
			task.wait(1.5)
		end

		if vaultDone and not atticusEntered then
			enterAtticusRoom(character)
			task.wait(0.5)
		end
	end

	-- Kill all mobs (including bosses)
	if killall then
		for _, v in workspace:GetChildren() do
			local hum = v:FindFirstChild("Humanoid")
			if not hum and v:IsA("Model") then
				hum = v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model"):FindFirstChild("Humanoid")
			end

			if hum and v:GetAttribute("hadEntrance") and v:FindFirstChild("Health") then
				replicatedStorage.remotes.useAbility:FireServer("tornado")
				replicatedStorage.remotes.abilityHit:FireServer(hum, math.huge, {["stun"] = {["dur"] = 1}})
			end
		end
	end
end)
