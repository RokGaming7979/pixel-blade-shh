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
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 700, 0, 450)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Search Bar
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 200, 0, 24)
searchBox.Position = UDim2.new(1, -260, 0, 4)
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.PlaceholderText = "Search..."
searchBox.Font = Enum.Font.SourceSans
searchBox.TextSize = 16
searchBox.ClearTextOnFocus = false
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.Parent = mainFrame

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

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ScrollFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -40)
scrollFrame.Position = UDim2.new(0, 10, 0, 30)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.XY
scrollFrame.CanvasSize = UDim2.new(2, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ClipsDescendants = true
scrollFrame.Parent = mainFrame

-- Content Frame inside Scroll
local contentFrame = Instance.new("Frame")
contentFrame.BackgroundTransparency = 1
contentFrame.Size = UDim2.new(2, 0, 0, 0)
contentFrame.AutomaticSize = Enum.AutomaticSize.Y
contentFrame.Parent = scrollFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "[GAME OBJECT NAME SCAN]"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextSize = 20
titleLabel.TextWrapped = false
titleLabel.Parent = contentFrame

-- Table to store all logged entries
local allEntries = {}

-- Logging function
local function log(msg)
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, 0, 0, 20)
    entry.BackgroundTransparency = 1
    entry.Font = Enum.Font.Code
    entry.TextSize = 16
    entry.TextColor3 = Color3.new(1, 1, 1)
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.TextWrapped = false
    entry.TextTruncate = Enum.TextTruncate.None
    entry.Text = msg
    entry.Parent = contentFrame
    table.insert(allEntries, entry)
end

-- Scan and log all instances
for _, instance in ipairs(game:GetDescendants()) do
    log("🔹 " .. instance:GetFullName())
end

-- Search filter
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchBox.Text:lower()
    for _, label in ipairs(allEntries) do
        if searchText == "" or label.Text:lower():find(searchText, 1, true) then
            label.Visible = true
        else
            label.Visible = false
        end
    end
end)
