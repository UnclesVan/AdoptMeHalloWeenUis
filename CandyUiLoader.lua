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

-- Create a TextLabel for the currency amount
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

-- Create a label to display the timer
local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Size = UDim2.new(1, 0, 0.3, 0)  -- Full width for a straight line
timerLabel.Position = UDim2.new(0, 0, -0.3, 0)  -- Moved this higher
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextScaled = true  -- Scale text to fit
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.TextStrokeTransparency = 0.5
timerLabel.TextTruncate = Enum.TextTruncate.AtEnd
timerLabel.TextSize = 24  -- Set a reasonable text size

-- Create an event over label
local eventOverLabel = Instance.new("TextLabel", frame)
eventOverLabel.Size = UDim2.new(1, 0, 0.2, 0)
eventOverLabel.Position = UDim2.new(0, 0, 0.75, 0) 
eventOverLabel.BackgroundTransparency = 1
eventOverLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
eventOverLabel.TextScaled = true
eventOverLabel.Font = Enum.Font.SourceSansBold
eventOverLabel.TextStrokeTransparency = 0.5
eventOverLabel.Text = ""
eventOverLabel.Visible = false  -- Hidden by default

-- Function to check if the timer has reached zero and kick the player
local function checkTimerAndKick()
    if originalTimerLabel and originalTimerLabel.Text then
        local daysRemaining = tonumber(string.match(originalTimerLabel.Text, "%d+")) or 0
        if daysRemaining <= 0 then
            player:Kick("You were kicked from this Experience. The event has ended. Please check for updates.")
            eventOverLabel.Text = "EVENT IS OVER"  -- Update the event over label
            eventOverLabel.Visible = true  -- Show the label
        end
    end
end

-- Function to update the timer label
local function updateTimerFromGameUI()
    if originalTimerLabel and originalTimerLabel.Text then
        local remainingTimeText = originalTimerLabel.Text
        local daysRemaining = string.match(remainingTimeText, "(%d+)%s+DAYS") or "0"
        local hoursRemaining = string.match(remainingTimeText, "(%d+)%s+HOURS") or "0"
        local secondsRemaining = string.match(remainingTimeText, "(%d+)%s+SECONDS") or "0"

        local timerComponents = {}

        -- Format the components
        if daysRemaining ~= "0" then
            table.insert(timerComponents, string.format("%s DAYS", daysRemaining))
        end
        if hoursRemaining ~= "0" then
            table.insert(timerComponents, string.format("%s HOURS", hoursRemaining))
        end
        if secondsRemaining ~= "0" then
            table.insert(timerComponents, string.format("%s SECONDS", secondsRemaining))
        end

        local timerText = "EVENT STARTS IN:"  -- Update to new text
        if #timerComponents > 0 then
            timerText = timerText .. " " .. table.concat(timerComponents, " ")
        else
            timerText = timerText .. " TIME NOT AVAILABLE"
        end

        timerLabel.Text = timerText
        checkTimerAndKick()
    end
end

-- Connect to the original timer label's Changed event
if originalTimerLabel then
    originalTimerLabel.Changed:Connect(updateTimerFromGameUI)
end

-- Initial display update for the timer
updateTimerFromGameUI()

-- Add the owner label
local ownerLabel = Instance.new("TextLabel", frame)
ownerLabel.Size = UDim2.new(1, 0, 0.2, 0)
ownerLabel.Position = UDim2.new(0, 0, 0.1, 0)
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = true
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"

-- Add the kick warning label
local kickWarning = Instance.new("TextLabel", frame)
kickWarning.Size = UDim2.new(1, 0, 0.2, 0)
kickWarning.Position = UDim2.new(0, 0, 0.85, 0)
kickWarning.BackgroundTransparency = 0.5
kickWarning.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
kickWarning.TextColor3 = Color3.fromRGB(255, 255, 255)
kickWarning.TextScaled = true
kickWarning.Font = Enum.Font.SourceSansBold
kickWarning.TextStrokeTransparency = 0.5
kickWarning.Text = "You will be kicked from this Experience once the timer hits 0."

-- Create new TextLabels for time until Christmas and the current date
local timeUntilChristmasLabel = Instance.new("TextLabel", frame)
timeUntilChristmasLabel.Size = UDim2.new(1, 0, 0.2, 0)
timeUntilChristmasLabel.Position = UDim2.new(0, 0, 1.05, 0)
timeUntilChristmasLabel.BackgroundTransparency = 1
timeUntilChristmasLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeUntilChristmasLabel.TextScaled = true
timeUntilChristmasLabel.Font = Enum.Font.SourceSansBold
timeUntilChristmasLabel.TextStrokeTransparency = 0.5
timeUntilChristmasLabel.Text = "TIME UNTIL CHRISTMAS: 00 DAYS 00 HOURS 00 MINUTES 00 SECONDS"

