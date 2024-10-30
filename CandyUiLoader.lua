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
amountDisplay.TextSize = 80
amountDisplay.Text = originalAmountLabel.Text

-- Create TextLabel for notifications
local notificationLabel = Instance.new("TextLabel", frame)
notificationLabel.Size = UDim2.new(1, 0, 0.2, 0)
notificationLabel.Position = UDim2.new(0, 0, 0.75, 0)
notificationLabel.BackgroundTransparency = 1
notificationLabel.TextColor3 = Color3.new(0, 1, 0)  -- Green color for notifications
notificationLabel.TextScaled = true
notificationLabel.Font = Enum.Font.SourceSansBold
notificationLabel.TextStrokeTransparency = 0.5
notificationLabel.Text = ""
notificationLabel.Visible = false  -- Initially hidden

-- Function to show notification
local function showNotification(amount)
    notificationLabel.Text = "+" .. tostring(amount)
    notificationLabel.Visible = true
    notificationLabel.TextTransparency = 0  -- Ensure it's fully visible

    -- Keep it visible for 1 second before fading
    wait(1)  -- Adjust visibility duration here

    -- Fade out the notification
    local tweenService = game:GetService("TweenService")
    tweenService:Create(notificationLabel, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()

    wait(0.5) -- Wait for fade out to complete
    notificationLabel.Visible = false  -- Hide it after fading out
end

-- Function to update the amount and show notification
local function updateCurrencyAmount()
    local previousAmount = tonumber(amountDisplay.Text) or 0
    local newAmount = tonumber(originalAmountLabel.Text) or 0
    
    -- Update the amount display
    amountDisplay.Text = originalAmountLabel.Text

    -- Check if there was an increase
    if newAmount > previousAmount then
        local amountEarned = newAmount - previousAmount
        showNotification(amountEarned)  -- Show notification for the amount earned
    end
end

originalAmountLabel.Changed:Connect(updateCurrencyAmount)
updateCurrencyAmount()

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

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    currencyUI:Destroy()  -- Close the UI
end)

-- Function to pop in the UI
local function popInUI()
    frame.Position = UDim2.new(0.5, -0.15, 0.1, 0)
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Visible = true

    local tweenService = game:GetService("TweenService")
    tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -0.15, 0.05, 0),
        Size = UDim2.new(0.3, 0, 0.15, 0)
    }):Play()
end

-- Call the pop-in function to show the UI with animation
popInUI()
