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
