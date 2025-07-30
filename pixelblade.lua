-- Setup
local player = game:GetService("Players").LocalPlayer

-- Remove old GUI if it exists
if player.PlayerGui:FindFirstChild("NameLog") then
    player.PlayerGui.NameLog:Destroy()
end

-- Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NameLog"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (holds everything)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 320)
mainFrame.Position = UDim2.new(0, 10, 0, 60)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -28, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

-- Close logic
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ScrollFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -34)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scrollFrame.ClipsDescendants = false
scrollFrame.Parent = mainFrame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(1, 0, 0, 0)
contentFrame.AutomaticSize = Enum.AutomaticSize.Y
contentFrame.Parent = scrollFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

-- TextLabel
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

-- Logger
local function log(msg)
    textLabel.Text = textLabel.Text .. msg .. "\n"
end

-- Scan all instances
for _, instance in ipairs(game:GetDescendants()) do
    log("🔹 " .. instance:GetFullName())
end
