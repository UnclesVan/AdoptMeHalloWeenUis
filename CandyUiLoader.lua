-- Variables for player and UI references
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference to the original amount label
local originalAmountLabel = playerGui:WaitForChild("AltCurrencyIndicatorApp"):WaitForChild("CurrencyIndicator"):WaitForChild("Container"):WaitForChild("Amount")

-- Reference to the original timer label
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
timerLabel.TextScaled = false  -- Scales the text to fit
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.TextStrokeTransparency = 0.5
timerLabel.TextWrapped = false  -- Ensure the text does not wrap to a new line
timerLabel.TextTruncate = Enum.TextTruncate.AtEnd  -- Truncate the text at the end if it exceeds the label width
timerLabel.TextSize = 37  -- Make the text size larger for visibility

-- Function to check if the timer has reached zero and kick the player
local function checkTimerAndKick()
    if originalTimerLabel and originalTimerLabel.Text then
        local daysRemaining = tonumber(string.match(originalTimerLabel.Text, "%d+"))
        if daysRemaining and daysRemaining <= 0 then
            player:Kick("You were kicked from this Experience. The event has ended. Please check for updates.")
        end
    end
end

-- Function to update the timer label
local function updateTimerFromGameUI()
    if originalTimerLabel and originalTimerLabel.Text then
        -- Extract the remaining time components
        local remainingTimeText = originalTimerLabel.Text
        local daysRemaining = string.match(remainingTimeText, "(%d+)%s+DAYS") or "0" -- Default to "0" if nil
        local hoursRemaining = string.match(remainingTimeText, "(%d+)%s+HOURS") or "0"
        local secondsRemaining = string.match(remainingTimeText, "(%d+)%s+SECONDS") or "0"

        -- Update the timer label based on available values
        local timerComponents = {}

        if hoursRemaining ~= "0" then
            table.insert(timerComponents, string.format("%s HOURS", hoursRemaining))
        end

        if daysRemaining ~= "0" then
            table.insert(timerComponents, string.format("%s DAYS", daysRemaining))
        end

        if secondsRemaining ~= "0" then
            table.insert(timerComponents, string.format("%s SECONDS", secondsRemaining))
        end

        local timerText = "EVENT ENDS IN:"
        if #timerComponents > 0 then
            timerText = timerText .. " " .. table.concat(timerComponents, " ")
        else
            timerText = timerText .. " TIME NOT AVAILABLE"
        end

        timerLabel.Text = timerText

        -- Check if the timer has run out
        checkTimerAndKick()
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
kickWarning.Text = "You will be kicked from this Experience once the timer hits 0."

-- Create new TextLabels for time until Christmas and the current date
local timeUntilChristmasLabel = Instance.new("TextLabel", frame)
timeUntilChristmasLabel.Size = UDim2.new(1, 0, 0.2, 0) -- Clarity
timeUntilChristmasLabel.Position = UDim2.new(0, 0, 1.05, 0) -- Adjusted position lower
timeUntilChristmasLabel.BackgroundTransparency = 1 -- Fully transparent
timeUntilChristmasLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeUntilChristmasLabel.TextScaled = true
timeUntilChristmasLabel.Font = Enum.Font.SourceSansBold
timeUntilChristmasLabel.TextStrokeTransparency = 0.5
timeUntilChristmasLabel.Text = "TIME UNTIL CHRISTMAS: 00 DAYS 00 HOURS 00 MINUTES 00 SECONDS"

local currentDateLabel = Instance.new("TextLabel", frame)
currentDateLabel.Size = UDim2.new(1, 0, 0.2, 0)
currentDateLabel.Position = UDim2.new(0, 0, 1.25, 0) -- Adjusted position lower
currentDateLabel.BackgroundTransparency = 1 -- Making background fully transparent
currentDateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
currentDateLabel.TextScaled = true
currentDateLabel.Font = Enum.Font.SourceSansBold
currentDateLabel.TextStrokeTransparency = 0.5
currentDateLabel.Text = "Current Date: YYYY-MM-DD"

-- Function to update the countdown label and date label
local function updateChristmasCountdown()
    local currentTime = os.time()
    local christmasTime = os.time({year = 2024, month = 12, day = 25, hour = 0, min = 0, sec = 0})

    -- Get the current date and format it
    local currentDate = os.date("%B %d, %Y", currentTime)
    currentDateLabel.Text = "Current Date: " .. currentDate

    -- Check if the current date is before Christmas
    if currentTime < christmasTime then
        local timeLeft = christmasTime - currentTime
        local days = math.floor(timeLeft / 86400)
        local hours = math.floor((timeLeft % 86400) / 3600)
        local minutes = math.floor((timeLeft % 3600) / 60)
        local seconds = timeLeft % 60

        timeUntilChristmasLabel.Text = string.format("TIME UNTIL CHRISTMAS: %02d DAYS %02d HOURS %02d MINUTES %02d SECONDS", days, hours, minutes, seconds)
    else
        -- Hide the labels if the Christmas countdown is finished
        timeUntilChristmasLabel.Visible = false
        currentDateLabel.Visible = false
    end
