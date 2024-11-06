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

-- Create a label to display the timer in your custom UI
local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Size = UDim2.new(1, 0, 0.3, 0) -- Adjust height
timerLabel.Position = UDim2.new(0, 0, -0.4, 0) -- Move higher within the frame
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Set text color to white
timerLabel.TextScaled = true  -- Scales the text to fit
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.TextStrokeTransparency = 0.5

-- Set TextWrapping to false to prevent text from wrapping
timerLabel.TextWrapped = false  -- Ensure the text does not wrap to a new line
timerLabel.TextTruncate = Enum.TextTruncate.AtEnd  -- Truncate the text at the end if it exceeds the label width

-- Set a larger TextSize to make the timer more prominent
timerLabel.TextSize = 36  -- Make the text size larger for visibility

-- Function to copy the game's timer text to your custom UI
local function updateTimerFromGameUI()
    if originalTimerLabel and originalTimerLabel.Text then
        -- Extract the remaining time and format it
        local remainingTimeText = originalTimerLabel.Text
        local daysRemaining = string.match(remainingTimeText, "%d+")
        if daysRemaining then
            -- Update the timer with a custom message that includes the number of days remaining
            timerLabel.Text = string.format("EVENT ENDS IN: %s DAYS", daysRemaining)
        else
            timerLabel.Text = "EVENT ENDS IN: -- DAYS"
        end
    end
end

-- Connect to the original timer label's Changed event to update your custom timer UI
if originalTimerLabel then
    originalTimerLabel.Changed:Connect(updateTimerFromGameUI)
end

-- Initial display update for the timer
updateTimerFromGameUI()

-- Add the owner label
local ownerLabel = Instance.new("TextLabel", frame)
ownerLabel.Size = UDim2.new(1, 0, 0.2, 0)
ownerLabel.Position = UDim2.new(0, 0, 0.1, 0) -- Positioned lower in the frame
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = true
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"

-- Add the candy corn image
local candyCorn = Instance.new("ImageLabel", frame)
candyCorn.Size = UDim2.new(0.35, 0, 0.9, 0)
candyCorn.Position = UDim2.new(0.02, 0, 0.05, 0) -- Adjust position as needed
candyCorn.BackgroundTransparency = 1
candyCorn.Image = "rbxassetid://5865214349"
candyCorn.ScaleType = Enum.ScaleType.Fit

-- Add the kick warning label
local kickWarning = Instance.new("TextLabel", frame)
kickWarning.Size = UDim2.new(1, 0, 0.2, 0)
kickWarning.Position = UDim2.new(0, 0, 0.85, 0) -- Positioned below the timer
kickWarning.BackgroundTransparency = 0.5 -- Slightly transparent background
kickWarning.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red background
kickWarning.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
kickWarning.TextScaled = true
kickWarning.Font = Enum.Font.SourceSansBold
kickWarning.TextStrokeTransparency = 0.5
kickWarning.Text = "You will be kicked once the timer hits 0."

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

-- Add the "Open UI" button (Beside Close Button, Right Side)
local openButtonContainer = Instance.new("Frame", frame)
openButtonContainer.Size = UDim2.new(0.1, 0, 0.5, 0)
openButtonContainer.Position = UDim2.new(1, -0.1, 0.25, 0)  -- Positioned immediately beside the close button on the right
openButtonContainer.BackgroundColor3 = Color3.fromRGB(200, 255, 200)
openButtonContainer.BorderSizePixel = 0
openButtonContainer.BackgroundTransparency = 0.2

local openButton = Instance.new("TextButton", openButtonContainer)
openButton.Size = UDim2.new(1, 0, 1, 0)
openButton.BackgroundColor3 = Color3.fromRGB(58, 255, 58)
openButton.TextColor3 = Color3.fromRGB(0, 0, 0)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 24
openButton.Text = "Open"

-- Hover effect for open button
openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
end)

openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(58, 255, 58)
end)

-- Open button functionality (opens the Fluent UI window)
openButton.MouseButton1Click:Connect(function()
    -- Load the Fluent UI library and create the window
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

    if Fluent then
        local Window = Fluent:CreateWindow({
            Title = "Fire Hub",  
            SubTitle = "Testing UI Functionality",
            TabWidth = 160,
            Size = UDim2.fromOffset(580, 460),
            Acrylic = false,
            Theme = "Dark",
        })

        -- Create the "Main" tab
        local Tabs = {}
        Tabs.Main = Window:AddTab({ Title = "Main", Icon = "" })
        Tabs.StampsFarm = Window:AddTab({ Title = "Stamps Farm", Icon = "" })
        
        -- Add a new tab for Christmas
        Tabs.Christmas = Window:AddTab({ Title = "Christmas: Coming Soon", Icon = "" })
        
        -- Add a new tab for Pet-Farm
        Tabs.PetFarm = Window:AddTab({ Title = "Pet-Farm: Coming Soon", Icon = "" })

        -- Toggleable farming logic for Stamps
        local farmingActive = false -- Variable to track farming state

        -- Add a new button to the "Stamps Farm" tab after it is created
        local stampsButton = Tabs.StampsFarm:AddButton({
            Title = "Collect Stamps", -- Title for the button
            Callback = function()
                if farmingActive then
                    -- Stop farming when clicked again
                    print("Stopping stamp collection.")
                    farmingActive = false
                else
                    -- Start farming when clicked
                    print("Starting stamp collection.")
                    farmingActive = true

                    -- Example farming action: simulate ongoing collection while farmingActive is true
                    while farmingActive do
                        -- Add logic for the farming process here, for example:
                        print("Collecting stamps...")
                        wait(1)  -- Simulate the time between stamp collections
                    end
                end
            end
        })

        -- Show the Fluent UI window
        Window.Visible = true
    else
        warn("Failed to load Fluent UI!")
    end
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
