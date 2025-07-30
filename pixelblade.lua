-- Setup
local player = game:GetService("Players").LocalPlayer

if player.PlayerGui:FindFirstChild("NameLog") then
    player.PlayerGui.NameLog:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NameLog"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 400, 0, 300)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- will auto-adjust
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scrollFrame.ClipsDescendants = false
scrollFrame.Parent = screenGui

-- Use a frame to hold textLabel for proper auto-sizing
local contentFrame = Instance.new("Frame")
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, 0, 0, 0)
contentFrame.AutomaticSize = Enum.AutomaticSize.Y
contentFrame.Parent = scrollFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

local textLabel = Instance.new("TextLabel")
textLabel.Name = "LogText"
textLabel.BackgroundTransparency = 1
textLabel.Size = UDim2.new(1, -10, 0, 0)
textLabel.Position = UDim2.new(0, 5, 0, 0)
textLabel.Font = Enum.Font.Code
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top
textLabel.TextWrapped = true
textLabel.TextSize = 16
textLabel.Text = "[GAME OBJECT NAME SCAN]\n"
textLabel.AutomaticSize = Enum.AutomaticSize.Y
textLabel.Parent = contentFrame

-- Logging function
local function log(msg)
    textLabel.Text = textLabel.Text .. msg .. "\n"
end

-- Scan all instances in the game
for _, instance in ipairs(game:GetDescendants()) do
    log("🔹 " .. instance:GetFullName())
end
