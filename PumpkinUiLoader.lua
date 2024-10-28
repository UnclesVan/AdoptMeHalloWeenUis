local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original UI
local originalUI = playerGui:WaitForChild("VendingMachineDisplayApp")
local originalAmountLabel = originalUI:WaitForChild("TopBar"):WaitForChild("CollectedFrame"):WaitForChild("Amount")

-- Create the ScreenGui
local currencyUI = Instance.new("ScreenGui")
currencyUI.Name = "CurrencyUI"
currencyUI.Parent = playerGui

-- Create the owner label above the frame
local ownerLabel = Instance.new("TextLabel", currencyUI)
ownerLabel.Size = UDim2.new(1, 0, 0.1, 0) -- Adjust height as needed
ownerLabel.Position = UDim2.new(0, 0, 0, 0) -- Position at the top
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = true
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"

-- Create the main frame for the currency display
local frame = Instance.new("Frame", currencyUI)
frame.Size = UDim2.new(0.3, 0, 0.1, 0)
frame.Position = UDim2.new(0.5, -0.15, 0.15, 0) -- Adjusted to fit below the owner label
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Add rounded corners to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = frame

-- Create TextLabel for amount
local amountDisplay = Instance.new("TextLabel", frame)
amountDisplay.Size = UDim2.new(0.7, 0, 1, 0)
amountDisplay.Position = UDim2.new(0.15, 0, 0, 0)
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
closeButtonContainer.Position = UDim2.new(0.85, 0, 0.25, 0) -- Center it vertically
closeButtonContainer.BackgroundColor3 = Color3.fromRGB(255, 200, 200) -- Light red for contrast
closeButtonContainer.BorderSizePixel = 0
closeButtonContainer.BackgroundTransparency = 0.2

-- Create the close button (X)
local closeButton = Instance.new("TextButton", closeButtonContainer)
closeButton.Size = UDim2.new(1, 0, 1, 0) -- Fill the closeButtonContainer
closeButton.BackgroundColor3 = Color3.fromRGB(255, 58, 58) -- Red background for the button
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White "X" text
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 36
closeButton.Text = "X"

-- Function to create the sinking effect
local function sinkCloseButton()
    local tweenService = game:GetService("TweenService")
    
    -- Sink the button container
    tweenService:Create(closeButtonContainer, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(0.85, 0, 0.35, 0), Size = UDim2.new(0.1, 0, 0.4, 0) }):Play()
    
    -- Reset effect after a short delay
    wait(0.1)
    tweenService:Create(closeButtonContainer, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(0.85, 0, 0.25, 0), Size = UDim2.new(0.1, 0, 0.5, 0) }):Play()
end

-- Connect close button click to sink effect and close functionality
closeButton.MouseButton1Click:Connect(function()
    sinkCloseButton() -- Call the sinking effect
    wait(0.2) -- Delay to show the effect
    currencyUI:Destroy() -- Close the UI
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
    frame.Position = UDim2.new(0.5, -0.15, 0.1, 0)
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Visible = true

    local tweenService = game:GetService("TweenService")
    local popTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -0.15, 0.15, 0),
        Size = UDim2.new(0.3, 0, 0.1, 0)
    })

    popTween:Play()
    popTween.Completed:Wait() -- Wait for the animation to complete
end

-- Call the pop-out function to show the UI with animation
popOutUI()

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
