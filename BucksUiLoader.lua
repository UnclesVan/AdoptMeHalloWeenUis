
-- Variables for player and UI references
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original Bucks currency label
local originalBucksLabel = playerGui:WaitForChild("BucksIndicatorApp"):WaitForChild("CurrencyIndicator"):WaitForChild("Container"):WaitForChild("Amount")

-- Create the ScreenGui for the Bucks display
local currencyUI = Instance.new("ScreenGui")
currencyUI.Name = "CurrencyUI"
currencyUI.Parent = playerGui

-- Create the main frame for the Bucks display
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.25, 0)
frame.Position = UDim2.new(0.5, -0.15, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = currencyUI

-- Add rounded corners to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2, 0)
corner.Parent = frame

-- Function to create TextLabels (helps avoid repetitive code)
local function createTextLabel(parent, size, position, text, textColor, textSize, font)
    local label = Instance.new("TextLabel", parent)
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = textColor
    label.TextScaled = true
    label.Font = font
    label.TextSize = textSize
    label.TextStrokeTransparency = 0.5
    label.Text = text
    return label
end

-- Create TextLabel for the Bucks amount
local amountDisplay = createTextLabel(frame, UDim2.new(0.55, 0, 0.7, 0), UDim2.new(0.35, 0, 0.25, 0), originalBucksLabel.Text, Color3.new(0, 0, 0), 36, Enum.Font.SourceSansBold)

-- Update the Bucks display whenever the original amount changes
local function updateBucksAmount()
    amountDisplay.Text = originalBucksLabel.Text
end
originalBucksLabel.Changed:Connect(updateBucksAmount)
updateBucksAmount()

-- Add the owner label
local ownerLabel = createTextLabel(frame, UDim2.new(1, 0, 0.2, 0), UDim2.new(0, 0, 0.1, 0), "Private Script Owner: made by me", Color3.new(0, 0, 0), 24, Enum.Font.SourceSansBold)

-- Add the candy corn image
local candyCorn = Instance.new("ImageLabel", frame)
candyCorn.Size = UDim2.new(0.35, 0, 0.9, 0)
candyCorn.Position = UDim2.new(0.02, 0, 0.05, 0)
candyCorn.BackgroundTransparency = 1
candyCorn.Image = "rbxassetid://2576547983"  -- Updated candy corn image asset ID
candyCorn.ScaleType = Enum.ScaleType.Fit

-- Add the "Close" button
local closeButtonContainer = Instance.new("Frame", frame)
closeButtonContainer.Size = UDim2.new(0.1, 0, 0.5, 0)
closeButtonContainer.Position = UDim2.new(0.9, 0, 0.25, 0)
closeButtonContainer.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
closeButtonContainer.BorderSizePixel = 0
closeButtonContainer.BackgroundTransparency = 0.2

local closeButton = Instance.new("TextButton", closeButtonContainer)
closeButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 58, 58)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 36
closeButton.Text = "X"

-- Hover effect for close button
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 58, 58)
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local tweenService = game:GetService("TweenService")
    local closeTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -0.15, 0.5, -0.1)
    })
    closeTween:Play()
    closeTween.Completed:Wait()
    currencyUI:Destroy()
end)

-- Function to pop in the UI
local function popInUI()
    frame.Position = UDim2.new(0.5, -0.15, 0.1, 0)
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Visible = true

    local tweenService = game:GetService("TweenService")
    local popTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -0.15, 0.05, 0),
        Size = UDim2.new(0.3, 0, 0.15, 0)
    })
    popTween:Play()
end

-- Call the pop-in function to show the UI with animation
popInUI()

-- Draggable functionality
local dragging = false
local dragStart = nil
local startPos = nil
local userInputService = game:GetService("UserInputService")

local function updateInput(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Wait()
        dragging = false
    end
end)

userInputService.InputChanged:Connect(updateInput)

-- Hover effects for the frame
frame.MouseEnter:Connect(function()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.32, 0, 0.17, 0)
    }):Play()
end)

frame.MouseLeave:Connect(function()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.3, 0, 0.15, 0)
    }):Play()
end)

print'5'
print'4'
print'3'
print'2'
print'1'
print"0, stack gui has loaded."

-- Get the Player
local player = game.Players.LocalPlayer

