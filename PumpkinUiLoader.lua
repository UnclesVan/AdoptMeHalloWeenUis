local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original UI
local originalUI = playerGui:WaitForChild("VendingMachineDisplayApp")
local originalAmountLabel = originalUI:WaitForChild("TopBar"):WaitForChild("CollectedFrame"):WaitForChild("Amount")

-- Create the ScreenGui
local currencyUI = Instance.new("ScreenGui")
currencyUI.Name = "CurrencyUI"
currencyUI.Parent = playerGui

-- Create the main frame for the currency display
local frame = Instance.new("Frame", currencyUI)
frame.Size = UDim2.new(0.3, 0, 0.1, 0)
frame.Position = UDim2.new(0.5, -0.15, 0.5, -0.1)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Add rounded corners to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = frame

-- Create TextLabel for amount
local amountDisplay = Instance.new("TextLabel", frame)
amountDisplay.Size = UDim2.new(0.7, 0, 0.5, 0)
amountDisplay.Position = UDim2.new(0.15, 0, 0.3, 0)
amountDisplay.BackgroundTransparency = 1
amountDisplay.TextColor3 = Color3.new(0, 0, 0)
amountDisplay.Font = Enum.Font.SourceSansBold
amountDisplay.TextStrokeTransparency = 0.5
amountDisplay.TextSize = 70
amountDisplay.TextScaled = false
amountDisplay.Text = originalAmountLabel.Text

-- Create the pumpkin image
local pumpkin = Instance.new("ImageLabel", frame)
pumpkin.Size = UDim2.new(0.2, 0, 1, 0)
pumpkin.Position = UDim2.new(0, 0, 0, 0)
pumpkin.BackgroundTransparency = 1
pumpkin.Image = "rbxassetid://125606063774512"
pumpkin.ScaleType = Enum.ScaleType.Fit

-- Create a frame behind the close button for the sink effect
local closeButtonContainer = Instance.new("Frame", frame)
closeButtonContainer.Size = UDim2.new(0.1, 0, 0.5, 0)
closeButtonContainer.Position = UDim2.new(0.85, 0, 0.25, 0)
closeButtonContainer.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
closeButtonContainer.BorderSizePixel = 0
closeButtonContainer.BackgroundTransparency = 0.2

-- Create the close button (X)
local closeButton = Instance.new("TextButton", closeButtonContainer)
closeButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 58, 58)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 36
closeButton.Text = "X"

-- Hover effect for close button
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)  -- Darker red on hover
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 58, 58)  -- Original color
end)

-- Hover effect for main frame with scale animation and shadow effect
local originalSize = frame.Size

frame.MouseEnter:Connect(function()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0.31, 0, 0.11, 0)}):Play()
    frame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)  -- Lighten background
end)

frame.MouseLeave:Connect(function()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Reset background color
end)

-- Function to create the sinking effect
local function sinkCloseButton()
    local tweenService = game:GetService("TweenService")
    
    -- Sink the button container
    tweenService:Create(closeButtonContainer, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(0.85, 0, 0.35, 0), Size = UDim2.new(0.1, 0, 0.4, 0) }):Play()
    
    -- Reset effect after a short delay
    wait(0.1)
    tweenService:Create(closeButtonContainer, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(0.85, 0, 0.25, 0), Size = UDim2.new(0.1, 0, 0.5, 0) }):Play()
end

-- Connect close button click to sink effect and closing
closeButton.MouseButton1Click:Connect(function()
    sinkCloseButton()
    wait(0.2)  -- Wait before closing
    local tweenService = game:GetService("TweenService")
    local closeTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -0.15, 0.5, -0.1)
    })
    closeTween:Play()
    closeTween.Completed:Wait()  -- Wait for the animation to complete
    currencyUI:Destroy()  -- Close the UI
end)

-- Function to update the amount
local function updateCurrencyAmount()
    amountDisplay.Text = originalAmountLabel.Text
end

-- Connect to the changed event to update the display when the amount changes
originalAmountLabel.Changed:Connect(updateCurrencyAmount)

-- Initialize the amount display
updateCurrencyAmount()

-- Call the pop-out function to show the UI with animation
local function popOutUI()
    frame.Position = UDim2.new(0.5, -0.15, 0.5, -0.1)
    frame.Size = UDim2.new(0.3, 0, 0.1, 0)
    frame.Visible = true

    local tweenService = game:GetService("TweenService")
    local popTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -0.15, 0.5, -0.1),
        Size = UDim2.new(0.3, 0, 0.1, 0)
    })

    popTween:Play()
    popTween.Completed:Wait() -- Wait for the animation to complete
end

-- Call the pop-out function to show the UI with animation
popOutUI()

-- Create TextLabel for script owner above the amount display
local ownerLabel = Instance.new("TextLabel", frame)
ownerLabel.Size = UDim2.new(1, 0, 0.3, 0)
ownerLabel.Position = UDim2.new(0, 0, 0, 0)  -- Positioned above the amount
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = true
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"

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
