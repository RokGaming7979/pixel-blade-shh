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

-- Toggle pause with 'P' key
uis.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.P and not gp then
        paused = not paused
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

local function pressButtons(character)
    -- Press all proximity prompts related to last boss buttons (hold E)
    local prompts = {}
    for _, v in workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") and v.Enabled then
            -- Optionally filter prompts for last boss buttons by name or location if needed
            table.insert(prompts, v)
        end
    end

    -- Press them all in sequence
    for _, prompt in ipairs(prompts) do
        character.HumanoidRootPart.CFrame = prompt.Parent.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.1)
        pcall(function()
            fireproximityprompt(prompt, prompt.HoldDuration or 1)
        end)
        task.wait((prompt.HoldDuration or 1) + 0.1)
    end
end

local function enterFinalBossRoom(character)
    -- Find the boss room part(s) to teleport into
    for _, v in workspace:GetDescendants() do
        if v:IsA("Part") and v.Name:lower():find("bossroom") then
            character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
            task.wait(1.5) -- wait for boss spawn
            return true
        end
    end
    return false
end

local function room(character)
    -- Normal room prompts except last boss buttons handled separately
    for _, v in workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") and v.Enabled then
            if not v.Parent.Name:lower():find("bossbutton") then -- skip boss buttons here
                character.HumanoidRootPart.CFrame = v.Parent.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.1)
                pcall(function()
                    fireproximityprompt(v, v.HoldDuration or 1)
                end)
                task.wait((v.HoldDuration or 1) + 0.1)
            end
        end
    end

    -- Exit zones
    for _, v in workspace:GetChildren() do
        if v:FindFirstChild("ExitZone") then
            character.HumanoidRootPart.CFrame = v.ExitZone.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.1)
            character.HumanoidRootPart.CFrame = CFrame.new(v:GetPivot().Position)
            task.wait(0.1)
        end
    end

    -- Special last boss handling: press boss buttons and enter final boss room
    pressButtons(character)
    enterFinalBossRoom(character)

    roomcheck = false
end

-- Main loop: auto farm and kill all
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