-- Define the paths to the Scroll elements
local scrollContainer = player:WaitForChild("PlayerGui"):WaitForChild("BackpackApp"):WaitForChild("Tooltip"):WaitForChild("List"):WaitForChild("description"):WaitForChild("Scroll")
local backpackStackCountPath = player:WaitForChild("PlayerGui"):WaitForChild("BackpackApp").Frame.Body.ScrollComplex.ScrollingFrame.Content.food.Row0["2_ec2e53ab06e64eeabbe11911c68f6b69"].Button.StackCount.TextLabel

-- Create ScreenGui to hold the UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Function to create a stack count frame
local function createStackCountFrame(position, labelText, isBackpack)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.35, 0, 0.25, 0) -- Size of the frame
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local aspectRatio = Instance.new("UIAspectRatioConstraint")
    aspectRatio.Parent = frame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0.1, 0, 0.1, 0)
    icon.Position = UDim2.new(0.02, 0, 0.2, 0)
    icon.Image = "rbxassetid://13619902566" -- Example icon, replace as needed
    icon.BackgroundTransparency = 1
    icon.Parent = frame

    local stackCountLabel = Instance.new("TextLabel")
    stackCountLabel.Size = UDim2.new(0.88, 0, 1, 0)
    stackCountLabel.Position = UDim2.new(0.12, 0, 0, 0)
    stackCountLabel.BackgroundTransparency = 1
    stackCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stackCountLabel.TextScaled = true
    stackCountLabel.Text = labelText
    stackCountLabel.Parent = frame

    local function onHover()
        frame:TweenSize(UDim2.new(0.4, 0, 0.3, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end

    local function onUnhover()
        frame:TweenSize(UDim2.new(0.35, 0, 0.25, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end

    frame.MouseEnter:Connect(onHover)
    frame.MouseLeave:Connect(onUnhover)

    -- Original stack count logic for the first frame
    if not isBackpack then
        local function updateStackCount()
            local stackCounts = {}

            -- Iterate over all children in the Scroll container
            for _, child in ipairs(scrollContainer:GetChildren()) do
                if child:IsA("TextLabel") then
                    local text = child.Text
                    local currentCount = text:match("Stack Count:%s*(%d+)")
                    if currentCount then
                        table.insert(stackCounts, tonumber(currentCount))
                    end
                end
            end

            -- Update the displayed stack counts for "Stack Counts"
            local stackCountText = labelText .. ": "
            for _, count in ipairs(stackCounts) do
                stackCountText = stackCountText .. tostring(count) .. ", "
            end

            if #stackCounts > 0 then
                stackCountText = stackCountText:sub(1, -3)
            else
                stackCountText = stackCountText .. "None"
            end

            stackCountLabel.Text = stackCountText
        end

        -- Connect to change events
        scrollContainer.ChildAdded:Connect(updateStackCount)
        scrollContainer.ChildRemoved:Connect(updateStackCount)

        -- Check existing labels on creation
        for _, child in ipairs(scrollContainer:GetChildren()) do
            if child:IsA("TextLabel") then
                child:GetPropertyChangedSignal("Text"):Connect(updateStackCount)
            end
        end

        -- Initial update
        updateStackCount()
    else
        -- Logic for updating the backpack stack count
        local function updateBackpackStackCount()
            -- Directly get the Backpack stack count from the specified path
            local backpackCountText = backpackStackCountPath.Text

            -- Update the displayed stack count for "BackPack Stacks"
            stackCountLabel.Text = "BackPack Stacks: " .. backpackCountText
        end

        -- Listen for changes in the Backpack stack count
        backpackStackCountPath:GetPropertyChangedSignal("Text"):Connect(updateBackpackStackCount)

        -- Initial update for backpack counts
        updateBackpackStackCount()
    end

    return frame, stackCountLabel
end

-- Create the first stack count frame with label "Stack Counts"
createStackCountFrame(UDim2.new(0.02, 0, 0.6, 0), "Stack Counts", false) -- Position for the first frame, isBackpack = false

-- Create the second stack count frame with label "BackPack Stacks"
createStackCountFrame(UDim2.new(0.18, 0, 0.6, 0), "BackPack Stacks", true) -- Position for the second frame, isBackpack = true

-- Optional: Update periodically (every 1 second) if items can change rapidly
while wait(1) do
    for _, frame in ipairs(screenGui:GetChildren()) do
        if frame:IsA("Frame") then
            local stackCountLabel = frame:FindFirstChildOfClass("TextLabel")
            if stackCountLabel then
                -- This will keep the original count updated, though it shouldn't change every second
                stackCountLabel.Text = stackCountLabel.Text 
            end
        end
    end
end




