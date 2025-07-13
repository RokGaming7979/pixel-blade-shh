-- Services
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Startup config
local roomcheck = false
local autofarm = true
local killall = true

-- Hide UI and blur effects on startup
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

-- Auto room handling
local function room(character)
    for _,v in workspace:GetDescendants() do
        if v.ClassName == "ProximityPrompt" and v.Enabled then
            character.HumanoidRootPart.CFrame = v.Parent.CFrame
            fireproximityprompt(v)
            task.wait(0.1)
        end
    end
    for _,v in workspace:GetChildren() do   
        if v:FindFirstChild("ExitZone") then
            character.HumanoidRootPart.CFrame = v.ExitZone.CFrame
            task.wait(0.25)
            character.HumanoidRootPart.CFrame = CFrame.new(v:GetPivot().Position)
            task.wait(0.25)
        end
    end
    roomcheck = false
end

-- Main game loop
runService.RenderStepped:Connect(function()
    local character = player.Character
    if character then
        if autofarm and not roomcheck then
            roomcheck = true
            room(character)
        end
        if killall then
            for _,v in workspace:GetChildren() do   
                local humanoid = v:FindFirstChild("Humanoid")
                if not humanoid then
                    local model = v:FindFirstChildWhichIsA("Model")
                    if model then
                        humanoid = model:FindFirstChild("Humanoid")
                    end
                end
                if humanoid and v:GetAttribute("hadEntrance") and v:FindFirstChild("Health") then
                    replicatedStorage.remotes.useAbility:FireServer("tornado")
                    replicatedStorage.remotes.abilityHit:FireServer(humanoid, math.huge, {["stun"] = {["dur"] = 1}})
                end
            end
        end
    end
end)
