-- Variables for player and UI references 
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original amount label
local originalAmountLabel = playerGui:WaitForChild("AltCurrencyIndicatorApp"):WaitForChild("CurrencyIndicator"):WaitForChild("Container"):WaitForChild("Amount")

-- Reference the original timer label
local originalTimerLabel = playerGui:WaitForChild("QuestIconApp"):WaitForChild("ImageButton"):WaitForChild("EventContainer"):WaitForChild("EventFrame"):WaitForChild("EventImageBottom"):WaitForChild("EventTime")

-- Create the ScreenGui for the currency display
local currencyUI = Instance.new("ScreenGui")
currencyUI.Name = "CurrencyUI"
currencyUI.Parent = playerGui

-- Create the Frame for the currency display
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.15, 0)
frame.Position = UDim2.new(0.5, -0.15, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = currencyUI

-- Add rounded corners to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2, 0)
corner.Parent = frame

-- Create TextLabel for the currency amount
local amountDisplay = Instance.new("TextLabel", frame)
amountDisplay.Size = UDim2.new(0.55, 0, 0.7, 0)
amountDisplay.Position = UDim2.new(0.35, 0, 0.25, 0)
amountDisplay.BackgroundTransparency = 1
amountDisplay.TextColor3 = Color3.new(0, 0, 0)
amountDisplay.TextScaled = true
amountDisplay.Font = Enum.Font.SourceSansBold
amountDisplay.TextStrokeTransparency = 0.5
amountDisplay.Text = originalAmountLabel.Text

-- Function to update the amount
local function updateCurrencyAmount()
    amountDisplay.Text = originalAmountLabel.Text
end

originalAmountLabel.Changed:Connect(updateCurrencyAmount)
updateCurrencyAmount()

-- Timer variables
local durationInDays = 11  -- Set to 11 days
local durationInSeconds = durationInDays * 24 * 60 * 60  -- Convert to seconds
local timeRemaining = durationInSeconds

-- Create a label to display the timer
local timerLabel = Instance.new("TextLabel", frame) -- Keep it as a child of the frame
timerLabel.Size = UDim2.new(1, 0, 0.3, 0) -- Adjust height
timerLabel.Position = UDim2.new(0, 0, -0.4, 0) -- Move higher within the frame
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Set text color to white
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.TextStrokeTransparency = 0.5

-- Function to update the timer display
local function updateTimer()
    while timeRemaining > 0 do
        local days = math.ceil(timeRemaining / (24 * 60 * 60))
        timerLabel.Text = string.format("EVENT ENDS IN: %d DAYS", days)
        wait(1)
        timeRemaining = timeRemaining - 1
    end
    timerLabel.Text = "Time's Up!"
    player:Kick("You have been kicked from the Experience please head to play adopt me twitter and discord for any updates on when Halloween will return. 🎃🎃🎃🎃🎃🎃🎃 this script will be updated for Christmas so stay tuned for any updates. ☃️☃️☃️☃️☃️☃️☃️")
end

-- Start the timer
spawn(updateTimer)

-- Function to copy the game's timer UI
local function updateTimerFromGameUI()
    if originalTimerLabel then
        timerLabel.Text = originalTimerLabel.Text
    end
end

-- Connect to the original timer label's Changed event
if originalTimerLabel then
    originalTimerLabel.Changed:Connect(updateTimerFromGameUI)
end

-- Initial display
updateTimerFromGameUI()

-- Create TextLabel for the kick warning
local kickWarning = Instance.new("TextLabel", frame)
kickWarning.Size = UDim2.new(1, 0, 0.2, 0)
kickWarning.Position = UDim2.new(0, 0, 0.90, 0) -- Positioned below the timer
kickWarning.BackgroundTransparency = 0.5 -- Slightly transparent background
kickWarning.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red background
kickWarning.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
kickWarning.TextScaled = true
kickWarning.Font = Enum.Font.SourceSansBold
kickWarning.TextStrokeTransparency = 0.5
kickWarning.Text = "You will be kicked once the timer hits 0."

-- Create TextLabel for script owner
local ownerLabel = Instance.new("TextLabel", frame)
ownerLabel.Size = UDim2.new(1, 0, 0.2, 0)
ownerLabel.Position = UDim2.new(0, 0, 0.1, 0) -- Moved down further
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = true
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"

-- Create the candy corn image
local candyCorn = Instance.new("ImageLabel", frame)
candyCorn.Size = UDim2.new(0.35, 0, 0.9, 0)
candyCorn.Position = UDim2.new(0.02, 0, 0.05, 0) -- Adjust position as needed
candyCorn.BackgroundTransparency = 1
candyCorn.Image = "rbxassetid://5865214349"
candyCorn.ScaleType = Enum.ScaleType.Fit

-- Create the close button (X)
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
