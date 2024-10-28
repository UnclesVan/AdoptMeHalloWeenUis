local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original amount label in BucksIndicatorApp
local originalAmountLabel = playerGui:WaitForChild("BucksIndicatorApp"):WaitForChild("CurrencyIndicator"):WaitForChild("Container"):WaitForChild("Amount")

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

-- Create TextLabel for amount
local amountDisplay = Instance.new("TextLabel", frame)
amountDisplay.Size = UDim2.new(0.6, 0, 0.5, 0)
amountDisplay.Position = UDim2.new(0.3, 0, 0.25, 0)
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

-- Connect to the changed event to update the display when the amount changes
originalAmountLabel.Changed:Connect(updateCurrencyAmount)

-- Initialize the amount display
updateCurrencyAmount()

-- Create the close button (X)
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0.1, 0, 0.5, 0)
closeButton.Position = UDim2.new(0.9, 0, 0.25, 0)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.new(1, 0, 0)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"

-- Hover effect for close button
closeButton.MouseEnter:Connect(function()
    closeButton.TextColor3 = Color3.new(1, 0.5, 0.5) -- Change color on hover
end)

closeButton.MouseLeave:Connect(function()
    closeButton.TextColor3 = Color3.new(1, 0, 0) -- Original color
end)

-- Function to create the sinking effect
local function sinkCloseButton()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(closeButton, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(0.9, 0, 0.35, 0) }):Play()
    wait(0.1)
    tweenService:Create(closeButton, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(0.9, 0, 0.25, 0) }):Play()
end

-- Close button functionality with tween
closeButton.MouseButton1Click:Connect(function()
    sinkCloseButton()
    wait(0.2)  -- Wait before closing
    local tweenService = game:GetService("TweenService")
    local closeTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()
    closeTween.Completed:Wait()
    currencyUI:Destroy()  -- Close the UI
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

-- Hover effects for frame
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
