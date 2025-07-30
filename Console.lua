-- Set up GUI
local player = game:GetService("Players").LocalPlayer
if player.PlayerGui:FindFirstChild("RemoteLog") then
    player.PlayerGui.RemoteLog:Destroy()
end

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "RemoteLog"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 700, 0, 400)
frame.Position = UDim2.new(0.5, -350, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -28, 0, 4)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -34)
scroll.Position = UDim2.new(0, 5, 0, 30)
scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 5, 0)
scroll.ScrollBarThickness = 6
scroll.ScrollingDirection = Enum.ScrollingDirection.Y

local content = Instance.new("Frame", scroll)
content.BackgroundTransparency = 1
content.Size = UDim2.new(1, 0, 0, 0)
content.AutomaticSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", content)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

local function log(text)
    local label = Instance.new("TextLabel", content)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = false
    label.TextTruncate = Enum.TextTruncate.AtEnd
end

--// Hook functions
local rawmt = getrawmetatable(game)
local oldNamecall = rawmt.__namecall
setreadonly(rawmt, false)

rawmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if (method == "FireServer" or method == "InvokeServer") and (typeof(self) == "Instance") then
        local args = {...}
        local call = "[" .. method .. "] " .. self:GetFullName() .. " | Args: "

        for i, v in ipairs(args) do
            pcall(function()
                if typeof(v) == "string" then
                    call = call .. '"' .. v .. '"'
                else
                    call = call .. tostring(v)
                end
                if i < #args then
                    call = call .. ", "
                end
            end)
        end

        log(call)
    end

    return oldNamecall(self, ...)
end)

setreadonly(rawmt, true)

log("📡 Remote Logger Initialized - Watching FireServer / InvokeServer...")