end

-- Update the countdown and date every second in a coroutine
coroutine.wrap(function()
    while true do
        updateChristmasCountdown()
        wait(1)
    end
end)()

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

-- Add the "Open" button beside the Close Button
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
    
    -- Load Fluent UI
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

        -- Add a button to the "Stamps Farm" tab
        local stampsButton = Tabs.StampsFarm:AddButton({
            Title = "Collect Stamps",
            Callback = function()
                if farmingActive then
                    -- Stop farming
                    print("Stopping stamp collection.")
                    farmingActive = false
                else
                    -- Start farming
                    print("Starting stamp collection.")
                    farmingActive = true

                    -- Example farming action: simulate ongoing collection while farmingActive is true
                    while farmingActive do
                        -- Add logic for the farming process here
                        print("Collecting stamps...")
                        
                        -- Trigger the server event to claim stamps
                        local api = game:GetService("ReplicatedStorage"):WaitForChild("API")
                        local claimStamp = api:FindFirstChild("DdlmAPI/ClaimStamp")
                        if claimStamp then
                            claimStamp:FireServer()  -- Fire the claim server event
                        end

                        wait(1)  -- Simulate the time between stamp collections
                    end
                end
            end
        })

        -- Create a TextLabel for the countdown timer in the Christmas tab
        local countdownLabel = Instance.new("TextLabel")
        countdownLabel.Size = UDim2.new(1, 0, 0.3, 0) -- Full width and height of 30% of the tab area
        countdownLabel.Position = UDim2.new(0, 0, 0.1, 0) -- Positioned within the Christmas tab
        countdownLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark background color inspired by Fluent UI
        countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Light text color for visibility
        countdownLabel.TextScaled = true  -- Scale the text to fit
        countdownLabel.Text = "Initializing..."  -- Initial text
        countdownLabel.Parent = Tabs.Christmas.Container  -- Parent it to the Christmas tab's container

        -- Create another TextLabel for the current date and year
        local dateLabel = Instance.new("TextLabel")
        dateLabel.Size = UDim2.new(1, 0, 0.3, 0) -- Full width and height of 30% of the tab area
        dateLabel.Position = UDim2.new(0, 0, 0.5, 0) -- Positioned below the countdown label
        dateLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark background color inspired by Fluent UI
        dateLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Light text color for visibility
        dateLabel.TextScaled = true  -- Scale the text to fit
        dateLabel.Text = "Current Date: Initializing..."  -- Initial text
        dateLabel.Parent = Tabs.Christmas.Container  -- Parent it to the Christmas tab's container

        -- Function to update the countdown label and date label
        local function updateChristmasCountdown()
            local currentTime = os.time()
            local christmasTime = os.time({year = 2024, month = 12, day = 25, hour = 0, min = 0, sec = 0})

            -- Get the current date and format it
            local currentDate = os.date("%B %d, %Y", currentTime)
            dateLabel.Text = "Current Date: " .. currentDate

            -- Check if the current date is before Christmas
            if currentTime < christmasTime then
                local timeLeft = christmasTime - currentTime
                local days = math.floor(timeLeft / 86400)
                local hours = math.floor((timeLeft % 86400) / 3600)
                local minutes = math.floor((timeLeft % 3600) / 60)
                local seconds = timeLeft % 60

                countdownLabel.Text = string.format("TIME UNTIL CHRISTMAS: %02d DAYS %02d HOURS %02d MINUTES %02d SECONDS", days, hours, minutes, seconds)
            elseif currentTime >= christmasTime then
                -- Hide the labels
                countdownLabel.Visible = false
                dateLabel.Visible = false

                -- Create the Collect Gingerbread button if it doesn't exist
                if not collectGingerbreadButton then
                    collectGingerbreadButton = Tabs.Christmas:AddButton({
                        Title = "Collect Gingerbread",
                        Callback = function()
                            print("Collecting Gingerbread!")
                            -- Add the logic to collect gingerbread here
                        end
                    })
                end
            end
        end

        -- Update the countdown and date every second in a coroutine
        coroutine.wrap(function()
            while true do
                updateChristmasCountdown()
                wait(1)
            end
        end)()

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
