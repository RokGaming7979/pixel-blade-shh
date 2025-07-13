-- Services
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Auto-enable features on load
local roomcheck = false
local autofarm = true
local killall = true

-- Hide upgrade UI and remove screen effects
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

-- Room logic including proximity buttons and boss room
local function room(character)
    -- Press all active proximity prompts (supports "Hold E")
    for _, v in workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") and v.Enabled then
            local holdTime = v.HoldDuration or 1
            character.HumanoidRootPart.CFrame = v.Parent.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.2)
            fireproximityprompt(v, holdTime)
            task.wait(holdTime + 0.2)
        end
    end

    -- Go through ExitZones (doorways / room exits)
    for _, v in workspace:GetChildren() do
        if v:FindFirstChild("ExitZone") then
            local zone = v.ExitZone
            character.HumanoidRootPart.CFrame = zone.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.5)
            character.HumanoidRootPart.CFrame = CFrame.new(v:GetPivot().Position)
            task.wait(0.5)
        end
    end

    -- Try to trigger final boss room if found
    for _, v in workspace:GetDescendants() do
        if v:IsA("Part") and v.Name:lower():find("boss") and v:IsDescendantOf(workspace) then
            character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
            task.wait(2) -- Wait for boss spawn trigger
        end
    end

    roomcheck = false
end

-- Main loop: auto farm and kill all
runService.RenderStepped:Connect(function()
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
