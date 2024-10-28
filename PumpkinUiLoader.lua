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
frame.Size = UDim2.new(0.4, 0, 0.2, 0)
frame.Position = UDim2.new(0.5, -0.2, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Create TextLabel for script owner
local ownerLabel = Instance.new("TextLabel", frame)
ownerLabel.Size = UDim2.new(1, 0, 0.3, 0)
ownerLabel.Position = UDim2.new(0, 0, 0, 0)
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextSize = 30 -- Normal size for owner label
ownerLabel.Text = "Private Script Owner: made by me"

-- Create TextLabel for amount
local amountDisplay = Instance.new("TextLabel", frame)
amountDisplay.Size = UDim2.new(1, 0, 0.6, 0) -- Full width, height for the amount display
amountDisplay.Position = UDim2.new(0, 0, 0.3, 0) -- Position below the owner label
amountDisplay.BackgroundTransparency = 1
amountDisplay.TextColor3 = Color3.new(0, 0, 0)
amountDisplay.Font = Enum.Font.SourceSansBold
amountDisplay.TextSize = 80 -- Increased size for amount display
amountDisplay.Text = originalAmountLabel.Text -- Initialize with original amount

-- Function to update the amount
local function updateCurrencyAmount()
    amountDisplay.Text = originalAmountLabel.Text
end

-- Connect to the changed event to update the display when the amount changes
originalAmountLabel.Changed:Connect(updateCurrencyAmount)

-- Initialize the amount display
updateCurrencyAmount()

-- Debugging: Confirm the UI creation
print("Currency UI created with amount:", amountDisplay.Text)
