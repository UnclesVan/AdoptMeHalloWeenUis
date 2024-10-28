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
amountDisplay.Font = Enum.Font.SourceSansBold
amountDisplay.TextStrokeTransparency = 0.5
amountDisplay.TextSize = 80 -- Increased text size for amount display
amountDisplay.TextScaled = false -- Disable scaling

-- Initialize amount display text
amountDisplay.Text = originalAmountLabel.Text -- Initialize text
print("Amount display initialized:", amountDisplay.Text) -- Debugging line

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
closeButton.TextSize = 30 -- Normal text size for close button
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"

-- Function to update the amount
local function updateCurrencyAmount()
    amountDisplay.Text = originalAmountLabel.Text
    print("Updated amount display:", amountDisplay.Text) -- Debugging line
end

-- Connect to the changed event to update the display when the amount changes
originalAmountLabel.Changed:Connect(updateCurrencyAmount)

-- Initialize the amount display
updateCurrencyAmount()

-- Call the pop-out function to show the UI with animation
-- Function to pop out the UI
local function popOutUI()
    frame.Visible = true
    local tweenService = game:GetService("TweenService")
    local popTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.4, 0, 0.15, 0)
    })

    popTween:Play()
end

popOutUI()

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    currencyUI:Destroy()
end)

-- Debugging: Print to confirm UI creation
print("Currency UI created")
