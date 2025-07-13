-- Services
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Settings
local roomcheck = false
local autofarm = true
local killall = true
local paused = false

-- Create Pause/Resume GUI Button for Mobile (top-left corner)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmToggleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)  -- top-left corner
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 22
toggleButton.Text = "Pause"
toggleButton.Parent = screenGui

toggleButton.MouseButton1Click:Connect(function()
    paused = not paused
    toggleButton.Text = paused and "Resume" or "Pause"
    warn("Auto Script is now", paused and "Paused" or "Running")
end)

-- Keyboard toggle with 'V' key for when you plug in keyboard
uis.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.V and not gp then
        paused = not paused
        toggleButton.Text = paused and "Resume" or "Pause"
        warn("Auto Script is now", paused and "Paused" or "Running")
    end
end)

-- Cleanup UI & screen blur
task.spawn(function()
    local ui = player:WaitForChild("PlayerGui"):WaitForChild("gameUI")
    if ui:FindFirstChild("upgradeFrame") then
        ui.upgradeFrame.Visible = false
    end
    if game.Lighting:FindFirstChild("deathBlur") then
        game.Lighting.deathBlur:Destroy()
    end
    if game.Lighting:FindFirstChild("screenBlur") then
        game.Lighting.screenBlur:Destroy()
    end
end)

-- Press all boss buttons that require hold E
local function pressButtons(character)
    local prompts = {}
    for _, v in workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") and v.Enabled then
            if v.Parent.Name:lower():find("bossbutton") or v.Name:lower():find("bossbutton") then
                table.insert(prompts, v)
            end
        end
    end

    for _, prompt in ipairs(prompts) do
        character.HumanoidRootPart.CFrame = prompt.Parent.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.1)
        pcall(function()
            fireproximityprompt(prompt, prompt.HoldDuration or 1)
        end)
        task.wait((prompt.HoldDuration or 1) + 0.1)
    end
end

-- Improved boss room detection and teleport
local function enterFinalBossRoom(character)
    for _, v in workspace:GetDescendants() do
        if v:IsA("BasePart") then
            local lname = v.Name:lower()
            local parentName = v.Parent and v.Parent.Name:lower() or ""
            if lname:find("bossroom") or lname:find("finalroom") or parentName:find("bossroom") or parentName:find("finalroom") then
                character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                task.wait(1.5) -- Wait for boss to spawn
                return true
            end
        end
    end
    local finalBossFolder = workspace:FindFirstChild("FinalBossRoom")
    if finalBossFolder then
        local part = finalBossFolder:FindFirstChildWhichIsA("BasePart")
        if part then
            character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
            task.wait(1.5)
            return true
        end
    end
    return false
end

-- Main room function
local function room(character)
    for _, v in workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") and v.Enabled then
            if not (v.Parent.Name:lower():find("bossbutton") or v.Name:lower():find("bossbutton")) then
                character.HumanoidRootPart.CFrame = v.Parent.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.1)
                pcall(function()
                    fireproximityprompt(v, v.HoldDuration or 1)
                end)
                task.wait((v.HoldDuration or 1) + 0.1)
            end
        end
    end

    for _, v in workspace:GetChildren() do
        if v:FindFirstChild("ExitZone") then
            character.HumanoidRootPart.CFrame = v.ExitZone.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.1)
            character.HumanoidRootPart.CFrame = CFrame.new(v:GetPivot().Position)
            task.wait(0.1)
        end
    end

    pressButtons(character)
    enterFinalBossRoom(character)

    roomcheck = false
end

-- Main loop
runService.RenderStepped:Connect(function()
    if paused then return end
    local character = player.Character
    if character then
        if autofarm and not roomcheck then
            roomcheck = true
            room(character)
        end

        if killall then
            for _, v in workspace:GetChildren() do
                local humanoid = v:FindFirstChild("Humanoid")
                if not humanoid then
                    local model = v:FindFirstChildWhichIsA("Model")
                    if model then
                        humanoid = model:FindFirstChild("Humanoid")
                    end
                end

                if humanoid and v:GetAttribute("hadEntrance") and v:FindFirstChild("Health") then
                    replicatedStorage.remotes.useAbility:FireServer("tornado")
                    replicatedStorage.remotes.abilityHit:FireServer(humanoid, math.huge, {
                        ["stun"] = {["dur"] = 1}
                    })
                end
            end
        end
    end
end)