local currentDateLabel = Instance.new("TextLabel", frame)
currentDateLabel.Size = UDim2.new(1, 0, 0.2, 0)
currentDateLabel.Position = UDim2.new(0, 0, 1.25, 0)
currentDateLabel.BackgroundTransparency = 1
currentDateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
currentDateLabel.TextScaled = true
currentDateLabel.Font = Enum.Font.SourceSansBold
currentDateLabel.TextStrokeTransparency = 0.5
currentDateLabel.Text = "Current Date: YYYY-MM-DD"

-- Function to get current Australian time considering DST
local function getCurrentAustralianTime()
    local utcOffset = 10 * 3600 -- Default to UTC+10 (AEST)
    
    -- Check if it's currently Daylight Saving Time (DST)
    local month = os.date("*t").month
    if month >= 10 or month <= 4 then
        utcOffset = 10 * 3600 -- AEST
    else
        utcOffset = 11 * 3600 -- AEDT
    end

    return os.time() + utcOffset
end

-- Function to update the countdown label and date label
local function updateChristmasCountdown()
    local currentTime = getCurrentAustralianTime()
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
openButtonContainer.Position = UDim2.new(1, -0.1, 0.25, 0)
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
                    print("Stopping stamp collection.")
                    farmingActive = false
                else
                    print("Starting stamp collection.")
                    farmingActive = true

                    while farmingActive do
                        print("Collecting stamps...")
                        local api = game:GetService("ReplicatedStorage"):WaitForChild("API")
                        local claimStamp = api:FindFirstChild("DdlmAPI/ClaimStamp")
                        if claimStamp then
                            claimStamp:FireServer()
                        end
                        wait(1)
                    end
                end
            end
        })

        -- Create a TextLabel for the countdown timer in the Christmas tab
        local countdownLabel = Instance.new("TextLabel", Tabs.Christmas.Container)
        countdownLabel.Size = UDim2.new(1, 0, 0.3, 0)
        countdownLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        countdownLabel.TextScaled = true
        countdownLabel.Text = "Initializing..."

        -- Create another TextLabel for the current date and year
        local dateLabel = Instance.new("TextLabel", Tabs.Christmas.Container)
        dateLabel.Size = UDim2.new(1, 0, 0.3, 0)
        dateLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        dateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        dateLabel.TextScaled = true
        dateLabel.Text = "Current Date: Initializing..."

        -- Function to update the countdown label and date label
        local function updateChristmasCountdown()
            local currentTime = getCurrentAustralianTime()
            local christmasTime = os.time({year = 2024, month = 12, day = 25, hour = 0, min = 0, sec = 0})

            local currentDate = os.date("%B %d, %Y", currentTime)
            dateLabel.Text = "Current Date: " .. currentDate

            if currentTime < christmasTime then
                local timeLeft = christmasTime - currentTime
                local days = math.floor(timeLeft / 86400)
                local hours = math.floor((timeLeft % 86400) / 3600)
                local minutes = math.floor((timeLeft % 3600) / 60)
                local seconds = timeLeft % 60

                countdownLabel.Text = string.format("TIME UNTIL CHRISTMAS: %02d DAYS %02d HOURS %02d MINUTES %02d SECONDS", days, hours, minutes, seconds)
            else
                countdownLabel.Visible = false
                dateLabel.Visible = false
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

-- Add the candy corn image
local candyCorn = Instance.new("ImageLabel", frame)
candyCorn.Size = UDim2.new(0.35, 0, 0.9, 0)
candyCorn.Position = UDim2.new(0.02, 0, 0.05, 0)
candyCorn.BackgroundTransparency = 1
candyCorn.Image = "rbxassetid://"  -- Candy corn image ID
candyCorn.ScaleType = Enum.ScaleType.Fit

-- Create the "READY FOR CHRISTMAS" message on top of the candy corn image
local readyForChristmasLabel = Instance.new("TextLabel", frame)
readyForChristmasLabel.Size = UDim2.new(0.35, 0, 0.3, 0)  -- Adjust size as necessary
readyForChristmasLabel.Position = UDim2.new(0.02, 0, 0.35, 0)  -- Centered over the image
readyForChristmasLabel.BackgroundTransparency = 1
readyForChristmasLabel.TextColor3 = Color3.fromRGB(132, 182, 141)  -- White text
readyForChristmasLabel.TextScaled = true
readyForChristmasLabel.Font = Enum.Font.SourceSansBold
readyForChristmasLabel.TextStrokeTransparency = 0.5
readyForChristmasLabel.Text = "READY FOR CHRISTMAS"


