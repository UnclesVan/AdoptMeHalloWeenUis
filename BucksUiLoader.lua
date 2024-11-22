
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

-- Define the paths to the UI elements
local scrollContainer = player:WaitForChild("PlayerGui"):WaitForChild("BackpackApp"):WaitForChild("Tooltip"):WaitForChild("List"):WaitForChild("description"):WaitForChild("Scroll")
local backpackStackCountPath = player:WaitForChild("PlayerGui"):WaitForChild("ToolApp"):WaitForChild("Frame"):WaitForChild("Hotbar"):WaitForChild("ToolContainer"):WaitForChild("StackCount"):WaitForChild("TextLabel")

-- Create ScreenGui to hold the UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Function to create a loading spinner (UI element for loading state)
local function createLoadingSpinner(parent)
    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0.1, 0, 0.1, 0)
    spinner.Position = UDim2.new(0.45, 0, 0.45, 0)
    spinner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    spinner.BackgroundTransparency = 0.5
    spinner.Parent = parent

    -- Create the rotating circle for the spinner
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.Position = UDim2.new(0, 0, 0, 0)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = spinner

    -- Round the corners of the circle
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0.5, 0)
    uiCorner.Parent = circle

    -- Create rotation animation for the spinner
    local rotateTween = game:GetService("TweenService"):Create(circle, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Rotation = 360})
    rotateTween:Play()

    spinner.Visible = false -- Spinner is hidden by default
    return spinner
end

-- Function to create a stack count frame
local function createStackCountFrame(position, labelText, isBackpack)
    -- Create the main frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.35, 0, 0.25, 0) -- Size of the frame
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Aspect ratio for the frame (optional)
    local aspectRatio = Instance.new("UIAspectRatioConstraint")
    aspectRatio.Parent = frame

    -- Corner radius for rounded corners
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    -- Icon in the frame
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0.1, 0, 0.1, 0)
    icon.Position = UDim2.new(0.02, 0, 0.2, 0)
    icon.Image = "rbxassetid://13619902566" -- Example icon, replace as needed
    icon.BackgroundTransparency = 1
    icon.Parent = frame

    -- Stack count label in the frame
    local stackCountLabel = Instance.new("TextLabel")
    stackCountLabel.Size = UDim2.new(0.88, 0, 1, 0)
    stackCountLabel.Position = UDim2.new(0.12, 0, 0, 0)
    stackCountLabel.BackgroundTransparency = 1
    stackCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stackCountLabel.TextScaled = true
    stackCountLabel.Text = labelText
    stackCountLabel.Parent = frame

    -- Create the loading spinner for this frame
    local loadingSpinner = createLoadingSpinner(frame)

    -- Hover effect: expand on mouse enter
    local function onHover()
        frame:TweenSize(UDim2.new(0.4, 0, 0.3, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end

    -- Hover effect: shrink on mouse leave
    local function onUnhover()
        frame:TweenSize(UDim2.new(0.35, 0, 0.25, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end

    -- Connect hover events to the frame
    frame.MouseEnter:Connect(onHover)
    frame.MouseLeave:Connect(onUnhover)

    -- Logic for "Stack Counts" frame (for regular stack counts)
    if not isBackpack then
        local function updateStackCount()
            local stackCounts = {}

            -- Show the spinner while data is loading
            loadingSpinner.Visible = true

            -- Simulate loading (replace with actual data fetching)
            wait(2)  -- Simulating delay for loading the data

            -- Iterate over all children in the Scroll container and find stack counts
            for _, child in ipairs(scrollContainer:GetChildren()) do
                if child:IsA("TextLabel") then
                    local text = child.Text
                    local currentCount = text:match("Stack Count:%s*(%d+)")
                    if currentCount then
                        table.insert(stackCounts, tonumber(currentCount))
                    end
                end
            end

            -- Update the stack count text
            local stackCountText = labelText .. ": "
            for _, count in ipairs(stackCounts) do
                stackCountText = stackCountText .. tostring(count) .. ", "
            end

            if #stackCounts > 0 then
                stackCountText = stackCountText:sub(1, -3)  -- Remove the last comma
            else
                stackCountText = stackCountText .. "None"
            end

            stackCountLabel.Text = stackCountText

            -- Hide the spinner once data is loaded
            loadingSpinner.Visible = false
        end

        -- Listen for changes to stack counts
        scrollContainer.ChildAdded:Connect(updateStackCount)
        scrollContainer.ChildRemoved:Connect(updateStackCount)

        -- Check existing stack labels on creation
        for _, child in ipairs(scrollContainer:GetChildren()) do
            if child:IsA("TextLabel") then
                child:GetPropertyChangedSignal("Text"):Connect(updateStackCount)
            end
        end

        -- Initial update of stack count
        updateStackCount()
    else
        -- Logic for updating the Backpack stack count
        local function updateBackpackStackCount()
            -- Show the spinner while data is loading
            loadingSpinner.Visible = true

            -- Simulate loading (replace with actual data fetching)
            wait(2)  -- Simulating delay for loading the data

            -- Directly get the Backpack stack count from the specified path
            local backpackCountText = backpackStackCountPath.Text

            -- Update the displayed stack count for "BackPack Stacks"
            stackCountLabel.Text = "BackPack Stacks: " .. backpackCountText

            -- Hide the spinner once data is loaded
            loadingSpinner.Visible = false
        end

        -- Listen for changes in the Backpack stack count
        backpackStackCountPath:GetPropertyChangedSignal("Text"):Connect(updateBackpackStackCount)

        -- Initial update for backpack stack counts
        updateBackpackStackCount()
    end

    return frame, stackCountLabel
end

-- Function to dynamically position each UI frame horizontally
local function createStackCountFrames()
    local startX = 0.02 -- Initial X position
    local spacing = 0.18 -- Space between frames in the X axis

    -- Create the first stack count frame with label "Stack Counts"
    createStackCountFrame(UDim2.new(startX, 0, 0.6, 0), "Stack Counts", false) -- Position for the first frame, isBackpack = false

    -- Create the second stack count frame with label "BackPack Stacks"
    createStackCountFrame(UDim2.new(startX + spacing, 0, 0.6, 0), "BackPack Stacks", true) -- Position for the second frame, isBackpack = true

    -- Add more frames in the same line by adjusting the `startX` and `spacing`
    -- Create more frames as needed:
    createStackCountFrame(UDim2.new(startX + 2 * spacing, 0, 0.6, 0), "Other Stack", false) -- Add another frame
    -- You can continue adding frames like this
end

-- Create the stack count frames
createStackCountFrames()
