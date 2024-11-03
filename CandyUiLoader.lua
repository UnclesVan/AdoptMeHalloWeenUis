local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original amount label
local originalAmountLabel = playerGui:WaitForChild("AltCurrencyIndicatorApp"):WaitForChild("CurrencyIndicator"):WaitForChild("Container"):WaitForChild("Amount")

-- Create the ScreenGui
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

-- Create TextLabel for script owner
local ownerLabel = Instance.new("TextLabel")
ownerLabel.Size = UDim2.new(1, 0, 0.3, 0)
ownerLabel.Position = UDim2.new(0, 0, 0, 0)
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = true
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"
ownerLabel.Parent = frame

-- Create the candy corn image
local candyCorn = Instance.new("ImageLabel", frame)
candyCorn.Size = UDim2.new(0.35, 0, 0.9, 0)
candyCorn.Position = UDim2.new(0.02, 0, 0.05, 0)
candyCorn.BackgroundTransparency = 1
candyCorn.Image = "rbxassetid://5865214349"
candyCorn.ScaleType = Enum.ScaleType.Fit

-- Create TextLabel for amount
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
local durationInDays = 13  -- Set to 13 days
local durationInSeconds = durationInDays * 24 * 60 * 60  -- 13 days in seconds
local timeRemaining = durationInSeconds
local timerExpired = false  -- Variable to track if the timer has expired

-- Create a label to display the timer
local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Size = UDim2.new(1, 0, 0.2, 0)
timerLabel.Position = UDim2.new(0.009, 0, -0.258, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Set text color to white
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.TextStrokeTransparency = 0.5

-- Create TextLabel for the kick warning
local kickWarning = Instance.new("TextLabel", frame)
kickWarning.Size = UDim2.new(1, 0, 0.2, 0)
kickWarning.Position = UDim2.new(0, 0, 0.85, 0) -- Adjusted further down
kickWarning.BackgroundTransparency = 0.5 -- Slightly transparent background
kickWarning.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red background
kickWarning.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
kickWarning.TextScaled = true
kickWarning.Font = Enum.Font.SourceSansBold
kickWarning.TextStrokeTransparency = 0.5
kickWarning.Text = "TIMER IS BROKEN FIXING IT"

-- Function to update the timer
local function updateTimer()
    while timeRemaining > 0 do
        local days = math.ceil(timeRemaining / (24 * 60 * 60))
        timerLabel.Text = string.format("TIMER IS BROKEN FIXING IT", days)
        wait(1)
        timeRemaining = timeRemaining - 1
    end

    -- When the timer ends
    timerLabel.Text = "Time's Up!"
    timerExpired = true  -- Set the timer as expired
    player:Kick("Your time is up! Please check Play Adopt me Twitter and their discord for updates on when Halloween will return. 🎃🎃🎃🎃🎃🎃🎃")
end

-- Check if the timer has already expired before starting
if not timerExpired then
    -- Start the timer in a separate thread
    spawn(updateTimer)

    -- Optional: Initial display for the timer
    timerLabel.Text = string.format("EVENT ENDS IN: %d DAYS", math.ceil(timeRemaining / (24 * 60 * 60)))
else
    -- Timer has already expired; you might want to handle this case
    timerLabel.Text = "Timer already expired."
end

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

-- Function to create the sinking effect
local function sinkCloseButton()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(closeButtonContainer, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.9, 0, 0.35, 0),
        Size = UDim2.new(0.1, 0, 0.4, 0)
    }):Play()

    wait(0.1)
    tweenService:Create(closeButtonContainer, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.9, 0, 0.25, 0),
        Size = UDim2.new(0.1, 0, 0.5, 0)
    }):Play()
end

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    sinkCloseButton()
    wait(0.2)
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