print'5'
print'4'
print'3'
print'2'
print'1'
print"0, Ailments Monitor - Task Handler v1.0 has loaded."

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IDDisplay"
screenGui.Parent = LocalPlayer.PlayerGui

-- Create a Frame to display the IDs
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Create a Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "Ailments Monitor - Task Handler v1.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Create a Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 60, 0, 30)
closeButton.Position = UDim2.new(0.5, -30, 0.85, 0) -- Adjusted Y position to be lower
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "Close"
closeButton.Parent = mainFrame

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Create a Scrolling Frame for ID List
local idListFrame = Instance.new("ScrollingFrame")
idListFrame.Size = UDim2.new(0.7, 0, 0.8, -40)
idListFrame.Position = UDim2.new(0, 0, 0.2, 0)
idListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
idListFrame.BackgroundTransparency = 0.5
idListFrame.ScrollBarThickness = 10
idListFrame.Parent = mainFrame

-- List layout for the ID list
local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = idListFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.Parent = idListFrame

local displayedIds = {}

-- Create a console frame
local consoleFrame = Instance.new("Frame")
consoleFrame.Size = UDim2.new(0.3, 0, 0.8, -40) -- Increased width, height = 0.8
consoleFrame.Position = UDim2.new(0.7, 0, 0.2, 0) -- Keep original position
consoleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
consoleFrame.BackgroundTransparency = 0.1
consoleFrame.Parent = mainFrame

-- Create Title above the console: "Game Error Handler"
local consoleTitleLabel = Instance.new("TextLabel")
consoleTitleLabel.Size = UDim2.new(1, 0, 0.05, 0)
consoleTitleLabel.Position = UDim2.new(0, 0, 0, 0)
consoleTitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
consoleTitleLabel.Text = "Game Error Handler"
consoleTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
consoleTitleLabel.TextSize = 12
consoleTitleLabel.Font = Enum.Font.GothamBold
consoleTitleLabel.Parent = consoleFrame

-- Create a Scrolling Frame for console messages
local consoleScrollFrame = Instance.new("ScrollingFrame")
consoleScrollFrame.Size = UDim2.new(1, 0, 0.85, 0) -- Height adjusted with increased size
consoleScrollFrame.Position = UDim2.new(0, 0, 0.05, 0)
consoleScrollFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
consoleScrollFrame.BackgroundTransparency = 0.5
consoleScrollFrame.ScrollBarThickness = 10
consoleScrollFrame.Parent = consoleFrame

-- Create a UIListLayout for the console
local consoleListLayout = Instance.new("UIListLayout")
consoleListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
consoleListLayout.Padding = UDim.new(0, 5)
consoleListLayout.Parent = consoleScrollFrame

-- Create "Copy Text" button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.15, 0, 0.07, 0) -- Button size
copyButton.Position = UDim2.new(0.7, 0, 0.9, 0) -- Position for the Copy button
copyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Text = "Copy Text"
copyButton.TextSize = 20 -- Increased text size
copyButton.Parent = mainFrame

-- Create "Clear Text" button with a gap and ensure it remains in the frame
local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.15, 0, 0.07, 0) -- Button size
clearButton.Position = UDim2.new(0.86, 0, 0.9, 0) -- Adjusted position for a gap
clearButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.Text = "Clear Text"
clearButton.TextSize = 20 -- Increased text size
clearButton.Parent = mainFrame

-- Function to log messages to the console
local function logToConsole(message)
    local logEntry = Instance.new("TextLabel")
    logEntry.Size = UDim2.new(1, 0, 0, 20)
    logEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    logEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
    logEntry.Text = message
    logEntry.TextSize = 14
    logEntry.Font = Enum.Font.SourceSans
    logEntry.TextWrapped = true
    logEntry.Parent = consoleScrollFrame

    -- Adjust canvas size for the console
    consoleScrollFrame.CanvasSize = UDim2.new(0, 0, 0, consoleScrollFrame.UIListLayout.AbsoluteContentSize.Y)
    consoleScrollFrame.CanvasPosition = Vector2.new(0, consoleScrollFrame.CanvasSize.Y.Offset)
end

