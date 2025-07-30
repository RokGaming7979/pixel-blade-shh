-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LocalScriptViewer"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add UI elements
local uiCorner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Text = "LocalScript Viewer"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 8
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

-- Function to find and list LocalScripts
local function listLocalScripts()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") then
            local label = Instance.new("TextLabel")
            label.Text = v:GetFullName()
            label.Size = UDim2.new(1, -10, 0, 20)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Code
            label.TextScaled = false
            label.TextWrapped = true
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = scroll
        end
    end
    wait()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Run the function
listLocalScripts()
