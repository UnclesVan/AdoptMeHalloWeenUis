local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original UI
local originalUI = playerGui:WaitForChild("VendingMachineDisplayApp")
local originalAmountLabel = originalUI:WaitForChild("TopBar"):WaitForChild("CollectedFrame"):WaitForChild("Amount")

-- Create the ScreenGui
local currencyUI = Instance.new("ScreenGui")
currencyUI.Name = "CurrencyUI"
currencyUI.Parent = playerGui

-- Create the Frame for the currency display
local frame = Instance.new("Frame", currencyUI)
frame.Size = UDim2.new(0.4, 0, 0.15, 0)
frame.Position = UDim2.new(0.5, -0.2, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Add rounded corners to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = frame

-- Create TextLabel for script owner
local ownerLabel = Instance.new("TextLabel")
ownerLabel.Size = UDim2.new(1, 0, 0.3, 0)
ownerLabel.Position = UDim2.new(0, 0, 0, 0)
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = false
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"
ownerLabel.TextSize = 30 -- Normal text size
ownerLabel.Parent = frame

-- Create TextLabel for amount
local amountDisplay = Instance.new("TextLabel", frame)
amountDisplay.Size = UDim2.new(0.7, 0, 0.6, 0)
amountDisplay.Position = UDim2.new(0.15, 0, 0.4, 0)
amountDisplay.BackgroundTransparency = 1
amountDisplay.TextColor3 = Color3.new(0, 0, 0)
amountDisplay.TextScaled = false
amountDisplay.Font = Enum.Font.SourceSansBold
amountDisplay.TextStrokeTransparency = 0.5
amountDisplay.Text = originalAmountLabel.Text -- Initialize text
amountDisplay.TextSize = 110 -- Increased text size

-- Create the purple pumpkin image
local pumpkin = Instance.new("ImageLabel", frame)
pumpkin.Size = UDim2.new(0.25, 0, 1, 0)
pumpkin.Position = UDim2.new(0, 0, 0, 0)
pumpkin.BackgroundTransparency = 1
pumpkin.Image = "rbxassetid://125606063774512" -- Purple pumpkin image ID
pumpkin.ScaleType = Enum.ScaleType.Fit

-- Create the close button (X)
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0.1, 0, 1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.new(1, 0, 0)
closeButton.TextScaled = false
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextSize = 30 -- Normal text size

-- Function to pop out the UI
local function popOutUI()
    frame.Position = UDim2.new(0.5, -0.2, 0.1, 0)
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Visible = true

    local tweenService = game:GetService("TweenService")
    local popTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -0.2, 0.05, 0),
        Size = UDim2.new(0.4, 0, 0.15, 0)
    })

    popTween:Play()
    popTween.Completed:Wait() -- Wait for the animation to complete
end

-- Function to update the amount
local function updateCurrencyAmount()
    amountDisplay.Text = originalAmountLabel.Text
end

-- Connect to the changed event to update the display when the amount changes
originalAmountLabel.Changed:Connect(updateCurrencyAmount)

-- Initialize the amount display
updateCurrencyAmount()

-- Call the pop-out function to show the UI with animation
popOutUI()

-- Hover effects
frame.MouseEnter:Connect(function()
    local tweenService = game:GetService("TweenService")
    local hoverTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.42, 0, 0.17, 0) -- Slightly larger
    })
    hoverTween:Play()
end)

frame.MouseLeave:Connect(function()
    local tweenService = game:GetService("TweenService")
    local shrinkTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.4, 0, 0.15, 0) -- Return to normal size
    })
    shrinkTween:Play()
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local tweenService = game:GetService("TweenService")
    local closeTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()
    closeTween.Completed:Wait() -- Wait for the animation to complete

    -- Destroy the entire UI after the tween completes
    currencyUI:Destroy()
end)

-- Make the frame draggable
local dragging = false
local dragStart = nil
local startPos = nil

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

game:GetService("UserInputService").InputChanged:Connect(updateInput)

-- Debugging: Print to confirm UI creation
print("Currency UI created")