-- Function to copy all console text
local function copyConsoleText()
    local combinedText = ""
    for _, child in ipairs(consoleScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") and child.Text ~= "" then
            combinedText = combinedText .. child.Text .. "\n"
        end
    end

    setclipboard(combinedText) -- Copy to clipboard
    logToConsole("Copied console text to clipboard.")
end

-- Function to clear the console text
local function clearConsole()
    for _, child in ipairs(consoleScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    consoleScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    logToConsole("Cleared console text.")
end

-- Connect button functions
copyButton.MouseButton1Click:Connect(copyConsoleText)
clearButton.MouseButton1Click:Connect(clearConsole)

-- Function to refresh the list of ailments
local function refreshIDList()
    local container = LocalPlayer.PlayerGui:FindFirstChild("ailments_list")
        and LocalPlayer.PlayerGui.ailments_list:FindFirstChild("SurfaceGui")
        and LocalPlayer.PlayerGui.ailments_list.SurfaceGui:FindFirstChild("Container")

    if not container then
        logToConsole("Container not found!")
        return
    end

    local currentIds = {} -- Current IDs found in the Container
    local displayedIdsCopy = {} -- Track IDs that should still be displayed

    -- Check existing image labels and populate displayedIdsCopy
    for _, child in ipairs(idListFrame:GetChildren()) do
        if child:IsA("ImageLabel") and child.Image and child.Image ~= "" then
            table.insert(displayedIdsCopy, child.Image) -- Store existing images
        end
    end

    logToConsole("Scanning for Icons...")

    -- Check each button in the container
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("ImageButton") then
            local background = child:FindFirstChild("Background")
            if background then
                local icon = background:FindFirstChild("Icon")
                if icon and icon:IsA("ImageLabel") then
                    local imageId = icon.Image
                    if imageId and imageId ~= "" then
                        -- Add the image to displayed IDs if it's not already there
                        if not displayedIds[imageId] then
                            displayedIds[imageId] = true -- Mark as displayed

                            local imageLabel = Instance.new("ImageLabel")
                            imageLabel.Size = UDim2.new(0, 80, 0, 80) -- Size of the icon
                            imageLabel.Image = imageId
                            imageLabel.BackgroundTransparency = 1
                            imageLabel.Parent = idListFrame

                            logToConsole("Added Image ID: " .. imageId)
                        end

                        -- Add to current IDs list
                        table.insert(currentIds, imageId)
                    end
                end
            end
        end
    end

    -- Check for IDs that were previously displayed but are not in currentIds
    for _, id in ipairs(displayedIdsCopy) do
        if not table.find(currentIds, id) then
            -- This ID is no longer present, remove it from the display
            for _, child in ipairs(idListFrame:GetChildren()) do
                if child:IsA("ImageLabel") and child.Image == id then
                    child:Destroy()
                    logToConsole("Removed Image ID: " .. id)
                    break
                end
            end
            displayedIds[id] = nil -- Remove from displayedIds tracking
        end
    end

    -- Adjust the canvas size for the ID list
    if #currentIds ~= #idListFrame:GetChildren() then
        idListFrame.CanvasSize = UDim2.new(0, 0, 0, idListFrame.UIListLayout.AbsoluteContentSize.Y)
    end
end

-- Initial scan to display IDs
refreshIDList()

-- Continuous scanning every 1 second
while true do
    wait(1) -- Refresh every 1 second
    refreshIDList()
end


print'5'
print'4'
print'3'
print'2'
print'1'
print"0, Collecting Rewards has loaded."


local loopEnabled = true  -- Set this to true to enable the loop

-- Check if the loop is enabled
if loopEnabled then
    -- Get the player and TextLabel to show notifications
    local player = game:GetService("Players").LocalPlayer
    local hintLabel = player.PlayerGui:WaitForChild("HintApp"):WaitForChild("TextLabel")

    -- Ensure the TextLabel is visible
    hintLabel.Visible = true

    -- Function to update the notification
    local function updateNotification(message)
        hintLabel.Text = message
    end

    -- Start the loop
    while true do
        -- Start of loop: Notify that the loop is enabled
        updateNotification("Loop is enabled! Attempting to claim rewards...")

        -- Perform the loop to attempt to claim rewards
        for i = 1, 100 do
            local args = {
                [1] = i
            }

            -- Update the notification to show the current reward being claimed
            updateNotification("Attempting to claim reward " .. i .. "...")

            -- Try to claim the reward for each number
            game:GetService("ReplicatedStorage").API:FindFirstChild("WinterfestAPI/AdventCalendarTryTakeReward"):InvokeServer(unpack(args))

            -- Wait between each request to prevent too many rapid calls
            wait(0.5)  -- Adjust this value as needed
        end

        -- After all rewards are attempted, update the message
        updateNotification("Looping again... Attempting to claim rewards.")

        -- Wait before starting the next loop iteration
        wait(3)  -- Adjust this wait time for how often you want the message to update
    end
else
    -- If the loop is disabled, show a message
    local player = game:GetService("Players").LocalPlayer
    local hintLabel = player.PlayerGui:WaitForChild("HintApp"):WaitForChild("TextLabel")
    hintLabel.Text = "Loop is disabled."
    hintLabel.Visible = true
end




