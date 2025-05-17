-- dehash
loadstring(game:HttpGet(('https://raw.githubusercontent.com/UnclesVan/AdoPtMe-/refs/heads/main/dehashwithslashinmiddle')))()



-- Remove any existing item on the hotbar
local argsClear = {1}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/SetSlotProperties"):InvokeServer(unpack(argsClear))

-- Buy/set the item to the hotbar
local argsSetItem = {
    1,
    {
        category = "gifts",
        kind = "gibbon_2025_standard_box"
    }
}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/SetSlotProperties"):InvokeServer(unpack(argsSetItem))

-- You can repeat the above if needed, but it seems you want to set the item in slot 1
-- So, the above commands will clear and then set the item in slot 1

-- Now, the auto-clicker UI and logic
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerUI"
screenGui.Parent = playerGui

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Auto Click: OFF"
toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Parent = screenGui

-- Create Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 150, 0, 50)
closeButton.Position = UDim2.new(0, 10, 0, 70)
closeButton.Text = "Close"
closeButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = screenGui

-- Variables
local isAutoClicking = false
local autoClickCoroutine = nil

-- Function to fire all connections of an event
local function fireConnections(event)
    for _, connection in pairs(getconnections(event)) do
        connection:Fire()
    end
end

-- Function to simulate a click on a GUI object
local function simulateClick(button)
    if button then
        fireConnections(button.MouseButton1Down)
        wait(0.05)
        fireConnections(button.MouseButton1Click)
        wait(0.05)
        fireConnections(button.MouseButton1Up)
    end
end

-- Function to click all tools inside ToolContainer
local function clickAllTools()
    local success, err = pcall(function()
        local toolContainer = playerGui:WaitForChild("ToolApp")
            :WaitForChild("Frame")
            :WaitForChild("Hotbar")
            :WaitForChild("ToolContainer")
        for _, child in ipairs(toolContainer:GetChildren()) do
            if child:IsA("GuiObject") then
                simulateClick(child)
            end
        end
    end)
    if not success then
        warn("Error clicking tools:", err)
    end
end

-- Auto-click loop
local function autoClickLoop()
    while isAutoClicking do
        local success, err = pcall(function()
            -- ClaimButton
            local claimButton = playerGui:WaitForChild("JackboxRewardApp")
                :WaitForChild("Body")
                :WaitForChild("ClaimButton")
            simulateClick(claimButton)
            -- Tools
            clickAllTools()
        end)
        if not success then
            warn("AutoClick error:", err)
        end
        wait(2) -- delay between cycles
    end
end

-- Toggle button logic
toggleButton.MouseButton1Click:Connect(function()
    isAutoClicking = not isAutoClicking
    if isAutoClicking then
        toggleButton.Text = "Auto Click: ON"
        toggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
        -- Start the auto-click loop in a separate thread
        autoClickCoroutine = coroutine.create(autoClickLoop)
        coroutine.resume(autoClickCoroutine)
    else
        toggleButton.Text = "Auto Click: OFF"
        toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
    end
end)

-- Close button logic
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)
