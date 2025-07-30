for _, gui in ipairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name == "BossLog" or gui.Name == "AutoFarmToggleGui" or gui.Name == "DebugLogger") then
        gui:Destroy()
    end
end
